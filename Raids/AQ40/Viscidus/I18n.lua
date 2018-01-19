------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.aq40.viscidus
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Viscidus",

	-- commangs
	volley_cmd = "volley",
	volley_name = "Poison Volley Alert",
	volley_desc = "Warn for Poison Volley",
	toxinyou_cmd = "toxinyou",
	toxinyou_name = "Toxin Cloud on You Alert",
	toxinyou_desc = "Warn if you are standing in a toxin cloud",
	toxinother_cmd = "toxinother",
	toxinother_name = "Toxin Cloud on Others Alert",
	toxinother_desc = "Warn if others are standing in a toxin cloud",
	freeze_cmd = "freeze",
	freeze_name = "Freezing States Alert",
	freeze_desc = "Warn for the different frozen states",

	-- triggers
	trigger_slow = "Viscidus begins to slow.",
	trigger_freeze = "Viscidus is freezing up.",
	trigger_frozen = "Viscidus is frozen solid.",
	trigger_crack = "Viscidus begins to crack.",
	trigger_shatter = "Viscidus looks ready to shatter.",
	trigger_volley = "afflicted by Poison Bolt Volley",
	trigger_toxin = "^([^%s]+) ([^%s]+) afflicted by Toxin%.$",

	-- messages
	msg_freeze1 = "First freeze phase!",
	msg_freeze2 = "Second freeze phase!",
	msg_frozen = "Viscidus is frozen!",
	msg_crack1 = "Cracking up - little more now!",
	msg_crack2 = "Cracking up - almost there!",
	msg_volley = "Poison Bolt Volley!",
	msg_volleySoon = "Poison Bolt Volley in ~3 sec!",
	msg_toxin = "%s is in a toxin cloud!",
	msg_toxinSelf = "You are in the toxin cloud!",

	-- bars
	bar_volley = "Possible Poison Bolt Volley",

	-- misc
	misc_you = "You",
	misc_are = "are",
}
end)

L:RegisterTranslations("deDE", function() return {
	volley_name = "Giftblitzsalve Alarm", -- ?
	volley_desc = "Warnt vor Giftblitzsalve", -- ?

	toxinyou_name = "Toxin Wolke",
	toxinyou_desc = "Warnung, wenn Du in einer Toxin Wolke stehst.",
	toxinother_name = "Toxin Wolke auf Anderen",
	toxinother_desc = "Warnung, wenn andere Spieler in einer Toxin Wolke stehen.",
	freeze_name = "Freeze Phasen",
	freeze_desc = "Zeigt die verschiedenen Freeze Phasen an.",
	trigger_slow = "wird langsamer!",
	trigger_freeze = "friert ein!",
	trigger_frozen = "ist tiefgefroren!",
	trigger_crack = "geht die Puste aus!", --CHECK
	trigger_shatter = "ist kurz davor, zu zerspringen!",
	trigger_volley = "ist von Giftblitzsalve betroffen.",
	trigger_toxin = "^([^%s]+) ([^%s]+) von Toxin betroffen.$",
	misc_you = "Ihr",
	misc_are = "seid",
	msg_freeze1 = "Erste Freeze Phase!",
	msg_freeze2 = "Zweite Freeze Phase!",
	msg_frozen = "Dritte Freeze Phase!",
	msg_crack1 = "Zerspringen - etwas noch!",
	msg_crack2 = "Zerspringen - fast da!",
	msg_volley = "Giftblitzsalve!", -- ?
	msg_volleySoon = "Giftblitzsalve in ~3 Sekunden!", -- ?
	msg_toxin = "%s ist in einer Toxin Wolke!",
	msg_toxinSelf = "Du bist in einer Toxin Wolke!",
	bar_volley = "Mögliche Giftblitzsalve",
}
end)
