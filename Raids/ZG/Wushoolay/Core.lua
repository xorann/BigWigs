------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.zg.wushoolay
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"chainlightning", "lightningcloud", "bosskill"}


-- locals
module.timer = {
	chainlightning = 1.5,
}
local timer = module.timer

module.icon = {
	chainlightning = "Spell_Nature_ChainLightning",
}
local icon = module.icon

module.syncName = {
	chainlightning = "WushoolayChainLightning",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.chainlightning and self.db.profile.chainlightning then
		self:Message(L["msg_chainLightning"], "Important")
		self:Bar(L["bar_chainLightning"], timer.chainlightning, icon.chainlightning)
	end
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
	module:BigWigs_RecvSync(syncName.chainlightning)
end
