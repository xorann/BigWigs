------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.other.ysondre
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Ysondre",

	-- commands
	noxious_cmd = "noxious",
	noxious_name = "Noxious breath alert",
	noxious_desc = "Warn for noxious breath",

	-- triggers
	trigger_engage = "The strands of LIFE have been severed! The Dreamers must be avenged!",
	trigger_noxiousBreath = "afflicted by Noxious Breath",
	trigger_druids = "Come forth, ye Dreamers - and claim your vengeance!",

	-- messages
	msg_druids = "Druids spawned!",
	msg_engage = "Ysondre egaged! 8 seconds till Noxious Breath!",
	msg_noxiousBreathSoon = "5 seconds until Noxious Breath!",
	msg_noxiousBreathNow = "Noxious Breath! 18 seconds till next!",

	-- bars
	bar_noxiousBreath = "Noxious Breath",
	
	-- misc
	
} end )