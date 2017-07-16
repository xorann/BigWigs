------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.aq40.huhuran
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Huhuran",

	-- commands
	wyvern_cmd = "wyvern",
	wyvern_name = "Wyvern Sting Alert",
	wyvern_desc = "Warn for Wyvern Sting",
	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy Alert",
	frenzy_desc = "Warn for Frenzy",
	berserk_cmd = "berserk",
	berserk_name = "Berserk Alert",
	berserk_desc = "Warn for Berserk",

	-- triggers
	trigger_frenzyGain = "Princess Huhuran gains Frenzy.",
	trigger_frenzyGone = "Frenzy fades from Princess Huhuran.",
	trigger_berserk = "Princess Huhuran goes into a berserk rage!",
	trigger_sting = "afflicted by Wyvern Sting",

	-- messages
	msg_frenzy = "Frenzy - Tranq Shot!",
	msg_berserk = "Berserk!",
	msg_berserkSoon = "Berserk Soon!",
	msg_sting = "Wyvern Sting!",
	msg_berserk60 = "Berserk in 1 minute!",
	msg_berserk30 = "Berserk in 30 seconds!",
	msg_berserk5 = "Berserk in 5 seconds!",

	-- bars
	bar_frenzy = "Frenzy",
	bar_berserk = "Berserk",
	bar_sting = "Possible Wyvern Sting",

	-- misc
}
end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	wyvern_name = "Stich des Flügeldrachen",
	wyvern_desc = "Warnung, wenn Huhuran Stich des Flügeldrachen wirkt.",
	frenzy_name = "Raserei",
	frenzy_desc = "Warnung, wenn Huhuran in Raserei gerät.",
	berserk_name = "Berserkerwut",
	berserk_desc = "Warnung, wenn Huhuran in Berserkerwut verfällt.",

	-- triggers
	trigger_frenzyGain = "Prinzessin Huhuran gerät in Raserei!", -- translation missing
	trigger_frenzyGone = "Wutanfall schwindet von Prinzessin Huhuran.",
	trigger_berserk = "Prinzession Huhuran verfällt in Berserkerwut!", -- translation missing
	trigger_sting = "von Stich des Flügeldrachen betroffen",

	-- messages
	msg_frenzy = "Frenzy - Tranq Shot!",
	msg_berserk = "Berserkerwut!",
	msg_berserkSoon = "Berserkerwut in Kürze!",
	msg_sting = "Stich des Flügeldrachen!",
	msg_berserk60 = "Berserkerwut in 1 Minute!",
	msg_berserk30 = "Berserkerwut in 30 Sekunden!",
	msg_berserk5 = "Berserkerwut in 5 Sekunden!",

	-- bars
	bar_frenzy = "Frenzy",
	bar_sting = "Möglicher Stich",
	bar_berserk = "Berserkerwut",

	-- misc
}
end)
