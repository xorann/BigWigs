------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.heigan
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Heigan",

	-- commands
	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for Teleports.",

	engage_cmd = "engage",
	engage_name = "Engage Alert",
	engage_desc = "Warn when Heigan is engaged.",

	disease_cmd = "disease",
	disease_name = "Decrepit Fever Alert",
	disease_desc = "Warn for Decrepit Fever",

	dance_cmd = "dance",
	dance_name = "Dancing Alert",
	dance_desc = "Warn for Dancing",
	
    --erruption_cmd = "erruption",
    --erruption_name = "Erruption Alert",
    --erruption_desc = "Warn for Erruption",
          
	-- triggers
	trigger_engage1 = "You are mine now!",
	trigger_engage2 = "You...are next!",
	trigger_engage3 = "I see you!",
	trigger_toPlatform = "teleports and begins to channel a spell!",
    trigger_toFloor = "rushes to attack once more!",
	trigger_bossDeath = "takes his last breath.",
	trigger_decrepitFever = "afflicted by Decrepit Fever.",

	-- messages
	msg_decrepitFever = "Decrepit Fever",

	msg_onPlatform = "Teleport! Dancing for %d sec!",

	msg_onFloor = "Back on the floor! 90 sec to next teleport!",

	-- bars
	bar_toPlatform = "Teleport!",
	bar_toFloor = "Back on the floor!",
	bar_decrepitFever = "Decrepit Fever",
    --bar_erruption = "Erruption",
    bar_dancingShoes = "Put on your dancing shoes!",

	-- misc
	["Eye Stalk"] = true,
	["Rotting Maggot"] = true,
	
} end )