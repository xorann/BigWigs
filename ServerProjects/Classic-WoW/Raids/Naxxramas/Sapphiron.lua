local bossName = BigWigs.bossmods.naxx.sapphiron
local serverProjectName = "Classic-WoW"
if not BigWigs:IsServerRegisteredForServerProject(serverProjectName) or not BigWigs:IsBossSupportedByServerProject(bossName, serverProjectName) then
	return
end


--BigWigs:Print("classic-wow " .. bossName)

------------------------------
-- Variables     			--
------------------------------

local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]
local timer = module.timer
local icon = module.icon
local syncName = module.syncName

-- module variables
module.revision = 20018 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300
module.timer.deepbreathInc = 20


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	if self:IsEventScheduled("bwsapphtargetscanner") then
		self:CancelScheduledEvent("bwsapphtargetscanner")
	end
	if self:IsEventScheduled("bwsapphdelayed") then
		self:CancelScheduledEvent("bwsapphdelayed")
	end

	self:CombatlogFilter(L["trigger_deepBreath"], self.DeepBreathEvent, true)
	self:CombatlogFilter(L["trigger_flight"], self.FlightEvent, true)
	self:CombatlogFilter(L["trigger_blizzardGain"], self.BlizzardGainEvent)
	self:CombatlogFilter(L["trigger_blizzardGone"], self.BlizzardGoneEvent)
	
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckForLifeDrain")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckForLifeDrain")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckForLifeDrain")
	
	self:ThrottleSync(4, syncName.lifedrain)
	self:ThrottleSync(5, syncName.flight)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.timeLifeDrain = nil
	module.cachedUnitId = nil
	module.lastTarget = nil
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.berserk then
		self:Message(L["msg_engage"], "Attention")
		self:Bar(L["bar_berserk"], timer.berserk, icon.berserk)
		self:DelayedMessage(timer.berserk - 10 * 60, L["msg_berserk10m"], "Attention")
		self:DelayedMessage(timer.berserk - 5 * 60, L["msg_berserk5m"], "Attention")
		self:DelayedMessage(timer.berserk - 60, string.format(L["msg_berserkSoon"], 60), "Urgent")
		self:DelayedMessage(timer.berserk - 30, string.format(L["msg_berserkSoon"], 30), "Important")
		self:DelayedMessage(timer.berserk - 10, string.format(L["msg_berserkSoon"], 10), "Important")
		self:DelayedMessage(timer.berserk - 5, string.format(L["msg_berserkSoon"], 5), "Important")
	end
	if self.db.profile.deepbreath then
		-- Lets start a repeated event after 5 seconds of combat so that
		-- we're sure that the entire raid is in fact in combat when we
		-- start it.
		self:ScheduleEvent("besapphdelayed", self.StartTargetScanner, 5, self)
	end
	
	self:Bar(L["bar_flight"], timer.firstFlight, icon.flight)
	
	self:ScheduleRepeatingEvent("bwsapphengagecheck", self.EngageCheck, 1, self)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
	if self:IsEventScheduled("bwsapphtargetscanner") then
		self:CancelScheduledEvent("bwsapphtargetscanner")
	end
	if self:IsEventScheduled("bwsapphdelayed") then
		self:CancelScheduledEvent("bwsapphdelayed")
	end
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CheckForLifeDrain(msg)
	if string.find(msg, L["trigger_lifeDrain1"]) or string.find(msg, L["trigger_lifeDrain2"]) then
		if not module.timeLifeDrain or (module.timeLifeDrain + 2) < GetTime() then
			self:Sync(syncName.lifedrain)
			module.timeLifeDrain = GetTime()
		end
	elseif string.find(msg, L["trigger_icebolt"]) and self.db.profile.icebolt then
		SendChatMessage(L["msg_IceBlockYell"], "YELL")
		Minimap:PingLocation(CURSOR_OFFSET_X, CURSOR_OFFSET_Y)
	end
end

function module:DeepBreathEvent(msg)
	if string.find(msg, L["trigger_deepBreath"]) then
		self:Sync(syncName.deepbreath)
	end
end

function module:FlightEvent(msg)
	if string.find(msg, L["trigger_flight"]) then
		self:Sync(syncName.flight)
	end
end

function module:BlizzardGainEvent(msg)
	if string.find(msg, L["trigger_blizzardGain"]) then
		module:BlizzardGain()
	end
end

function module:BlizzardGoneEvent(msg)
	if string.find(msg, L["trigger_blizzardGone"]) then
		module:BlizzardGone()
	end
end

------------------------------
-- Utility	Functions   	--
------------------------------
function module:EngageCheck()
	if not self.engaged then
		if self:IsSapphironVisible() then
			module:CancelScheduledEvent("bwsapphengagecheck")

			module:SendEngageSync()
		end
	else
		module:CancelScheduledEvent("bwsapphengagecheck")
	end
end

function module:IsSapphironVisible()
	if UnitName("playertarget") == self:ToString() then
		return true
	else
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitName("Raid" .. i .. "target") == self:ToString() then
				return true
			end
		end
	end

	return false
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModule()
	module:OnEnable()
	module:OnSetup()
	module:OnEngage()

	module:TestModuleCore()

	-- check event handlers
	module:EngageCheck()
	module:IsSapphironVisible()
	
	module:BlizzardGainEvent(L["trigger_blizzardGain"])
	module:BlizzardGoneEvent(L["trigger_blizzardGone"])
	module:FlightEvent(L["trigger_flight"])
	module:DeepBreathEvent(L["trigger_deepBreath"])
	module:CheckForLifeDrain(L["trigger_lifeDrain1"])
	module:CheckForLifeDrain(L["trigger_lifeDrain2"])
	module:CheckForLifeDrain(L["trigger_icebolt"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	-- /run local m=BigWigs:GetModule("Sapphiron");m:TestVisual()
	local function flight()
		module:FlightEvent(L["trigger_flight"])
	end

	local function deepbreath()
		module:DeepBreathEvent(L["trigger_deepBreath"])
	end

	local function lifedrain()
		module:CheckForLifeDrain(L["trigger_lifeDrain1"])
	end

	local function icebolt()
		module:CheckForLifeDrain(L["trigger_icebolt"])
	end
	
	local function blizzardGain()
		module:BlizzardGainEvent(L["trigger_blizzardGain"])
	end
	
	local function blizzardGone()
		module:BlizzardGoneEvent(L["trigger_blizzardGone"])
	end

	local function deactivate()
		self:DebugMessage("deactivate")
		self:Disable()
		--[[self:DebugMessage("deactivate ")
		if self.phase then
			self:DebugMessage("deactivate module "..self:ToString())
			--BigWigs:ToggleModuleActive(self, false)
			self.core:ToggleModuleActive(self, false)
			self.phase = nil
		end]]
	end

	BigWigs:Print("module Test started")
	BigWigs:Print("  Life Drain Test after 3s")
	BigWigs:Print("  Blizzard Test after 6s")
	BigWigs:Print("  Flight Test after 10s")
	BigWigs:Print("  Icebolt Test after 13s")
	BigWigs:Print("  Deep Breath Test after 16s")
	BigWigs:Print("  Deactivate after 25s")

	-- immitate CheckForEngage
	self:SendEngageSync()

	-- sweep after 3s
	self:ScheduleEvent(self:ToString() .. "Test_lifedrain", lifedrain, 3, self)

	-- sand blast after 6s
	self:ScheduleEvent(self:ToString() .. "Test_blizzardGain", blizzardGain, 6, self)

	-- submerge after 8s
	self:ScheduleEvent(self:ToString() .. "Test_blizzardGone", blizzardGone, 8, self)

	-- emerge after 10s
	self:ScheduleEvent(self:ToString() .. "Test_flight", flight, 10, self)

	-- emerge after 13s
	self:ScheduleEvent(self:ToString() .. "Test_icebolt", icebolt, 13, self)

	-- emerge after 16s
	self:ScheduleEvent(self:ToString() .. "Test_deepbreath", deepbreath, 16, self)

	-- reset after 25s
	self:ScheduleEvent(self:ToString() .. "Test_deactivate", deactivate, 25, self)
end
