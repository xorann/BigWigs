local bossName = BigWigs.bossmods.naxx.razuvious
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
module.revision = 20014 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300
timer.firstShout = 25.4
timer.shout = 25.4

module.toggleoptions = {"shout", "shieldwall", "bosskill"} -- removed unbalance, doesn't make sense on nefarian

------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["trigger_engage1"])
module:RegisterYellEngage(L["trigger_engage2"])
module:RegisterYellEngage(L["trigger_engage3"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CheckForShout")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "CheckForShout")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "CheckForShout")

	--[[self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckForUnbalance")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckForUnbalance")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckForUnbalance")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE", "CheckForUnbalance")]]

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS", "CheckForShieldwall")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS", "CheckForShieldwall")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS", "CheckForShieldwall")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "CheckForShieldwall")

	self:ThrottleSync(5, syncName.shout)
	self:ThrottleSync(5, syncName.shieldwall)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.shout then
		self:Message(L["msg_engage"], "Attention", nil, "Urgent")
		self:DelayedMessage(timer.firstShout - 7, L["msg_shout7"], "Urgent")
		self:DelayedMessage(timer.firstShout - 3, L["msg_shout3"], "Urgent")
		self:Bar(L["bar_shout"], timer.firstShout, icon.shout)
	end
	self:ScheduleEvent("bwrazuviousnoshout", self.NoShout, timer.shout, self) -- praeda first no shout fix
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CheckForShieldwall(msg) 
	if string.find(msg, L["trigger_shieldWall"]) then
		self:Sync(syncName.shieldwall)
	end
end

function module:CheckForShout(msg)
	if string.find(msg, L["trigger_shout"]) then
		self:Sync(syncName.shout)
	end
end

--[[function module:CheckForUnbalance(msg)
	if string.find(msg, L["trigger_unbalance"]) then
		self:Sync(syncName.unbalance)
	end
end]]


------------------------------
-- Utility	Functions   	--
------------------------------
-- you only see disrupting shout if someone gets hit
function module:NoShout()	
	self:CancelScheduledEvent("bwrazuviousnoshout")
	self:ScheduleEvent("bwrazuviousnoshout", self.NoShout, timer.shout, self)
	
	if self.db.profile.shout then
		--self:Message(L["msg_noShout"], "Attention") -- is this message useful?		
		self:Bar(L["bar_shout"], timer.shout, icon.shout)
		self:DelayedMessage(timer.shout - 7, L["msg_shout7"], "Urgent")
		self:DelayedMessage(timer.shout - 3, L["msg_shout3"], "Urgent")
	end
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
	module:CheckForUnbalance(L["trigger_unbalance"])
	module:CheckForShout(L["trigger_shout"])
	module:CheckForShieldwall(L["trigger_shieldWall"]) 
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
	
	
	-- /run local m=BigWigs:GetModule("Instructor Razuvious");m:TestVisual()
	local function unbalance()
		--module:CheckForUnbalance("Instructor Razuvious's Unbalancing Strike hits Death Knight Understudy for 10724.")
		module:Sync(syncName.unbalance)
		BigWigs:Print("unbalance")
	end 
	
	local function shout()
		module:CheckForShout("Instructor Razuvious's Disrupting Shout hits Anthem for 1216.")
		BigWigs:Print("shout")
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

	-- immitate CheckForEngage
	self:SendEngageSync()

	-- sweep after 5s
	self:ScheduleEvent(self:ToString() .. "Test_unbalance", unbalance, 2, self)
	self:ScheduleEvent(self:ToString() .. "Test_shout", shout, 3, self)
	self:ScheduleEvent(self:ToString() .. "Test_deactivate", deactivate, 5, self)
end
