------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.zg.gahzranka
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Gahzranka",

	-- commands
	frostbreath_cmd = "frostbreath",
	frostbreath_name = "Frost Breath alert",
	frostbreath_desc = "Warn when the boss is casting Frost Breath.",

	massivegeyser_cmd = "massivegeyser",
	massivegeyser_name = "Massive Geyser alert",
	massivegeyser_desc = "Warn when the boss is casting Massive Geyser.",
	
	-- triggers
	trigger_frostBreath = "Gahz\'ranka begins to perform Frost Breath\.",
	trigger_massiveGeyser = "Gahz\'ranka begins to cast Massive Geyser\.",
	
	-- messages
	
	-- bars
	bar_frostBreath = "Frost Breath",
	bar_massiveGeyser = "Massive Geyser",
	
	-- misc	

} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	frostbreath_name = "Alarm für Frostatem",
	frostbreath_desc = "Warnen wenn Gahz'ranka beginnt Frostatem zu wirken.",
	
	massivegeyser_name = "Alarm für Massiver Geysir",
	massivegeyser_desc = "Warnen wenn Gahz'ranka beginnt Massiver Geysir zu wirken.",
	
	-- triggers
	trigger_frostBreath = "Gahz\'ranka beginnt Frostatem auszuführen\.",
	trigger_massiveGeyser = "Gahz\'ranka beginnt Massiver Geysir zu wirken\.",
	
	-- messages
	
	-- bars
	bar_frostBreath = "Frostatem",
	bar_massiveGeyser = "Massiver Geysir",
	
	-- misc

} end )