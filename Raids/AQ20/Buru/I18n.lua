------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.aq20.buru
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Buru",
	
	-- commands
	you_cmd = "you",
	you_name = "You're being watched alert",
	you_desc = "Warn when you're being watched",

	other_cmd = "other",
	other_name = "Others being watched alert",
	other_desc = "Warn when others are being watched",

	icon_cmd = "icon",
	icon_name = "Place icon",
	icon_desc = "Place raid icon on watched person (requires promoted or higher)",

	-- triggers
	trigger_watch = "sets eyes on (.+)!",
	
	-- messages
	msg_watchOther = "%s is being watched!",
	msg_watchYou = "You are being watched!",
	
	-- bars
	
	-- misc
	misc_you = "You",
	
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	you_name = "Du wirst beobachtet",
	you_desc = "Warnung, wenn Du beobachtet wirst.",

	other_name = "X wird beobachtet",
	other_desc = "Warnung, wenn andere Spieler beobachtet werden.",

	icon_name = "Symbol",
	icon_desc = "Platziert ein Symbol \195\188ber dem Spieler, der beobachtet wird. (Ben\195\182tigt Anf\195\188hrer oder Bef\195\182rdert Status.)",

	-- triggers
	trigger_watch = "beh\195\164lt (.+) im Blickfeld!",
	
	-- messages
	msg_watchOther = " wird beobachtet!",
	msg_watchYou = "Du wirst beobachtet!",
	
	-- bars
	
	-- misc
	misc_you = "Euch",
	
} end )
