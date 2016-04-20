------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Magmadar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local _, playerClass = UnitClass("player")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	-- Chat message triggers
	trigger1 = "goes into a killing frenzy!",
	trigger2 = "afflicted by Panic.",
	trigger3 = "Panic fail(.+) immune.",
	trigger4 = "Magmadar's Panic was resisted",
	frenzy_bar = "Frenzy",
	frenzyfade_trigger = "Frenzy fades from Magmadar",

	-- Warnings and bar texts
	frenzyann = "Frenzy! Tranq now!",
	fearsoon = "Panic incoming soon!",
	feartime = "Fear! ~30 seconds until next!",
	fearbar = "Panic",

	-- AceConsole strings
	cmd = "Magmadar",
	
	panic_cmd = "panic",
	panic_name = "Warn for Panic",
	panic_desc = "Warn when Magmadar casts Panic",
	
	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy alert",
	frenzy_desc = "Warn when Magmadar goes into a frenzy",
} end)

L:RegisterTranslations("deDE", function() return {
	trigger1 = "goes into a killing frenzy!",
	trigger2 = "von Panik betroffen",
	trigger3 = "Panik(.+)immun",
	trigger4 = "Panik(.+)widerstanden",
	frenzy_bar = "Wutanfall",
	frenzyfade_trigger = "Wutanfall schwindet von Magmadar.",

	frenzyann = "Raserei! Tranq jetzt!",
	fearsoon = "Panik in 5 Sekunden!",
	feartime = "AoE Furcht! N\195\164chste in ~30 Sekunden!",
	fearbar = "Panik",

	panic_cmd = "panic",
	panic_name = "Alarm f\195\188r Panik",
	panic_desc = "Warnung, wenn Magmadar AoE Furcht wirkt.",
	
	frenzy_cmd = "frenzy",
	frenzy_name = "Alarm f\195\188r Raserei",
	frenzy_desc = "Warnung, wenn Magmadar in Raserei ger\195\164t.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMagmadar = BigWigs:NewModule(boss)
BigWigsMagmadar.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsMagmadar.enabletrigger = boss
BigWigsMagmadar.bossSync = "Magmadar"
BigWigsMagmadar.toggleoptions = {"panic", "frenzy", "bosskill"}
BigWigsMagmadar.revision = tonumber(string.sub("$Revision: 11204 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMagmadar:OnEnable()
	firstpanic = 0
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Panic")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Panic")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Panic")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Panic")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Panic")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Panic")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MagmadarPanic", 15)
	self:TriggerEvent("BigWigs_ThrottleSync", "MagmadarFrenzyStart", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MagmadarFrenzyStop", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MagmadarPanicIni", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsMagmadar:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(arg1, L["trigger1"]) and self.db.profile.frenzy then
		self:TriggerEvent("BigWigs_SendSync", "MagmadarFrenzyStart")
	end
end

function BigWigsMagmadar:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if string.find(msg, L["frenzyfade_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "MagmadarFrenzyStop")
	end
end

function BigWigsMagmadar:BigWigs_RecvSync(sync, rest, nick)
	if not self.started and sync == "BossEngaged" and rest == self.bossSync then
		if firstpanic == 0 then
			self:TriggerEvent("BigWigs_SendSync", "MagmadarPanicIni")
		end
	elseif sync == "MagmadarPanicIni" then
		firstpanic = 1
		if self.db.profile.panic then
			self:ScheduleEvent("BigWigs_Message", 15, L["fearsoon"], "Attention")		
			self:TriggerEvent("BigWigs_StartBar", self, L["fearbar"], 20, "Interface\\Icons\\Spell_Shadow_DeathScream")
		end
        self:TriggerEvent("BigWigs_StartBar", self, "First Frenzy", 29, "Interface\\Icons\\Ability_Druid_ChallangingRoar")
        --self:TriggerEvent("BigWigs_StartBar", self, "Lava Bomb", 12, "Interface\\Icons\\Spell_Fire_SelfDestruct")
        --self:ScheduleEvent("BigWigs_SendSync", 12, "MagmadarLavaBomb")
	elseif sync == "MagmadarPanic" and self.db.profile.panic then
		self:TriggerEvent("BigWigs_Message", L["feartime"], "Important")
		self:ScheduleEvent("BigWigs_Message", 30, L["fearsoon"], "Urgent")		
		self:TriggerEvent("BigWigs_StartBar", self, L["fearbar"], 35, "Interface\\Icons\\Spell_Shadow_DeathScream")
	elseif sync == "MagmadarFrenzyStart" and self.db.profile.frenzy then
		self:TriggerEvent("BigWigs_Message", L["frenzyann"], "Important", true, "Alert")
		self:TriggerEvent("BigWigs_StartBar", self, L["frenzy_bar"], 8, "Interface\\Icons\\Ability_Druid_ChallangingRoar", true, "red")
        if playerClass == "HUNTER" then
            self:TriggerEvent("BigWigs_ShowIcon", "Interface\\Icons\\Spell_Nature_Drowsy", 8, true)
        end
	elseif sync == "MagmadarFrenzyStop" and self.db.profile.frenzy then
        self:TriggerEvent("BigWigs_StopBar", self, L["frenzy_bar"])
        self:TriggerEvent("BigWigs_HideIcon", "Interface\\Icons\\Spell_Nature_Drowsy")
    elseif sync == "MagmadarLavaBomb" then
        --self:TriggerEvent("BigWigs_StartBar", self, "Lava Bomb", 11, "Interface\\Icons\\Spell_Fire_SelfDestruct")
        --self:ScheduleEvent("BigWigs_SendSync", 11, "MagmadarLavaBomb")
	end
end

function BigWigsMagmadar:Panic(msg)
	if ((string.find(msg, L["trigger2"])) or (string.find(msg, L["trigger3"])) or (string.find(msg, L["trigger4"]))) then
		self:TriggerEvent("BigWigs_SendSync", "MagmadarPanic")
	end
end
