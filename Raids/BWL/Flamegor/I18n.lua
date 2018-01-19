------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.bwl.flamegor
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Flamegor",
	
	-- commands
	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet alert",
	wingbuffet_desc = "Warn when Flamegor casts Wing Buffet.",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn when Flamegor casts Shadow Flame.",

	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy alert",
	frenzy_desc = "Warn when Flamegor is frenzied.",
	
	-- triggers
	trigger_wingBuffet = "Flamegor begins to cast Wing Buffet.",
	trigger_shadowFlame = "Flamegor begins to cast Shadow Flame.",
	trigger_frenzyGain1 = "Flamegor gains Frenzy.",
	trigger_frenzyGain2 = "Flamegor goes into a frenzy!",
	trigger_frenzyGone = "Frenzy fades from Flamegor.",
	
	-- messages
	msg_wingBuffet = "Wing Buffet! Next one in 30 seconds!",
	msg_wingBuffetSoon = "TAUNT now! Wing Buffet soon!",
	msg_shadowFlame = "Shadow Flame incoming!",
	msg_frenzy = "Frenzy! Tranq now!",
	
	-- bars
	bar_frenzy = "Frenzy",
    bar_frenzyNext = "Next Frenzy",
	bar_wingBuffetCast = "Wing Buffet",
	bar_wingBuffetNext = "Next Wing Buffet",
	bar_wingBuffetFirst = "Initial Wing Buffet",
	bar_shadowFlameCast = "Shadow Flame",
	bar_shadowFlameNext = "Possible Shadow Flame",
	
	-- misc

} end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	wingbuffet_name = "Alarm f\195\188r Fl\195\188gelsto\195\159",
	wingbuffet_desc = "Warnung, wenn Flamegor Fl\195\188gelsto\195\159 wirkt.",

	shadowflame_name = "Alarm f\195\188r Schattenflamme",
	shadowflame_desc = "Warnung, wenn Flamegor Schattenflamme wirkt.",

	frenzy_name = "Alarm f\195\188r Wutanfall",
	frenzy_desc = "Warnung, wenn Flamegor in Wutanfall ger\195\164t.",
	
	-- triggers
	trigger_wingBuffet = "Flamegor beginnt Fl\195\188gelsto\195\159 zu wirken.",
	trigger_shadowFlame = "Flamegor beginnt Schattenflamme zu wirken.",
	trigger_frenzyGain1 = "Flamegor bekommt \'Wutanfall\'.",
	trigger_frenzyGone = "Wutanfall schwindet von Flamegor.",
	
	-- messages
	msg_wingBuffet = "Fl\195\188gelsto\195\159! N\195\164chster in 30 Sekunden!",
	msg_wingBuffetSoon = "Jetzt TAUNT! Fl\195\188gelsto\195\159 bald!",
	msg_shadowFlame = "Schattenflamme bald!",
	msg_frenzy = "Wutanfall! Tranq jetzt!",
	
	-- bars
	bar_frenzy = "Wutanfall",
    bar_frenzyNext = "Nächster Wutanfall",
	bar_wingBuffetCast = "Fl\195\188gelsto\195\159",
	bar_wingBuffetNext = "N\195\164chster Fl\195\188gelsto\195\159",
	bar_wingBuffetFirst = "Erster Fl\195\188gelsto\195\159",
	bar_shadowFlameCast = "Schattenflamme",
	bar_shadowFlameNext = "Mögliche Schattenflamme",
	
	-- misc
	
} end)
