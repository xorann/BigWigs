------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.anubrekhan
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Anubrekhan",

	-- commands
	locust_cmd = "locust",
	locust_name = "Locust Swarm Alert",
	locust_desc = "Warn for Locust Swarm",

	enrage_cmd = "enrage",
	enrage_name = "Crypt Guard Enrage Alert",
	enrage_desc = "Warn for Enrage",
		
	-- triggers
	trigger_engage1 = "Just a little taste...",
	trigger_engage2 = "Yes, run! It makes the blood pump faster!",
	trigger_engage3 = "There is no way out.",
	
	trigger_enrage = "gains Enrage.",
	trigger_locustSwarm = "Anub'Rekhan gains Locust Swarm.",
	trigger_locustSwarmCast = "Anub'Rekhan begins to cast Locust Swarm.",
	
	-- messages
	msg_enrage = "Crypt Guard Enrage - Stun + Traps!",
	msg_locustSwarmGone = "Locust Swarm ended!",
	msg_locustSwarmNext = "Next Locust Swarm in 90 sec",
	msg_locustSwarmSoon = "10 Seconds until Locust Swarm",
	msg_locustSwarmNow = "Incoming Locust Swarm!",
	
	-- bars
	bar_locustSwarmNext = "Possible Locust Swarm",
	bar_locustSwarmDuration = "Locust Swarm",
	bar_locustSwarmCast = "Incoming Locust Swarm!",
	
	-- misc

} end )