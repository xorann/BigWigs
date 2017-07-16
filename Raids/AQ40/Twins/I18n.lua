

----------------------------
--      Localization      --
----------------------------
local bossName = BigWigs.bossmods.aq40.twins
local L = BigWigs.I18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Twins",

	-- commands
	bug_cmd = "bug",
	bug_name = "Exploding Bug Alert",
	bug_desc = "Warn for exploding bugs",

	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for Teleport",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	heal_cmd = "heal",
	heal_name = "Heal Alert",
	heal_desc = "Warn for Twins Healing",
            
    blizzard_cmd = "blizzard",
    blizzard_name = "Blizzard Warning",
    blizzard_desc = "Shows an Icon if you are standing in a Blizzard",

	-- triggers
	trigger_teleport = "casts Twin Teleport.",
	trigger_heal1 = "'s Heal Brother heals",
	trigger_heal2 = " Heal Brother heals",
	trigger_explosion = "gains Explode Bug",
	trigger_enrage = "becomes enraged.",
	trigger_blizzardGain = "You are afflicted by Blizzard.",
	trigger_blizzard_gone = "Blizzard fades from you",

	trigger_pull1 = "Ah, lambs to the slaughter.",
	trigger_pull2 = "Prepare to embrace oblivion!",
	trigger_pull3 = "Join me brother, there is blood to be shed.",
	trigger_pull4 = "To decorate our halls.",
	trigger_pull5 = "Let none survive!",
	trigger_pull6 = "It's too late to turn away.",
	trigger_pull7 = "Look brother, fresh blood.",
	trigger_pull8 = "Like a fly in a web.",
	trigger_pull9 = "Shall be your undoing!",
	trigger_pull10 = "Your brash arrogance",

	trigger_kill = "My brother...NO!",

	-- messages
	msg_teleport = "Teleport!",
	msg_teleport5 = "Teleport in 5 seconds!",
	msg_teleport10 = "Teleport in 10 seconds!",
	msg_explosion = "Bug exploding nearby!",
	msg_enrage = "Twins are enraged",
	msg_heal = "Casting Heal!",
	msg_engage = "Twin Emperors engaged! Enrage in 15 minutes!",
	msg_blizzard = "Run from Blizzard!",

	msg_enrage10m = "Enrage in 10 minutes",
	msg_enrage5m = "Enrage in 5 minutes",
	msg_enrage3m = "Enrage in 3 minutes",
	msg_enrage90 = "Enrage in 90 seconds",
	msg_enrage60 = "Enrage in 60 seconds",
	msg_enrage30 = "Enrage in 30 seconds",
	msg_enrage10 = "Enrage in 10 seconds",

	-- bars
	bar_teleport = "Teleport",
	bar_enrage = "Enrage",
} end )

L:RegisterTranslations("deDE", function() return {

	bug_name = "Explodierende K\195\164fer",
	bug_desc = "Warnung vor explodierenden K\195\164fern.",

	teleport_name = "Teleport",
	teleport_desc = "Warnung, wenn die Zwillings Imperatoren sich teleportieren.",

	enrage_name = "Wutanfall",
	enrage_desc = "Warnung, wenn die Zwillings Imperatoren w\195\188tend werden.",

	heal_name = "Heilung",
	heal_desc = "Warnung, wenn die Zwillings Imperatoren sich heilen.",

    blizzard_name = "Blizzard Warnung",
    blizzard_desc = "Zeigt ein Icon wenn du im Blizzard stehst",
            
	porttrigger = "wirkt Zwillingsteleport.",
	portwarn = "Teleport!",
	portdelaywarn = "Teleport in ~5 Sekunden!",
	portdelaywarn10 = "Teleport in ~10 Sekunden!",
	bartext = "Teleport",
	explodebugtrigger = "bekommt 'Käfer explodieren lassen'",
	explodebugwarn = "K\195\164fer explodiert!",
	enragetrigger = "wird w\195\188tend.", -- ? "bekommt 'Wutanfall'"
	enragewarn = "Zwillings Imperatoren sind w\195\188tend!",
	healtrigger1 = "'s Bruder heilen heilt",
	healtrigger2 = " Bruder heilen heilt",
	healwarn = "Heilung gewirkt!",
	startwarn = "Zwillings Imperatoren angegriffen! Wutanfall in 15 Minuten!",
	enragebartext = "Wutanfall",
	warn1 = "Wutanfall in 10 Minuten",
	warn2 = "Wutanfall in 5 Minuten",
	warn3 = "Wutanfall in 3 Minuten",
	warn4 = "Wutanfall in 90 Sekunden",
	warn5 = "Wutanfall in 60 Sekunden",
	warn6 = "Wutanfall in 30 Sekunden",
	warn7 = "Wutanfall in 10 Sekunden",
    
    blizzard_trigger = "Ihr seid von Blizzard betroffen.",
    blizzard_gone_trigger = "'Blizzard' schwindet von Euch.",
	blizzard_warn = "Lauf aus Blizzard!",
            
    pull_trigger1 = "Ihr seid nichts weiter als",
    pull_trigger2 = "Seid bereit in die",
    pull_trigger3 = "Komm Bruder",
    pull_trigger4 = "Um unsere Hallen",
    pull_trigger5 = "Niemand wird",
    pull_trigger6 = "Nun gibt es kein",
    pull_trigger7 = "Sieh Bruder",
    pull_trigger8 = "Wie eine Fliege",
    pull_trigger9 = "Wird euer Untergang",
    pull_trigger10 = "Eure unversch",
            
    kill_trigger = "Mein Bruder...",
} end )

