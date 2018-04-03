------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.gluth
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Gluth",

	-- commands
	fear_cmd = "fear",
	fear_name = "Fear Alert",
	fear_desc = "Warn for fear",

	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy Alert",
	frenzy_desc = "Warn for frenzy",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Timer",
	enrage_desc = "Warn for Enrage",

	decimate_cmd = "decimate",
	decimate_name = "Decimate Alert",
	decimate_desc = "Warn for Decimate",
	
	-- triggers
	trigger_berserk = "gains Berserk",
	trigger_fear = "by Terrifying Roar.",
	trigger_engage = "devours all nearby zombies!",
    trigger_frenzyGain1 = "Gluth gains Frenzy.",
	trigger_frenzyGain2 = "Gluth goes into a frenzy!",
	trigger_frenzyGone = "Frenzy fades from Gluth.",
	trigger_decimate = "decimates all nearby flesh!",
	
	-- messages
	msg_fearSoon = "5 second until AoE Fear!",
	msg_fearNow = "AoE Fear alert - 20 seconds till next!",
	msg_enrage = "ENRAGE!",
	msg_enrage90 = "Enrage in 90 seconds",
	msg_enrage30 = "Enrage in 30 seconds",
	msg_enrage10 = "Enrage in 10 seconds",

	msg_engage = "Gluth Engaged! ~1:45 till Decimate!",
	msg_decimateSoon = "Decimate Soon!",
    msg_frenzy = "Frenzy! Tranq now!",
	
	-- bars
	bar_decimate = "Possible Decimate Zombies",
	bar_fear = "AoE Fear",
	bar_frenzy = "Frenzy",
    bar_frenzyNext = "Next Frenzy",
	bar_enrage = "Enrage",
	
	-- misc
	
} end )

L:RegisterTranslations("deDE", function() return {
	--cmd = "Gluth",

	-- commands
	--fear_cmd = "fear",
	fear_name = "Furcht Alarm",
	fear_desc = "Warnung für Furcht",

	--frenzy_cmd = "frenzy",
	frenzy_name = "Raserei Alarm",
	frenzy_desc = "Warnung für Raserei",

	--enrage_cmd = "enrage",
	enrage_name = "Wutanfall Timer",
	enrage_desc = "Warnung für Wutanfall",

	--decimate_cmd = "decimate",
	decimate_name = "Decimate Alert",
	decimate_desc = "Warn for Decimate",
	
	-- triggers
	trigger_berserk = "Gluth bekommt 'Berserker'.",
	trigger_fear = "von Erschreckendes Gebrüll betroffen.",
	trigger_engage = "devours all nearby zombies!",
    trigger_frenzyGain1 = "Gluth bekommt 'Raserei'.",
	trigger_frenzyGain2 = "Gluth goes into a frenzy!",
	trigger_frenzyGone = "'Raserei' von Gluth wurde entfernt.",
	trigger_decimate = "decimates all nearby flesh!",
	
	-- messages
	msg_fearSoon = "5 Sekunden bis Furcht!",
	msg_fearNow = "Furcht! - 20 Sekunden bis zur Nächsten!",
	msg_enrage = "WUTANFALL!",
	msg_enrage90 = "Wutanfall in 90 Sekunden",
	msg_enrage30 = "Wutanfall in 30 Sekunden",
	msg_enrage10 = "Wutanfall in 10 Sekunden",

	msg_engage = "Gluth angegriffen! ~1:45 bis Decimate!",
	msg_decimateSoon = "Decimate Soon!",
    msg_frenzy = "Raserei!",
	
	-- bars
	bar_decimate = "Decimate Zombies",
	bar_fear = "Furcht",
	bar_frenzy = "Raserei",
    bar_frenzyNext = "Nächste Raserei",
	bar_enrage = "Wutanfall",
	
	-- misc
	
} end )