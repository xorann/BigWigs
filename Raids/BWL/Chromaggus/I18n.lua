------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.bwl.chromaggus
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Chromaggus",

	-- commands
	enrage_cmd = "enrage",
	enrage_name = "Enrage",
	enrage_desc = "Warn before the Enrage phase at 20%.",

	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy",
	frenzy_desc = "Warn for Frenzy.",

	breath_cmd = "breath",
	breath_name = "Breaths",
	breath_desc = "Warn for Breaths.",
    
    breathcd_cmd = "breathcd",
    breathcd_name = "Breath Voice Countdown",
    breathcd_desc = "Voice warning for the Breaths.",
            
	vulnerability_cmd = "vulnerability",
	vulnerability_name = "Vulnerability",
	vulnerability_desc = "Warn for Vulnerability changes.",
	
	-- triggers
	trigger_breath = "Chromaggus begins to cast (.+)\.",
	trigger_vulnerability_direct_crit = "^[%w]+[%s's]* ([%w%s:]+) crits Chromaggus for ([%d]+) ([%w]+) damage%.[%s%(]*([%d]*)", -- [Fashu's] [Firebolt] [hits] Battleguard Sartura for [44] [Fire] damage. ([14] resisted)
	trigger_vulnerability_direct_hit = "^[%w]+[%s's]* ([%w%s:]+) hits Chromaggus for ([%d]+) ([%w]+) damage%.[%s%(]*([%d]*)", -- [Fashu's] [Firebolt] [hits] Battleguard Sartura for [44] [Fire] damage. ([14] resisted)
	trigger_vulnerability_dot = "^Chromaggus suffers ([%d]+) ([%w]+) damage from [%w]+[%s's]* ([%w%s:]+)%.[%s%(]*([%d]*)",
	trigger_frenzy = "goes into a killing frenzy",
	trigger_frenzyGone = "Frenzy fades from Chromaggus\.",
	trigger_vulnerability = "flinches as its skin shimmers.",
	
	-- messages
	msg_breathUnknown = "Breath in 5 seconds!",
	msg_breathSoon = "%s in 5 seconds!",
	msg_breath = "%s is casting!",
	msg_vulnerability = "Vulnerability: %s!",
	msg_vulnerabilityChanged = "Spell vulnerability changed!",
	msg_frenzy = "Frenzy! TRANQ NOW!",
	msg_enrage = "Enrage soon!",
	
	-- bars
	bar_breathCast = "Cast %s",
	bar_frenzy = "Frenzy",
    bar_frenzyNext = "Next Frenzy",
	bar_breathFirst = "First Breath",
	bar_breathSecond = "Second Breath",
    bar_vulnerability = "%s Vulnerability",
	
	-- misc
	hit = "hits",
	crit = "crits",

	breath1 = "Time Lapse",
	breath2 = "Corrosive Acid",
	breath3 = "Ignite Flesh",
	breath4 = "Incinerate",
	breath5 = "Frost Burn",
	
	breathcolor1 = "black",
	breathcolor2 = "green",
	breathcolor3 = "orange",
	breathcolor4 = "red",
	breathcolor5 = "blue",

	icon1 = "Spell_Arcane_PortalOrgrimmar",
	icon2 = "Spell_Nature_Acid_01",
	icon3 = "Spell_Fire_Fire",
	icon4 = "Spell_Shadow_ChillTouch",
	icon5 = "Spell_Frost_ChillingBlast",

	fire = "Fire",
	frost = "Frost",
	shadow = "Shadow",
	nature = "Nature",
	arcane = "Arcane",
	
	curseofdoom = "Curse of Doom",
	ignite = "Ignite",
	starfire = "Starfire",
	thunderfury = "Thunderfury",
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	enrage_name = "Wutanfall",
	enrage_desc = "Warnung, wenn Chromaggus w\195\188tend wird (ab 20%).",

	frenzy_name = "Raserei",
	frenzy_desc = "Warnung, wenn Chromaggus in Raserei ger\195\164t.",

	breath_name = "Atem",
	breath_desc = "Warnung, wenn Chromaggus seinen Atem wirkt.",

	vulnerability_name = "Zauber-Verwundbarkeiten",
	vulnerability_desc = "Warnung, wenn Chromagguss Zauber-Verwundbarkeit sich \195\164ndert.",
	
	-- triggers
	trigger_breath = "^Chromaggus beginnt (.+) zu wirken\.",
	trigger_vulnerability_direct_crit = "^(.+) trifft Chromaggus kritisch für ([%d]+) ([%w]+)schaden+%.[%s%(]*([%d]*)", --<name> hits <enemy> critically for <x> damage.
	trigger_vulnerability_direct_hit = "^(.+) trifft Chromaggus für ([%d]+) ([%w]+)schaden+%.[%s%(]*([%d]*)",
	trigger_vulnerability_dot = "^Chromaggus erleidet ([%d]+) ([%w]+)schaden[%svon]*[%s%w]* %(durch ([%w%s:]+)%)%.[%s%(]*([%d]*)",
	trigger_frenzy = "Chromaggus wird mörderisch wahnsinnig!",
	trigger_frenzyGone = "Raserei schwindet von Chromaggus\.",
	trigger_vulnerability = "Chromaggus weicht zurück, als die Haut schimmert.",
	
	-- messages
	msg_breathUnknown = "Atem in 5 Sekunden!",
	msg_breathSoon = "%s in 5 Sekunden!",
	msg_breath = "Chromaggus wirkt: %s Atem!",
	msg_vulnerability = "Zauber-Verwundbarkeit: %s",
	msg_vulnerabilityChanged = "Zauber-Verwundbarkeit ge\195\164ndert!",
	msg_frenzy = "Raserei - Einlullender Schuss!",
	msg_enrage = "Wutanfall steht kurz bevor!",
	
	-- bars
	bar_breathCast = "Wirkt %s",
	bar_frenzy = "Raserei",
    bar_frenzyNext = "Nächste Raserei",
	bar_breathFirst = "Erster Atem",
	bar_breathSecond = "Zweite Atem",
    bar_vulnerability = "%s Verwundbarkeit",
	
	-- misc
	hit = "trifft",
	crit = "kritisch",

	breath1 = "Zeitraffer",
	breath2 = "\195\132tzende S\195\164ure",
	breath3 = "Fleisch entz\195\188nden",
	breath4 = "Verbrennen",
	breath5 = "Frostbeulen",

	breathcolor1 = "black",
	breathcolor2 = "green",
	breathcolor3 = "orange",
	breathcolor4 = "red",
	breathcolor5 = "blue",

	icon1 = "Spell_Arcane_PortalOrgrimmar",
	icon2 = "Spell_Nature_Acid_01",
	icon3 = "Spell_Fire_Fire",
	icon4 = "Spell_Shadow_ChillTouch",
	icon5 = "Spell_Frost_ChillingBlast",

	fire = "Feuer",
	frost = "Frost",
	shadow = "Schatten",
	nature = "Natur",
	arcane = "Arkan",
	
	curseofdoom = "Fluch der Verdammnis",
	ignite = "Entz\195\188nden",
	starfire = "Sternenfeuer",
	thunderfury = "Zorn der Winde",
} end )
