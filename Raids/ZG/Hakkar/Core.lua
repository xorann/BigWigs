------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.zg.hakkar
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"mc", "puticon", "siphon", "enrage", -1, "aspectjeklik", "aspectvenoxis", "aspectmarli", "aspectthekal", "aspectarlokk", "bosskill"}


-- locals
module.timer = {
	enrage = 600,
	bloodSiphon = 90,
	firstMindcontrol = 17,
    mindcontrol = 10,
}
local timer = module.timer

module.icon = {
	enrage = "Spell_Shadow_UnholyFrenzy",
	bloodSiphon = "Spell_Shadow_LifeDrain",
	serpent = "Ability_Hunter_Pet_WindSerpent",
	mindcontrol = "Spell_Shadow_ShadowWordDominate",
	
	-- aspects
	jeklik = "Spell_Shadow_Teleport",
	arlokk = "Ability_Vanish",
	venoxis = "Spell_Nature_CorrosiveBreath",
	marli = "Ability_Smash",
	thekal = "Ability_Druid_ChallangingRoar",
}
local icon = module.icon

module.syncName = {
	bloodSiphon = "HakkarBloodSiphon",
	mindcontrol = "HakkarMC",
	
	-- aspects
	jeklik = "HakkarAspectJeklik",
	arlokk = "HakkarAspectArlokk",
	arlokkAvoid = "HakkarAspectArlokkAvoid",
	venoxis = "HakkarAspectVenoxis",
	marli = "HakkarAspectMarli",
	marliAvoid = "HakkarAspectMarliAvoid",
	thekalStart = "HakkarAspectThekalStart",
	thekalStop = "HakkarAspectThekalStop",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.bloodSiphon then
        self:BloodSiphon()
	elseif sync == syncName.mindcontrol and rest then
		self:MindControl(rest)

	-- aspects
	elseif sync == syncName.jeklik and self.db.profile.aspectjeklik then
		self:Bar(L["bar_aspectOfJeklikNext"], 10, icon.jeklik, true, "Orange")
		self:Bar(L["bar_aspectOfJeklikDebuff"], 5, icon.jeklik, true, "Orange")
	elseif sync == syncName.arlokk and rest and self.db.profile.aspectarlokk then
		self:Bar(L["bar_aspectOfArlokkNext"], 10, icon.arlokk, true, "Blue")
		self:Bar(string.format(L["bar_aspectOfArlokkDebuff"], rest), 2, icon.arlokk, true, "Blue")	
	elseif sync == syncName.arlokkAvoid and self.db.profile.aspectarlokk then
		self:Bar(L["bar_aspectOfArlokkNext"], 10, icon.arlokk, true, "Blue")
	elseif sync == syncName.venoxis and self.db.profile.aspectvenoxis then
		self:Bar(L["bar_aspectOfVenoxisNext"], 8, icon.venoxis, true, "Green")
		self:Bar(L["bar_aspectOfVenoxisDebuff"], 10, icon.venoxis, true, "Green")
	elseif sync == syncName.marli and rest and self.db.profile.aspectmarli then
		self:Bar(L["bar_aspectOfMarliNext"], 10, icon.marli, true, "Yellow")
		self:Bar(string.format(L["bar_aspectOfMarliDebuff"], rest), 6, icon.marli, true, "Yellow")
	elseif sync == syncName.marliAvoid and self.db.profile.aspectmarli then
		self:Bar(L["bar_aspectOfMarliNext"], 10, icon.marli, true, "Yellow")
	elseif sync == syncName.thekalStart and self.db.profile.aspectthekal then
		self:Bar(L["bar_aspectOfThekalNext"], 15, icon.thekal, true, "Black")
		self:Bar(L["bar_aspectOfThekal"], 8, icon.thekal, true, "Black")
		self:Message(L["msg_aspectOfThekal"], "Important", true, "Alarm")
	elseif sync == syncName.thekalStop and self.db.profile.aspectthekal then
        self:RemoveBar(L["bar_aspectOfThekal"])
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:BloodSiphon()
	self:RemoveWarningSign(icon.serpent)   -- just to be safe, shouldn't be needed
	if self.db.profile.siphon then
		self:Bar(L["bar_siphon"], timer.bloodSiphon, icon.bloodSiphon)
		self:DelayedMessage(timer.bloodSiphon - 30, string.format(L["msg_siphonSoon"], 30), "Urgent")
		self:DelayedWarningSign(timer.bloodSiphon - 30, icon.serpent, 3)
		-- before I display that I need to figure out, how to track when the player gained the Poisonous Blood - this should hide the icon again
		self:DelayedMessage(timer.bloodSiphon - 10, string.format(L["msg_siphonSoon"], 10), "Attention", nil, nil, true)
	end
	
	-- aspects
	if self.db.profile.aspectjeklik then
		self:RemoveBar(L["bar_aspectOfJeklikNext"])
	end
	if self.db.profile.aspectvenoxis then
		self:RemoveBar(L["bar_aspectOfVenoxisNext"])
	end
	if self.db.profile.aspectmarli then
		self:RemoveBar(L["bar_aspectOfMarliNext"])
	end
	if self.db.profile.aspectarlokk then
		self:RemoveBar(L["bar_aspectOfArlokkNext"])
	end
	if self.db.profile.aspectthekal then
		self:RemoveBar(L["bar_aspectOfThekalNext"])
	end
end

function module:MindControl(rest)
	if self.db.profile.mc and rest then
		self:DelayedBar(timer.mindcontrol, L["bar_nextMindControl"], 11, icon.mindcontrol)
		self:Bar(string.format(L["bar_mindControl"], rest), timer.mindcontrol, icon.mindcontrol, true, BigWigsColors.db.profile.mindControl)
		if rest == UnitName("player") then
			self:Message(L["msg_mindControlYou"], "Attention", true, "Alarm")
		else
			self:Message(string.format(L["msg_mindControlOther"], rest), "Attention")
		end
	end
	if self.db.profile.puticon then
		self:Icon(rest, -1, timer.mindcontrol)
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:MindControl(UnitName("player"))
	module:BloodSiphon()
	
	module:BigWigs_RecvSync(syncName.bloodSiphon)
	module:BigWigs_RecvSync(syncName.mindcontrol, UnitName("player"))
	module:BigWigs_RecvSync(syncName.jeklik)
	module:BigWigs_RecvSync(syncName.arlokk, UnitName("player"))
	module:BigWigs_RecvSync(syncName.arlokkAvoid)
	module:BigWigs_RecvSync(syncName.venoxis)
	module:BigWigs_RecvSync(syncName.marli, UnitName("player"))
	module:BigWigs_RecvSync(syncName.marliAvoid)
	module:BigWigs_RecvSync(syncName.thekalStart)
	module:BigWigs_RecvSync(syncName.thekalStop)
end
