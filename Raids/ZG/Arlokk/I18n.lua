------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.zg.arlokk
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Arlokk",

	-- commands
	vanish_cmd = "vanish",
	vanish_name = "Vanish alert",
	vanish_desc = "Shows a bar for the Vanish duration.",

	mark_cmd = "mark",
	mark_name = "Mark of Arlokk alert",
	mark_desc = "Warns when people are marked.",

	whirlwind_cmd = "whirlwind",
	whirlwind_name = "Whirldind alert",
	whirlwind_desc = "Shows you when the boss has Whirlwind.",
	
	phase_cmd = "phase",
	phase_name = "Phase notification",
	phase_desc = "Announces the boss' phase transitions.",
	
	puticon_cmd = "puticon",
	puticon_name = "Raid icon on marked players",
	puticon_desc = "Place a raid icon on the player with Mark of Arlokk.\n\n(Requires assistant or higher)",
	
	-- triggers
    trigger_engage = "your priestess calls upon your might",
	trigger_mark = "Feast on (.+), my pretties!",
	trigger_whirlwind = "High Priestess Arlokk gains Whirlwind\.",
	
	-- messages
	msg_markYou = "You are marked!",
	msg_markOther = "%s is marked!",
	msg_markGone = "Mark of Arlokk fades from (.+)\.",
	msg_phaseTroll = "Troll Phase",
	msg_phasePanther = "Panther Phase",
	msg_phaseVanish = "Vanish!",
	
	-- bars
	bar_whirlwind = "Whirlwind",
	bar_vanishReturn = "Estimated Return",
	bar_vanishNext = "Next Vanish",
	
	-- misc
	
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	vanish_name = "Verschwinden anzeigen",
	vanish_desc = "Verk\195\188ndet Boss' Verschwinden.",

	mark_name = "Alarm f\195\188r Arlokks Mal",
	mark_desc = "Warnt wenn Spieler markiert sind.",

	whirlwind_name = "Alarm f\195\188r Wirbelwind",
	whirlwind_desc = "Zeigt Balken f\195\188r Wirbelwind.",
	
	phase_name = "Phasen-Benachrichtigung",
	phase_desc = "Verk\195\188ndet den Phasenwechsel des Bosses.",
	
	puticon_name = "Schlachtzugsymbol auf die markiert Spieler",
	puticon_desc = "Versetzt eine Schlachtzugsymbol auf der markiert Spieler.\n\n(Ben\195\182tigt Schlachtzugleiter oder Assistent)",
	
	-- triggers
    trigger_engage = "your priestess calls upon your might",
	trigger_mark = "Feast on (.+), my pretties!",
	trigger_whirlwind = "High Priestess Arlokk bekommt \'Wirbelwind\'\.",
	
	-- messages
	msg_markYou = "Du bist markiert!",
	msg_markOther = "%s ist markiert!",
	msg_markGone = "Arlokks Mal schwindet von (.+)\.",
	msg_phaseTroll = "Troll Phase",
	msg_phasePanther = "Panther Phase",
	msg_phaseVanish = "Verschwinden!",
	
	-- bars
	bar_whirlwind = "Wirbelwind",
	bar_vanishReturn = "Ungefähre Rückkehr",
	bar_vanishNext = "Nächstes Verschwinden",
	
	-- misc	

} end )
