------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.kelthuzad
local L = BigWigs.i18n[bossName]


L:RegisterTranslations("enUS", function() return {
	cmd = "Kelthuzad",

	-- commands
	phase_cmd = "phase",
	phase_name = "Phase Warnings",
	phase_desc = "Warn for phases.",

	mc_cmd = "mindcontrol",
	mc_name = "Mind Control",
	mc_desc = "Alerts when people are mind controlled.",

	fissure_cmd = "fissure",
	fissure_name = "Shadow Fissure",
	fissure_desc = "Alerts about incoming Shadow Fissures.",

	frostblast_cmd = "frostblast",
	frostblast_name = "Frost Blast",
	frostblast_desc = "Alerts when people get Frost Blasted.",

	frostbolt_cmd = "frostbolt",
	frostbolt_name = "Frostbolt Alert",
	frostbolt_desc = "Alerts about incoming Frostbolts",

	frostboltbar_cmd = "frostboltbar",
	frostboltbar_name = "Frostbolt Bar",
	frostboltbar_desc = "Displays a bar for Frostbolt casts",

	detonate_cmd = "detonate",
	detonate_name = "Detonate Mana Warning",
	detonate_desc = "Warns about Detonate Mana soon.",

	detonateicon_cmd = "detonateicon",
	detonateicon_name = "Raid Icon on Detonate",
	detonateicon_desc = "Place a raid icon on people with Detonate Mana.",

	guardians_cmd = "guardians",
	guardians_name = "Guardian Spawns",
	guardians_desc = "Warn for incoming Icecrown Guardians in phase 3.",
	
	fbvolley_cmd = "fbvolley",
	fbvolley_name = "Possible volley",
	fbvolley_desc = "Timer for possible Frostbolt volley/multiple",
	
	addcount_cmd = "addcount",
	addcount_name = "P1 Add counter",
	addcount_desc = "Counts number of killed adds in P1",
	
	ktmreset_cmd = "ktmreset",
	ktmreset_name = "Do not reset KTM on MC",
	ktmreset_desc = "Resets KTM on MC when disabled, does nothing when enabled.",
	
	proximity_cmd = "proximity",
    proximity_name = "Proximity Warning",
    proximity_desc = "Show Proximity Warning Frame",
	
	-- triggers
	trigger_mindControl1 = "Your soul, is bound to me now!",
	trigger_mindControl2 = "There will be no escape!",
	trigger_engage1 = "Minions, servants, soldiers of the cold dark, obey the call of Kel'Thuzad!",   
	trigger_engage2 = "Minions, servants, soldiers of the cold dark! Obey the call of Kel'Thuzad!",
	trigger_attack1 = "Kel'Thuzad attacks",
	trigger_attack2 = "Kel'Thuzad misses",
	trigger_attack3 = "Kel'Thuzad hits",
	trigger_attack4 = "Kel'Thuzad crits",
	trigger_kick1 = "Kick hits Kel'Thuzad",
	trigger_kick2 = "Kick crits Kel'Thuzad",
	trigger_kick3 = "Kick was blocked by Kel'Thuzad",
	trigger_pummel1 = "Pummel hits Kel'Thuzad",
	trigger_pummel2 = "Pummel crits Kel'Thuzad",
	trigger_pummel3 = "Pummel was blocked by Kel'Thuzad",
	trigger_shieldBash1 = "Shield Bash hits Kel'Thuzad",
	trigger_shieldBash2 = "Shield Bash crits Kel'Thuzad",
	trigger_shieldBash3 = "Shield Bash was blocked by Kel'Thuzad",
	trigger_earthShock1 = "Earth Shock hits Kel'Thuzad",
	trigger_earthShock2 = "Earth Shock crits Kel'Thuzad",
	trigger_phase2_1 = "Pray for mercy!",
	trigger_phase2_2 = "Scream your dying breath!",
	trigger_phase2_3 = "The end is upon you!",
	trigger_phase3 = "Master, I require aid!",
	trigger_guardians = "Very well. Warriors of the frozen wastes, rise up! I command you to fight, kill and die for your master! Let none survive!",
	trigger_fissure = "casts Shadow Fissure.",
	trigger_fissure_self = "You cast Shadow Fissure.",
	trigger_frostbolt = "Kel'Thuzad begins to cast Frostbolt.",
	trigger_frostboltVolley = "afflicted by Frostbolt",
	trigger_addDeath = "(.*) dies",
	trigger_frostBlast = "I will freeze the blood in your veins!", 
	trigger_detonate = "^([^%s]+) ([^%s]+) afflicted by Detonate Mana",
	
	-- messages
	msg_mindControl = "Mind Control!",
	msg_engage = "Kel'Thuzad encounter started! ~5min till he is active!",
	msg_phase2Soon = "Phase 1 ends in 20 seconds!",
	msg_phase2Now = "Phase 2, Kel'Thuzad incoming!",
	msg_phase3Soon = "Phase 3 soon!",
	msg_phase3Now = "Phase 3, Guardians in ~15sec!",
	msg_guardians = "Guardians incoming in ~10sec!",
	msg_fissure = "Shadow Fissure!",
	msg_frostbolt = "Frostbolt! Interrupt!",
	msg_frostblast = "Frost Blast!",
	msg_frostblastSoon = "Possible Frost Blast in ~5sec!",
	msg_mindControlAndfrostblastSoon = "Possible Frost Blast and Mind Control in ~5sec!",
	msg_detonateSoon = "Detonate Mana in ~5sec!",
	msg_detonateNow = "%s has Detonate Mana!",
	
	-- bars
	bar_mindControl = "Possible Mind Control!",
	bar_phase1 = "Phase 1 Timer",
	bar_phase2 = "Kel'Thuzad Active!",
	bar_guardians = "Guardians incoming!",
	bar_frostbolt = "Frostbolt",
	bar_frostboltVolley = "Possible volley",
	bar_add = "%d/14 %s",
	bar_frostBlast = "Possible Frost Blast",
	bar_mindControlAndFrostBlast = "First Frost Blast and MC",
	bar_detonateNow = "Detonate Mana - %s",
	bar_detonateNext = "Detonate Mana",
	
	-- misc
	misc_zone = "Kel'Thuzad Chamber",
	misc_you = "You",
	misc_are = "are",
	
} end )

L:RegisterTranslations("deDe", function() return {
} end )