------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.zg.mandokir
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Mandokir",
	
	-- commands
	announce_cmd = "whispers",
	announce_name = "Whisper watched players",
	announce_desc = "Warn when boss uses Threatening Gaze.\n\n(Requires assistant or higher)",

	puticon_cmd = "puticon",
	puticon_name = "Raid icon on watched players",
	puticon_desc = "Place a raid icon on the watched person.\n\n(Requires assistant or higher)",
	
	gaze_cmd = "gaze",
	gaze_name = "Threatening Gaze alert",
	gaze_desc = "Shows bars for Threatening Gaze",

	whirlwind_cmd = "whirlwind",
	whirlwind_name = "Whirlwind Alert",
	whirlwind_desc = "Shows Whirlwind bars",

	enraged_cmd = "enraged",
	enraged_name = "Enrage alert",
	enraged_desc = "Announces the boss' Enrage",
	
	-- triggers
	trigger_engage = "feed your souls to Hakkar himself",
	trigger_watch = "(.+)! I'm watching you!",
	trigger_gazeCast = "Bloodlord Mandokir begins to cast Threatening Gaze.",
	trigger_gazeYouGain = "You are afflicted by Threatening Gaze.",
	trigger_gazeOtherGain = "(.+) is afflicted by Threatening Gaze.",
	trigger_gazeYouGone = "Threatening Gaze fades from you.",
	trigger_gazeOtherGone = "Threatening Gaze fades from (.+).",
	trigger_enrageGain = "Bloodlord Mandokir gains Enrage.",
	trigger_enrageFade = "Enrage fades from Bloodlord Mandokir.",
	trigger_whirlwindGain = "Bloodlord Mandokir gains Whirlwind.",
	trigger_whirlwindGone = "Whirlwind fades from Bloodlord Mandokir.",
	trigger_deathYou = "You die.",
	trigger_deathOther = "(.+) dies.",
	
	-- messages
	msg_watchYou = "You are being watched! Stop everything!",
	msg_watchWhisper = "You are being watched! Stop everything!",
	msg_watchOther = "%s is being watched!",
	msg_enrage = "Ohgan down! Mandokir enraged!",	
	
	-- bars
    bar_gazeCast = "Incoming Threatening Gaze!",
	bar_watch = "Threatening Gaze: %s",
	bar_enrage = "Enrage",
	bar_whirlwind = "Whirlwind",
	
	-- misc
	misc_ohgan = "Ohgan",
	misc_you = "you",
	
    ["Possible Gaze"] = true,
	
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	announce_name = "Warnung, wenn Spieler beobachtet werden",
	announce_desc = "Warnen, wenn Bloodlord Mandokir wirft Bedrohlicher Blick\n\n(Benötigt Schlachtzugleiter oder Assistent)",

	puticon_name = "Schlachtzugsymbol auf die beobachtet Spieler",
	puticon_desc = "Versetzt eine Schlachtzugsymbol auf der beobachteten Spieler.\n\n(Benötigt Schlachtzugleiter oder Assistent)",
	
	gaze_name = "Alarm für Bedrohlicher Blick",
	gaze_desc = "Zeigt Balken für Bedrohlicher Blick",

	whirlwind_name = "Alarm für Wirbelwind",
	whirlwind_desc = "Zeigt Balken für Wirbelwind",

	enraged_name = "Verkündet Boss' Raserei",
	enraged_desc = "Lässt dich wissen, wenn Boss härter zuschlägt",
	
	-- triggers
    trigger_engage = "feed your souls to Hakkar himself",
	trigger_watch = "(.+)! I'm watching you!",
	trigger_gazeCast = "Bloodlord Mandokir beginnt Bedrohlicher Blick zu wirken.",
	trigger_gazeYouGain = "Ihr seid von Bedrohlicher Blick betroffen.",
	trigger_gazeOtherGain = "(.+) ist von Bedrohlicher Blick betroffen.",
	trigger_gazeYouGone = "'Bedrohlicher Blick' schwindet von Euch.",
	trigger_gazeOtherGone = "Bedrohlicher Blick schwindet von (.+).",
	trigger_enrageGain = "Bloodlord Mandokir bekommt 'Wutanfall'.",
	trigger_enrageFade = "Wutanfall schwindet von Bloodlord Mandokir.",
	trigger_whirlwindGain = "Bloodlord Mandokir bekommt 'Wirbelwind'.",
	trigger_whirlwindGone = "Wirbelwind schwindet von Bloodlord Mandokir\.",
	trigger_deathYou = "Du stirbst.",
	trigger_deathOther = "(.+) stirbt.",
	
	-- messages
	msg_watchYou = "Du wirst beobachtet! Stoppen Sie alles!",
	msg_watchWhisper = "You are being watched! Stop everything!",
	msg_watchOther = "%s wird beobachtet!",
	msg_enrage = "Ohgan ist tot! Mandokir wütend!",	
	
	-- bars
    bar_gazeCast = "Bedrohlicher Blick kommt!",
	bar_watch = "Bedrohlicher Blick: %s",
	bar_enrage = "Wutanfall",
	bar_whirlwind = "Wirbelwind",
	
	-- misc
	misc_ohgan = "Ohgan",
	misc_you = "Euch",
	
    ["Possible Gaze"] = "Mögliches Starren"
	
} end )
