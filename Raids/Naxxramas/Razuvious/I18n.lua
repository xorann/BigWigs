------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.razuvious
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Razuvious",

	-- commands
	shout_cmd = "shout",
	shout_name = "Shout Alert",
	shout_desc = "Warn for disrupting shout",

	unbalance_cmd = "unbalancing",
	unbalance_name = "Unbalancing Strike Alert",
	unbalance_desc = "Warn for Unbalancing Strike",

	shieldwall_cmd = "shieldwall",
	shieldwall_name = "Shield Wall Timer",
	shieldwall_desc = "Show timer for Shield Wall",
	
	taunt_cmd = "taunt",
	taunt_name = "Taunt Timer",
	taunt_desc = "Show timer for Taunt",

	-- triggers
	trigger_engage1 = "Stand and fight!",
	trigger_engage2 = "Show me what you've got!",
	trigger_engage3 = "Hah hah, I'm just getting warmed up!",
	--trigger_engage4 = "Stand and fight!",
	trigger_shout = "Disrupting Shout",
    trigger_unbalance = "afflicted by Unbalancing Strike",
	trigger_shieldWall   = "Death Knight Understudy gains Shield Wall.",
	trigger_taunt = "Razuvious is afflicted by Taunt.",
	
	-- messages
	msg_engage = "Instructor Razuvious engaged! 20sec to Shout, 30sec to Unbalancing Strike!",
	msg_shout7 = "7 sec to Disrupting Shout",
	msg_shout3 = "3 sec to Disrupting Shout!",
	msg_shoutNow = "Disrupting Shout! Next in 25secs",
	msg_noShout = "No shout! Next in 20secs",
	msg_unbalanceSoon = "Unbalancing Strike coming soon!",
	msg_unbalanceNow = "Unbalancing Strike! Next in ~30sec",
	msg_taunt = "Taunt!",
	
	-- bars
	bar_shout = "Possible Disrupting Shout",
	bar_unbalance = "Unbalancing Strike",
	bar_shieldWall       = "Shield Wall",
	bar_taunt = "Taunt",
	
	-- misc
	misc_understudy = "Death Knight Understudy"
} end )

L:RegisterTranslations("deDE", function() return {
	cmd = "Razuvious",
	
	-- misc
	misc_understudy = "Reservist der Todesritter"
} end )
