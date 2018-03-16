--[[
    Created by Dorann
--]]

------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.stitchedGiant
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20015 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"slimeBolt"}
module.trashMod = true

-- locals
module.timer = {
	slimeFirst = 5,
	slimeCast = 0.3,
	slimeInterval = 6
}
local timer = module.timer

module.icon = {
	slimeBolt = "spell_nature_corrosivebreath"
}
local icon = module.icon

module.syncName = {
	slimeBolt = "StitchedGiantSlimeBolt"
}
local syncName = module.syncName


module.boltNumber = nil
module.lastBolt = nil
	

------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
end


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
