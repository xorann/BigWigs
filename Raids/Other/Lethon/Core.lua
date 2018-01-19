------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.other.lethon
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"noxious", "bosskill"}

module.zonename = {
	AceLibrary("AceLocale-2.2"):new("BigWigs")["Outdoor Raid Bosses Zone"],
	AceLibrary("Babble-Zone-2.2")["Ashenvale"],
	AceLibrary("Babble-Zone-2.2")["Duskwood"],
	AceLibrary("Babble-Zone-2.2")["The Hinterlands"],
	AceLibrary("Babble-Zone-2.2")["Feralas"]
}

-- locals
local timer = {
	firstNoxiousBreath = 10,
	noxiousBreath = 18,
}
module.timer = timer

local icon = {
	noxiousBreath = "Spell_Shadow_LifeDrain02",
}
module.icon = icon

local syncName = {}
module.syncName = syncName

module.announceTime = nil

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
