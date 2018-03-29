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

L:RegisterTranslations("deDE", function() return {
	--cmd = "Anubrekhan",

	-- commands
	--locust_cmd = "locust",
	locust_name = "Heuschreckenschwarm Alarm",
	locust_desc = "Warnung vor Heuschreckenschwarm",

	--enrage_cmd = "enrage",
	enrage_name = "Gruftwache Wutanfall Alarm",
	enrage_desc = "Warnung für Wutanfall",
		
	-- triggers
	trigger_engage1 = "Just a little taste...",
	trigger_engage2 = "Yes, run! It makes the blood pump faster!",
	trigger_engage3 = "There is no way out.",
	
	trigger_enrage = "Gruftwache bekommt 'Wutanfall'.",
	trigger_locustSwarm = "Anub'Rekhan bekommt 'Heuschreckenschwarm'.",
	trigger_locustSwarmCast = "Anub'Rekhan beginnt Heuschreckenschwarm zu wirken.",
	
	-- messages
	msg_enrage = "Gruftwache Wutanfall!",
	msg_locustSwarmGone = "Heuschreckenschwarm beendet!",
	msg_locustSwarmNext = "Nächster Heuschreckenschwarm in 90 sek",
	msg_locustSwarmSoon = "10 Sekunden bis Heuschreckenschwarm",
	msg_locustSwarmNow = "Heuschreckenschwarm!",
	
	-- bars
	bar_locustSwarmNext = "Möglicher Heuschreckenschwarm",
	bar_locustSwarmDuration = "Heuschreckenschwarm",
	bar_locustSwarmCast = "Heuschreckenschwarm!",
	
	-- misc

} end )