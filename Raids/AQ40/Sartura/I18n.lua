------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.aq40.sartura
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Sartura",

	-- commands
	adds_cmd = "adds",
	adds_name = "Dead adds counter",
	adds_desc = "Announces dead Sartura's Royal Guards.",
	enrage_cmd = "enrage",
	enrage_name = "Enrage",
	enrage_desc = "Announces the Enrage when the boss is at 20% HP.",
	berserk_cmd = "berserk",
	berserk_name = "Berserk",
	berserk_desc = "Warns for the Berserk that the boss gains after 10 minutes.",
	whirlwind_cmd = "whirlwind",
	whirlwind_name = "Whirlwind",
	whirlwind_desc = "Timers and bars for Whirlwinds.",

	-- triggers
	trigger_start = "defiling these sacred grounds",
	trigger_enrageEmote = "becomes enraged",
	trigger_enrage2 = "Battleguard Sartura gains Enrage.",
	trigger_enrage = "Battleguard Sartura gains Berserk.",
	trigger_whirlwindGain = "Battleguard Sartura gains Whirlwind.",
	trigger_whirlwindGone = "Whirlwind fades from Battleguard Sartura.",
	trigger_addDeath = "Sartura's Royal Guard dies.",

	-- messages
	msg_enrage = "Enrage!",
	msg_berserk = "Berserk!",
	msg_whirlwindGain = "Whirlwind!",
	msg_whirlwindGone = "Whirlwind ended!",
	msg_addDeath = "%d/3 Sartura's Royal Guards dead!",
	msg_berserk5m = "Berserk in 5 minutes!",
	msg_berserk3m = "Berserk in 3 minutes!",
	msg_berserk90 = "Berserk in 90 seconds!",
	msg_berserk60 = "Berserk in 60 seconds!",
	msg_berserk30 = "Berserk in 30 seconds!",
	msg_berserk10 = "Berserk in 10 seconds!",

	-- bars
	bar_whirlwind = "Whirlwind",
	bar_possibleWhirlwind = "Possible Whirlwind",
	bar_firstWhirlwind = "First Whirlwind",
	bar_berserk = "Berserk",

	-- misc
	misc_addName = "Sartura's Royal Guard",
}
end)

L:RegisterTranslations("deDE", function() return {
	cmd = "Sartura",

	-- commands
	adds_name = "Zähler für tote Adds",
	adds_desc = "Verkündet Sarturas Königswache Tod.",
	enrage_name = "Wutanfall",
	enrage_desc = "Meldet den Wutanfall, wenn der Boss bei 20% HP ist.",
	berserk_name = "Berserker",
	berserk_desc = "Warnt vor dem Berserkermodus, in den der Boss nach 10 Minuten geht.",
	whirlwind_name = "Wirbelwind",
	whirlwind_desc = "Timer und Balken für Wirbelwinde.",

	-- triggers
	trigger_start = "defiling these sacred grounds", -- translation missing
	trigger_enrageEmote = "becomes enraged", -- translation missing
	trigger_enrage2 = "Schlachtwache Sartura bekommt 'Wutanfall'.",
	trigger_enrage = "Schlachtwache Sartura bekommt 'Berserker'.",
	trigger_whirlwindGain = "Schlachtwache Sartura bekommt 'Wirbelwind'.",
	trigger_whirlwindGone = "Wirbelwind schwindet von Schlachtwache Sartura.",
	trigger_addDeath = "Sarturas Königswache stirbt.",

	-- messages
	msg_enrage = "Wutanfall!",
	msg_berserk = "Berserker!",
	msg_whirlwindGain = "Wirbelwind!",
	msg_whirlwindGone = "Wirbelwind ist zu Ende!",
	msg_addDeath = "%d/3 Sarturas Königswache tot!",
	msg_berserk5m = "Berserker in 5 Minuten!",
	msg_berserk3m = "Berserker in 3 Minuten!",
	msg_berserk90 = "Berserker in 90 Sekunden!",
	msg_berserk60 = "Berserker in 60 Sekunden!",
	msg_berserk30 = "Berserker in 30 Sekunden!",
	msg_berserk10 = "Berserker in 10 Sekunden!",

	-- bars
	bar_whirlwind = "Wirbelwind",
	bar_possibleWhirlwind = "Möglicher Wirbelwind",
	bar_firstWhirlwind = "Erster Wirbelwind",
	bar_berserk = "Berserker",

	-- misc
	misc_addName = "Sarturas Königswache",
}
end)
