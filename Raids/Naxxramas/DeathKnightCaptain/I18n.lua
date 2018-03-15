--[[
    Created by Dorann
--]]

------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.deathKnightCaptain
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "DeathKnightCaptain",
	
	-- commands
	whirlwind_cmd = "whirlwind",
	whirlwind_name = "Whirlwind",
	whirlwind_desc = "Whirlwind timer and cooldown.",
	
	-- triggers
	trigger_whirlwind = "Death Knight Captain gains Whirlwind.",
	
	-- messages
	
	-- bars
	bar_whirlwind = "Whirlwind",
	bar_whirlwindNext = "Possible Whirlwind",
	
	-- misc
	
} end )