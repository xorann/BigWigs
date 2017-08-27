------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.zg.venoxis
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
    cmd                 = "Venoxis",
	
	-- commands
    adds_cmd            = "adds",
    adds_name           = "Dead adds counter",
    adds_desc           = "Announces dead Razzashi Cobras",
	
    renew_cmd           = "renew",
    renew_name          = "Renew Alert",
    renew_desc          = "Warn for Renew",

    holyfire_cmd        = "holyfire",
    holyfire_name       = "Holy Fire Alert",
    holyfire_desc       = "Warn for Holy Fire",

    phase_cmd           = "phase",
    phase_name          = "Phase Notification",
    phase_desc          = "Announces the boss' phase transition",

    announce_cmd        = "whispers",
    announce_name       = "Whisper to people in Poison Clouds",
    announce_desc       = "Sends a whisper to players that stand in poison\n\n(Requires assistant or higher)\n\n(Disclaimer: to avoid spamming whispers, it will only whisper people that actually take damage from the Poison Clouds)",

    enrage_cmd          = "enrage",
    enrage_name         = "Enrage Alert",
    enrage_desc         = "Warn for Enrage",
	
	-- triggers
    trigger_renew                   = "High Priest Venoxis gains Renew\.",
    trigger_renewGone               = "Renew fades from High Priest Venoxis\.",
    trigger_enrage                  = "High Priest Venoxis gains Enrage\.",
    trigger_holyFire                = "High Priest Venoxis begins to cast Holy Fire\.",
    trigger_phase2                  = "Let the coils of hate unfurl!",
    trigger_attack1                 = "High Priest Venoxis attacks",
    trigger_attack2                 = "High Priest Venoxis misses",
    trigger_attack3                 = "High Priest Venoxis hits",
    trigger_attack4                 = "High Priest Venoxis crits",
    trigger_poisonCloud             = "Poison Cloud",
    trigger_poisonCloudYouHit      	= "You suffer (.+) Nature damage from High Priest Venoxis 's Poison Cloud.",
    trigger_poisonCloudOtherHit    	= "(.+) suffers (.+) Nature damage from High Priest Venoxis 's Poison Cloud.",
    trigger_poisonCloudYou          = "You are afflicted by Poison Cloud.",
    trigger_poisonCloudYouAbsorb    = "You absorb High Priest Venoxis 's Poison Cloud\.",
    trigger_poisonCloudOtherAbsorb  = "High Priest Venoxis 's Poison Cloud is absorbed by (.+)\.",
    trigger_poisonCloudYouResist    = "High Priest Venoxis 's Poison Cloud was resisted\.",
    trigger_poisonCloudOtherResist  = "High Priest Venoxis 's Poison Cloud was resisted by (.+)\.",
    trigger_poisonCloudYouImmune    = "High Priest Venoxis 's Poison Cloud failed. You are immune\.",
    trigger_poisonCloudOtherImmune  = "High Priest Venoxis 's Poison Cloud fails. (.+) is immune\.",
    trigger_addDeath                = "Razzashi Cobra dies",
    trigger_bossDeath               = "High Priest Venoxis dies",
	
	-- messages
    msg_renew       	= "Renew! Dispel it!",
    msg_phase1      	= "Troll Phase",
    msg_phase2      	= "Snake Phase",
    msg_enrage      	= "Boss is enraged! Spam heals!",
    msg_poisonYou   	= "Move away from poison cloud!",
    msg_poisonWhisper   = "Move away from poison cloud!",
    msg_adds            = "%d/4 Razzashi Cobras dead!",
	
	-- bars
    bar_holyFire        = "Holy Fire",
    bar_renew           = "Renew",
	
	-- misc
    misc_addName        = "Razzashi Cobra",
    misc_you            = "you",
	
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	adds_name = "Zähler für tote Adds",
	adds_desc = "Verkündet Razzashi Cobras Tod",
	
	renew_name = "Alarm für Erneuerung",
	renew_desc = "Warnung, wenn Venoxis Erneuerung auf sich wirkt",

	holyfire_name = "Alarm für Heiliges Feuer",
	holyfire_desc = "Warnen, wenn Heiliges Feuer gewirkt wird",

	phase_name = "Phasen-Benachrichtigung",
	phase_desc = "Verkündet den Phasenwechsel des Bosses",

	announce_name = "Brennenden Personen flüstern",
	announce_desc = "Flüster der Person, die im Giftwolken steht\n\n(Benötigt Schlachtzugleiter oder Assistent)\n\n(Warnung: um überflüssiges Flüstern zu vermeiden, wird es nur den Personen flüstern, die tatsächlichen Schaden von den Giftwolken bekommen.)",

	enrage_name = "Verkündet Boss' Raserei",
	enrage_desc = "Lässt dich wissen, wenn Boss härter zuschlägt",
	
	-- triggers
	trigger_renew = "High Priest Venoxis bekommt 'Erneuerung",
	trigger_renewGone = "Erneuerung schwindet von High Priest Venoxis\.",
	trigger_enrage = "High Priest Venoxis bekommt \'Wutanfall",
	trigger_holyFire = "High Priest Venoxis beginnt Heiliges Feuer zu wirken\.",
	trigger_phase2 = "Let the coils of hate unfurl!",
	trigger_attack1 = "High Priest Venoxis greift an",
	trigger_attack2 = "High Priest Venoxis verfehlt",
	trigger_attack3 = "High Priest Venoxis trifft",
	trigger_attack4 = "High Priest Venoxis trifft (.+) kritisch",
	trigger_poisonCloud = "Giftwolke",
	trigger_poisonCloudYouHit = "Ihr erleidet (.+) Naturschaden von High Priest Venoxis (durch Giftwolke)\.",
	trigger_poisonCloudOtherHit = "(.+) erleidet (.+) Naturschaden von High Priest Venoxis (durch Giftwolke)\.",
    trigger_poisonCloudYou              = "You are afflicted by Poison Cloud.",
	trigger_poisonCloudYouAbsorb = "Ihr absorbiert High Priest Venoxiss Giftwolke\.",
	trigger_poisonCloudOtherAbsorb = "Giftwolke von High Priest Venoxis wird absorbiert von\: (.+)\.",
	trigger_poisonCloudYouResist = "High Priest Venoxis versucht es mit Giftwolke\.\.\. widerstanden\.",
	trigger_poisonCloudOtherResist = "High Priest Venoxiss Giftwolke wurde von (.+) widerstanden\.",
	trigger_poisonCloudYouImmune = "High Priest Venoxis versucht es mit Giftwolke\.\.\. ein Fehlschlag. Ihr seid immun\.",
	trigger_poisonCloudOtherImmune = "High Priest Venoxis versucht es mit Giftwolke. Ein Fehlschlag, denn (.+) ist immun\.",
	trigger_addDeath = "Razzashi Cobra stirbt",
	trigger_bossDeath = "High Priest Venoxis stirbt",
	
	-- messages
	msg_renew = "Erneuerung! Entferne magie!",
	msg_phase1 = "Troll-Phase",
	msg_phase2 = "Schlange-Phase",
	msg_enrage = "Boss ist in Raserei! Spam Heilung!",
	msg_poisonYou = "Beweg\' dich aus dem Giftwolke!",
	msg_poisonWhisper = "Move away from poison cloud!",
	msg_adds = "%d/4 Razzashi Cobra tot!",
	
	-- bars
	bar_holyFire = "Heiliges Feuer",
	bar_renew = "Erneuerung",
	
	-- misc
	misc_addName = "Razzashi Cobra",
	misc_you = "Ihr",
	
} end )
