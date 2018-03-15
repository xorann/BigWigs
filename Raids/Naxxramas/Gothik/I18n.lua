------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.gothik
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Gothik",

	-- command
	room_cmd = "room",
	room_name = "Room Arrival Warnings",
	room_desc = "Warn for Gothik's arrival",

	add_cmd = "add",
	add_name = "Add Warnings",
	add_desc = "Warn for adds",

	adddeath_cmd = "adddeath",
	adddeath_name = "Add Death Alert",
	adddeath_desc = "Alerts when an add dies.",
	
	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Alerts when Gothik teleports.",

	-- triggers
	trigger_victory = "I... am... undone.",
	trigger_engage1 = "Brazenly you have disregarded powers beyond your understanding.",
	trigger_engage2 = "Teamanare shi rikk mannor rikk lok karkun",
	trigger_inRoom = "I have waited long enough! Now, you face the harvester of souls.",
	
	-- messages
	msg_engage = "Gothik the Harvester engaged! 4:35 till he's in the room.",
	msg_riderDeath = "Rider dead!",
	msg_deathKnightDeath = "Death Knight dead!",
	msg_inRoom3m = "In room in 3 minutes",
	msg_inRoom90 = "In room in 90 seconds",
	msg_inRoom60 = "In room in 60 seconds",
	msg_inRoom30 = "In room in 30 seconds",
	msg_inRoom10 = "Gothik Incoming in 10 seconds",
	msg_wave = "%d/22: ", -- its only 22 waves not 26
	msg_trainee = "Trainees in 3 seconds",
	msg_deathKnight = "Deathknight in 3 seconds",
	msg_rider = "Rider in 3 seconds",
	msg_inRoom = "He's in the room!",
	
	-- bars
	bar_trainee = "Trainee - %d",
	bar_deathKnight = "Deathknight - %d",
	bar_rider = "Rider - %d",
	bar_inRoom = "In Room",
	bar_teleport = "Teleport",
	
	-- misc
	misc_riderName = "Unrelenting Rider",
	misc_spectralRiderName = "Spectral Rider",
	misc_deathKnightName = "Unrelenting Deathknight",
	misc_spectralDeathKnightName = "Spectral Deathknight",
	misc_traineeName = "Unrelenting Trainee",
	misc_spectralTraineeName = "Spectral Trainee",

} end )