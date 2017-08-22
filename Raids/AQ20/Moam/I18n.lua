------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.aq20.moam
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Moam",

	-- commands
	adds_cmd = "adds",
	adds_name = "Mana Fiend Alert",
	adds_desc = "Warn for Mana fiends",

	paralyze_cmd = "paralyze",
	paralyze_name = "Paralyze Alert",
	paralyze_desc = "Warn for Paralyze",

	-- triggers
	trigger_adds = "drains your mana and turns to stone.",
	trigger_return1 = "Energize fades from Moam.",
    trigger_return2 = "bristles with energy",
	
	-- messages
	msg_engage = "Moam Engaged! 90 Seconds until adds!",
	msg_addsSoon = "Mana Fiends incoming in %s seconds!",
	msg_addsNow = "Mana Fiends spawned! Moam Paralyzed for 90 seconds!",
	msg_returnSoon = "Moam unparalyzed in %s seconds!",
	msg_returnNow = "Moam unparalyzed! 90 seconds until Mana Fiends!",	
	
	-- bars
	bar_adds = "Adds",
	bar_paralyze = "Paralyze",
	
	-- misc
	
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	adds_name = "Elementare",
	adds_desc = "Warnung, wenn Elementare erscheinen.",

	paralyze_name = "Steinform",
	paralyze_desc = "Warnung, wenn Moam in Steinform.",

	-- triggers
	trigger_adds = "entzieht Euch Euer Mana und versteinert Euch.",
	trigger_return1 = "Energiezufuhr schwindet von Moam.",
	
	-- messages
	msg_engage = "Moam angegriffen! Elementare in 90 Sekunden!",
	msg_addsSoon = "Elementare in %s Sekunden!",
	msg_addsNow = "Elementare! Moam in Steinform f\195\188r 90 Sekunden.",
	msg_returnSoon = "Moam erwacht in %s Sekunden!",
	msg_returnNow = "Moam erwacht! Elementare in 90 Sekunden!",
	
	-- bars
	bar_adds = "Elementare",
	bar_paralyze = "Steinform",
	
	-- misc	
	
} end )
