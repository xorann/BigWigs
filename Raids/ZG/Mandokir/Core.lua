------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.zg.mandokir
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = { L["misc_ohgan"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"gaze", "announce", "puticon", "whirlwind", "enraged", "bosskill"}


-- locals
module.timer = {
	firstCharge = 15,
	firstWhirlwind = 20,
	firstGaze = 29.5,
	
	gaze = 28.1,
}
local timer = module.timer

module.icon = {
	charge = "Ability_Warrior_Charge",
	whirlwind = "Ability_Whirlwind",
	gaze = "Spell_Shadow_Charm",
}
local icon = module.icon

module.syncName = {
	whirlwind = "MandokirWWStart",
	whirlwindOver = "MandokirWWStop",
	enrage = "MandokirEnrageStart",
	enrageOver = "MandokirEnrageEnd",
	gazeCast = "MandokirGazeCast",
	gazeAfflicted = "MandokirGazeAfflict",
	gazeOver = "MandokirGazeEnd",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.whirlwind and self.db.profile.whirlwind then
		self:Bar(L["bar_whirlwind"], 2, icon.whirlwind)
		--self:ScheduleEvent("BigWigs_StartBar", 2, self, "Next Whirlwind", 18, icon.whirlwind)
	elseif sync == syncName.whirlwindOver and self.db.profile.whirlwind then
		self:RemoveBar(L["bar_whirlwind"])
        self:Bar("Next Whirlwind", 18, icon.whirlwind)
	elseif sync == syncName.enrage and self.db.profile.enraged then
		self:Message(L["msg_enrage"], "Urgent")
		self:Bar(L["bar_enrage"], 90, "Spell_Shadow_UnholyFrenzy")
	elseif sync == syncName.enrageOver and self.db.profile.enraged then
		self:RemoveBar(L["bar_enrage"])
	elseif sync == syncName.gazeCast and self.db.profile.gaze then
		self:Bar(L["bar_gazeCast"], 2, icon.gaze)
        self:RemoveBar(L["Possible Gaze"])
	elseif sync == syncName.gazeAfflicted and rest and self.db.profile.gaze then
		self:Bar(string.format(L["bar_watch"], rest), 5, icon.gaze, true, BigWigsColors.db.profile.significant)
	elseif sync == syncName.gazeOver and rest then
		if self.db.profile.gaze then
			self:RemoveBar(string.format(L["bar_watch"], rest))
		end
		if self.db.profile.puticon then
			self:RemoveIcon(rest)
		end
        self:Bar(L["Possible Gaze"], timer.gaze, icon.gaze)
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
	module:BigWigs_RecvSync(syncName.whirlwind)
	module:BigWigs_RecvSync(syncName.whirlwindOver)
	module:BigWigs_RecvSync(syncName.enrage)
	module:BigWigs_RecvSync(syncName.enrageOver)
	module:BigWigs_RecvSync(syncName.gazeCast)
	module:BigWigs_RecvSync(syncName.gazeAfflicted, UnitName("player"))
	module:BigWigs_RecvSync(syncName.gazeOver, UnitName("player"))
end
