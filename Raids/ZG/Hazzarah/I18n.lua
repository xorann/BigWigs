------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.zg.hazzarah
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Hazzarah",
	
	-- commands
	nightmaresummon_cmd = "spawns",
	nightmaresummon_name = "Spawns alert",
	nightmaresummon_desc = "Shows a warning when the boss summons Nightmare Illusions.",
	
	-- triggers
	trigger_nightmareSummon = "Hazza\'rah casts Summon Nightmare Illusions\.",
	
	-- messages
	msg_nightmareSummon = "Kill the spawns!",
	
	-- bars
	
	-- misc	
	
} end )

L:RegisterTranslations("deDE", function() return {
	cmd = "Hazzarah",

	-- commands
	nightmaresummon_name = "Alarm für die Adds",
	nightmaresummon_desc = "Zeigt eine Warnung wenn der Boss Alptraumillusionen beschwört.",
	
	-- triggers
	trigger_nightmareSummon = "Hazza\'rah wirkt Alptraumillusionen beschwören\.",
	
	-- messages
	msg_nightmareSummon = "Tötet die Adds!",
	
	-- bars
	
	-- misc	
	
} end )