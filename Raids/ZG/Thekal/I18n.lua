------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.zg.thekal
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Thekal",

	-- commands
	heal_cmd = "heal",
	heal_name = "Heal alert",
	heal_desc = "Warn for Lor'Khan's heals.",

	bloodlust_cmd = "bloodlust",
	bloodlust_name = "Bloodlust alert",
	bloodlust_desc = "Announces which boss gets Bloodlust, for easy dispel announce.",
	
	silence_cmd = "silence",
	silence_name = "Silence",
	silence_desc = "Shows you who gets silenced.",
	
	disarm_cmd = "disarm",
	disarm_name = "Disarm",
	disarm_desc = "Warn for Zealot Lor'Khan's disarm.",
	
	cleave_cmd = "cleave",
	cleave_name = "Mortal Cleave notifications",
	cleave_desc = "Shows who has Mortal Strike-type debuff.",
	
	punch_cmd = "punch",
	punch_name = "Force Punch alert",
	punch_desc = "JUMP!",
	
	tigers_cmd = "tigers",
	tigers_name = "Tiger spawns",
	tigers_desc = "Warn for incoming tigers.",
	
	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy announce",
	frenzy_desc = "Warn when High Priest Thekal goes into a frenzy.",
	
	enraged_cmd = "enraged",
	enraged_name = "Enrage alert",
	enraged_desc = "Lets you know when the boss is enraged.",
	
	phase_cmd = "phase",
	phase_name = "Phase notification",
	phase_desc = "Announces the boss' phase transitions.",
	
	-- triggers
    trigger_phase2 = "fill me with your RAGE!",
	trigger_tigers = "High Priest Thekal performs Summon Zulian Guardians.",
	trigger_forcepunch = "High Priest Thekal begins to perform Force Punch.",
	trigger_heal = "Zealot Lor'Khan begins to cast Great Heal.",
	trigger_enrage = "High Priest Thekal gains Enrage\.",
	trigger_disarmYou = "You are afflicted by Disarm.",
	trigger_disarmOther = "(.+) is afflicted by Disarm.",
	trigger_mortalCleaveYou = "You are afflicted by Mortal Cleave.",
	trigger_mortalCleaveOther = "(.+) is afflicted by Mortal Cleave.",
	trigger_silenceYou = "You are afflicted by Silence.",
	trigger_silenceOther = "(.+) is afflicted by Silence.",
	trigger_silenceYouGone = "Silence fades from you.",
	trigger_silenceOtherGone = "Silence fades from (.+).",
	trigger_bloodlustGain = "(.+) gains Bloodlust.",
	trigger_bloodlustGone = "Bloodlust fades from (.+).",
	trigger_frenzyGain = "High Priest Thekal gains Frenzy.",
	trigger_frenzyGone = "Frenzy fades from High Priest Thekal.",
	trigger_death = "dies.",
	trigger_zath = "Zealot Zath",
	trigger_lorkhan = "Zealot Lor'Khan",
	trigger_thekal = "High Priest Thekal",
	trigger_resurrectionThekal = "High Priest Thekal begins to cast Resurrection.",
	trigger_resurrectionZath = "Zealot Zath begins to cast Resurrection.",
	trigger_resurrectionLorkhan = "Zealot Lor'Khan begins to cast Resurrection.",
	
	-- messages
	msg_phase1 = "Troll Phase",
	msg_phase2 = "Tiger Phase",
	msg_enrage = "Boss is enraged! Spam heals!",
	msg_tigers = "Incoming Tigers!",
	msg_heal = "Zealot Lor'Khan is Healing! Interrupt it!",
	msg_silence = "Silence on %s! Dispel it!",
	msg_bloodlust = "Dispel Bloodlust from %s!",
	msg_frenzy = "Frenzy! Tranq now!",
	
	-- bars
    bar_phase2 = "Tiger Phase",
	bar_forcePunch = "Force Punch",
	bar_heal = "Great Heal",
	bar_mortalCleave = "Mortal Cleave: %s",
	bar_silence = "Silence: %s",
	bar_disarm = "Disarm: %s",
	bar_bloodlust = "Bloodlust: %s",
	bar_frenzy = "Frenzy",
	
	-- misc
	misc_rogueName = "Zealot Zath",
	misc_shamanName = "Zealot Lor'Khan",
	
    ["You have slain %s!"] = true,
    ["Knockback"] = true,
    ["New Adds"] = true,
    ["Next Bloodlust"] = true,
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	heal_name = "Heilungs Warnung",
	heal_desc = "Warnt vor Lor'Khan's Gro\195\159e Heilung.",

	bloodlust_name = "Kampfrausch",
	bloodlust_desc = "Kündigt an, wenn der Boss Kampfrausch hat, zum einfachen entfernen.",
	
	silence_name = "Stille",
	silence_desc = "Zeigt an wer Stille hat.",
	
	disarm_name = "Entwaffnen",
	disarm_desc = "Warnt vor Zealot Lor'Khan's entwaffnen.",
	
	cleave_name = "Benachrichtigung für Tödliches Spalten",
	cleave_desc = "Zeigt wer den Tödlichen Schlag Effekt auf sich hat.",
	
	punch_name = "Machthieb Warnung",
	punch_desc = "SPRING!",
	
	tigers_name = "Tiger spawns",
	tigers_desc = "Warnt vor ankommenden Tigern.",
	
	frenzy_name = "Alarm für Raserei",
	frenzy_desc = "Warnung, wenn High Priest Thekal in Raserei gerät.",
	
	enraged_name = "Verkündet Boss' Raserei",
	enraged_desc = "Lässt dich wissen, wenn Boss härter zuschlägt.",
	
	phase_name = "Phasen-Benachrichtigung",
	phase_desc = "Verkündet den Phasenwechsel des Bosses.",
	
	-- triggers
    trigger_phase2 = "fill me with your RAGE!",
	trigger_tigers = "High Priest Thekal führt Zulianische Wächter beschwören aus\.",
	trigger_forcepunch = "High Priest Thekal beginnt Machthieb auszuführen\.",
	trigger_heal = "Zealot Lor\'Khan beginnt Gro\195\159e Heilung\.",
	trigger_enrage = "High Priest Thekal bekommt \'Wutanfall\'\.",
	trigger_disarmYou = "Ihr seid von Entwaffnen betroffen\.",
	trigger_disarmOther = "(.+) ist von Entwaffnen betroffen\.",
	trigger_mortalCleaveYou = "Ihr seid von Tödliches Spalten betroffen\.",
	trigger_mortalCleaveOther = "(.+) ist von Tödliches Spalten betroffen\.",
	trigger_silenceYou = "Ihr seid von Stille betroffen\.",
	trigger_silenceOther = "(.+) ist von Stille betroffen\.",
	trigger_silenceYouGone = "\'Stille\' schwindet von Euch\.",
	trigger_silenceOtherGone = "Stille schwindet von (.+)\.",
	trigger_bloodlustGain = "(.+) bekommt \'Kampfrausch\'\.",
	trigger_bloodlustGone = "Kampfrausch schwindet von (.+)\.",
	trigger_frenzyGain = "High Priest Thekal bekommt \'Raserei\'\.",
	trigger_frenzyGone = "Raserei schwindet von High Priest Thekal\.",
	trigger_death = "dies\.",
	trigger_zath = "Zealot Zath",
	trigger_lorkhan = "Zealot Lor\'Khan",
	trigger_thekal = "High Priest Thekal",
	trigger_resurrectionThekal = "High Priest Thekal beginnt Auferstehung zu wirken\.",
	trigger_resurrectionZath = "Zealot Zath beginnt Auferstehung zu wirken\.",
	trigger_resurrectionLorkhan = "Zealot Lor\'Khan beginnt Auferstehung zu wirken\.",
	
	-- messages
	msg_phase1 = "Troll Phase",
	msg_phase2 = "Tiger Phase",
	msg_enrage = "Boss ist Wütend! Verwendet gro\195\159e Heilung!",
	msg_tigers = "Tiger kommen!",
	msg_heal = "Zealot Lor'Khan heilt! Unterbrecht es!",
	msg_silence = "Stille auf %s! Entfernt es!",
	msg_bloodlust = "Entfernt Kampfrausch von %s\!",
	msg_frenzy = "Raserei! Tranq jetzt!",
	
	-- bars
	bar_forcePunch = "Machthieb",
	bar_heal = "Gro\195\159e Heilung",
    bar_phase2 = "Tiger Phase",
	bar_mortalCleave = "Tödliches Spalten: %s",
	bar_silence = "Stille: %s",
	bar_disarm = "Entwaffnen: %s",
	bar_bloodlust = "Kampfrausch: %s",
	bar_frenzy = "Raserei",
	
	-- misc
	misc_rogueName = "Zealot Zath",
	misc_shamanName = "Zealot Lor\'Khan",
	
    ["You have slain %s!"] = "Ihr habt %s getötet!",
    ["Knockback"] = "Rückschlag",
    ["New Adds"] = "Neue Tiger",
    ["Next Bloodlust"] = "Nächster Blutrausch",
	
} end )
