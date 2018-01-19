------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.mc.majordomo
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Majordomo",
	
	-- commands
	adds_cmd = "adds",
	adds_name = "Dead adds counter",
	adds_desc = "Announces dead Healers and Elites",
	
	magic_cmd = "magic",
	magic_name = "Magic Reflection",
	magic_desc = "Warn for Magic Reflection",
	
	dmg_cmd = "dmg",
	dmg_name = "Damage Shield",
	dmg_desc = "Warn for Damage Shield",
	
	-- triggers
	trigger_victory = "My flame! Please don",
    trigger_engage = "Reckless mortals, none may challenge the sons of the living flame!",
	trigger_magic = "gains Magic Reflection",
	trigger_dmg = "gains Damage Shield",
	trigger_magicGone = "Magic Reflection fades",
	trigger_dmgGone = "Damage Shield fades",
	trigger_healerDeath = "Flamewaker Healer dies",
	trigger_eliteDeath = "Flamewaker Elite dies",
	
	-- messages
	msg_magic = "Magic Reflection for 10 seconds!",
	msg_dmg = "Damage Shield for 10 seconds!",
	msg_shieldSoon = "5 seconds until new auras!",
	msg_magicGone = "Magic Reflection down!",
	msg_dmgGone = "Damage Shield down!",
	msg_healerDeath = "%d/4 Flamewaker Healers dead!",
	msg_eliteDeath = "%d/4 Flamewaker Elites dead!",
	
	-- bars
	bar_magic = "Magic Reflection",
	bar_dmg = "Damage Shield",
	bar_nextShield = "New shields",
	
	-- misc	
	misc_eliteName = "Flamewaker Elite",
	misc_healerName = "Flamewaker Healer",

} end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	adds_name = "Zähler für tote Adds",
	adds_desc = "Verkündet Feuerschuppenheiler und Feuerschuppenelite Tod.",
	
	magic_name = "Magiereflexion",
	magic_desc = "Warnung, wenn Magiereflexion aktiv.",
	
	dmg_name = "Schadensschild",
	dmg_desc = "Warnung, wenn Schadensschild aktiv.",
	
	-- triggers
	trigger_victory = "Ich werde euch nun verlassen",
    trigger_engage = "Niemand fordert die Söhne der Lebenden Flamme heraus", --"Reckless mortals, none may challenge the sons of the living flame!",

	trigger_magic = "bekommt \'Magiereflexion'",
	trigger_dmg = "bekommt \'Schadensschild'",
	trigger_magicGone = "Magiereflexion schwindet von",
	trigger_dmgGone = "Schadensschild schwindet von",
	trigger_healerDeath = "Feuerschuppenheiler stirbt",
	trigger_eliteDeath = "Feuerschuppenelite stirbt",
	
	-- messages
	msg_magic = "Magiereflexion für 10 Sekunden!",
	msg_dmg = "Schadensschild für 10 Sekunden!",
	msg_shieldSoon = "Neue Schilder in 3 Sekunden!",
	msg_magicGone = "Magiereflexion beendet!",
	msg_dmgGone = "Schadensschild beendet!",
	msg_healerDeath = "%d/4 Heiler tot!",
	msg_eliteDeath = "%d/4 Elite tot!",
	
	-- bars
	bar_magic = "Magiereflexion",
	bar_dmg = "Schadensschild",
	bar_nextShield = "Nächstes Schild",
	
	-- misc
	misc_eliteName = "Feuerschuppenelite",
	misc_healerName = "Feuerschuppenheiler",

} end)
