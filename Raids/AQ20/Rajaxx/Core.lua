------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.aq20.rajaxx
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = {module.translatedName, andorov} -- string or table {boss, add1, add2}
module.toggleoptions = {"wave", "bosskill"}

-- locals
module.timer = {
    wave = 180,
}
local timer = module.timer

module.icon = {
    wave = "Spell_Holy_PrayerOfHealing",
}
local icon = module.icon

module.syncName = {}
local syncName = module.syncName

--module.wave = nil


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
