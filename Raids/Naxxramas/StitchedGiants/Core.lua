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
module.toggleoptions = {"slime"}
module.trashMod = true

-- locals
module.timer = {
	slimeFirst = {
		min = 5,
		max = 10,
	},
	slimeCast = 2,
	slimeInterval = {
		min = 20,
		max = 25
	}
}
local timer = module.timer

module.icon = {
	slime = "ability_whirlwind"
}
local icon = module.icon

module.syncName = {
	slime = "StitchedGiantSlime"
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.slime then
		self:Slime()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Slime()
	if self.db.profile.slime then		
		self:Bar(L["bar_slime"], timer.slimeCast, icon.slime, true, BigWigsColors.db.profile.significant)
		self:Bar(L["bar_slimeNext"], timer.slimeInterval, icon.slime)
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:Slime()
	
	module:BigWigs_RecvSync(syncName.slime)
end
