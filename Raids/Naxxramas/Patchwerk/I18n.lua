------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.patchwerk
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Patchwerk",

	-- commands
	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	-- triggers
	trigger_enrage = "%s goes into a berserker rage!",
	trigger_engage1 = "Patchwerk want to play!",
	trigger_engage2 = "Kel'Thuzad make Patchwerk his Avatar of War!",

	-- messages
	msg_enrage = "Enrage!",
	msg_engage = "Patchwerk Engaged! Enrage in 7 minutes!",
	msg_enrage5m = "Enrage in 5 minutes",
	msg_enrage3m = "Enrage in 3 minutes",
	msg_enrage90 = "Enrage in 90 seconds",
	msg_enrage60 = "Enrage in 60 seconds",
	msg_enrage30 = "Enrage in 30 seconds",
	msg_enrage10 = "Enrage in 10 seconds",
	
	-- bars
	bar_enrage = "Enrage",
	
	-- misc
	
} end )

L:RegisterTranslations("deDE", function() return {
	--cmd = "Patchwerk",

	-- commands
	--enrage_cmd = "enrage",
	enrage_name = "Wutanfall Alarm",
	enrage_desc = "Warnung für Wutanfall",

	-- triggers
	trigger_enrage = "%s goes into a berserker rage!",
	trigger_engage1 = "Patchwerk want to play!",
	trigger_engage2 = "Kel'Thuzad make Patchwerk his Avatar of War!",

	-- messages
	msg_enrage = "Wutanfall!",
	msg_engage = "Flickwerk angegriffen! Wutanfall in 7 Minuten!",
	msg_enrage5m = "Wutanfall in 5 Minuten",
	msg_enrage3m = "Wutanfall in 3 Minuten",
	msg_enrage90 = "Wutanfall in 90 Sekunden",
	msg_enrage60 = "Wutanfall in 60 Sekunden",
	msg_enrage30 = "Wutanfall in 30 Sekunden",
	msg_enrage10 = "Wutanfall in 10 Sekunden",
	
	-- bars
	bar_enrage = "Wutanfall",
	
	-- misc
	
} end )