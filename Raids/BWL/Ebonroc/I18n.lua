------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.bwl.ebonroc
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Ebonroc",
	
	-- commands
	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet alert",
	wingbuffet_desc = "Warn when Ebonroc casts Wing Buffet.",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn when Ebonroc casts Shadow Flame.",

	curse_cmd = "curse",
	curse_name = "Shadow of Ebonroc warnings",
	curse_desc = "Shows a timer bar and announces who gets Shadow of Ebonroc.",
	
	-- triggers
	trigger_wingBuffet = "Ebonroc begins to cast Wing Buffet.",
	trigger_shadowFlame = "Ebonroc begins to cast Shadow Flame.",
	trigger_shadowCurseYou = "You are afflicted by Shadow of Ebonroc\.",
	trigger_shadowCurseOther = "(.+) is afflicted by Shadow of Ebonroc\.",
	
	-- messages
	msg_wingBuffet = "Wing Buffet! Next one in 30 seconds!",
	msg_wingBuffetSoon = "TAUNT now! Wing Buffet soon!",
	msg_shadowFlame = "Shadow Flame incoming!",
	msg_shadowCurseYou = "You have Shadow of Ebonroc!",
	msg_shadowCurseOther = "%s has Shadow of Ebonroc! TAUNT!",
	
	-- bars
	bar_wingBuffetCast = "Wing Buffet",
	bar_wingBuffetNext = "Next Wing Buffet",
	bar_wingBuffetFirst = "Initial Wing Buffet",
	bar_shadowFlameCast = "Possible Shadow Flame",
	bar_shadowFlameNext = "Next Shadow Flame",
	bar_shadowCurse = "%s - Shadow of Ebonroc",
    bar_shadowCurseFirst = "Initial Shadow of Ebonroc",
	
	-- misc

} end)

L:RegisterTranslations("deDE", function() return {

	-- commands
	wingbuffet_name = "Alarm f\195\188r Fl\195\188gelsto\195\159",
	wingbuffet_desc = "Warnung, wenn Ebonroc Fl\195\188gelsto\195\159 wirkt.",

	shadowflame_name = "Alarm f\195\188r Schattenflamme",
	shadowflame_desc = "Warnung, wenn Ebonroc Schattenflamme wirkt.",

	curse_name = "Schattenschwinges Schatten Warnungen",
	curse_desc = "Zeigt eine Zeitleiste und k\195\188ndigt an wer Schattenschwinges Schatten bekommt.",
	
	-- triggers
	trigger_wingBuffet = "Schattenschwinge beginnt Fl\195\188gelsto\195\159 zu wirken.",
	trigger_shadowFlame = "Schattenschwinge beginnt Schattenflamme zu wirken.",
	trigger_shadowCurseYou = "Ihr seid von Schattenschwinges Schatten betroffen.",
	trigger_shadowCurseOther = "(.+) ist von Schattenschwinges Schatten betroffen.",
	
	-- messages
	msg_wingBuffet = "Fl\195\188gelsto\195\159! N\195\164chster in 30 Sekunden!",
	msg_wingBuffetSoon = "SPOTT jetzt! Fl\195\188gelsto\195\159 bald!",
	msg_shadowFlame = "Schattenflamme bald!",
	msg_shadowCurseYou = "Du hast Schattenschwinges Schatten!",
	msg_shadowCurseOther = "%s hat Schattenschwinges Schatten! SPOTT!",
	
	-- bars
	bar_wingBuffetCast = "Fl\195\188gelsto\195\159",
	bar_wingBuffetNext = "N\195\164chster Fl\195\188gelsto\195\159",
	bar_wingBuffetFirst = "Erster Fl\195\188gelsto\195\159",
	bar_shadowFlameCast = "Mögliche Schattenflamme",
	bar_shadowFlameNext = "Nächste Schattenflamme",
	bar_shadowCurse = "%s - Schattenschwinges Schatten",
    bar_shadowCurseFirst = "Erster Schattenschwinges Schatten",
	
	-- misc
	
} end)
