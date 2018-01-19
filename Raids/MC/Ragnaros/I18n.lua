------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.mc.ragnaros
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Ragnaros",

	-- commands
	emerge_cmd = "emerge",
	emerge_name = "Emerge alert",
	emerge_desc = "Warn for Ragnaros Emerge",

	adds_cmd = "adds",
	adds_name = "Son of Flame dies",
	adds_desc = "Warn when a son dies",

	submerge_cmd = "submerge",
	submerge_name = "Submerge alert",
	submerge_desc = "Warn for Ragnaros Submerge",

	aoeknock_cmd = "aoeknock",
	aoeknock_name = "Knockback alert",
	aoeknock_desc = "Warn for Wrath of Ragnaros knockback",
	
	-- triggers
	trigger_knockback = "^TASTE",
	trigger_submerge = "^COME FORTH,",
	trigger_engage = "^NOW FOR YOU",
    trigger_engageSoon = "TOO SOON! YOU HAVE AWAKENED ME TOO SOON",
    trigger_hammer = "^BY FIRE BE PURGED!",

	-- messages
	msg_knockbackNow = "Knockback!",
	msg_knockbackSoon = "5 sec to knockback!",
	msg_submerge = "Ragnaros submerged. Incoming Sons of Flame!",
	msg_emergeSoon = "15 sec until Ragnaros emerges!",
	msg_emergeNow = "Ragnaros emerged, 3 minutes until submerge!",
	msg_submerge60 = "60 sec to submerge!",
	msg_submerge30 = "30 sec to submerge!",
	msg_submerge10 = "10 sec to submerge!",
	msg_submerge5 = "5 sec to submerge!",
	msg_sonDeath = "%d/8 Sons of Flame dead!",
    msg_combat = "Combat",
	
	-- bars
	bar_knockback = "AoE knockback",
	bar_emerge = "Ragnaros emerge",
	bar_submerge = "Ragnaros submerge",
	bar_hammer = "Hammer of Ragnaros",

	-- misc
	misc_addName = "Son of Flame",
	
} end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	emerge_name = "Alarm für Abtauchen",
	emerge_desc = "Warnen, wenn Ragnaros auftaucht",

	adds_name = "Zähler für tote Adds",
	adds_desc = "Verkündet Sohn der Flamme Tod",

	submerge_name = "Alarm für Untertauchen",
	submerge_desc = "Warnen, wenn Ragnaros untertaucht",

	aoeknock_name = "Alarm für Rückstoss",
	aoeknock_desc = "Warnen, wenn Zorn des Ragnaros zurückstösst",
	
	-- triggers
	trigger_knockback = "DIE FLAMMEN VON SULFURON",
	trigger_submerge = "^Kommt herbei, meine Diener!",
	trigger_engage = "^NUN ZU EUCH,",
    trigger_engageSoon = "ZU FRÜH!",
    trigger_hammer = "^DAS FEUER WIRD EUCH!",
	
	-- messages
	msg_knockbackNow = "Rückstoss!",
	msg_knockbackSoon = "5 Sekunden bis Rückstoss!",
	msg_submerge = "Ragnaros ist untergetaucht! Söhne der Flamme kommen!",
	msg_emergeSoon = "15 Sekunden bis Ragnaros auftaucht",
	msg_emergeNow = "Ragnaros ist aufgetaucht, Untertauchen in 3 Minuten!",
	msg_submerge60 = "Auftauchen in 60 Sekunden!",
	msg_submerge30 = "Auftauchen in 30 Sekunden!",
	msg_submerge10 = "Auftauchen in 10 Sekunden!",
	msg_submerge5 = "Auftauchen in 5 Sekunden!",
	msg_sonDeath = "%d/8 Sohn der Flamme tot!",
    msg_combat = "Kampf beginnt",

	-- bars
	bar_knockback = "AoE Rückstoss",
	bar_emerge = "Ragnaros taucht auf",
	bar_submerge = "Ragnaros taucht unter",

	-- misc
	misc_addName = "Sohn der Flamme",

} end)
