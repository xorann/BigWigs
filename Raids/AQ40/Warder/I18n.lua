------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.aq40.warder
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Warder",

	-- commands
	fear_cmd = "fear",
	fear_name = "Fear timer",
	fear_desc = "Shows fear cd",

	silence_cmd = "silence",
	silence_name = "Silence timer",
	silence_desc = "Shows Silence cd",

	roots_cmd = "roots",
	roots_name = "Roots timer",
	roots_desc = "Shows Roots cd",

	dust_cmd = "dust",
	dust_name = "Dust Cloud timer",
	dust_desc = "Shows Dust Cloud cd",

	warnings_cmd = "warnings",
	warnings_name = "Warning messages ",
	warnings_desc = "Warning messages showing which 2 abilities current mob has",

	-- trigger
	trigger_fear = "Anubisath Warder begins to cast Fear.",
	trigger_silence = "Anubisath Warder begins to cast Silence.",
	trigger_roots = "Anubisath Warder begins to cast Entangling Roots.",
	trigger_dust = "Anubisath Warder begins to perform Dust Cloud.",
	
	-- bars
	bar_fear = "Fear!",
	bar_possibleFear = "Possible Fear",
	bar_silence = "Silence!",
	bar_possibleSilence = "Possible Silence",
	bar_roots = "Roots!",
	bar_possibleRoots = "Possible Roots",
	bar_dust = "Dust Cloud!",
	bar_possibleDust = "Possible Dust Cloud",
	
	-- messages
	msg_dust = "Dust Cloud",
	msg_rootsFear = "(Roots or Fear)",
	msg_fear = "Fear",
	msg_silenceDust = "(Silence or Dust Cloud)",
	msg_Roots = "Roots",
	msg_silenceDust2 = "(Silence or Dust Cloud)",
	msg_silence = "Silence",
	msg_rootsFear2 = "(Roots or Fear)",
	
	-- misc
	
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	--fear_cmd = "fear",
	fear_name = "Furcht",
	fear_desc = "Zeige Furchttimer",

	--silence_cmd = "silence",
	silence_name = "Stille",
	silence_desc = "Zeige Stilletimer",

	--roots_cmd = "roots",
	roots_name = "Wurzeln",
	roots_desc = "Zeige Wurzelntimer",

	--dust_cmd = "dust",
	dust_name = "Dust Cloud timer",
	dust_desc = "Shows Dust Cloud cd",

	--warnings_cmd = "warnings",
	warnings_name = "Warnungen",
	warnings_desc = "Warnt vor den zwei Fähigkeiten die der Gegner hat.",

	-- trigger
	trigger_fear = "Anubisath Warder begins to cast Fear.",
	trigger_silence = "Anubisath Warder begins to cast Silence.",
	trigger_roots = "Anubisath Warder begins to cast Entangling Roots.",
	trigger_dust = "Anubisath Warder begins to perform Dust Cloud.",
	
	-- bars
	bar_fear = "Furcht!",
	bar_possibleFear = "Mögliche Furcht",
	bar_silence = "Stille!",
	bar_possibleSilence = "Mögliche Stille",
	bar_roots = "Wurzeln!",
	bar_possibleRoots = "Mögliches Wurzeln",
	bar_dust = "Dust Cloud!",
	bar_possibleDust = "Possible Dust Cloud",
	
	-- messages
	msg_dust = "Dust Cloud",
	msg_rootsFear = "(Wurnzeln oder Furcht)",
	msg_fear = "Furcht",
	msg_silenceDust = "(Stille oder Dust Cloud)",
	msg_Roots = "Wurzeln",
	msg_silenceDust2 = "(Stille oder Dust Cloud)",
	msg_silence = "Stille",
	msg_rootsFear2 = "(Wurzeln oder Furcht)",
	
	-- misc
	
} end )

