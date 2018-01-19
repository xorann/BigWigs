------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.mc.geddon
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Baron",
	
	-- commands
	service_cmd = "service",
	service_name = "Last Service warning",
	service_desc = "Timer bar for Geddon's last service.",

	inferno_cmd = "inferno",
	inferno_name = "Inferno alert",
	inferno_desc = "Timer bar for Geddon's Inferno.",

	bombtimer_cmd = "bombtimer",
	bombtimer_name = "Living Bomb timers",
	bombtimer_desc = "Shows a 8 second bar for when the bomb goes off at the target.",

	bomb_cmd = "bomb",
	bomb_name = "Living Bomb alert",
	bomb_desc = "Warn when players are the bomb",
	
	mana_cmd = "manaignite",
	mana_name = "Ignite Mana alert",
	mana_desc = "Shows timers for Ignite Mana and announce to dispel it",

	icon_cmd = "icon",
	icon_name = "Raid Icon on bomb",
	icon_desc = "Put a Raid Icon on the person who's the bomb. (Requires assistant or higher)",

	announce_cmd = "whispers",
	announce_name = "Whisper to Bomb targets",
	announce_desc = "Sends a whisper to players targetted by Living Bomb. (Requires assistant or higher)",
	
	-- triggers
	trigger_inferno = "is afflicted by Inferno.",
	trigger_service = "performs one last service for Ragnaros",
	trigger_bombYou = "You are afflicted by Living Bomb.",
	trigger_bombOther = "(.*) is afflicted by Living Bomb.",
	trigger_bombYouGone = "Living Bomb fades from you.",
	trigger_bombOtherGone = "Living Bomb fades from (.*).",
	trigger_igniteManaHit = "afflicted by Ignite Mana",
	trigger_igniteManaResist = "Ignite Mana was resisted",
	trigger_deathYou = "You die.",
	trigger_deathOther = "(.*) dies",
	
	-- messages
	msg_bombWhisper = "You are the bomb!",
	msg_bombYou = "You are the bomb!",
	msg_bombOther = "%s is the bomb!",
	msg_infernoSoon = "3 seconds until Inferno!",
	msg_service = "Last Service! Baron Geddon exploding in 8 seconds!",
	msg_infernoNow = "Inferno for 8 seconds!",
	msg_ignite = "Dispel NOW!",
	
	-- bars
	bar_bomb = "Living Bomb: %s",
	bar_infernoNext = "Next Inferno",
	bar_infernoChannel = "Inferno",
	bar_service = "Last Service",
	bar_ignite = "Possible Ignite Mana",
	
	-- misc
	
} end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	service_name = "Alarm für Letzten Dienst",
	service_desc = "Timer Balken für Baron Geddons Letzten Dienst.",

	inferno_name = "Alarm für Inferno",
	inferno_desc = "Timer Balken für Baron Geddons Inferno.",

	bombtimer_name = "Timer für Lebende Bombe",
	bombtimer_desc = "Zeigt einen 8 Sekunden Timer für die Explosion der Lebenden Bombe an.",

	bomb_name = "Alarm für Lebende Bombe",
	bomb_desc = "Warnen, wenn andere Spieler die Bombe sind.",
	
	mana_name = "Alarm für Mana entzünden",
	mana_desc = "Zeige Timer für Mana entzünden und verkünde Magie entfernen",

	icon_name = "Schlachtzugssymbole auf die Bombe",
	icon_desc = "Markiert den Spieler, der die Bombe ist.\n\n(Benötigt Schlachtzugleiter oder Assistent).",

	announce_name = "Der Bombe flüstern",
	announce_desc = "Dem Spieler flüstern, wenn er die Bombe ist.\n\n(Benötigt Schlachtzugleiter oder Assistent).",
	
	-- triggers
	trigger_inferno = "ist von Inferno betroffen",
	trigger_service = "performs one last service for Ragnaros",
	trigger_bombYou = "Ihr seid von Lebende Bombe betroffen.",
	trigger_bombOther = "(.*) ist von Lebende Bombe betroffen.",
	trigger_bombYouGone = "'Lebende Bombe\' schwindet von Euch.",
	trigger_bombOtherGone = "Lebende Bombe schwindet von (.*).",
	trigger_igniteManaHit = "von Mana entzünden betroffen",
	trigger_igniteManaResist = "Mana entzünden(.+)widerstanden",
	trigger_deathYou = "Ihr sterbt.",
	trigger_deathOther = "(.*) stirbt",
	
	-- messages
	msg_bombWhisper = "Du bist die Bombe!",
	msg_bombYou = "Du bist die Bombe!",
	msg_bombOther = "%s ist die Bombe!",
	msg_infernoSoon = "3 Sekunden bis Inferno!",
	msg_service = "Letzter Dienst! Baron Geddon explodiert in 8 Sekunden!",
	msg_infernoNow = "Inferno 8 Sekunden lang!",
	msg_ignite = "Entferne Magie JETZT!",
	
	-- bars
	bar_bomb = "Lebende Bombe: %s",
	bar_infernoNext = "Nächstes Inferno",
	bar_infernoChannel = "Inferno",
	bar_service = "Letzter Dienst.",
	bar_ignite = "Mögliches Mana entzünden",
	
	-- misc
	
} end)
