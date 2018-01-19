------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.aq20.guardians
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.toggleoptions = {"summon", "explode", "enrage", -1, "plagueyou", "plagueother", "icon"--[[, "bosskill"]]}

module.defaultDB = {
	bosskill = false,
}

-- locals
module.timer = {}
local timer = module.timer

module.icon = {}
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
