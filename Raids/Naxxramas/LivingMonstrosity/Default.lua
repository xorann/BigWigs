--[[
    Created by Vnm-Kronos - https://github.com/Vnm-Kronos
    modified by Dorann
--]]

local bossName = BigWigs.bossmods.naxx.livingmonstrosity
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
module.revision = 20015 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:CombatlogFilter(L["trigger_lightningtotemCast"], self.LightningTotemCastEvent)
	self:CombatlogFilter(L["trigger_lightningtotemSummon"], self.LightningTotemSummonEvent)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
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
function module:LightningTotemCastEvent(event, msg)
	if string.find(msg, L["trigger_lightningtotemCast"]) then
		self:Sync(syncName.lightningTotemCast)
	end
end

function module:LightningTotemSummonEvent(event, msg)
	if string.find(msg, L["trigger_lightningtotemSummon"]) then
		self:Sync(syncName.lightningTotemSummon)
	end
end
		
function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	BigWigs:CheckForBossDeath(msg, self)
	if msg == string.format(UNITDIESOTHER, L["misc_lightningTotem"]) then
		self:Sync(syncName.lightningTotemDeath)
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
	module:LightningTotemCastEvent("", L["trigger_lightningtotemCast"])
	module:LightningTotemSummonEvent("", L["trigger_lightningtotemSummon"])
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(string.format(UNITDIESOTHER, L["misc_lightningTotem"]))
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual(long)
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
