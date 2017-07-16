

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
	trigger_blizzardGone = "Blizzard fades from you",

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
	-- commands
	bug_name = "Explodierende Käfer",
	bug_desc = "Warnung vor explodierenden Käfern.",

	teleport_name = "Teleport",
	teleport_desc = "Warnung, wenn die Zwillings Imperatoren sich teleportieren.",

	enrage_name = "Wutanfall",
	enrage_desc = "Warnung, wenn die Zwillings Imperatoren wütend werden.",

	heal_name = "Heilung",
	heal_desc = "Warnung, wenn die Zwillings Imperatoren sich heilen.",

    blizzard_name = "Blizzard Warnung",
    blizzard_desc = "Zeigt ein Icon wenn du im Blizzard stehst",

	-- triggers
	trigger_teleport = "wirkt Zwillingsteleport.",
	trigger_enrage = "wird wütend.", -- ? "bekommt 'Wutanfall'"
	trigger_explosion = "bekommt 'Käfer explodieren lassen'",
	trigger_heal1 = "'s Bruder heilen heilt",
	trigger_heal2 = " Bruder heilen heilt",
	trigger_blizzardGain = "Ihr seid von Blizzard betroffen.",
	trigger_blizzardGone = "'Blizzard' schwindet von Euch.",

	trigger_pull1 = "Ihr seid nichts weiter als",
	trigger_pull2 = "Seid bereit in die",
	trigger_pull3 = "Komm Bruder",
	trigger_pull4 = "Um unsere Hallen",
	trigger_pull5 = "Niemand wird",
	trigger_pull6 = "Nun gibt es kein",
	trigger_pull7 = "Sieh Bruder",
	trigger_pull8 = "Wie eine Fliege",
	trigger_pull9 = "Wird euer Untergang",
	trigger_pull10 = "Eure unversch",

	kill_trigger = "Mein Bruder...",

	-- messages
	msg_teleport = "Teleport!",
	msg_teleport5 = "Teleport in ~5 Sekunden!",
	msg_teleport10 = "Teleport in ~10 Sekunden!",
	msg_explosion = "Käfer explodiert!",
	msg_enrage = "Zwillings Imperatoren sind wütend!",
	msg_heal = "Heilung gewirkt!",
	msg_enrage10m = "Wutanfall in 10 Minuten",
	msg_enrage5m = "Wutanfall in 5 Minuten",
	msg_enrage3m = "Wutanfall in 3 Minuten",
	msg_enrage90 = "Wutanfall in 90 Sekunden",
	msg_enrage60 = "Wutanfall in 60 Sekunden",
	msg_enrage30 = "Wutanfall in 30 Sekunden",
	msg_enrage10 = "Wutanfall in 10 Sekunden",

	blizzard_warn = "Lauf aus Blizzard!",

	-- bars
	bar_enrage = "Wutanfall",
	bar_teleport = "Teleport",
} end )
