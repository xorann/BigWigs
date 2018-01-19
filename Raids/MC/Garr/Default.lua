local bossName = BigWigs.bossmods.mc.garr
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
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
end

-- called after module is enabled and after each wipe
function module:OnSetup()
    self.adds = 0
end

-- called after boss is engaged
function module:OnEngage()
	--self:TriggerEvent("BigWigs_StartCounterBar", self, L["bar_adds"], 8, "Interface\\Icons\\spell_nature_strengthofearthtotem02")
    --self:TriggerEvent("BigWigs_SetCounterBar", self, L["bar_adds"], (8 - 0.1))
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if (string.find(msg, L["trigger_addDead8"])) then
		self:Sync("GarrAddDead 8")
		self:Sync(syncName.addDeath .. " 8")
	elseif (string.find(msg, L["trigger_addDead7"])) then
		self:Sync(syncName.addDeath .. " 7")
	elseif (string.find(msg, L["trigger_addDead6"])) then
		self:Sync(syncName.addDeath .. " 6")
	elseif (string.find(msg, L["trigger_addDead5"])) then
		self:Sync(syncName.addDeath .. " 5")
	elseif (string.find(msg, L["trigger_addDead4"])) then
		self:Sync(syncName.addDeath .. " 4")
	elseif (string.find(msg, L["trigger_addDead3"])) then
		self:Sync(syncName.addDeath .. " 3")
	elseif (string.find(msg, L["trigger_addDead2"])) then
		self:Sync(syncName.addDeath .. " 2")
	elseif (string.find(msg, L["trigger_addDead1"])) then
		self:Sync(syncName.addDeath .. " 1")
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
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_addDead8"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_addDead7"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_addDead6"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_addDead5"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_addDead4"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_addDead3"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_addDead2"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_addDead1"])
		
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
