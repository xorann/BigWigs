------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Broodlord Lashlayer"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Broodlord",

	engage_trigger = "None of your kind should be here",
	ms_trigger = "^(.+) (.+) afflicted by Mortal Strike",
	bw_trigger = "^(.+) (.+) afflicted by Blast Wave",
	deathyou_trigger = "You die\.",
	deathother_trigger = "(.+) dies\.",
	ms_warn_you = "Mortal Strike on you!",
	ms_warn_other = "Mortal Strike on %s!",
	bw_warn = "Blast Wave soon!",
	ms_bar = "Mortal Strike: %s",
	bw_bar = "Blast Wave",

	you = "You",
	are = "are",

	ms_cmd = "ms",
	ms_name = "Mortal Strike",
	ms_desc = "Warn when someone gets Mortal Strike and starts a clickable bar for easy selection.",

	bw_cmd = "bw",
	bw_name = "Blast Wave",
	bw_desc = "Shows a bar with the possible Blast Wave cooldown.\n\n(Disclaimer: this varies anywhere from 8 to 15 seconds. Chosen shortest interval for safety.)",
} end )

L:RegisterTranslations("deDE", function() return {
	cmd = "Broodlord",
	
	engage_trigger = "None of your kind should be here",
	ms_trigger = "^(.+) (.+) von T\195\182dlicher Sto\195\159 betroffen",
	bw_trigger = "^(.+) (.+) von Druckwelle betroffen",
	deathyou_trigger = "Du stirbst\.",
	deathother_trigger = "(.+) stirbt\.",
	ms_warn_you = "T\195\182dlicher Sto\195\159 auf Dir!",
	ms_warn_other = "T\195\182dlicher Sto\195\159 auf %s!",
	bw_warn = "Druckwelle bald!",
	ms_bar = "T\195\182dlicher Sto\195\159: %s",
	bw_bar = "Druckwelle",

	you = "Ihr",
	are = "seid",

	ms_cmd = "ms",
	ms_name = "T\195\182dlicher Sto\195\159",
	ms_desc = "Warnung, wenn Spieler von T\195\182dlicher Sto\195\159 betroffen sind und beginnt einen anklickbaren Balken f\195\188r einfache Auswahl.",
	
	bw_cmd = "bw",
	bw_name = "Druckwelle",
	bw_desc = "Zeigt eine Balken mit der m\195\182glichen Druckwelle Abklingzeit.\n\n(Dementi: Diese variiert \195\188berall von 8 bis 15 den Sekunden Sie wurde k\195\188rzeste Intervall für die Sicherheit entschieden.)",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsBroodlord = BigWigs:NewModule(boss)
BigWigsBroodlord.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsBroodlord.enabletrigger = boss
BigWigsBroodlord.bossSync = "Broodlord"
BigWigsBroodlord.toggleoptions = {"ms", "bw", "bosskill"}
BigWigsBroodlord.revision = tonumber(string.sub("$Revision: 11206 $", 12, -3))
BigWigsBroodlord:RegisterYellEngage(L["engage_trigger"])

------------------------------
--      Initialization      --
------------------------------

function BigWigsBroodlord:OnEnable()
    self.started = nil
	self.lastbw = 0
    self.lastMS = 0
    self.MS = ""
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsBroodlord:Event(msg)
	local _, _, name, detect = string.find(msg, L["ms_trigger"])
	if name and detect and self.db.profile.ms then
        self.MS = name
        self.lastMS = GetTime()
		if detect == L["are"] then
			self:TriggerEvent("BigWigs_Message", L["ms_warn_you"], "Urgent")
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["ms_bar"], UnitName("player")), 5, "Interface\\Icons\\Ability_Warrior_SavageBlow", true, "Black")
			self:SetCandyBarOnClick("BigWigsBar "..string.format(L["ms_bar"], UnitName("player")), function(name, button, extra) TargetByName(extra, true) end, UnitName("player"))
            self:TriggerEvent("BigWigs_ShowIcon", "Interface\\Icons\\Ability_Warrior_SavageBlow", 5)
		else
			self:TriggerEvent("BigWigs_Message", string.format(L["ms_warn_other"], name), "Attention")
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["ms_bar"], name), 5, "Interface\\Icons\\Ability_Warrior_SavageBlow", true, "Black")
			self:SetCandyBarOnClick("BigWigsBar "..string.format(L["ms_bar"], name), function(name, button, extra) TargetByName(extra, true) end, name)
		end
	elseif string.find(msg, L["bw_trigger"]) and self.db.profile.bw then
		if GetTime() - self.lastbw > 5 then
			self:TriggerEvent("BigWigs_StartBar", self, L["bw_bar"], 8, "Interface\\Icons\\Spell_Holy_Excorcism_02", true, "Red")
			self:ScheduleEvent("BigWigs_Message", 24, L["bw_warn"], "Urgent", true, "Alert")
		end
		self.lastbw = GetTime()
	end
end

function BigWigsBroodlord:CHAT_MSG_COMBAT_FRIENDLY_DEATH(msg)
	if not self.db.profile.bw then return end
	local _, _, deathother = string.find(msg, L["deathother_trigger"])
	if msg == L["deathyou_trigger"] then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["ms_bar"], UnitName("player")))
	elseif deathother then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["ms_bar"], deathother))
	end
end

function BigWigsBroodlord:CHAT_MSG_MONSTER_YELL(msg)
	if not self.db.profile.bw then return end
	if string.find(msg, L["engage_trigger"]) and not self.started then
		self:TriggerEvent("BigWigs_StartBar", self, L["bw_bar"], 19.5, "Interface\\Icons\\Spell_Holy_Excorcism_02", true, "Red")
		self:ScheduleEvent("BigWigs_Message", 14.5, L["bw_warn"], "Urgent", true, "Alert")
        self:SendEngageSync()
        self:StartFight()
	end
end

function BigWigsBroodlord:PLAYER_TARGET_CHANGED()
    if (self.lastMS + 5) > GetTime() and UnitName("target") == self.MS then
        self:TriggerEvent("BigWigs_ShowIcon", "Interface\\Icons\\Ability_Warrior_SavageBlow", (self.lastMS + 5) - GetTime())
    else
        self:TriggerEvent("BigWigs_HideIcon", "Interface\\Icons\\Ability_Warrior_SavageBlow")
    end
end