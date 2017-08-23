------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.zg.gahzranka
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"frostbreath", "massivegeyser", "bosskill"}


-- locals
module.timer = {
	breath = 2,
	geyser = 1.5,
}
local timer = module.timer

module.icon = {
	breath = "Spell_Frost_FrostNova",
	geyser = "Spell_Frost_SummonWaterElemental",
}
local icon = module.icon

module.syncName = {}
local syncName = module.syncName


------------------------------
-- Synchronization	    	--
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
