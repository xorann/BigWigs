------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.bwl.razorgore
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Razorgore",

	-- commands
	mc_cmd = "mindcontrol",
	mc_name = "Mind Control",
	mc_desc = "Announces who gets mind controlled and starts a clickable bar for easy selection.",
	eggs_cmd = "eggs",
	eggs_name = "Eggs",
	eggs_desc = "Does a counter for Black Dragon Eggs destroyed.",
	phase_cmd = "phase",
	phase_name = "Phase",
	phase_desc = "Warn for Phase Change.",
	mobs_cmd = "mobs",
	mobs_name = "First wave",
	mobs_desc = "Shows you when the first wave spawns.",
	orb_cmd = "orb",
	orb_name = "Orb Control",
	orb_desc = "Shows you who is controlling the boss and starts a clickable bar for easy selection.",
	ktm_cmd = "ktm",
	ktm_name = "Phase 2 KTM reset",
	ktm_desc = "Default is to not reset KTM (to avoid spam from too many assistants). Uncheck to reset KTM.\n\n(Requires assistant or higher)",
	fireballvolley_cmd = "fireballvolley",
	fireballvolley_name = "Fireball Volley",
	fireballvolley_desc = "Announces when the boss is casting Fireball Volley.",
	conflagration_cmd = "conflagration",
	conflagration_name = "Conflagration",
	conflagration_desc = "Starts a bar with the duration of the Conflagration.",
	polymorph_cmd = "polymorph",
	polymorph_name = "Greater Polymorph",
	polymorph_desc = "Tells you who got polymorphed by Grethok the Controller and starts a clickable bar for easy selection.",
	icon_cmd = "icon",
	icon_name = "Raid Icon on Mind Control",
	icon_desc = "Place a raid icon on the mind controlled player for the duration of the debuff.\n\n(Requires assistant or higher)",

	-- triggers
	trigger_engage = "Intruders have breached",
	trigger_orbControlOther = "(.+) is afflicted by Mind Exhaustion\.",
	trigger_orbControlYou = "You are afflicted by Mind Exhaustion\.",
	trigger_mindControlOtherGain = "(.+) is afflicted by Dominate Mind\.",
	trigger_mindControlYouGain = "You are afflicted by Dominate Mind\.",
	trigger_mindControlYouGone = "Dominate Mind fades from you\.",
	trigger_mindControlOtherGone = "Dominate Mind fades from (.+)\.",
	trigger_polymorphOtherGain = "(.+) is afflicted by Greater Polymorph\.",
	trigger_polymorphYouGain = "You are afflicted by Greater Polymorph\.",
	trigger_polymorphYouGone = "Greater Polymorph fades from you\.",
	trigger_polymorphOtherGone = "Greater Polymorph fades from (.+)\.",
	trigger_deathYou = "You die\.",
	trigger_deathOther = "(.+) dies\.",
	trigger_egg = "Razorgore the Untamed begins to cast Destroy Egg\.",
	trigger_phase2 = "I'm free! That device shall never torment me again!", --"You'll pay for forcing me to do this.",
	trigger_volley = "Razorgore the Untamed begins to cast Fireball Volley\.",
	trigger_conflagration = "afflicted by Conflagration",
	trigger_destroyEgg1 = "You'll pay for forcing me to do this\.",
	trigger_destroyEgg2 = "Fools! These eggs are more precious than you know!",
	trigger_destoryEgg3 = "No - not another one! I'll have your heads for this atrocity!",

	-- messages
	msg_engage = "Phase 1",
	msg_mobsSoon = "First Wave in 5sec!",
	msg_mindControlOther = "%s is mindcontrolled!",
	msg_mindControlYou = "You are mindcontrolled!",
	msg_polymorphOther = "%s is polymorphed! Dispel!",
	msg_polymorphYou = "You are polymorphed!",
	msg_egg = "%d/30 eggs destroyed!",
	msg_phase2 = "Phase 2", -- there is no clear phase2 trigger
	msg_volley = "Hide!",

	-- bars
	bar_mobs = "First Wave",
	bar_mindControl = "MC: %s",
	bar_polymorph = "Polymorph: %s",
	bar_egg = "Destroy Egg",
	bar_volley = "Fireball Volley",
	bar_conflagration = "Conflagration",
	bar_orb = "Orb control: %s",

	-- misc
}
end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	mc_cmd = "mindcontrol",
	mc_name = "Gedankenkontrolle",
	mc_desc = "Gibt bekannt, die unter Gedankenkontrolle bekommt und beginnt einen anklickbaren Balken f\195\188r einfache Auswahl.",
	eggs_cmd = "eggs",
	eggs_name = "Eier",
	eggs_desc = "Hat ein Z\195\164hler f\195\188r Schwarzes Dracheneier zerst\195\182rt.",
	phase_cmd = "phase",
	phase_name = "Phasen",
	phase_desc = "Verk\195\188ndet den Phasenwechsel des Bosses.",
	mobs_cmd = "mobs",
	mobs_name = "Erste Welle",
	mobs_desc = "Zeigt Ihnen, wann die erste Welle spawnt.",
	orb_cmd = "orb",
	orb_name = "Orb Kontrolle",
	orb_desc = "Zeigt Ihnen, wer ist die Steuerung der Boss und beginnt einen anklickbaren Balken f\195\188r einfache Auswahl.",
	ktm_cmd = "ktm",
	ktm_name = "Phase 2 KTM zur\195\188ckgesetzt",
	ktm_desc = "Standardm\195\164\195\159ig wird KTM nicht zur\195\188ckgesetzt (um Spam von zu vielen Helfer zu vermeiden). Deaktivieren Sie, um KTM zur\195\188ckzusetzen.\n\n(Ben\195\182tigt Schlachtzugleiter oder Assistent)",
	fireballvolley_cmd = "fireballvolley",
	fireballvolley_name = "Feuerballsalve",
	fireballvolley_desc = "Gibt bekannt, wenn der Boss wirft Feuerballsalve.",
	conflagration_cmd = "conflagration",
	conflagration_name = "Gro\195\159brand",
	conflagration_desc = "Startet eine Balken mit der Dauer der Gro\195\159brand.",
	polymorph_cmd = "polymorph",
	polymorph_name = "Gro\195\159e Verwandlung",
	polymorph_desc = "Sagt Ihnen, wer von Grethok den Controller polymorphed habe und startet einen anklickbaren Balken f\195\188r einfache Auswahl.",
	icon_cmd = "icon",
	icon_name = "Schlachtzugsymbol auf die Gedankenkontrolle Spieler",
	icon_desc = "Versetzt eine Schlachtzugsymbol auf der Gedankenkontrolle Spieler.\n\n(Ben\195\182tigt Schlachtzugleiter oder Assistent)",

	-- triggers
	trigger_engage = "Intruders have breached",
	trigger_orbControlOther = "(.+) ist von Gedankenersch\195\182pfung betroffen\.",
	trigger_orbControlYou = "Ihr seid von Gedankenersch\195\182pfung betroffen\.",
	trigger_mindControlOtherGain = "(.+) ist von Gedanken beherrschen betroffen\.",
	trigger_mindControlYouGain = "Ihr seid von Gedanken beherrschen betroffen\.",
	trigger_mindControlYouGone = "'Gedanken beherrschen' schwindet von Euch\.",
	trigger_mindControlOtherGone = "Gedanken beherrschen schwindet von (.+)\.",
	trigger_polymorphOtherGain = "(.+) ist von Gro\195\159e Verwandlung betroffen\.",
	trigger_polymorphYouGain = "Ihr seid von Gro\195\159e Verwandlung betroffen\.",
	trigger_polymorphYouGone = "'Gro\195\159e Verwandlung' schwindet von Euch\.",
	trigger_polymorphOtherGone = "Gro\195\159e Verwandlung schwindet von (.+)\.",
	trigger_deathYou = "Du stirbst\.",
	trigger_deathOther = "(.+) stirbt\.",
	trigger_egg = "Razorgore the Untamed beginnt Ei zerst\195\182ren zu wirken\.",
	trigger_phase2 = "I'm free! That device shall never torment me again!",
	trigger_volley = "Razorgore the Untamed beginnt Feuerballsalve zu wirken\.",
	trigger_conflagration = "von Gro\195\159brand betroffen",
	trigger_destroyEgg1 = "You'll pay for forcing me to do this\.",
	trigger_destroyEgg2 = "Fools! These eggs are more precious than you know!",
	trigger_destoryEgg3 = "No - not another one! I'll have your heads for this atrocity!",

	-- messages
	msg_engage = "Phase 1",
	msg_mobsSoon = "Erste Welle in 5sec!",
	msg_mindControlOther = "%s ist ferngesteuert!",
	msg_mindControlYou = "Du bist ferngesteuert!",
	msg_polymorphOther = "%s ist polymorphed! Entfernt es!",
	msg_polymorphYou = "Du bist polymorphed!",
	msg_egg = "%d/30 Eier zerst\195\182rt!",
	msg_phase2 = "Phase 2",
	msg_volley = "Verstecken!",

	-- bars
	bar_mobs = "Erste Welle",
	bar_mindControl = "Gedankenkontrolle: %s",
	bar_polymorph = "Polymorph: %s",
	bar_egg = "Ei zerst\195\182ren",
	bar_volley = "Feuerballsalve",
	bar_conflagration = "Gro\195\159brand",
	bar_orb = "Orb Kontrolle: %s",

	-- misc
}
end)