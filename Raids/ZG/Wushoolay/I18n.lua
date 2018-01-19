------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.zg.wushoolay
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Wushoolay",

	-- commands
	chainlightning_cmd = "chainlightning",
	chainlightning_name = "Chain Lightning alert",
	chainlightning_desc = "Warn when the boss is casting Chain Lightning.",
	
	lightningcloud_cmd = "lightningcloud",
	lightningcloud_name = "Lightning Cloud warning",
	lightningcloud_desc = "Warns when you stand in the Lightning Cloud.",
	
	-- triggers
	trigger_chainLightning = "Wushoolay begins to cast Chain Lightning\.",
	trigger_lightningcloud = "You are afflicted by Lightning Cloud\.",
	
	-- messages
	msg_chainLightning = "Chain Lightning! Interrupt it!",
	msg_lightningCloud = "Get out of the Lightning Cloud!",
	
	-- bars
	bar_chainLightning = "Chain Lightning",
	
	-- misc
	
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	chainlightning_cmd = "chainlightning",
	chainlightning_name = "Alarm f\195\188r Kettenblitzschlag",
	chainlightning_desc = "Warnen wenn Wushoolay beginnt Kettenblitzschlag zu wirken.", 
	
	lightningcloud_cmd = "lightningcloud",
	lightningcloud_name = "Alarm f\195\188r Blitzschlagwolke",
	lightningcloud_desc = "Warnt dich wenn du in Blitzschlagwolke stehst.",
	
	-- triggers
	trigger_chainLightning = "Wushoolay beginnt Kettenblitzschlag zu wirken\.",
	trigger_lightningcloud = "Ihr seid von Blitzschlagwolke betroffen\.",
	
	-- messages
	msg_chainLightning = "Kettenblitzschlag! Unterbreche sie!",
	msg_lightningCloud = "Beweg dich aus der Blitzschlagwolke!",
	
	-- bars
	bar_chainLightning = "Kettenblitzschlag",
	
	-- misc	

} end )
