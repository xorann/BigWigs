------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.other.taerar
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Taerar",

	-- commands
	noxious_cmd = "noxious",
	noxious_name = "Noxious breath alert",
	noxious_desc = "Warn for noxious breath",

	fear_cmd = "fear",
	fear_name = "Fear",
	fear_desc = "Warn for Bellowing Roar",

	-- triggers
	trigger_fear = "Taerar begins to cast Bellowing Roar.",
	trigger_noxiousBreath = "afflicted by Noxious Breath",
	trigger_engage = "Peace is but a fleeting dream! Let the NIGHTMARE reign!",
	trigger_banish = "Children of Madness - I release you upon this world!",

	-- messages
	msg_banish = "Taerar banished! Kill Shades!",
	msg_fearNow = "Fear in 1.5sec!",
	msg_noxiousBreathSoon = "5 seconds until Noxious Breath!",
	msg_noxiousBreathNow = "Noxious Breath! 18 seconds till next!",
	msg_engage = "Taerar engaged! Noxious Breath in 8 seconds!",
	msg_fearSoon = "AoE Fear soon!",

	-- bars
	bar_noxiousBreath = "Noxious Breath",
	bar_banish = "Banish",
	bar_fear = "AoE Fear",

	-- misc
	
} end )
