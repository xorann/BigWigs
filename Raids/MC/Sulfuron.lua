------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Sulfuron Harbinger"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	triggeradddead = "Flamewaker Priest dies",
	triggercast = "begins to cast Dark Mending",
    spear_cast = "begins to perform Flame Spear",
	healbar = "Dark Mending",
	knockbacktimer = "AoE knockback",
	knockbackannounce = "3 seconds until knockback!",
	healwarn = "Healing!",
	knockback1 = "Hand of Ragnaros hits",
	knockback11 = "Hand of Ragnaros hits",
	knockback2 = "Hand of Ragnaros was resisted",
	knockback3 = "absorb (.+) Hand of Ragnaros",
	knockback33 = "Hand of Ragnaros is absorbed",
	knockback4 = "Hand of Ragnaros (.+) immune",
	flamewakerpriest_name = "Flamewaker Priest",

	addmsg = "%d/4 Flamewaker Priests dead!",

	cmd = "Sulfuron",
	
	knockback_cmd = "knockback",
	knockback_name = "Hand of Ragnaros announce",
	knockback_desc = "Show timer for knockbacks",
	
	heal_cmd = "heal",
	heal_name = "Adds' heals",
	heal_desc = "Announces Flamewaker Priests' heals",
	
	adds_cmd = "adds",
	adds_name = "Dead adds counter",
	adds_desc = "Announces dead Flamewaker Priests",
} end)

L:RegisterTranslations("deDE", function() return {
	triggeradddead = "Flamewaker Priest stirbt",
	triggercast = "beginnt Dunkle Besserung",
    spear_cast = "begins to perform Flame Spear",
	healbar = "Dunkle Besserung",
	knockbacktimer = "AoE R\195\188cksto\195\159",
	knockbackannounce = "3 Sekunden bis R\195\188cksto\195\159!",
	healwarn = "Heilung!",
	knockback1 = "trifft(.+)Hand von Ragnaros",
	knockback11 = "Hand von Ragnaros(.+)trifft",
	knockback2 = "Hand von Ragnaros(.+)widerstanden",
	knockback3 = "absorbiert (.+) Hand von Ragnaros",
	knockback33 = "Hand von Ragnaros (.+) absorbiert",
	knockback4 = "Hand von Ragnaros(.+) immun",
	flamewakerpriest_name = "Flamewaker Priest",

	addmsg = "%d/4 Flamewaker Priest tot!",

	cmd = "Sulfuron",
	
	knockback_cmd = "knockback",
	knockback_name = "Verk\195\188ndet Hand von Ragnaros",
	knockback_desc = "Zeige Timer f\195\188r R\195\188ckst\195\182\195\159e",
	
	heal_cmd = "heal",
	heal_name = "Heilung der Adds",
	heal_desc = "Verk\195\188ndet Heilung der Flamewaker Priest",
	
	adds_cmd = "adds",
	adds_name = "Z\195\164hler f\195\188r tote Adds",
	adds_desc = "Verk\195\188ndet Flamewaker Priests Tod",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsSulfuron = BigWigs:NewModule(boss)
BigWigsSulfuron.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsSulfuron.enabletrigger = boss
BigWigsSulfuron.bossSync = "Sulfuron"
BigWigsSulfuron.wipemobs = { L["flamewakerpriest_name"] }
BigWigsSulfuron.toggleoptions = {"heal", "adds", "knockback", "bosskill"}
BigWigsSulfuron.revision = tonumber(string.sub("$Revision: 11203 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsSulfuron:OnEnable()
    self.started = nil
    self.deadpriests = 0
    
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Events")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Events")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Events")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SulfuronAddHeal", 1)
	self:TriggerEvent("BigWigs_ThrottleSync", "SulfuronKnockback", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "SulfuronSpear", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsSulfuron:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if string.find(msg, L["triggeradddead"]) then
		self:TriggerEvent("BigWigs_SendSync", "SulfuronAddDead " .. tostring(self.deadpriests + 1))
	end
end

function BigWigsSulfuron:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if string.find(msg, L["triggercast"]) then
		self:TriggerEvent("BigWigs_SendSync", "SulfuronAddHeal")
	end
end

function BigWigsSulfuron:Events(msg)
	if (string.find(msg, L["knockback1"]) or string.find(msg, L["knockback11"]) or string.find(msg, L["knockback2"]) or string.find(msg, L["knockback3"]) or string.find(msg, L["knockback33"]) or string.find(msg, L["knockback4"])) then
		self:TriggerEvent("BigWigs_SendSync", "SulfuronKnockback")
    elseif string.find(msg,"spear_cast") then
        self:TriggerEvent("BigWigs_SendSync", "SulfuronSpear")
	end
end

function BigWigsSulfuron:BigWigs_RecvSync(sync, rest, nick)
	if not self.started and sync == "BossEngaged" and rest == self.bossSync then
        self:StartFight()
		if self.db.profile.knockback then
			self:ScheduleEvent("BigWigs_Message", 2.8, L["knockbackannounce"], "Urgent")
			self:TriggerEvent("BigWigs_StartBar", self, L["knockbacktimer"], 5.8 , "Interface\\Icons\\Spell_Fire_Fireball")
		end
        self:TriggerEvent("BigWigs_StartCounterBar", self, "Priests dead", 4, "Interface\\Icons\\Spell_Holy_BlessedRecovery")
        self:TriggerEvent("BigWigs_SetCounterBar", self, "Priests dead", (4 - 0.1))
	elseif sync == "SulfuronAddDead" and rest and rest ~= "" then
        rest = tonumber(rest)
        if rest <= 4 and self.deadpriests < rest then
            self.deadpriests = rest
            self:TriggerEvent("BigWigs_Message", string.format(L["addmsg"], self.deadpriests), "Positive")
            self:TriggerEvent("BigWigs_SetCounterBar", self, "Priests dead", (4 - self.deadpriests))
        end
	elseif sync == "SulfuronAddHeal" and self.db.profile.heal then		
		self:TriggerEvent("BigWigs_Message", L["healwarn"], "Attention", true, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["healbar"], 2 , "Interface\\Icons\\Spell_Shadow_ChillTouch")
	elseif sync == "SulfuronKnockback" and self.db.profile.knockback then
		self:ScheduleEvent("messagewarn1", "BigWigs_Message", 10.5, L["knockbackannounce"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["knockbacktimer"], 13.5 , "Interface\\Icons\\Spell_Fire_Fireball")
    elseif sync == "SulfuronSpear" then
        self:TriggerEvent("BigWigs_StartBar", self, "Flame Spear", 13 , "Interface\\Icons\\Spell_Fire_FlameBlades")
	end
end