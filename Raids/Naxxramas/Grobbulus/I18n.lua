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
	otherinjected_desc = "Warn when others are injected (Whisper)",

	icon_cmd = "icon",
	icon_name = "Place Icon",
	icon_desc = "Place a skull icon on an injected person. (Requires promoted or higher)",

	cloud_cmd = "cloud",
	cloud_name = "Poison Cloud",
	cloud_desc = "Warn for Poison Clouds",

	slimespray_cmd = "slimespray",
	slimespray_name = "Slime Spray",
	slimespray_desc = "Show timer for Slime Spray",
	
	bombardSlime_cmd = "bombardSlime",
	bombardSlime_name = "Bombard Slime",
	bombardSlime_desc = "Trash Respawn Timer for the three Sewage Slimes",
	
	-- triggers
	trigger_inject = "^([^%s]+) ([^%s]+) afflicted by Mutating Injection",
	trigger_cloud = "Grobbulus casts Poison Cloud.",
	trigger_slimeSpray = "Slime Spray",
	trigger_slimeSpray2 = "sprays slime across the room!",
	trigger_bombardSlime = "begins to cast Bombard Slime.", -- slime trash respawn
	
	-- messages
	msg_engage = "Grobbulus engaged, 12min to enrage!",
	msg_enrage10m = "Enrage in 10min",
	msg_enrage5m = "Enrage in 5min",
	msg_enrage1m = "Enrage in 1min",
	msg_enrage30 = "Enrage in 30sec",
	msg_enrage10 = "Enrage in 10sec",
	msg_bombYou = "You are injected!",
	msg_bombOther = "%s is injected!",
	msg_cloud = "Poison Cloud. Next in ~15 seconds!",
	
	-- bars
	bar_enrage = "Enrage",
	bar_bomb = "%s injected",
	bar_cloud = "Poison Cloud",
	bar_slimeSpray = "Possible Slime Spray",
	bar_bombardSlime = "Sewage Slime Respawn",
	
	-- misc
	misc_you = "You",
	misc_are = "are",
	misc_bombSay = "I am injected",
	
	misc_addName = "Sewage Slime",
} end )

L:RegisterTranslations("deDE", function() return {
	--cmd = "Grobbulus",

	-- commands
	--enrage_cmd = "enrage",
	enrage_name = "Wutanfall Alarm",
	enrage_desc = "Warnung für Wutanfall",

	--youinjected_cmd = "youinjected",
	youinjected_name = "Du wurdest injiziert Alarm",
	youinjected_desc = "Warnung wenn du injiziert wirst",

	--otherinjected_cmd = "otherinjected",
	otherinjected_name = "Andere injiziert Alarm",
	otherinjected_desc = "Warnung wenn andere injiziert werden (Flüstern)",

	--icon_cmd = "icon",
	icon_name = "Icon platzieren",
	icon_desc = "Platziert ein Skull Icon auf der injizierten Person. (Erfordert Assistent oder höher)",

	--cloud_cmd = "cloud",
	cloud_name = "Giftwolke",
	cloud_desc = "Warnung für Giftwolke",

	--slimespray_cmd = "slimespray",
	slimespray_name = "Schleimnebel",
	slimespray_desc = "Zeigt Timer für Schleimnebel",
	
	--bombardSlime_cmd = "bombardSlime",
	bombardSlime_name = "Bombard Slime",
	bombardSlime_desc = "Trash Respawn Timer for the three Sewage Slimes",
	
	-- triggers
	trigger_inject = "^([^%s]+) ([^%s]+) von Mutagene Injektion betroffen.", 
	trigger_cloud = "Grobbulus wirkt Giftwolke.",
	trigger_slimeSpray = "Schleimnebel",
	trigger_slimeSpray2 = "sprays slime across the room!",
	trigger_bombardSlime = "begins to cast Bombard Slime.", -- slime trash respawn
	
	-- messages
	msg_engage = "Grobbulus angegriffen, 12min bis zum Wutanfall!",
	msg_enrage10m = "Wutanfall in 10min",
	msg_enrage5m = "Wutanfall in 5min",
	msg_enrage1m = "Wutanfall in 1min",
	msg_enrage30 = "Wutanfall in 30sek",
	msg_enrage10 = "Wutanfall in 10sek",
	msg_bombYou = "Du bist injiziert!",
	msg_bombOther = "%s ist injiziert!",
	msg_cloud = "Giftwolke. Nächste in ~15 Sekunden!",
	
	-- bars
	bar_enrage = "Wutanfall",
	bar_bomb = "%s injiziert",
	bar_cloud = "Giftwolke",
	bar_slimeSpray = "Möglicher Schleimnebel",
	bar_bombardSlime = "Sewage Slime Respawn",
	
	-- misc
	misc_you = "Ihr",
	misc_are = "seid",
	misc_bombSay = "Ich wurde injiziert",
} end )
