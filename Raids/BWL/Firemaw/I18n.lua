------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.bwl.firemaw
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Firemaw",
	
	-- commands
	flamebuffet_cmd = "flamebuffet",
	flamebuffet_name = "Flame Buffet alert",
	flamebuffet_desc = "Warn when Flamegor casts Flame Buffet.",

	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet alert",
	wingbuffet_desc = "Warn when Flamegor casts Wing Buffet.",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn when Flamegor casts Shadow Flame.",
	
	-- triggers
	trigger_wingBuffet = "Firemaw begins to cast Wing Buffet.",
	trigger_shadowFlame = "Firemaw begins to cast Shadow Flame.",
	trigger_flameBuffetAfflicted = "afflicted by Flame Buffet",
	trigger_flameBuffetResisted = "Firemaw 's Flame Buffet was resisted",
	trigger_flameBuffetImmune = "Firemaw 's Flame Buffet fail(.+) immune\.",
	trigger_flameBuffetAbsorbYou = "You absorb Firemaw 's Flame Buffet",
	trigger_flameBuffetAbsorbOther = "Firemaw 's Flame Buffet is absorbed",
	
	-- messages
	msg_wingBuffet = "Wing Buffet! Next one in 30 seconds!",
	msg_wingBuffetSoon = "TAUNT now! Wing Buffet soon!",
	msg_shadowFlame = "Shadow Flame incoming!",
	
	-- bars
	bar_wingBuffetCast = "Wing Buffet",
	bar_wingBuffetNext = "Next Wing Buffet",
	bar_wingBuffetFirst = "Initial Wing Buffet",
	bar_shadowFlameCast = "Shadow Flame",
	bar_shadowFlameNext = "Possible Shadow Flame",
	bar_flameBuffet = "Flame Buffet",
	
	-- misc

} end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	flamebuffet_name = "Alarm f\195\188r Flammenpuffer",
	flamebuffet_desc = "Warnung f\195\188r Flammenpuffer.",

	wingbuffet_name = "Alarm f\195\188r Fl\195\188gelsto\195\159",
	wingbuffet_desc = "Warnung, wenn Ebonroc Fl\195\188gelsto\195\159 wirkt.",

	shadowflame_name = "Alarm f\195\188r Schattenflamme",
	shadowflame_desc = "Warnung, wenn Ebonroc Schattenflamme wirkt.",
	
	-- triggers
	trigger_wingBuffet = "Ebonroc beginnt Fl\195\188gelsto\195\159 zu wirken.",
	trigger_shadowFlame = "Ebonroc beginnt Schattenflamme zu wirken.",
	trigger_flameBuffetAfflicted = "von Flammenpuffer betroffen",
	trigger_flameBuffetResisted = "Flammenpuffer(.+) widerstanden",
	trigger_flameBuffetImmune = "Flammenpuffer(.+) immun",
	trigger_flameBuffetAbsorbYou = "Ihr absorbiert Firemaws Flammenpuffer",
	trigger_flameBuffetAbsorbOther = "Flammenpuffer von Firemaw wird absorbiert von",
	
	-- messages
	msg_wingBuffet = "Fl\195\188gelsto\195\159! N\195\164chster in 30 Sekunden!",
	msg_wingBuffetSoon = "Jetzt TAUNT! Fl\195\188gelsto\195\159 bald!",
	msg_shadowFlame = "Schattenflamme bald!",
	
	-- bars
	bar_wingBuffetCast = "Fl\195\188gelsto\195\159",
	bar_wingBuffetNext = "N\195\164chster Fl\195\188gelsto\195\159",
	bar_wingBuffetFirst = "Erster Fl\195\188gelsto\195\159",
	bar_shadowFlameCast = "Schattenflamme",
	bar_shadowFlameNext = "Mögliche Schattenflamme",
	bar_flameBuffet = "Flammenpuffer",
	
	-- misc

} end)
