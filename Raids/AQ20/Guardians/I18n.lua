------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.aq20.guardians
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Guardian",

	-- commands
	summon_cmd = "summon",
	summon_name = "Summon Alert",
	summon_desc = "Warn for summoned adds",

	plagueyou_cmd = "plagueyou",
	plagueyou_name = "Plague on you alert",
	plagueyou_desc = "Warn for plague on you",

	plagueother_cmd = "plagueother",
	plagueother_name = "Plague on others alert",
	plagueother_desc = "Warn for plague on others",

	icon_cmd = "icon",
	icon_name = "Place icon",
	icon_desc = "Place raid icon on the last plagued person (requires promoted or higher)",

	explode_cmd = "explode",
	explode_name = "Explode Alert",
	explode_desc = "Warn for incoming explosion",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for enrage",

	-- trigger
	trigger_explode = "Anubisath Guardian gains Explode.",
	trigger_enrage = "Anubisath Guardian gains Enrage.",
	trigger_summonGuardian = "Anubisath Guardian casts Summon Anubisath Swarmguard.",
	trigger_summonWarrior = "Anubisath Guardian casts Summon Anubisath Warrior.",
	trigger_plague = "^([^%s]+) ([^%s]+) afflicted by Plague%.$",
	
	-- messages
	msg_explode = "Exploding!",
	msg_enrage = "Enraged!",
	msg_summonGuard = "Swarmguard Summoned",
	msg_summonWarrior = "Warrior Summoned",
	msg_plagueOther = " has the Plague!",
	msg_plagueYou = "You have the Plague!",
	
	-- bars
	
	-- misc
	misc_you = "You",
	misc_are = "are",
	
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	summon_name = "Beschwörung",
	summon_desc = "Warnung, wenn Beschützer des Anubisath Schwarmwachen oder Krieger beschwört.",

	plagueyou_name = "Du hast die Seuche",
	plagueyou_desc = "Warnung, wenn Du die Seuche hast.",

	plagueother_name = "X hat die Seuche",
	plagueother_desc = "Warnung, wenn andere Spieler die Seuche haben.",

	icon_name = "Symbol",
	icon_desc = "Platziert ein Symbol über dem Spieler, der die Seuche hat. (Benötigt Anführer oder Befördert Status.)",

	explode_name = "Explosion",
	explode_desc = "Warnung vor Explosion.",

	enrage_name = "Wutanfall",
	enrage_desc = "Warnung vor Wutanfall.",

	-- triggers
	trigger_explode = "Beschützer des Anubisath bekommt 'Explodieren'.",
	trigger_enrage = "Beschützer des Anubisath bekommt 'Wutanfall'.",
	trigger_summonGuardian = "Beschützer des Anubisath wirkt Schwarmwache des Anubisath beschwören.",
	trigger_summonWarrior = "Beschützer des Anubisath wirkt Krieger des Anubisath beschwören.",
	trigger_plague = "^([^%s]+) ([^%s]+) von Seuche betroffen%.$",
	
	-- messages
	msg_explode = "Explosion!",
	msg_enrage = "Wutanfall!",
	msg_summonGuard = "Schwarmwache beschworen!",
	msg_summonWarrior = "Krieger beschworen!",
	msg_plagueOther = " hat die Seuche!",
	msg_plagueYou = "Du hast die Seuche!",
	
	-- bars
	
	-- misc
	misc_you = "Ihr",
	misc_are = "seid",
	
} end )
