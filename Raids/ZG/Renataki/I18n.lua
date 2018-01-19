------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.zg.renataki
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Renataki",

	-- commands
	vanish_cmd = "vanish",
	vanish_name = "Vanish announce",
	vanish_desc = "Shows warnings for boss' Vanish.",
	
	enraged_cmd = "enraged",
	enraged_name = "Announce boss Enrage",
	enraged_desc = "Lets you know when boss hits harder.",
	
	-- triggers
	trigger_enrage = "Renataki gains Enrage\.",
	
	-- messages
	msg_enrageSoon = "Enrage soon! Get ready!",
	msg_enrageNow = "Enraged!",
	msg_vanishSoon = "Vanish soon!",
	msg_vanishNow = "Boss has vanished!",
	msg_unvanish = "Boss is revealed!",
	
	-- bars
	bar_vanish = "Vanish",
	
	-- misc

} end )

L:RegisterTranslations("deDE", function() return {
	cmd = "Renataki",

	-- commands
	vanish_cmd = "vanish",
	vanish_name = "Verschwinden anzeigen",
	vanish_desc = "Verk\195\188ndet Boss' Verschwinden.",
	
	enraged_cmd = "enraged",
	enraged_name = "Verk\195\188ndet Boss' Raserei",
	enraged_desc = "L\195\164sst dich wissen, wenn Boss h\195\164rter zuschl\195\164gt.",
	
	-- triggers
	trigger_enrage = "Renataki bekommt \'Wutanfall\'\.",
	
	-- messages
	msg_enrageSoon = "Raserei bald! Mach dich bereit!",
	msg_enrageNow = "Boss ist in Raserei!",
	msg_vanishSoon = "Verschwinden bald!",
	msg_vanishNow = "Boss ist verschwunden!",
	msg_unvanish = "Boss wird aufgedeckt!",
	
	-- bars
	bar_vanish = "Verschwinden",
	
	-- misc

} end )
