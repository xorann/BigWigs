------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.aq40.defenders
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Defender",

	-- commands
	plagueyou_cmd = "plagueyou",
	plagueyou_name = "Plague on you alert",
	plagueyou_desc = "Warn if you got the Plague",
	plagueother_cmd = "plagueother",
	plagueother_name = "Plague on others alert",
	plagueother_desc = "Warn if others got the Plague",
	thunderclap_cmd = "thunderclap",
	thunderclap_name = "Thunderclap Alert",
	thunderclap_desc = "Warn for Thunderclap",
	explode_cmd = "explode",
	explode_name = "Explode Alert",
	explode_desc = "Warn for Explode",
	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",
	summon_cmd = "summon",
	summon_name = "Summon Alert",
	summon_desc = "Warn for add summons",
	icon_cmd = "icon",
	icon_name = "Place icon",
	icon_desc = "Place raid icon on the last plagued person (requires promoted or higher)",

	-- triggers
	trigger_explode = "Anubisath Defender gains Explode.",
	trigger_enrage = "Anubisath Defender gains Enrage.",
	trigger_summonGuard = "Anubisath Defender casts Summon Anubisath Swarmguard.",
	trigger_summonWarrior = "Anubisath Defender casts Summon Anubisath Warrior.",
	trigger_plauge = "^([^%s]+) ([^%s]+) afflicted by Plague%.$",
	trigger_thunderclap = "^Anubisath Defender's Thunderclap hits ([^%s]+) for %d+%.",

	-- messages
	msg_explode = "Exploding!",
	msg_enrage = "Enraged!",
	msg_summonGuard = "Swarmguard Summoned",
	msg_summonWarrior = "Warrior Summoned",
	msg_plague = "%s has the Plague!",
	msg_plagueYou = "You have the plague!",
	msg_thunderclap = "Thunderclap!",

	-- bars

	-- misc
	misc_you = "You",
	misc_are = "are",
}
end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	plagueyou_name = "Du hast die Seuche",
	plagueyou_desc = "Warnung, wenn Du die Seuche hast.",
	plagueother_name = "X hat die Seuche",
	plagueother_desc = "Warnung, wenn andere Spieler die Seuche haben.",
	thunderclap_name = "Donnerknall",
	thunderclap_desc = "Warnung vor Donnerknall.",
	explode_name = "Explosion",
	explode_desc = "Warnung vor Explosion.",
	enrage_name = "Wutanfall",
	enrage_desc = "Warnung vor Wutanfall.",
	summon_name = "Beschw\195\182rung",
	summon_desc = "Warnung, wenn Verteidiger des Anubisath Schwarmwachen oder Krieger beschw\195\182rt.",
	icon_name = "Symbol",
	icon_desc = "Platziert ein Symbol \195\188ber dem Spieler, der die Seuche hat. (Ben\195\182tigt Anf\195\188hrer oder Bef\195\182rdert Status.)",

	-- triggers
	trigger_explode = "Verteidiger des Anubisath bekommt 'Explodieren'.",
	trigger_enrage = "Verteidiger des Anubisath bekommt 'Wutanfall'.",
	trigger_summonGuard = "Verteidiger des Anubisath wirkt Schwarmwache des Anubisath beschw\195\182ren.",
	trigger_summonWarrior = "Verteidiger des Anubisath wirkt Krieger des Anubisath beschw\195\182ren.",
	trigger_plauge = "^([^%s]+) ([^%s]+) von Seuche betroffen%.$",
	trigger_thunderclap = "^Verteidiger des Anubisath's Donnerknall trifft ([^%s]+) f\195\188r %d+%.",

	-- messages
	msg_explode = "Explosion!",
	msg_enrage = "Wutanfall!",
	msg_summonGuard = "Schwarmwache beschworen!",
	msg_summonWarrior = "Krieger beschworen!",
	msg_plague = "%s hat die Seuche!",
	msg_plagueYou = "Du hast die Seuche!",
	msg_thunderclap = "Donnerknall!",

	-- bars

	-- misc
	misc_you = "Ihr",
	misc_are = "seid",
}
end)
