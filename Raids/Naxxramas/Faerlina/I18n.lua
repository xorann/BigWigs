------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.faerlina
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Faerlina",

	-- commands
	silence_cmd = "silence",
	silence_name = "Silence Alert",
	silence_desc = "Warn for silence",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	rain_cmd = "rain",
	rain_name = "Rain of Fire Alert",
	rain_desc = "Warn when you are standing in Rain of Fire",
	
	-- triggers
	trigger_engage1 = "Kneel before me, worm!",
	trigger_engage2 = "Slay them in the master's name!",
	trigger_engage3 = "You cannot hide from me!",
	trigger_engage4 = "Run while you still can!",

	trigger_silence = "Grand Widow Faerlina is afflicted by Widow's Embrace.", -- EDITED it affects her too.
	trigger_enrage = "Grand Widow Faerlina gains Enrage.",
	trigger_rainGain = "You are afflicted by Rain of Fire",
	trigger_rainGone = "Rain of Fire",
	trigger_rainDamage = "You suffer (%d+) (.+) from Grand Widow Faerlina's Rain of Fire.",
	
	-- messages
	msg_engage = "Grand Widow Faerlina engaged, 60 seconds to enrage!",
	msg_enrage15 = "15 seconds until enrage!",
	msg_enrageNow = "Enrage!",
	msg_enrageRemoved = "Enrage removed! %d seconds until next!", -- added
	msg_silenceDelay = "Silence! Delaying Enrage!",
	msg_silenceNoDelay = "Silence!",
	msg_silence5 = "Silence ends in 5 sec",
	msg_rain = "Move from FIRE!",
	
	-- bars
	bar_enrage = "Enrage",
	bar_silence = "Silence",
	
	-- misc
	
} end )
