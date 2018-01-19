------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.mc.garr
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Garr",
	
	-- commands	
	adds_cmd = "adds",
	adds_name = "Dead adds counter",
	adds_desc = "Announces dead Firesworns",
	
	-- triggers
	trigger_addDead8 = "Garr gains Enrage(.+)8",
	trigger_addDead7 = "Garr gains Enrage(.+)7",
	trigger_addDead6 = "Garr gains Enrage(.+)6",
	trigger_addDead5 = "Garr gains Enrage(.+)5",
	trigger_addDead4 = "Garr gains Enrage(.+)4",
	trigger_addDead3 = "Garr gains Enrage(.+)3",
	trigger_addDead2 = "Garr gains Enrage(.+)2",
	trigger_addDead1 = "Garr gains Enrage.",
	
	-- messages
	msg_add1 = "1/8 Firesworns dead!",
	msg_add2 = "2/8 Firesworns dead!",
	msg_add3 = "3/8 Firesworns dead!",
	msg_add4 = "4/8 Firesworns dead!",
	msg_add5 = "5/8 Firesworns dead!",
	msg_add6 = "6/8 Firesworns dead!",
	msg_add7 = "7/8 Firesworns dead!",
	msg_add8 = "8/8 Firesworns dead!",
	
	-- bars
    bar_adds = "Firesworns dead",
	
	-- misc
	misc_fireswornName = "Firesworn",

} end)

L:RegisterTranslations("deDE", function() return {
	-- commands	
	adds_name = "Zähler für tote Adds",
	adds_desc = "Verkündet Feueranbeter Tod",
	
	-- triggers
	trigger_addDead1 = "Garr bekommt \'Wutanfall\'.",
	trigger_addDead2 = "Garr bekommt \'Wutanfall(.+)2",
	trigger_addDead3 = "Garr bekommt \'Wutanfall(.+)3",
	trigger_addDead4 = "Garr bekommt \'Wutanfall(.+)4",
	trigger_addDead5 = "Garr bekommt \'Wutanfall(.+)5",
	trigger_addDead6 = "Garr bekommt \'Wutanfall(.+)6",
	trigger_addDead7 = "Garr bekommt \'Wutanfall(.+)7",
	trigger_addDead8 = "Garr bekommt \'Wutanfall(.+)8",
	
	-- messages
	msg_add1 = "1/8 Feueranbeter tot!",
	msg_add2 = "2/8 Feueranbeter tot!",
	msg_add3 = "3/8 Feueranbeter tot!",
	msg_add4 = "4/8 Feueranbeter tot!",
	msg_add5 = "5/8 Feueranbeter tot!",
	msg_add6 = "6/8 Feueranbeter tot!",
	msg_add7 = "7/8 Feueranbeter tot!",
	msg_add8 = "8/8 Feueranbeter tot!",
	
	-- bars
    bar_adds = "Feueranbeter tot",
	
	-- misc
	misc_fireswornName = "Feueranbeter",

} end)
