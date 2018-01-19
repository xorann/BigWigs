------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.aq40.fankriss
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Fankriss",

	-- commands
	worm_cmd = "worm",
	worm_name = "Worm Alert",
	worm_desc = "Warn for Incoming Worms",
	entangle_cmd = "entangle",
	entangle_name = "Entangle Alert",
	entangle_desc = "Warn for Entangle and incoming Bugs",

	-- triggers
	trigger_entanglePlayer = "You are afflicted by Entangle.",
	trigger_entangleOther = "(.*) is afflicted by Entangle.",
	trigger_worm = "Fankriss the Unyielding casts Summon Worm.",

	-- messages
	msg_entangle = "Entangle!",
	msg_worm = "Incoming Worm! (%d)",

	-- bars
	bar_wormEnrage = "Sandworm Enrage (%d)",

	-- misc
}
end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	worm_name = "Wurm beschwören",
	worm_desc = "Warnung, wenn Fankriss einen Wurm beschwört.",
	entangle_name = "Umschlingen Warnung",
	entangle_desc = "Warnt vor Umschlingen und den Käfern",

	-- triggers
	trigger_worm = "Fankriss der Unnachgiebige wirkt Wurm beschwören.",
	trigger_entanglePlayer = "Ihr seid von Umschlingen betroffen.",
	trigger_entangleOther = "(.*) ist von Umschlingen betroffen.",

	-- messages
	msg_worm = "Wurm wurde beschworen! (%d)",
	msg_entangle = "Umschlingen!",

	-- bars
	bar_wormEnrage = "Wurm ist wütend (%d)",

	-- misc
}
end)
