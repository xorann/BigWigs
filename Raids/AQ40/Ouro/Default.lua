local bossName = BigWigs.bossmods.aq40.ouro
if BigWigs:IsBossSupportedByAnyServerProject(bossName) then
	return
end
-- no implementation found => use default implementation
--BigWigs:Print("default " .. bossName)

------------------------------
-- Variables     			--
------------------------------

local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]
local timer = module.timer
local icon = module.icon
local syncName = module.syncName

-- module variables
module.revision = 20013 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300

------------------------------
-- Initialization      --
------------------------------

-- Big evul hack to enable the module when entering Ouros chamber.
function module:OnRegister()
end

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")

	self:RegisterEvent("UNIT_HEALTH")

	self:ThrottleSync(10, syncName.sweep)
	self:ThrottleSync(10, syncName.sandblast)
	self:ThrottleSync(10, syncName.emerge)
	self:ThrottleSync(10, syncName.submerge)
	self:ThrottleSync(10, syncName.berserk)

	self:ScheduleRepeatingEvent("bwouroengagecheck", self.EngageCheck, 1, self)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

	module.berserkannounced = nil
	self.phase = nil
	self.submergeCheckName = self:ToString()
end

-- called after boss is engaged
function module:OnEngage()
	self.phase = "emerged"
	self:ScheduleRepeatingEvent("bwourosubmergecheck", self.SubmergeCheck, 1, self)

	if self.db.profile.emerge then
		self:PossibleSubmerge()
	end

	if self.db.profile.sweep then
		self:Bar(L["bar_sweepFirst"], timer.firstSweep, icon.sweep)
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
	self:CancelScheduledEvent("bwourosubmergecheck")
end


------------------------------
-- Event Handlers	    --
------------------------------
function module:UNIT_HEALTH(msg)
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 20 and health <= 23 and not module.berserkannounced then
			if self.db.profile.berserk then
				self:Message(L["msg_berserkSoon"], "Important")
			end
			module.berserkannounced = true
		elseif health > 30 and module.berserkannounced then
			module.berserkannounced = nil
		end
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["trigger_bersek"] then
		self:Sync(syncName.berserk)
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if string.find(msg, L["trigger_emerge"]) and self.phase ~= "berserk" then
		self:Sync(syncName.emerge)
	elseif string.find(msg, L["trigger_submerge"]) then
		self:Sync(syncName.submerge)
	end
end

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	BigWigs:CheckForBossDeath(msg, self)

	if string.find(msg, L["trigger_emerge"]) and self.phase ~= "berserk" then
		self:Sync(syncName.emerge)
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["trigger_sweep"]) then
		self:Sync(syncName.sweep)
	elseif string.find(msg, L["trigger_sandBlast"]) then
		self:Sync(syncName.sandblast)
	elseif string.find(msg, L["trigger_submerge"]) then
		self:Sync(syncName.submerge)
	end
end

-- there is no emote on nefarian ...
function module:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["trigger_bersek"] then
		self:Sync(syncName.berserk)
	end
end


----------------------------------
-- Module Test Function    --
----------------------------------

-- automated test
function module:TestModule()
	module:OnEnable()
	module:OnSetup()
	module:OnEngage()

	module:TestModuleCore()

	-- check event handlers
	module:UNIT_HEALTH("player")
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_bersek"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(L["trigger_emerge"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(L["trigger_submerge"])
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(L["trigger_emerge"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_sweep"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_sandBlast"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_submerge"])
	module:CHAT_MSG_MONSTER_EMOTE(L["trigger_bersek"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	-- /run local m=BigWigs:GetModule("Ouro");m:Test()
	local function sweep()
		if self.phase == "emerged" then
			module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_sweep"])
		end
	end

	local function sandblast()
		if self.phase == "emerged" then
			module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_sandBlast"])
		end
	end

	local function submerge()
		if self.phase == "emerged" then
			ClearTarget()
		end
	end

	local function emerge()
		if self.phase == "submerged" then
			TargetUnit("player")
			module:CHAT_MSG_COMBAT_HOSTILE_DEATH(L["trigger_emerge"])
		end
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
	BigWigs:Print("Do not change your target!")
	BigWigs:Print("  Sweep Test after 5s")
	BigWigs:Print("  Sand Storm Test after 10s")
	BigWigs:Print("  Submerge Test after 32s")
	BigWigs:Print("  Emerge Test after 42s")

	TargetUnit("player")

	-- immitate CheckForEngage
	self:SendEngageSync()

	-- encounter specific settings
	self.submergeCheckName = UnitName("player")


	-- sweep after 5s
	self:ScheduleEvent(self:ToString() .. "Test_sweep", sweep, 5, self)

	-- sand blast after 10s
	self:ScheduleEvent(self:ToString() .. "Test_sandblast", sandblast, 10, self)

	-- submerge after 22s
	self:ScheduleEvent(self:ToString() .. "Test_submerge", submerge, 22, self)

	-- emerge after 32s
	self:ScheduleEvent(self:ToString() .. "Test_emerge", emerge, 32, self)

	-- reset after 50s
	self:ScheduleEvent(self:ToString() .. "Test_deactivate", deactivate, 50, self)
end
