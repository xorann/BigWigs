------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Baron Geddon"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	inferno_trigger = "Baron Geddon gains Inferno\.",
	service_trigger = "performs one last service for Ragnaros",
	ignitemana_trigger = "afflicted by Ignite Mana",
	bombyou_trigger = "You are afflicted by Living Bomb.",
	bombother_trigger = "(.*) is afflicted by Living Bomb.",
	bombyouend_trigger = "Living Bomb fades from you.",
	bombotherend_trigger = "Living Bomb fades from (.*).",
	ignitemana_trigger1 = "afflicted by Ignite Mana",
	ignitemana_trigger2 = "Ignite Mana was resisted",
	deathyou_trigger = "You die.",
	deathother_trigger = "(.*) dies",

	bomb_message_you = "You are the bomb!",
	bomb_message_youscreen = "You are the bomb!",
	bomb_message_other = "%s is the bomb!",

	bomb_bar = "Living Bomb: %s",
	bomb_bar1 = "Living Bomb: %s",
	inferno_bar = "Next Inferno",
	inferno_channel = "Inferno",
	nextinferno_message = "3 seconds until Inferno!",
	service_bar = "Last Service",
	nextbomb_bar = "Next Living Bomb",
	ignite_bar = "Next Ignite Mana",

	service_message = "Last Service! Baron Geddon exploding in 8 seconds!",
	inferno_message = "Inferno for 8 seconds!",
	ignite_message = "Dispel NOW!",

	cmd = "Baron",

	service_cmd = "service",
	service_name = "Last Service warning",
	service_desc = "Timer bar for Geddon's last service.",

	inferno_cmd = "inferno",
	inferno_name = "Inferno alert",
	inferno_desc = "Timer bar for Geddon's Inferno.",

	bombtimer_cmd = "bombtimer",
	bombtimer_name = "Living Bomb timers",
	bombtimer_desc = "Shows a 8 second bar for when the bomb goes off at the target.",

	bomb_cmd = "bomb",
	bomb_name = "Living Bomb alert",
	bomb_desc = "Warn when players are the bomb",
	
	mana_cmd = "manaignite",
	mana_name = "Ignite Mana alert",
	mana_desc = "Shows timers for Ignite Mana and announce to dispel it",

	icon_cmd = "icon",
	icon_name = "Raid Icon on bomb",
	icon_desc = "Put a Raid Icon on the person who's the bomb. (Requires assistant or higher)",

	announce_cmd = "whispers",
	announce_name = "Whisper to Bomb targets",
	announce_desc = "Sends a whisper to players targetted by Living Bomb. (Requires assistant or higher)",
} end)

L:RegisterTranslations("deDE", function() return {
	inferno_trigger = "Baron Geddon bekommt \'Inferno",
	service_trigger = "performs one last service for Ragnaros",
	ignitemana_trigger = "von Mana entz\195\188nden betroffen",
	bombyou_trigger = "Ihr seid von Lebende Bombe betroffen.",
	bombother_trigger = "(.*) ist von Lebende Bombe betroffen.",
	bombyouend_trigger = "'Lebende Bombe\' schwindet von Euch.",
	bombotherend_trigger = "Lebende Bombe schwindet von (.*).",
	ignitemana_trigger1 = "von Mana entz\195\188nden betroffen",
	ignitemana_trigger2 = "Mana entz\195\188nden(.+)widerstanden",
	deathyou_trigger = "Du stirbst.",
	deathother_trigger = "(.*) stirbt",

	bomb_message_you = "You are the bomb!",
	bomb_message_youscreen = "Du bist die Bombe!",
	bomb_message_other = "%s ist die Bombe!",

	bomb_bar = "Lebende Bombe: %s",
	bomb_bar1 = "Lebende Bombe: %s",
	inferno_bar = "N\195\164chstes Inferno",
	inferno_channel = "Inferno",
	nextinferno_message = "3 Sekunden bis Inferno!",
	service_bar = "Letzter Dienst.",
	nextbomb_bar = "N\195\164chste Lebende Bombe",
	ignite_bar = "N\195\164chste Mana entz\195\188nden",

	service_message = "Letzter Dienst! Baron Geddon explodiert in 8 Sekunden!",
	inferno_message = "Inferno 8 Sekunden lang!",
	ignite_message = "Entferne Magie JETZT!",

	cmd = "Baron",

	service_cmd = "service",
	service_name = "Alarm f\195\188r Letzten Dienst",
	service_desc = "Timer Balken f\195\188r Baron Geddons Letzten Dienst.",

	inferno_cmd = "inferno",
	inferno_name = "Alarm f\195\188r Inferno",
	inferno_desc = "Timer Balken f\195\188r Baron Geddons Inferno.",

	bombtimer_cmd = "bombtimer",
	bombtimer_name = "Timer f\195\188r Lebende Bombe",
	bombtimer_desc = "Zeigt einen 8 Sekunden Timer f\195\188r die Explosion der Lebenden Bombe an.",

	bomb_cmd = "bomb",
	bomb_name = "Alarm f\195\188r Lebende Bombe",
	bomb_desc = "Warnen, wenn andere Spieler die Bombe sind.",
	
	mana_cmd = "mana",
	mana_name = "Alarm f\195\188r Mana entz\195\188nden",
	mana_desc = "Zeige Timer f\195\188r Mana entz\195\188nden und verk\195\188nde Magie entfernen",

	icon_cmd = "icon",
	icon_name = "Schlachtzugssymbole auf die Bombe",
	icon_desc = "Markiert den Spieler, der die Bombe ist.\n\n(Ben\195\182tigt Schlachtzugleiter oder Assistent).",

	announce_cmd = "whispers",
	announce_name = "Der Bombe fl\195\188stern",
	announce_desc = "Dem Spieler fl\195\188stern, wenn er die Bombe ist.\n\n(Ben\195\182tigt Schlachtzugleiter oder Assistent).",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsBaronGeddon                  = BigWigs:NewModule(boss)
BigWigsBaronGeddon.zonename         = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsBaronGeddon.enabletrigger    = boss
BigWigsBaronGeddon.bossSync         = "Geddon"
BigWigsBaronGeddon.toggleoptions    = {"inferno", "service", "bomb", "mana", "announce", "icon", "bosskill"}
BigWigsBaronGeddon.revision         = tonumber(string.sub("$Revision: 11203 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsBaronGeddon:OnEnable()
    self.started = nil
	firstinferno = 0
	firstbomb = 0
	firstignite = 0
	bombt = 0
	ignitestart = 0
	bombstart = 0
    
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH", "Event")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "GeddonBombX", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "GeddonBombStop", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "GeddonServiceX", 4)
	self:TriggerEvent("BigWigs_ThrottleSync", "GeddonManaIgniteX", 4)
	self:TriggerEvent("BigWigs_ThrottleSync", "GeddonManaIgniteFirst", 4)
	self:TriggerEvent("BigWigs_ThrottleSync", "GeddonInfernoX", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "GeddonInfernoFirst", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsBaronGeddon:Event(msg)
	local _,_, bombother, mcverb = string.find(msg, L["bombother_trigger"])
	local _,_, bombotherend, mcverb = string.find(msg, L["bombotherend_trigger"])
	local _,_, bombotherdeath,mctype = string.find(msg, L["deathother_trigger"])
	if string.find(msg, L["bombyou_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "GeddonBombX")
		if self.db.profile.bomb then
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["bomb_bar1"], UnitName("player")), 8, "Interface\\Icons\\Inv_Enchant_EssenceAstralSmall")
			self:TriggerEvent("BigWigs_Message", L["bomb_message_youscreen"], "Attention", "Alarm")
		end
		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", UnitName("player"))
		end
        self:TriggerEvent("BigWigs_ShowIcon", "Interface\\Icons\\Spell_Shadow_MindBomb", 8)
	elseif string.find(msg, L["bombyouend_trigger"]) then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["bomb_bar1"], UnitName("player")))
		self:TriggerEvent("BigWigs_SendSync", "GeddonBombStop")
	elseif string.find(msg, L["deathyou_trigger"]) then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["bomb_bar1"], UnitName("player")))
	elseif bombother then
		bombt = bombother
		self:TriggerEvent("BigWigs_SendSync", "GeddonBombX")
		if self.db.profile.bomb then
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["bomb_bar"], bombother), 8, "Interface\\Icons\\Inv_Enchant_EssenceAstralSmall")
			self:TriggerEvent("BigWigs_Message", string.format(L["bomb_message_other"], bombother), "Attention")
		end
		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", bombother)
		end
		if self.db.profile.announce then
			self:TriggerEvent("BigWigs_SendTell", bombother, L["bomb_message_you"])
		end
	elseif bombotherend then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["bomb_bar"], bombotherend))
	elseif string.find(msg, L["deathother_trigger"]) then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["bomb_bar"], bombotherdeath))
	elseif (string.find(msg, L["ignitemana_trigger1"]) or string.find(msg, L["ignitemana_trigger2"])) then
		self:TriggerEvent("BigWigs_SendSync", "GeddonManaIgniteX")
	end
end

function BigWigsBaronGeddon:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["inferno_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "GeddonInfernoX")
	end
end

function BigWigsBaronGeddon:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, L["service_trigger"]) and self.db.profile.service then
		self:TriggerEvent("BigWigs_SendSync", "GeddonServiceX")
	end
end

function BigWigsBaronGeddon:BigWigs_RecvSync(sync, rest, nick)
	if not self.started and sync == "BossEngaged" and rest == self.bossSync then
        self:StartFight()
		if self.db.profile.inferno then
			self:ScheduleEvent("BigWigs_Message", 11.5, L["nextinferno_message"], "Urgent")
			self:TriggerEvent("BigWigs_StartBar", self, L["inferno_bar"], 14.5, "Interface\\Icons\\Spell_Fire_Incinerate")
		end
		if self.db.profile.mana then
			self:TriggerEvent("BigWigs_StartBar", self, L["ignite_bar"], 30, "Interface\\Icons\\Spell_Fire_Incinerate")
		end
	elseif sync == "GeddonBombX" then
		bombstart = GetTime()
	elseif sync == "GeddonInfernoX" then
		if self.db.profile.inferno then
			self:TriggerEvent("BigWigs_Message", L["inferno_message"], "Important")
			self:ScheduleEvent("BigWigs_Message", 23, L["nextinferno_message"], "Urgent")
			self:TriggerEvent("BigWigs_StartBar", self, L["inferno_channel"], 9, "Interface\\Icons\\Spell_Fire_Incinerate")
			self:ScheduleEvent("BigWigs_StartBar", 9, self, L["inferno_bar"], 16, "Interface\\Icons\\Spell_Fire_Incinerate")
		end
	elseif sync == "GeddonManaIgniteX" and self.db.profile.mana then
		ignitestart = GetTime()
		self:TriggerEvent("BigWigs_Message", L["ignite_message"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["ignite_bar"], 30, "Interface\\Icons\\Spell_Fire_Incinerate")
	elseif sync == "GeddonBombStop" and self.db.profile.bomb then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["bomb_bar"], bombt))
	elseif sync == "GeddonServiceX" and self.db.profile.service then
		self:TriggerEvent("BigWigs_StartBar", self, L["service_bar"], 8, "Interface\\Icons\\Spell_Fire_SelfDestruct")
		self:TriggerEvent("BigWigs_Message", L["service_message"], "Important")
	end
end
