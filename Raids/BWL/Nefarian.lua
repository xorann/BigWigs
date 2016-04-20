------------------------------
--      Are you local?      --
------------------------------
local boss = AceLibrary("Babble-Boss-2.2")["Nefarian"]
local victor = AceLibrary("Babble-Boss-2.2")["Lord Victor Nefarius"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local warnpairs = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	landing_soon_trigger = "Let the games begin!",
	landing_trigger = "Enough! Now you",
    landingNOW_trigger = "courage begins to wane",
	zerg_trigger = "Impossible! Rise my",
	fear_trigger = "Nefarian begins to cast Bellowing Roar",
	shadowflame_trigger = "Nefarian begins to cast Shadow Flame",

	triggerfear = "by Panic.",
	fbar = "Fear",
	land = "Estimated Landing",
	Mob_Spawn = "Mob Spawn",
	warn = "Fear in 1.5sec!",

	triggershamans	= "Shamans, show me",
	triggerdruid	= "Druids and your silly",
	triggerwarlock	= "Warlocks, you shouldn't be playing",
	triggerpriest	= "Priests! If you're going to keep",
	triggerhunter	= "Hunters and your annoying",
	triggerwarrior	= "Warriors, I know you can hit harder",
	triggerrogue	= "Rogues%? Stop hiding",
	triggerpaladin	= "Paladins",
	triggermage		= "Mages too%?",

	landing_soon_warning = "Nefarian landing in 30 seconds!",
	landing_very_soon = "Nefarian landing in 10 seconds!",
	landing_warning = "Nefarian is landing!",
	zerg_warning = "Zerg incoming!",
	fear_warning = "Fear in 2 sec!",
	fear_soon_warning = "Possible fear in ~5 sec",
	shadowflame_warning = "Shadow Flame incoming!",
	shadowflame_bar = "Shadow Flame",
	classcall_warning = "Class call incoming!",

	warnshaman	= "Shamans - Totems spawned!",
	warndruid	= "Druids - Stuck in cat form!",
	warnwarlock	= "Warlocks - Incoming Infernals!",
	warnpriest	= "Priests - Heals hurt!",
	warnhunter	= "Hunters - Bows/Guns broken!",
	warnwarrior	= "Warriors - Stuck in berserking stance!",
	warnrogue	= "Rogues - Ported and rooted!",
	warnpaladin	= "Paladins - Blessing of Protection!",
	warnmage	= "Mages - Incoming polymorphs!",

	classcall_bar = "Class call",
	fear_bar = "Possible fear",

	cmd = "Nefarian",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn for Shadow Flame",

	fear_cmd = "fear",
	fear_name = "Warn for Fear",
	fear_desc = "Warn when Nefarian casts AoE Fear",

	classcall_cmd = "classcall",
	classcall_name = "Class Call alert",
	classcall_desc = "Warn for Class Calls",

	otherwarn_cmd = "otherwarn",
	otherwarn_name = "Other alerts",
	otherwarn_desc = "Landing and Zerg warnings",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsNefarian = BigWigs:NewModule(boss)
BigWigsNefarian.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsNefarian.enabletrigger = { boss, victor }
BigWigsNefarian.bossSync = "Nefarian"
BigWigsNefarian.toggleoptions = {"shadowflame", "fear", "classcall", "otherwarn", "bosskill"}
BigWigsNefarian.revision = tonumber(string.sub("$Revision: 16639 $", 12, -3))
BigWigsNefarian:RegisterYellEngage(L["landing_soon_trigger"])

------------------------------
--      Initialization      --
------------------------------

function BigWigsNefarian:OnEnable()
    self.started = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
    self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "NefarianShadowflame", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "NefarianFear", 15)
    self.phase2 = nil
	
	if not warnpairs then warnpairs = {
		[L["triggershamans"]] = {L["warnshaman"], true},
		[L["triggerdruid"]] = {L["warndruid"], true},
		[L["triggerwarlock"]] = {L["warnwarlock"], true},
		[L["triggerpriest"]] = {L["warnpriest"], true},
		[L["triggerhunter"]] = {L["warnhunter"], true},
		[L["triggerwarrior"]] = {L["warnwarrior"], true},
		[L["triggerrogue"]] = {L["warnrogue"], true},
		[L["triggerpaladin"]] = {L["warnpaladin"], true},
		[L["triggermage"]] = {L["warnmage"], true},
		[L["landing_soon_trigger"]] = {L["landing_soon_warning"]},
		[L["landing_trigger"]] = {L["landing_warning"]},
		[L["zerg_trigger"]] = {L["zerg_warning"]},
	} end
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsNefarian:CHAT_MSG_MONSTER_YELL(msg)
    if string.find(msg, L["landingNOW_trigger"]) then
        self:TriggerEvent("BigWigs_SendSync", "NefarianLandingNOW")
    end
    
	for i,v in pairs(warnpairs) do
		if string.find(msg, i) then
			if v[2] then
				if self.db.profile.classcall then
					self:TriggerEvent("BigWigs_Message", v[1], "Important")
					self:ScheduleEvent("BigWigs_Message", 23, L["classcall_warning"], "Important", true, "Alarm")
					self:TriggerEvent("BigWigs_StartBar", self, L["classcall_bar"], 28, "Interface\\Icons\\Spell_Shadow_Charm")
				end
			else
				if string.find(msg, L["landing_soon_trigger"]) then 
                    --self:SendEngageSync()
				elseif self.db.profile.otherwarn and string.find(msg, L["landing_trigger"]) then 
					--self:TriggerEvent("BigWigs_Message", v[1], "Important", true, "Long")
				elseif self.db.profile.otherwarn and string.find(msg, L["zerg_trigger"]) then 
					self:TriggerEvent("BigWigs_Message", v[1], "Important", true, "Long")
				end
			end
			return
		end
	end
end

function BigWigsNefarian:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["fear_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "NefarianFear")
	elseif string.find(msg, L["shadowflame_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "NefarianShadowflame")
	end
end

function BigWigsNefarian:BigWigs_RecvSync(sync, rest, nick)
    if not self.started and sync == "BossEngaged" and rest == self.bossSync then
        self:StartFight()
        self:TriggerEvent("BigWigs_Message", L["landing_soon_warning"], "Important", true, "Long")
        self:TriggerEvent("BigWigs_StartBar", self, L["land"], 135, "Interface\\Icons\\INV_Misc_Head_Dragon_Black")
        self:TriggerEvent("BigWigs_StartBar", self, L["Mob_Spawn"], 10, "Interface\\Icons\\Spell_Holy_PrayerOfHealing")
        self:ScheduleEvent("BigWigs_Message", 105, L["landing_soon_warning"], "Important", true, "Alarm")
        self:ScheduleEvent("BigWigs_Message", 125, L["landing_very_soon"], "Important", true, "Long")
	elseif sync == "NefarianShadowflame" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_StartBar", self, L["shadowflame_bar"], 2, "Interface\\Icons\\Spell_Fire_Incinerate")
		self:TriggerEvent("BigWigs_Message", L["shadowflame_warning"], "Important")
		self:ScheduleEvent("BigWigs_StartBar", 2, self, L["shadowflame_bar"], 17, "Interface\\Icons\\Spell_Fire_Incinerate")
	elseif sync == "NefarianFear" and self.db.profile.fear then
        self:TriggerEvent("BigWigs_StopBar", self, L["fear_bar"])
		self:TriggerEvent("BigWigs_Message", L["fear_warning"], "Important", true, "Alert")
		self:TriggerEvent("BigWigs_StartBar", self, "Fear NOW!", 1.5, "Interface\\Icons\\Spell_Shadow_Charm")
		self:ScheduleEvent("BigWigs_StartBar", 1.5, self, L["fear_bar"], 25, "Interface\\Icons\\Spell_Shadow_Charm")
        self:TriggerEvent("BigWigs_ShowIcon", "Interface\\Icons\\Spell_Shadow_Possession", 5)
    elseif sync == "NefarianLandingNOW" and not self.phase2 then
        self.phase2 = true
        self:TriggerEvent("BigWigs_StopBar", self, L["land"])
        self:TriggerEvent("BigWigs_StartBar", self, "Landing NOW!", 13, "Interface\\Icons\\INV_Misc_Head_Dragon_Black")
        self:TriggerEvent("BigWigs_Message", L["landing_warning"], "Important")
	end
end

function BigWigsNefarian:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
    if string.find(msg,"Bellowing Roar") then
        self:TriggerEvent("BigWigs_HideIcon", "Interface\\Icons\\Spell_Shadow_Possession")
    end
end