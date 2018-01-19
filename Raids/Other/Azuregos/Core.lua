------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.other.azuregos
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"teleport", "shield", "bosskill"}

-- locals
module.timer = {
	teleport = 30,
	shield = 10,
}
local timer = module.timer

module.icon = {
	teleport = "Spell_Arcane_Blink",
	shield = "Spell_Frost_FrostShock",
}
local icon = module.icon

module.syncName = {}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------


------------------------------
-- Sync Handlers	    	--
------------------------------


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
end
