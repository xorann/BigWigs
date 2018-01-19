------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.other.azuregos
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Azuregos",

	-- commands
	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for teleport",

	shield_cmd = "shield",
	shield_name = "Shield Alert",
	shield_desc = "Warn for shield",

	-- triggers
	trigger_teleport = "Come, little ones",
	trigger_shieldGone = "^Reflection fades from Azuregos",
	trigger_shieldGain = "^Azuregos gains Reflection",

	-- messages
	msg_teleport = "Teleport!",
	msg_shieldGain = "Magic Shield down!",
	msg_shieldGone = "Magic Shield UP!",
	msg_teleport10 = "Teleport in 10sec",
	msg_teleport5 = "Teleport in 5sec",

	-- bars
	bar_shield = "Magic Shield",
	bar_teleport = "Teleport",
	
	-- misc
	
} end )
