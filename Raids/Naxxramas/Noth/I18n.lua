------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.noth
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Noth",

	-- commands
	blink_cmd = "blink",
	blink_name = "Blink Alert",
	blink_desc = "Warn for blink",

	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for teleport",

	curse_cmd = "curse",
	curse_name = "Curse Alert",
	curse_desc = "Warn for curse",

	wave_cmd = "wave",
	wave_name = "Wave Alert",
	wave_desc = "Warn for waves",

	-- triggers
	trigger_engage1 = "Die, trespasser!",
	trigger_engage2 = "Glory to the master!",
	trigger_engage3 = "Your life is forfeit!",
	trigger_blink = "Noth the Plaguebringer gains Blink.",
    trigger_teleportToBalcony = "teleports to the balcony above!",
    trigger_teleportToRoom = "teleports back into the battle!",
	trigger_curse = "afflicted by Curse of the Plaguebringer",
	
	-- messages
	msg_engage = "Noth the Plaguebringer engaged! 90 seconds till teleport",
	msg_blinkNow = "Blink!",
	msg_blink5 = "Blink in ~5 seconds!",
	msg_blink10 = "Blink in ~10 seconds!",
	msg_teleportNow = "Teleport! He's on the balcony!",
	msg_teleport10 = "Teleport in 10 seconds!",
	msg_teleport30 = "Teleport in 30 seconds!",
	msg_backNow = "He's back in the room for %d seconds!",
	msg_back10 = "10 seconds until he's back in the room!",
	msg_back30 = "30 seconds until he's back in the room!",
	msg_curse = "Curse! next in ~28 seconds",
	msg_curse10 = "Curse in ~10 seconds",
	msg_wave2Soon = "Wave 2 in 10sec",
	msg_wave2Now = "Wave 2 Spawning!",
	
	-- bars
	bar_blink = "Blink",
	bar_teleport = "Teleport!",
	bar_back = "Back in room!",
	bar_wave1 = "Wave 1",
	bar_wave2 = "Wave 2",
	--bar_wave3 = "Wave 3",
	bar_curse = "Next Curse",
	
	-- misc
	
} end )

L:RegisterTranslations("deDE", function() return {
	cmd = "Noth",

	-- commands
	--blink_cmd = "blink",
	blink_name = "Blinzeln Alarm",
	blink_desc = "Warnung für blinzeln",

	--teleport_cmd = "teleport",
	teleport_name = "Teleport Alarm",
	teleport_desc = "Warnung für teleport",

	--curse_cmd = "curse",
	curse_name = "Fluch Alarm",
	curse_desc = "Warnung für den Fluch",

	--wave_cmd = "wave",
	wave_name = "Wellen Alarm",
	wave_desc = "Warnung für die Add-Wellen",

	-- triggers
	trigger_engage1 = "Die, trespasser!",
	trigger_engage2 = "Glory to the master!",
	trigger_engage3 = "Your life is forfeit!",
	trigger_blink = "Noth der Seuchenfürst bekommt 'Blinzeln'.",
    trigger_teleportToBalcony = "teleports to the balcony above!",
    trigger_teleportToRoom = "teleports back into the battle!",
	trigger_curse = "ist von Fluch des Seuchenfürsten betroffen.",
	
	-- messages
	msg_engage = "Noth der Seuchenfürst angegriffen! 90 Sekunden bis zum Teleport",
	msg_blinkNow = "Blinzeln!",
	msg_blink5 = "Blinzeln in 5 Sekunden!",
	msg_blink10 = "Blinzeln in 10 Sekunden!",
	msg_teleportNow = "Teleport! Er ist auf dem Balkon!",
	msg_teleport10 = "Teleport in 10 Sekunden!",
	msg_teleport30 = "Teleport in 30 Sekunden!",
	msg_backNow = "Er ist zurück im Raum für %s Sekunden!",
	msg_back10 = "10 Sekunden bis er zurück im Raum ist!",
	msg_back30 = "30 Sekunden bis er zurück im Raum ist!",
	msg_curse = "Fluch! Nächster in 28 Sekunden",
	msg_curse10 = "Fluch in 10 Sekunden",
	msg_wave2Soon = "Welle 2 in 10 Sekunden",
	msg_wave2Now = "Welle 2 gespawnt!",
	
	-- bars
	bar_blink = "Blinzeln",
	bar_teleport = "Teleport!",
	bar_back = "Zurück im Raum!",
	bar_wave1 = "Welle 1",
	bar_wave2 = "Welle 2",
	--bar_wave3 = "Welle 3",
	bar_curse = "Nächster Fluch",
	
	-- misc
	
} end )
