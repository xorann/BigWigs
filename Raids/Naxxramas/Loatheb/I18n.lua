------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.loatheb
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Loatheb",

	-- commands
	doom_cmd = "doom",
	doom_name = "Inevitable Doom Alert",
	doom_desc = "Warn for Inevitable Doom",

	curse_cmd = "curse",
	curse_name = "Remove Curse Alert",
	curse_desc = "Warn when curses are removed from Loatheb",
	
	spore_cmd = "spore",
	spore_name = "Spore Alert",
	spore_desc = "Warn for Spores",

	-- triggers
	trigger_doom = "afflicted by Inevitable Doom.",
	--trigger_curse = "Loatheb's Chains of Ice is removed.",
    trigger_curse  = "Loatheb's Curse (.+) is removed.",
	
	-- messages	doomwarn = "Inevitable Doom %d! %d sec to next!",
	msg_doomSoon = "Inevitable Doom %d in 5 sec!",
	msg_curse = "Curses removed! RENEW CURSES",    
	msg_doomChangeSoon = "Doom timerchange in %s seconds!",
	msg_doomChangeNow = "Inevitable Doom now happens every 15sec!",
	msg_engage = "Loatheb engaged, 2 min to Inevitable Doom!",
	--msg_spore = "Spore spawned",
	
	-- bars
	bar_doom = "Inevitable Doom %d",
	bar_curse = "Remove Curse",
	bar_softEnrage = "Doom every 15sec",
	bar_spore = "Next Spore",
	
	-- misc

} end )