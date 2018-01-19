------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.zg.marli
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = { L["misc_spawnName"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"phase", "spider", "drain", "volley", "bosskill"}


-- locals
module.timer = {
	charge = 10,
	teleport = 30,
}
local timer = module.timer

module.icon = {
	charge = "Spell_Frost_FrostShock",
	teleport = "Spell_Arcane_Blink",
}
local icon = module.icon

module.syncName = {
	drain = "MarliDrainStart",
	drainOver = "MarliDrainEnd",
	trollPhase = "MarliTrollPhase",
	spiderPhase = "MarliSpiderPhase",
	spiders = "MarliSpiders",
	volley = "MarliVolley",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.spiders and self.db.profile.spider then
		self:Message(L["msg_spiders"], "Attention")
	elseif sync == syncName.trollPhase and self.db.profile.phase then
		self:Message(L["msg_phaseTroll"], "Attention")
	elseif sync == syncName.spiderPhase then
		if self.db.profile.phase then
			self:Message(L["msg_phaseSpider"], "Attention")
		end
		if self.db.profile.drain then
			self:RemoveBar(L["bar_drainLife"])
		end
		if self.db.profile.volley then
			self:RemoveBar(L["bar_poison"])
		end
	elseif sync == syncName.volley and self.db.profile.volley then
		self:Bar(L["bar_poison"], 13, "Spell_Nature_CorrosiveBreath")
	elseif sync == syncName.drain and self.db.profile.drain then
		self:Bar(L["bar_drainLife"], 7, "Spell_Shadow_LifeDrain02")
		self:Message(L["msg_drainLife"], "Attention")
	elseif sync == syncName.drainOver and self.db.profile.drain then
		self:RemoveBar(L["bar_drainLife"])
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
	module:BigWigs_RecvSync(syncName.spiders)
	module:BigWigs_RecvSync(syncName.trollPhase)
	module:BigWigs_RecvSync(syncName.spiderPhase)
	module:BigWigs_RecvSync(syncName.volley)
	module:BigWigs_RecvSync(syncName.drain)
	module:BigWigs_RecvSync(syncName.drainOver)
end
