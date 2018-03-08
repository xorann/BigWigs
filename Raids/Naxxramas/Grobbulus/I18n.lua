------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.grobbulus
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Grobbulus",

	-- commands
	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	youinjected_cmd = "youinjected",
	youinjected_name = "You're injected Alert",
	youinjected_desc = "Warn when you're injected",

	otherinjected_cmd = "otherinjected",
	otherinjected_name = "Others injected Alert",
	otherinjected_desc = "Warn when others are injected",

	icon_cmd = "icon",
	icon_name = "Place Icon",
	icon_desc = "Place a skull icon on an injected person. (Requires promoted or higher)",

	cloud_cmd = "cloud",
	cloud_name = "Poison Cloud",
	cloud_desc = "Warn for Poison Clouds",

	slimespray_cmd = "slimespray",
	slimespray_name = "Slime Spray",
	slimespray_desc = "Show timer for Slime Spray",
	
	-- triggers
	trigger_inject = "^([^%s]+) ([^%s]+) afflicted by Mutating Injection",
	trigger_cloud = "Grobbulus casts Poison Cloud.",
	trigger_slimeSpray = "Slime Spray",
	trigger_slimeSpray2 = "Grobbulus sprays slime across the room!",
	
	-- messages
	msg_engage = "Grobbulus engaged, 12min to enrage!",
	msg_enrage10m = "Enrage in 10min",
	msg_enrage5m = "Enrage in 5min",
	msg_enrage1m = "Enrage in 1min",
	msg_enrage30 = "Enrage in 30sec",
	msg_enrage10 = "Enrage in 10sec",
	msg_bombYou = "You are injected!",
	msg_bombOther = "%s is injected!",
	msg_cloud = "Poison Cloud next in ~15 seconds!",
	
	-- bars
	bar_enrage = "Enrage",
	bar_bomb = "%s injected",
	bar_cloud = "Poison Cloud",
	bar_slimeSpray = "Possible Slime Spray",
	
	-- misc
	misc_you = "You",
	misc_are = "are",
	misc_bombSay = "I am injected",

} end )
