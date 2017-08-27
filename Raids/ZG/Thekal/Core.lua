------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.zg.thekal
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = {L["misc_rogueName"], L["misc_shamanName"]} -- adds which will be considered in CheckForEngage
module.toggleoptions = {"bloodlust", "silence", "cleave", "heal", "disarm", -1, "phase", "punch", "tigers", "frenzy", "enraged", "bosskill"}


-- locals
module.timer = {
    forcePunch = 1,
    knockback = 7,
    adds = 28,
    bloodlust = 33,
}
local timer = module.timer

module.icon = {
    forcePunch = "INV_Gauntlets_31",
    knockback = "Ability_WarStomp",
    adds = "Ability_Hunter_Pet_Cat",
    bloodlust = "Spell_Nature_BloodLust",
    heal = "Spell_Holy_Heal",
    frenzy = "Ability_Druid_ChallangingRoar",
    silence = "Spell_Holy_Silence",
    mortalCleave = "Ability_Warrior_SavageBlow",
    disarm = "Ability_Warrior_Disarm",
    phase2 = "Spell_Holy_PrayerOfHealing"
}
local icon = module.icon

module.syncName = {
	phase2 = "ThekalPhaseTwo1",
	heal = "ThekalLorkhanHeal",
	frenzy = "ThekalFrenzyStart",
	frenzyOver = "ThekalFrenzyStop",
	bloodlust = "ThekalBloodlustStart",
	bloodlustOver = "ThekalBloodlustStop",
	silence = "ThekalSilenceStart",
	silenceOver = "ThekalSilenceStop",
	mortalcleave = "ThekalMortalCleave",
	disarm = "ThekalDisarm",
	enrage = "ThekalEnrage",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.phase2 and self.phase < 2 then
        self.phase = 2
		if self.db.profile.heal then
			self:RemoveBar(L["bar_heal"])
		end
		if self.db.profile.bloodlust then
			self:Bar(L["Next Bloodlust"], timer.bloodlust, icon.bloodlust)
		end
		if self.db.profile.phase then
			self:Message(L["msg_phase2"], "Attention")
		end
        self:Bar(L["New Adds"], timer.adds, icon.adds)
        self:Bar(L["Knockback"], timer.knockback, icon.knockback)
	elseif sync == syncName.heal and self.db.profile.heal then
		self:Message(L["msg_heal"], "Attention", "Alarm")
		self:Bar(L["bar_heal"], 4, icon.heal, true, "Black")
	elseif sync == syncName.frenzy and self.db.profile.frenzy then
		self:Message(L["msg_frenzy"], "Important", true, "Alarm")
		self:Bar(L["bar_frenzy"], 8, icon.frenzy, true, "Black")
	elseif sync == syncName.frenzyOver and self.db.profile.frenzy then
        self:RemoveBar(L["bar_frenzy"])
	elseif sync == syncName.bloodlust and self.db.profile.bloodlust then
		self:Message(string.format(L["msg_bloodlust"], rest), "Important")
		self:Bar(string.format(L["bar_bloodlust"], rest), 30, icon.bloodlust)
	elseif sync == syncName.bloodlustOver and self.db.profile.bloodlust then
		self:RemoveBar(string.format(L["bar_bloodlust"], rest))
	elseif sync == syncName.silence and self.db.profile.silence then
		self:Message(string.format(L["msg_silence"], rest), "Attention")
		self:Bar(string.format(L["bar_silence"], rest), 6, icon.silence, true, "White")
	elseif sync == syncName.silenceOver and self.db.profile.silence then
		self:RemoveBar(string.format(L["bar_silence"], rest))
	elseif sync == syncName.mortalcleave and self.db.profile.cleave then
		self:Bar(string.format(L["bar_mortalCleave"], rest), 5, icon.mortalCleave)
	elseif sync == syncName.disarm and self.db.profile.disarm then
		self:Bar(string.format(L["bar_disarm"], rest), 5, icon.disarm, true, "Yellow")
	elseif sync == syncName.enrage and self.db.profile.enraged then
		self:Message(L["msg_enrage"], "Urgent")
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:PhaseSwitch()
    BigWigs:ToggleModuleActive(module, true)
    module:Bar(L["bar_phase2"], 9, icon.phase2)
    module.phase = 1.5;
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:BigWigs_RecvSync(syncName.illusions)
end
