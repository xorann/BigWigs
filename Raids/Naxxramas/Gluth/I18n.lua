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
	bar_decimate = "Decimate Zombies",
	bar_fear = "AoE Fear",
	bar_frenzy = "Frenzy",
    bar_frenzyNext = "Next Frenzy",
	bar_enrage = "Enrage",
	
	-- misc
	
} end )
