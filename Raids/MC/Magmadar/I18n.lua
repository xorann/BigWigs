------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.mc.magmadar
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Magmadar",
	
	-- commands
	panic_cmd = "panic",
	panic_name = "Warn for Panic",
	panic_desc = "Warn when Magmadar casts Panic",
	
	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy alert",
	frenzy_desc = "Warn when Magmadar goes into a frenzy",
	
	-- triggers	
	trigger_frenzy = "goes into a killing frenzy!",
	trigger_panicHit = "afflicted by Panic.",
	trigger_panicImmune = "Panic fail(.+) immune.",
	trigger_panicResist = "Magmadar's Panic was resisted",
	trigger_frenzyGone = "Frenzy fades from Magmadar",
	
	-- messages
	msg_frenzy = "Frenzy! Tranq now!",
	msg_panicSoon = "Panic incoming soon!",
	msg_panicNow = "Fear! 30 seconds until next!",
	
	-- bars
	bar_frenzy = "Frenzy",
	bar_panic = "Panic",
	
	-- misc
	
} end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	panic_name = "Alarm für Panik",
	panic_desc = "Warnung, wenn Magmadar AoE Furcht wirkt.",
	
	frenzy_name = "Alarm für Raserei",
	frenzy_desc = "Warnung, wenn Magmadar in Raserei gerät.",
	
	-- triggers
	trigger_frenzy = "wird mörderisch wahnsinnig!",
	trigger_panicHit = "von Panik betroffen",
	trigger_panicImmune = "Panik(.+)immun",
	trigger_panicResist = "Panik(.+)widerstanden",
	trigger_frenzyGone = "Wutanfall schwindet von Magmadar.",
	
	-- messages
	msg_frenzy = "Raserei! Tranq jetzt!",
	msg_panicSoon = "Panik in 5 Sekunden!",
	msg_panicNow = "AoE Furcht! Nächste in 30 Sekunden!",
	
	-- bars
	bar_frenzy = "Wutanfall",
	bar_panic = "Panik",
	
	-- misc

} end)