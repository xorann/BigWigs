local bossName = BigWigs.bossmods.other.azuregos
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

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.teleport and string.find(msg, L["trigger_teleport"]) then
		self:Message(L["msg_teleport"], "Important")
		self:Bar(L["bar_teleport"], timer.teleport, icon.teleport)
		self:Message(timer.teleport - 10, L["msg_teleport10"], "Important")
		self:Message(timer.teleport - 5, L["msg_teleport5"], "Important", true, "Alert")
		self:KTM_Reset()
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_OTHER( msg )
	if self.db.profile.shield and string.find(msg, L["trigger_shieldGone"]) then
		self:Message(L["msg_shieldGain"], "Attention")
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if self.db.profile.shield and string.find(msg, L["trigger_shieldGain"]) then
		self:Message(L["msg_shieldGone"], "Important", true, "Alert")
		self:Bar(L["bar_shield"], timer.shield, icon.shield)
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
	module:CHAT_MSG_MONSTER_YELL(L["trigger_teleport"])
	module:CHAT_MSG_SPELL_AURA_GONE_OTHER(L["trigger_shieldGone"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_shieldGain"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
