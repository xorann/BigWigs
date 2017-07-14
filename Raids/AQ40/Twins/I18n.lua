

----------------------------
--      Localization      --
----------------------------
local bossName = "The Twin Emperors"
local L = BigWigs.I18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Twins",

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

	porttrigger = "casts Twin Teleport.",
	portwarn = "Teleport!",
	portdelaywarn = "Teleport in 5 seconds!",
	portdelaywarn10 = "Teleport in 10 seconds!",
	bartext = "Teleport",
	explodebugtrigger = "gains Explode Bug",
	explodebugwarn = "Bug exploding nearby!",
	enragetrigger = "becomes enraged.",
	--trigger = "Blizzard",
	enragewarn = "Twins are enraged",
	healtrigger1 = "'s Heal Brother heals",
	healtrigger2 = " Heal Brother heals",
	healwarn = "Casting Heal!",
	startwarn = "Twin Emperors engaged! Enrage in 15 minutes!",
	enragebartext = "Enrage",
	warn1 = "Enrage in 10 minutes",
	warn2 = "Enrage in 5 minutes",
	warn3 = "Enrage in 3 minutes",
	warn4 = "Enrage in 90 seconds",
	warn5 = "Enrage in 60 seconds",
	warn6 = "Enrage in 30 seconds",
	warn7 = "Enrage in 10 seconds",
    
    blizzard_trigger = "You are afflicted by Blizzard.",
    blizzard_gone_trigger = "Blizzard fades from you",
	blizzard_warn = "Run from Blizzard!",
            
            
    pull_trigger1 = "Ah, lambs to the slaughter.",
    pull_trigger2 = "Prepare to embrace oblivion!",
    pull_trigger3 = "Join me brother, there is blood to be shed.",
    pull_trigger4 = "To decorate our halls.",
    pull_trigger5 = "Let none survive!",
    pull_trigger6 = "It's too late to turn away.",
    pull_trigger7 = "Look brother, fresh blood.",
    pull_trigger8 = "Like a fly in a web.",
    pull_trigger9 = "Shall be your undoing!",
    pull_trigger10 = "Your brash arrogance",
            
    kill_trigger = "My brother...NO!",
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

