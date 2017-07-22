------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.onyxia.onyxia
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Onyxia",

	-- commands
	deepbreath_cmd = "deepbreath",
	deepbreath_name = "Deep Breath",
	deepbreath_desc = "Warn when Onyxia begins to cast Deep Breath.",
	flamebreath_cmd = "flamebreath",
	flamebreath_name = "Flame Breath",
	flamebreath_desc = "Warn when Onyxia begins to cast Flame Breath.",
	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet",
	wingbuffet_desc = "Warn for Wing Buffet.",
	fireball_cmd = "fireball",
	fireball_name = "Fireball",
	fireball_desc = "Warn for Fireball.",
	phase_cmd = "phase",
	phase_name = "Phase",
	phase_desc = "Warn for Phase Change.",
	onyfear_cmd = "onyfear",
	onyfear_name = "Fear",
	onyfear_desc = "Warn for Bellowing Roar in phase 3.",

	-- triggers
	trigger_engage = "must leave my lair to feed",
	trigger_deepBreath = "takes in a deep breath",
	trigger_flameBreath = "Onyxia begins to cast Flame Breath\.",
	trigger_wingBuffet = "Onyxia begins to cast Wing Buffet\.",
	trigger_fireball = "Onyxia begins to cast Fireball.",
	trigger_phase2 = "from above",
	trigger_phase3 = "It seems you'll need another lesson",
	trigger_fear = "Onyxia begins to cast Bellowing Roar\.",
	trigger_fearGone = "Bellowing Roar",

	-- messages
	msg_deepBreath = "Deep Breath incoming!",
	msg_phase1 = "Phase 1",
	msg_phase2 = "Phase 2",
	msg_phase3 = "Phase 3",
	msg_fear = "Fear soon!",

	-- bars
	bar_fearCast = "Fear",
	bar_fearNext = "Next Fear",
	bar_deepBreath = "Deep Breath",
	bar_flameBreath = "Flame Breath",
	bar_wingBuffet = "Wing Buffet",
	bar_fireball = "Fireball",

	-- misc
}
end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	deepbreath_cmd = "deepbreath",
	deepbreath_name = "Tiefer Atem",
	deepbreath_desc = "Warnen, wenn Onyxia beginnt Tiefer Atem zu casten.",
	flamebreath_cmd = "flamebreath",
	flamebreath_name = "Flammenatem",
	flamebreath_desc = "Warnen, wenn Onyxia beginnt Flammenatem zu casten.",
	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Fl\195\188gelsto\195\159",
	wingbuffet_desc = "Alarm f\195\188r Fl\195\188gelsto\195\159.",
	fireball_cmd = "fireball",
	fireball_name = "Feuerball",
	fireball_desc = "Alarm f\195\188r Feuerball.",
	phase_cmd = "phase",
	phase_name = "Phasen-Benachrichtigung",
	phase_desc = "Verk\195\188ndet den Phasenwechsel des Bosses.",
	onyfear_cmd = "onyfear",
	onyfear_name = "Furcht",
	onyfear_desc = "Warne vor Dr\195\182hnendes Gebr\195\188ll in Phase 3.",

	-- triggers
	trigger_engage = "must leave my lair to feed",
	trigger_deepBreath = "holt tief Luft",
	trigger_flameBreath = "Onyxia beginnt Flammenatem zu wirken\.",
	trigger_wingBuffet = "Onyxia beginnt Fl\195\188gelsto\195\159 zu wirken\.",
	trigger_fireball = "Onyxia beginnt Feuerball zu wirken\.",
	trigger_fear = "Onyxia beginnt Dr\195\182hnendes Gebr\195\188ll zu wirken\.",
	trigger_fearGone = "Dr\195\182hnendes Gebr\195\188ll",
	trigger_phase2 = "from above",
	trigger_phase3 = "Es scheint, als wenn Ihr eine weitere Lektion braucht",

	-- messages
	msg_deepBreath = "Tiefer Atem kommen!",
	msg_phase1 = "Phase 1",
	msg_phase2 = "Phase 2",
	msg_phase3 = "Phase 3",
	msg_fear = "Furcht bald!",

	-- bars
	bar_fearCast = "Furcht",
	bar_fearNext = "Nächste Furcht",
	bar_deepBreath = "Tiefer Atem",
	bar_flameBreath = "Flammenatem",
	bar_wingBuffet = "Fl\195\188gelsto\195\159",
	bar_fireball = "Feuerball",

	-- misc
}
end)

