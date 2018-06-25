------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.sapphiron
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Sapphiron",

	-- commands
	deepbreath_cmd = "deepbreath",
	deepbreath_name = "Deep Breath alert",
	deepbreath_desc = "Warn when Sapphiron begins to cast Deep Breath.",

	lifedrain_cmd = "lifedrain",
	lifedrain_name = "Life Drain",
	lifedrain_desc = "Warns about the Life Drain curse.",

	berserk_cmd = "berserk",
	berserk_name = "Berserk",
	berserk_desc = "Warn for berserk.",

	icebolt_cmd = "icebolt",
	icebolt_name = "Announce Ice Block",
	icebolt_desc = "Yell when you become an Ice Block.",
	
	proximity_cmd = "proximity",
	proximity_name = "Proximity warning",
	proximity_desc = "Warns when other players are too near to you",

	-- triggers
	trigger_lifeDrain1 = "afflicted by Life Drain",
	trigger_lifeDrain2 = "Life Drain was resisted by",
	trigger_icebolt = "You are afflicted by Icebolt",
	trigger_deepBreath = " takes in a deep breath...",
	trigger_flight = "Sapphiron gets airbourne", --???
	
	-- messages
	msg_berserk10m = "10min to berserk!",
	msg_berserk5m = "5min to berserk!",
	msg_berserkSoon = "%s sec to berserk!",
	msg_engage = "Sapphiron engaged! Berserk in 15min!",
	msg_lifeDrainNow = "Life Drain! Possibly new one ~24sec!",
	msg_deepBreathSoon = "Ice Bomb casting in ~23sec!",
	msg_deepBreathNow = "Ice Bomb Incoming!",
	msg_IceBlockYell = "I'm an Ice Block!",
	
	-- bars
	bar_berserk = "Berserk",
	bar_lifeDrain = "Life Drain",
	bar_deepBreathCast = "Ice Bomb Cast",
	bar_deepBreath = "Ice Bomb Lands!",
	
	-- misc
	
} end )

L:RegisterTranslations("deDe", function() return {
	trigger_icebolt = "Ihr seid von Eisblitz betroffen.",
} end )