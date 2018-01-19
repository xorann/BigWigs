------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.other.lethon
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Lethon",

	-- commands
	noxious_cmd = "noxious",
	noxious_name = "Noxious breath alert",
	noxious_desc = "Warn for noxious breath",

	-- triggers
	trigger_engage = "I can sense the SHADOW on your hearts. There can be no rest for the wicked!",
	trigger_noxiousBreath = "afflicted by Noxious Breath",
	trigger_shadows = "Your wicked souls shall feed my power!",
	
	-- messages
	msg_shadows = "Shadows spawned!",
	msg_engage = "Lethon egaged! 8 seconds till Noxious Breath!",
	msg_noxiousBreathSoon = "5 seconds until Noxious Breath!",
	msg_noxiousBreathNow = "Noxious Breath! 18 seconds till next!",

	-- bars
	bar_noxiousBreath = "Noxious Breath",
	
	-- misc
	
} end )
