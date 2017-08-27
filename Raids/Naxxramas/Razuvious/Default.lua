local bossName = BigWigs.bossmods.naxx.razuvious
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
module.revision = 20014 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300


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

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckForUnbalance")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckForUnbalance")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckForUnbalance")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE", "CheckForUnbalance")

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
	self:ScheduleEvent("bwrazuviousnoshout", self.NoShout, timer.shout + timer.noShoutDelay, self) -- praeda first no shout fix
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

function module:CheckForUnbalance(msg)
	if string.find(msg, L["trigger_unbalance"]) then
		self:Sync(syncName.unbalance)
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
end
