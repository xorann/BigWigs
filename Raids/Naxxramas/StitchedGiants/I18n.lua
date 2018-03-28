--[[
    Created by Dorann
--]]

------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.stitchedGiant
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "StitchedGiant",
	
	-- commands
	slimeBolt_cmd = "slimeBolt",
	slimeBolt_name = "Slime Bolt",
	slimeBolt_desc = "Slime Bolt timer and cooldown.",
	
	-- triggers
	trigger_slimeBolt = "Stitched Giant begins to perform Slime Bolt.",
	
	-- messages
	
	-- bars
	bar_slimeBoltCast = "Slime Bolt",
	bar_slimeBoltNext = "Next Slime Bolt %s",
	
	-- misc
	
} end )