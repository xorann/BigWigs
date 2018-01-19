------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.mc.gehennas
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Gehennas",
	
	-- commands	
	adds_cmd = "adds",
	adds_name = "Dead adds counter",
	adds_desc = "Announces dead Flamewakers",
	
	curse_cmd = "curse",
	curse_name = "Gehennas' Curse alert",
	curse_desc = "Warn for Gehennas' Curse",
            
    rain_cmd = "rain",
    rain_name = "Rain of Fire alert",
    rain_desc = "Shows a warning sign for Rain of Fire",
	
	-- triggers
	trigger_curseHit = "afflicted by Gehennas",
	trigger_rain = "You are afflicted by Rain of Fire",
	trigger_rainRun = "You suffer (%d+) (.+) from Gehennas 's Rain of Fire.",
	trigger_curseResist = "Gehennas' Curse was resisted",
	trigger_addDeath = "Flamewaker dies",
	
	-- messages
	msg_add = "%d/2 Flamewakers dead!",
	msg_curseSoon = "5 seconds until Gehennas' Curse!",
	msg_curseNow = "Gehennas' Curse - Decurse NOW!",
	msg_fire = "Move from FIRE!",
	
	-- bars
    bar_rain = "Next Rain",
	bar_curse = "Gehennas' Curse",
	
	-- misc
	misc_flamewakerName = "Flamewaker",
    ["Rain of Fire"] = true,

} end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	adds_name = "Zähler für tote Adds",
	adds_desc = "Verkündet Feuerschuppe Tod",
	
	curse_name = "Alarm für Gehennas' Fluch",
	curse_desc = "Warnen vor Gehennas' Fluch",
            
    rain_name = "Feuerregen",
    rain_desc = "Zeigt ein Warnzeichen bei Feuerregen",
	
	-- triggers
	trigger_curseHit = "von Gehennas(.+)Fluch betroffen",
	trigger_rain = "Ihr seid von Feuerregen betroffen",
	trigger_rainRun = "Ihr erleidet (%d+) (.+) von Gehennas Feuerregen.",	
	trigger_curseResist = "Gehennas\' Fluch(.+) widerstanden",
	trigger_addDeath = "Feuerschuppe stirbt",
	
	-- messages
	msg_add = "%d/2 Feuerschuppe tot!",
	msg_curseSoon = "5 Sekunden bis Gehennas' Fluch!",
	msg_curseNow = "Gehennas' Fluch - JETZT Entfluchen!",
	msg_fire = "Raus aus dem Feuer!",
	
	-- bars
    bar_rain = "Nächster Regen",
	bar_curse = "Gehennas' Fluch",
	
	-- misc
	misc_flamewakerName = "Feuerschuppe",
    ["Rain of Fire"] = "Feuerregen",
	
} end)
