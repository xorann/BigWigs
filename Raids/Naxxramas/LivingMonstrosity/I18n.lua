--[[
    Created by Vnm-Kronos - https://github.com/Vnm-Kronos
    modified by Dorann
--]]

------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.livingmonstrosity
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Monstrosity",
	
	-- commands
	lightningtotem_cmd = "lightningtotem",
	lightningtotem_name = "Lightning Totem Alert",
	lightningtotem_desc = "Warn for Lightning Totem summon",
	
	-- triggers
	trigger_lightningtotemCast = "Living Monstrosity begins to cast Lightning Totem",
	trigger_lightningtotemSummon = "Living Monstrosity casts Lightning Totem.",
	
	-- messages
	message_lightningtotem = "LIGHTNING TOTEM INC",
	
	-- bars
	bar_lightningtotem = "SUMMON LIGHTNING TOTEM",
	
	-- misc
	misc_lightningTotem = "Lightning Totem",
	
} end )


L:RegisterTranslations("deDE", function() return {
	--cmd = "Monstrosity",
	
	-- commands
	--lightningtotem_cmd = "lightningtotem",
	lightningtotem_name = "Blitzschlagtotem Alarm",
	lightningtotem_desc = "Warnung für Blitzschlagtotem",
	
	-- triggers
	trigger_lightningtotemCast = "Living Monstrosity begins to cast Lightning Totem",
	trigger_lightningtotemSummon = "Living Monstrosity casts Lightning Totem.",
	
	-- messages
	message_lightningtotem = "LIGHTNING TOTEM INC",
	
	-- bars
	bar_lightningtotem = "SUMMON LIGHTNING TOTEM",
	
	-- misc
	misc_lightningTotem = "Lightning Totem",
	
} end )