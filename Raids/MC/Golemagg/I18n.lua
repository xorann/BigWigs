------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.mc.golemagg
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Golemagg",
	
	-- commands	
	enraged_cmd = "enraged",
	enraged_name = "Announce boss Enrage",
	enraged_desc = "Lets you know when boss hits harder",
	
	earthquake_cmd = "earthquake",
	earthquake_name = "Earthquake announce",
	earthquake_desc = "Announces when it's time for melees to back off",
	
	-- triggers
	trigger_enrage = "Golemagg the Incinerator gains Enrage",
	
	-- messages
	msg_earthquakeSoon = "Earthquake soon",
	msg_enrage = "Boss is enraged!",
	
	-- bars
	
	-- misc
	misc_addName = "Core Rager",
	
} end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	enraged_name = "Verkündet Boss' Raserei",
	enraged_desc = "Lässt dich wissen, wenn Boss härter zuschlägt",
	
	earthquake_name = "Verkündet erdbeben",
	earthquake_desc = "Sagt an, wenn es für die Melees zeit ist, weg zu gehen",
	
	-- triggers
	trigger_enrage = "Golemagg der Verbrenner bekommt \'Wutanfall",
	
	-- messages
	msg_earthquakeSoon = "Erdbeben bald",
	msg_enrage = "Boss ist in Raserei!",
	
	-- bars
	
	-- misc
	misc_addName = "Kernwüterich",

} end)
