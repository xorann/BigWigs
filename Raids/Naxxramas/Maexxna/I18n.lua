------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.maexxna
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Maexxna",

	-- commands
	spray_cmd = "spray",
	spray_name = "Web Spray Alert",
	spray_desc = "Warn for webspray and spiders",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for enrage",

	cocoon_cmd = "cocoon",
	cocoon_name = "Cocoon Alert",
	cocoon_desc = "Warn for Cocooned players",

	poison_cmd = "Poison",
	poison_name = "Necrotic Poison Alert",
	poison_desc = "Warn for Necrotic Poison",

	-- triggers
	trigger_cocoon = "(.*) (.*) afflicted by Web Wrap.",
	trigger_webSpray = "afflicted by Web Spray",
	trigger_poison = "afflicted by Necrotic Poison.",
	trigger_enrage = "Maexxna gains Enrage",
	
	-- messages
	msg_cocoon = "%s Cocooned!",
	msg_poison = "Necrotic Poison!",

	msg_webSpray = "Web Spray! 40 seconds until next!",

	msg_enrage = "Enrage - SQUISH SQUISH SQUISH!",
	msg_enrageSoon = "Enrage Soon - Bug Swatters out!",
	
	-- bars
	bar_webSpray = "Web Spray",
	bar_cocoon = "Cocoons",
	bar_spider = "Spiders",
	bar_poison = "Necrotic Poison",
	
	-- misc
	misc_you = "You",
	misc_are = "are",
	
} end )
