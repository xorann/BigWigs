------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.mc.coreHound
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Corehound",

	-- commands
	bars_cmd = "bars",
	bars_name = "Toggle bars",
	bars_desc = "Toggles showing bars for timers.",
	
	-- triggers
	trigger_hit = "afflicted by %s",
	trigger_immune = "%s fail(.+) immune.",
	trigger_resist = "%s was resisted",
	
	-- bars
	bar_unknown = "Unknown",
	
	-- messages
	
	-- misc
	misc_dread = "Ancient Dread",
	misc_dispair = "Ancient Despair",
	misc_stomp = "Ground Stomp",
	misc_flames = "Cauterizing Flames",
	misc_heat = "Withering Heat",
	misc_hysteria = "Ancient Hysteria",

} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	--bars_cmd = "bars",
	bars_name = "Timer",
	bars_desc = "Zeige Fähigkeitentimer",
	
	-- triggers
	trigger_hit = "afflicted by %s",
	trigger_immune = "%s fail(.+) immune.",
	trigger_resist = "%s was resisted",
	
	-- bars
	bar_unknown = "Unbekannt",
	
	-- messages
	
	-- misc
	misc_dread = "Ancient Dread",
	misc_dispair = "Ancient Despair",
	misc_stomp = "Ground Stomp",
	misc_flames = "Cauterizing Flames",
	misc_heat = "Withering Heat",
	misc_hysteria = "Ancient Hysteria",

} end )

