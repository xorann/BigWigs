------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.patchwerk
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"enrage", "bosskill"}


-- locals
module.timer = {
	enrage = 420,
}
local timer = module.timer

module.icon = {
	enrage = "Spell_Shadow_UnholyFrenzy",
}
local icon = module.icon

module.syncName = {
	enrage = "PatchwerkEnrage",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.enrage then
		self:Enrage()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Enrage()
	if self.db.profile.enrage then
		self:Message(L["msg_enrage"], "Important", nil, "Beware")

		self:RemoveBar(L["bar_enrage"])
		
		self:CancelDelayedMessage(L["msg_enrage5m"])
		self:CancelDelayedMessage(L["msg_enrage3m"])
		self:CancelDelayedMessage(L["msg_enrage90"])
		self:CancelDelayedMessage(L["msg_enrage60"])
		self:CancelDelayedMessage(L["msg_enrage30"])
		self:CancelDelayedMessage(L["msg_enrage10"])
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:Enrage()
	
	module:BigWigs_RecvSync(syncName.enrage)
end
