------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.mc.shazzrah
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Shazzrah",
	
	-- commands
	counterspell_cmd = "counterspell",
	counterspell_name = "Counterspell alert",
	counterspell_desc = "Warn for Shazzrah's Counterspell",
	
	curse_cmd = "curse",
	curse_name = "Shazzrah's Curse alert",
	curse_desc = "Warn for Shazzrah's Curse",
	
	deaden_cmd = "deaden",
	deaden_name = "Deaden Magic alert",
	deaden_desc = "Warn when Shazzrah has Deaden Magic",
	
	blink_cmd = "blink",
	blink_name = "Blink alert",
	blink_desc = "Warn when Shazzrah Blinks",
	
	-- triggers
	trigger_blink = "casts Gate of Shazzrah",
	trigger_deaden = "Shazzrah gains Deaden Magic",
	trigger_curseHit = "afflicted by Shazzrah",
	trigger_counterspellCast = "Shazzrah casts Counterspell",
    trigger_counterspellResist = "Shazzrah(.+) Counterspell was resisted by",
	trigger_curseResist = "Shazzrah(.+) Curse was resisted",
	trigger_deadenGone = "Deaden Magic fades from Shazzrah",
	
	-- messages
	msg_blinkNow = "Blink - 45 seconds until next one!",
	msg_blinkSoon = "3 seconds to Blink!",
	msg_deaden = "Deaden Magic is up! Dispel it!",
	msg_curse = "Shazzrah's Curse! Decurse NOW!",
	
	-- bars
	bar_blink = "Possible Blink",
	bar_deaden = "Deaden Magic",
	bar_curse = "Shazzrah's Curse",
	bar_counterspell = "Possible Counterspell",
	
	-- misc
	
} end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	counterspell_name = "Alarm für Gegenzauber",
	counterspell_desc = "Warnen vor Shazzrahs Gegenzauber",
	
	curse_name = "Alarm für Shazzrahs Fluch",
	curse_desc = "Warnen vor Shazzrahs Fluch",
	
	deaden_name = "Alarm für Magie dämpfen",
	deaden_desc = "Warnen wenn Shazzrah Magie dämpfen hat",
	
	blink_name = "Alarm für Blinzeln",
	blink_desc = "Warnen wenn Shazzrah blinzelt",
	
	-- triggers
	trigger_blink = "Shazzrah wirkt Portal von Shazzrah",
	trigger_deaden = "Shazzrah bekommt \'Magie dämpfen",
	trigger_curseHit = "von Shazzrahs Fluch betroffen",
	trigger_counterspellCast = "Shazzrah wirkt Gegenzauber",
    trigger_counterspellResist = "Shazzrahs Gegenzauber wurde von (.+) widerstanden",
	trigger_curseResist = "Shazzrahs Fluch(.)widerstanden",
	trigger_deadenGone = "Magie dämpfen schwindet von Shazzrah",
	
	-- messages
	msg_blinkNow = "Blinzeln! Nächstes in ~45 Sekunden!",
	msg_blinkSoon = "Blinzeln in ~5 Sekunden!",
	msg_deaden = "Magie dämpfen auf Shazzrah! Entferne magie!",
	msg_curse = "Shazzrahs Fluch! Entfluche JETZT!",
	
	-- bars
	bar_blink = "Mögliches Blinzeln",
	bar_deaden = "Magie dämpfen",
	bar_curse = "Nächster Fluch",
	bar_counterspell = "Möglicher Gegenzauber",
	
	-- misc
	
} end)
