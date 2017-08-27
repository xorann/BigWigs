local bossName = BigWigs.bossmods.naxx.patchwerk
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


------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["trigger_engage1"])
module:RegisterYellEngage(L["trigger_engage2"])

-- called after module is enabled
function module:OnEnable()
	self:ThrottleSync(10, syncName.enrage)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.enrage then
		self:Message(L["msg_engage"], "Important")
		self:Bar(L["bar_enrage"], timer.enrage, icon.enrage)
		self:DelayedMessage(timer.enrage - 5 * 60, L["msg_enrage5m"], "Attention")
		self:DelayedMessage(timer.enrage - 3 * 60, L["msg_enrage3m"], "Attention")
		self:DelayedMessage(timer.enrage - 90, L["msg_enrage90"], "Urgent")
		self:DelayedMessage(timer.enrage - 60, L["msg_enrage60"], "Urgent")
		self:DelayedMessage(timer.enrage - 30, L["msg_enrage30"], "Important")
		self:DelayedMessage(timer.enrage - 10, L["msg_enrage10"], "Important")
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["trigger_enrage"] then
		self:Sync(syncName.enrage)
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
	module:CHAT_MSG_MONSTER_EMOTE(L["trigger_enrage"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
