------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.zg.jeklik
local L = BigWigs.i18n[bossName]


L:RegisterTranslations("enUS", function() return {
	cmd = "Jeklik",

	-- commands
	phase_cmd = "phase",
	phase_name = "Phase Notification",
	phase_desc = "Announces the boss' phase transition",

	heal_cmd = "heal",
	heal_name = "Heal Alert",
	heal_desc = "Warn for healing",

	flay_cmd = "flay",
	flay_name = "Mind Flay Alert",
	flay_desc = "Warn for casting Mind Flay",

	fear_cmd = "fear",
	fear_name = "Fear Alert",
	fear_desc = "Warn for boss' fear\n\n(Disclaimer: timers vary a lot, usually fear will happen within 10s after the fear bar ends)",

	bomb_cmd = "bomb",
	bomb_name = "Bomb Bat Alert",
	bomb_desc = "Warn for Bomb Bats",

	swarm_cmd = "swarm",
	swarm_name = "Bat Swarm Alert",
	swarm_desc = "Warn for Bat swarms",
    swarm_bartext = "Bat Swarm",

	announce_cmd = "whispers",
	announce_name = "Whisper to burning people",
	announce_desc = "Sends a whisper to players that stand in fire\n\n(Requires assistant or higher)\n\n(Disclaimer: to avoid spamming whispers, it will only whisper people that take damage from fire that is on the ground - aka not the Bat's throw itself)",
	
	-- triggers
	trigger_engage = "grant me wings of v",
	trigger_swarm = "Bloodseeker Bat gains Hover\.",
	trigger_bomb = "Frenzied Bloodseeker Bat gains Hover\.",
	trigger_fearHit = "afflicted by Terrifying Screech",
	trigger_fearResist = "s Terrifying Screech was resisted",
	trigger_fearImmune = "Terrifying Screech fail(.+) immune",
	trigger_fearHit2 = "afflicted by Psychic Scream",
	trigger_fearResist2 = "s Psychic Scream was resisted",
	trigger_fearImmune2 = "Psychic Scream fail(.+) immune",
	trigger_attack1 = "High Priestess Jeklik attacks",
	trigger_attack2 = "High Priestess Jeklik misses",
	trigger_attack3 = "High Priestess Jeklik hits",
	trigger_attack4 = "High Priestess Jeklik crits",
	trigger_liquidFire = "Liquid Fire",
	trigger_liquidFireYouHit = "Throw Liquid Fire hits you for",
	trigger_liquidFireOtherHit = "Liquid Fire 's Blaze hits (.+) for",
	trigger_liquidFireYouAbsorb = "You absorb Liquid Fire 's Blaze\.",
	trigger_liquidFireOtherAbsorb = "Liquid Fire 's Blaze is absorbed by (.+)\.",
	trigger_liquidFireYouResist = "Liquid Fire 's Blaze was resisted\.",
	trigger_liquidFireOtherResist = "Liquid Fire 's Blaze was resisted by (.+)\.",
	trigger_liquidFireYouImmune = "Liquid Fire 's Blaze failed. You are immune\.",
	trigger_liquidFireOtherImmune = "Liquid Fire 's Blaze fails. (.+) is immune\.",
	trigger_mindFlayYouGain = "You are afflicted by Mind Flay\.",
	trigger_mindFlayOtherGain = "(.+) is afflicted by Mind Flay\.",
	trigger_mindFlayYouGone = "Mind Flay fades from you\.",
	trigger_mindFlayOtherGone = "Mind Flay fades from (.+)\.",
	trigger_phaseTwo = "Hover fades from High Priestess Jeklik\.",
	trigger_heal = "High Priestess Jeklik begins to cast Great Heal\.",
	
	-- messages
	msg_swarm = "Incoming bat swarm! Kill them!",
	msg_bomb = "A bomb bat joins the fight! Watch where you stand!",
	msg_heal = "Heal! Interrupt it!",
	msg_phaseOne = "Bat Phase",
	msg_phaseTwo = "Troll Phase",
	msg_fireWhisper = "Move away from fire!",
	msg_fireYou = "Move away from fire!",
	
	-- bars
	bar_fear = "Possible Fear",
	bar_mindFlay = "Mind Flay",
	bar_heal = "Heal",
	
	-- misc
	misc_swarmBarName = "Bloodseeker Bat",
	misc_bombBatName = "Frenzied Bloodseeker Bat",
	misc_you = "you",

} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	phase_name = "Phasen-Benachrichtigung",
	phase_desc = "Verkündet den Phasenwechsel des Bosses",

	heal_name = "Alarm für Heilung",
	heal_desc = "Warnen, wenn Jeklik versucht sich zu heilen",

	flay_name = "Alarm für Gedankenschinden",
	flay_desc = "Warnen, wenn Gedankenschinden gewirkt wird",

	fear_name = "Alarm für Furcht",
	fear_desc = "Warnen, wenn Boss Furcht wirkt.\n\n(Warnung: Timers variieren sehr, normalerweise wird Furcht innerhalb 10 Sekunden passieren, nachdem der Furcht-Balken endet)",

	bomb_name = "Alarm für Bomber-Fledermäuse",
	bomb_desc = "Warnen vor Bomber-Fledermäuse.",

	swarm_name = "Alarm f\195\188r Fledermausschwärme",
	swarm_desc = "Warnen vor Fledermausschwärme.",
    swarm_bartext = "Fledermausschwarm",

	announce_name = "Brennenden Personen flüstern",
	announce_desc = "Flüster der Person, die im Feuer steht\n\n(Benötigt Schlachtzugleiter oder Assistent)\n\n(Warnung: to avoid spamming whispers, it will only whisper people that take damage from fire that is on the ground - aka not the Bat's throw itself)",
	
	-- triggers
    trigger_engage = "grant me wings of v",
	trigger_swarm = "Bloodseeker Bat bekommt \'Schweben\'\.",
	trigger_bomb = "Frenzied Bloodseeker Bat bekommt \'Schweben\'\.",
	trigger_fearHit = "von Schreckliches Kreischen betroffen",
	trigger_fearResist = "Schreckliches Kreischen(.+) widerstanden",
	trigger_fearImmune = "Schreckliches Kreischen(.+) immun",
	trigger_fearHit2 = "von Psychischer Schrei betroffen",
	trigger_fearResist2 = "Psychischer Schrei(.+) widerstanden",
	trigger_fearImmune2 = "Psychischer Schrei(.+) immun",
	trigger_attack1 = "High Priestess Jeklik greift an",
	trigger_attack2 = "High Priestess Jeklik verfehlt",
	trigger_attack3 = "High Priestess Jeklik trifft",
	trigger_attack4 = "High Priestess Jeklik trifft (.+) kritisch",
	trigger_liquidFire = "Liquid Fire",
	trigger_liquidFireYouHit = "Liquid Fire trifft Euch mit \'Feuermeer'",
	trigger_liquidFireOtherHit = "Liquid Fires Feuermeer trifft (.+) f",
	trigger_liquidFireYouAbsorb = "Ihr absorbiert Liquid Fires Feuermeer",
	trigger_liquidFireOtherAbsorb = "Feuermeer von Liquid Fire wird absorbiert von\: (.+)\.",
	trigger_liquidFireYouResist = "Liquid Fire versucht es mit Feuermeer\.\.\. widerstanden\.",
	trigger_liquidFireOtherResist = "Liquid Fires Feuermeer wurde von (.+) widerstanden\.",
	trigger_liquidFireYouImmune = "Liquid Fire versucht es mit Feuermeer\.\.\. ein Fehlschlag. Ihr seid immun\.",
	trigger_liquidFireOtherImmune = "Liquid Fire versucht es mit Feuermeer. Ein Fehlschlag, denn (.+) ist immun\.",
	trigger_mindFlayYouGain = "Ihr seid von Gedankenschinden betroffen.",
	trigger_mindFlayOtherGain = "(.+) ist von Gedankenschinden betroffen.",
	trigger_mindFlayYouGone = "\'Gedankenschinden\' schwindet von Euch\.",
	trigger_mindFlayOtherGone = "Gedankenschinden schwindet von (.+)\.",
	trigger_phaseTwo = "Schweben schwindet von High Priestess Jeklik\.",
	trigger_heal = "High Priestess Jeklik beginnt Gro\195\159e Heilung zu wirken\.",
	
	-- messages
	msg_swarm = "Fledermausschwarm jetzt! Töte sie!",
	msg_bomb = "Eine Bomber-Fledermaus erscheint zum Kampf! Pass auf, wo du stehst!",
	msg_heal = "Heilung! Unterbreche sie!",
	msg_phaseOne = "Fledermaus-Phase",
	msg_phaseTwo = "Troll-Phase",
	msg_fireWhisper = "Move from fire!",
	msg_fireYou = "Beweg\' dich aus dem Feuer!",
	
	-- bars
	bar_fear = "Mögliche Furcht",
	bar_mindFlay = "Gedankenschinden",
	bar_heal = "Heilung",
	
	-- misc
	misc_swarmBarName = "Bloodseeker Bat",
	misc_bombBatName = "Frenzied Bloodseeker Bat",
	misc_you = "Euch"
	
} end )