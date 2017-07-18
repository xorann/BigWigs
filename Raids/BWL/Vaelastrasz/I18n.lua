------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.bwl.vaelastrasz
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Vaelastrasz",

	-- commands
	start_cmd = "start",
	start_name = "Start",
	start_desc = "Starts a bar for estimating the beginning of the fight.",
	flamebreath_cmd = "flamebreath",
	flamebreath_name = "Flame Breath",
	flamebreath_desc = "Warns when boss is casting Flame Breath.",
	adrenaline_cmd = "adrenaline",
	adrenaline_name = "Burning Adrenaline",
	adrenaline_desc = "Announces who received Burning Adrenaline and starts a clickable bar for easier selection.",
	whisper_cmd = "whisper",
	whisper_name = "Whisper",
	whisper_desc = "Whispers the players that got Burning Adrenaline, telling them to move away.",
	tankburn_cmd = "tankburn",
	tankburn_name = "Tank Burn",
	tankburn_desc = "Shows a bar for the Burning Adrenaline that will be applied on boss' target.",
	icon_cmd = "icon",
	icon_name = "Raid Icon",
	icon_desc = "Marks the player with Burning Adrenaline for easier localization.\n\n(Requires assistant or higher)",

	-- triggers
	trigger_adrenaline = "^(.+) (.+) afflicted by Burning Adrenaline\.",
	trigger_flamebreath = "Vaelastrasz the Corrupt begins to cast Flame Breath\.",
	trigger_yell1 = "^Too late, friends",
	trigger_yell2 = "^I beg you, mortals",
	trigger_yell3 = "^FLAME! DEATH! DESTRUCTION!",
	trigger_deathYou = "You die\.",
	trigger_deathOther = "(.+) dies\.",

	-- messages
	msg_breath = "Casting Flame Breath!",
	msg_tankBurnSoon = "Burning Adrenaline on tank in 5 seconds!",
	msg_adrenaline = "%s has Burning Adrenaline!",
	msg_adrenalineYou = "You have Burning Adrenaline! Go away!",

	-- bars
	bar_engage = "Start",
	bar_tankburn = "Tank Burn",
	bar_adrenaline = "Burning Adrenaline: %s",
	bar_breath = "Flame Breath",

	-- misc
	misc_are = "are",
}
end)

L:RegisterTranslations("deDE", function() return {
	cmd = "Vaelastrasz",
	trigger_adrenaline = "^(.+) (.+) von Brennendes Adrenalin betroffen\.",
	trigger_flamebreath = "Vaelastrasz the Corrupt beginnt Flammenatem zu wirken\.",
	trigger_yell1 = "^Too late, friends",
	trigger_yell2 = "^I beg you, mortals",
	trigger_yell3 = "^FLAME! DEATH! DESTRUCTION!",
	bar_engage = "Start",
	bar_tankburn = "Tank brennen",
	bar_adrenaline = "Brennendes Adrenalin: %s",
	bar_breath = "Flammenatem",
	msg_breath = "Wirkt Flammenatem!",
	msg_tankBurnSoon = "Brennendes Adrenalin am Tank in 5 Sekunden!",
	msg_adrenaline = "%s hat Brennendes Adrenalin!",
	msg_adrenalineYou = "Sie haben Brennendes Adrenalin! Geh weg!",
	trigger_deathYou = "Du stirbst\.",
	trigger_deathOther = "(.+) stirbt\.",
	misc_are = "seid",
	start_cmd = "start",
	start_name = "Start",
	start_desc = "Startet eine Balken f\195\188r die Sch\195\164tzung der Beginn des Kampfes.",
	flamebreath_cmd = "flamebreath",
	flamebreath_name = "Flammenatem",
	flamebreath_desc = "Warnt, wenn Boss wirft Flammenatem.",
	adrenaline_cmd = "adrenaline",
	adrenaline_name = "Brennendes Adrenalin",
	adrenaline_desc = "Gibt bekannt, die Brennendes Adrenalin empfangen und startet einen anklickbaren Balken f\195\188r eine einfachere Auswahl.",
	whisper_cmd = "whisper",
	whisper_name = "Fl\195\188stern",
	whisper_desc = "Fl\195\188stern die Spieler mit Brennendes Adrenalin, ihnen zu sagen, sich zu entfernen.",
	tankburn_cmd = "tankburn",
	tankburn_name = "Tank brennen",
	tankburn_desc = "Zeigt eine Balken f\195\188r die Brennendes Adrenalin, die auf Bosses Ziel angewendet wird.",
	icon_cmd = "icon",
	icon_name = "Schlachtzugsymbol",
	icon_desc = "Markiert den Spieler mit Brennendes Adrenalin zur leichteren Lokalisierung.\n\n(Ben\195\182tigt Schlachtzugleiter oder Assistent)",
}
end)
