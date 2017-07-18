------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.bwl.broodlord
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Broodlord",

	-- commands
	ms_cmd = "ms",
	ms_name = "Mortal Strike",
	ms_desc = "Warn when someone gets Mortal Strike and starts a clickable bar for easy selection.",
	bw_cmd = "bw",
	bw_name = "Blast Wave",
	bw_desc = "Shows a bar with the possible Blast Wave cooldown.\n\n(Disclaimer: this varies anywhere from 8 to 15 seconds. Chosen shortest interval for safety.)",

	-- triggers
	trigger_engage = "None of your kind should be here",
	trigger_mortalStrike = "^(.+) (.+) afflicted by Mortal Strike",
	trigger_blastWave = "^(.+) (.+) afflicted by Blast Wave",
	trigger_deathYou = "You die\.",
	trigger_deathOther = "(.+) dies\.",

	-- messages
	msg_mortalStrikeYou = "Mortal Strike on you!",
	msg_mortalStrikeOther = "Mortal Strike on %s!",
	msg_blastWave = "Blast Wave soon!",

	-- bars
	bar_mortalStrike = "Mortal Strike: %s",
	bar_blastWave = "Blast Wave",

	-- misc
	misc_you = "You",
	misc_are = "are",
}
end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	ms_name = "T\195\182dlicher Sto\195\159",
	ms_desc = "Warnung wenn ein Spieler von Tödlicher Sto\195\159 betroffen ist und startet einen anklickbaren Balken für eine einfache Auswahl.",
	bw_name = "Druckwelle",
	bw_desc = "Zeigt einen Balken mit der möglichen Druckwellenabklingzeit.\n\n(Hinweis: Diese variiert von 8 bis 15 Sekunden. Zur Sicherheit wurde der kürzeste Intervall gewählt.)",

	-- triggers
	trigger_engage = "Euresgleichen sollte nicht hier sein!",
	trigger_mortalStrike = "^(.+) (.+) von T\195\182dlicher Sto\195\159 betroffen",
	trigger_blastWave = "^(.+) (.+) von Druckwelle betroffen",
	trigger_deathYou = "Ihr sterbt.",
	trigger_deathOther = "(.+) stirbt.",

	-- messages
	msg_mortalStrikeYou = "T\195\182dlicher Sto\195\159 auf Dir!",
	msg_mortalStrikeOther = "T\195\182dlicher Sto\195\159 auf %s!",
	msg_blastWave = "Druckwelle bald!",

	-- bars
	bar_mortalStrike = "T\195\182dlicher Sto\195\159: %s",
	bar_blastWave = "Druckwelle",

	-- misc
	misc_you = "Ihr",
	misc_are = "seid",
}
end)
