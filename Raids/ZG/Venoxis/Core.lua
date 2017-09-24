------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.zg.venoxis
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = { L["misc_addName"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"phase", "adds", "renew", "holyfire", "enrage", "announce", "bosskill"}


-- locals
module.timer = {
	holyfireCast = 3.5,
	holyfire = 12,
	renew = 15,
}
local timer = module.timer

module.icon = {
	addDead = "INV_WAEPON_BOW_ZULGRUB_D_01",
	cloud = "Ability_Creature_Disease_02",
	renew = "Spell_Holy_Renew",
	holyfire = "Spell_Holy_SearingLight",
}
local icon = module.icon

module.syncName = {
	phase2 = "VenoxisPhaseTwo",
	renew = "VenoxisRenewStart",
	renewOver = "VenoxisRenewStop",
	holyfire = "VenoxisHolyFireStart",
	holyfireOver = "VenoxisHolyFireStop",
	enrage = "VenoxisEnrage",
	addDead = "VenoxisAddDead",
}
local syncName = module.syncName


module.cobra = 0
module.castingholyfire = 0
module.holyfiretime = 0


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.illusions and self.db.profile.nightmaresummon then
		self:Message(L["msg_nightmareSummon"], "Important", true, "Alarm")
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.phase2 then
		self:KTM_Reset()
		if self.db.profile.phase then
			self:Message(L["msg_phase2"], "Attention")
		end
		if self.db.profile.holyfire then
			self:RemoveBar(L["bar_holyFire"])
		end
	elseif sync == syncName.renew then
		if self.db.profile.renew then
			self:Message(L["msg_renew"], "Urgent")
			self:Bar(L["bar_renew"], timer.renew, icon.renew)
		end
	elseif sync == syncName.renewOver then
		if self.db.profile.renew then
			self:RemoveBar(L["bar_renew"])
		end
	elseif sync == syncName.holyfire then
		module.holyfiretime = GetTime()
		module.castingholyfire = 1
		if self.db.profile.holyfire then
			self:Bar(L["bar_holyFire"], timer.holyfireCast, icon.holyfire, true, "Blue")
			self:Bar("Next Holy Fire", timer.holyfire, icon.holyfire)
		end
	elseif sync == "VenoxisHolyFireStop" then
		module.castingholyfire = 0
		if self.db.profile.holyfire then
			self:RemoveBar(L["bar_holyFire"])
		end
	elseif sync == syncName.enrage then
		if self.db.profile.enrage then
			self:Message(L["msg_enrage"], "Attention")
		end
	elseif sync == syncName.addDead and rest and rest ~= "" then
        rest = tonumber(rest)
        if rest <= 4 and self.cobra < rest then
            self.cobra = rest
            self:Message(string.format(L["msg_adds"], self.cobra), "Positive")
            --self:TriggerEvent("BigWigs_SetCounterBar", self, "Snakes dead", (4 - self.cobra))
        end
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:BigWigs_RecvSync(syncName.illusions)
end
