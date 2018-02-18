------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.aq40.cthun
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Cthun",

	-- commands
	tentacle_cmd = "tentacle",
	tentacle_name = "Tentacle Alert",
	tentacle_desc = "Warn for Tentacles",
	glare_cmd = "glare",
	glare_name = "Dark Glare Alert",
	glare_desc = "Warn for Dark Glare",
	group_cmd = "group",
	group_name = "Dark Glare Group Warning",
	group_desc = "Warn for Dark Glare on Group X",
	giant_cmd = "giant",
	giant_name = "Giant Eye Alert",
	giant_desc = "Warn for Giant Eyes",
	weakened_cmd = "weakened",
	weakened_name = "Weakened Alert",
	weakened_desc = "Warn for Weakened State",
	acid_cmd = "acid",
	acid_name = "Digestive Acid alert",
	acid_desc = "Shows a warning sign when you have 5 stacks of digestive acid",
	proximity_cmd = "proximity",
	proximity_name = "Proximity Warning",
	proximity_desc = "Show Proximity Warning Frame",
	fleshtentacle_cmd = "fleshtentacle",
	fleshtentacle_name = "Flesh Tentacle",
	fleshtentacle_desc = "Healthbars of both Flesh tentacles",

	-- triggers
	trigger_eyeBeamGiantEye = "Giant Eye Tentacle begins to cast Eye Beam.",
	trigger_eyeBeamCthun = "Eye of C'Thun begins to cast Eye Beam.",
	trigger_giantClawSpawn = "Giant Claw Tentacle 's Ground Rupture",
	trigger_giantEyeSpawn = "Giant Eye Tentacle 's Ground Rupture",
	trigger_tentacleParty = "^Eye Tentacle's Ground Rupture hits (.+) for (.+)$", -- "Eye Tentacle's Ground Rupture hits Galo for 884.",
	trigger_weakened = "is weakened!",
	trigger_digestiveAcid = "You are afflicted by Digestive Acid [%s%(]*([%d]*).",

	-- messages
	msg_tentacle = "Tentacles in 5sec!",
	msg_darkGlare = "Dark Glare!",
	msg_darkGlareEnds = "Dark Glare ends in 5 sec",
	msg_darkGlareGroup = "Dark Glare on group %s (%s)",
	msg_giantEyeSoon = "Giant Eye Tentacle in 5 sec!",
	msg_giantEyeDown = "Giant Eye down!",
	msg_weakened = "C'Thun is weakened for 45 sec",
	msg_weakenedOverSoon = "Party ends in 5 seconds",
	msg_weakenedOverNow = "Party over - C'Thun invulnerable",
	msg_digestiveAcid = "5 Acid Stacks",
	msg_phase2 = "The Eye is dead! Body incoming!",

	-- bars
	bar_startRandomBeams = "Start of Random Beams!",
	bar_eyeBeam = "Eye Beam on %s",
	bar_tentacleParty = "Tentacle party!",
	bar_darkGlareNext = "Next Dark Glare!",
	bar_darkGlareEnd = "Dark Glare ends",
	bar_darkGlareCast = "Casting Dark Glare",
	bar_giantEye = "Possible Giant Eye!",
	bar_giantClaw = "Giant Claw!",
	bar_weakened = "C'Thun is weakened!",

	-- misc
	misc_unknown = "Unknown", -- Eye Beam on Unknown
	misc_gianteye = "Giant Eye Tentacle",
	misc_fleshTentacle = "Flesh Tentacle",
	misc_fleshTentacleFirst = "First Flesh Tentacle",
	misc_fleshTentacleSecond = "Second Flesh Tentacle",
}
end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	tentacle_name = "Tentakel Alarm",
	tentacle_desc = "Warnung vor Tentakeln", --"Warn for Tentacles",
	glare_name = "Dunkles Starren Alarm", --"Dark Glare Alert", -- Dunkles Starren
	glare_desc = "Warnung for Dunklem Starren", --"Warn for Dark Glare",
	group_name = "Dunkles Starren Gruppenwarnung", -- "Dark Glare Group Warning",
	group_desc = "Warnt vor Dunkles Starren auf Gruppe X", -- "Warn for Dark Glare on Group X",
	giant_name = "Riesiges Augententakel Alarm", --Giant Eye Alert",
	giant_desc = "Warnung vor Riesigem Augententakel", -- "Warn for Giant Eyes",
	weakened_name = "Schwäche Alarm", --"Weakened Alert",
	weakened_desc = "Warnung für Schwäche Phase", -- "Warn for Weakened State",
	acid_name = "Magensäure Alarm",
	acid_desc = "Zeigt ein Warnzeichen wenn du mehr als 5 Stapel der Magensäure hast.",
	fleshtentacle_name = "Fleischtentakel",
	fleshtentacle_desc = "Lebensbalken der beiden Fleischtentakel",
	proximity_cmd = "proximity",
	proximity_name = "Nähe Warnungsfenster",
	proximity_desc = "Zeit das Nähe Warnungsfenster",

	-- triggers
	trigger_eyeBeamGiantEye = "Riesiges Augententakel beginnt Augenstrahl zu wirken", --"Giant Eye Tentacle begins to cast Eye Beam.", -- Riesiges Augententakel beginnt Augenstrahl zu wirken
	trigger_eyeBeamCthun = "Auge von C'Thun beginnt Augenstrahl zu wirken", --"Eye of C'Thun begins to cast Eye Beam.", --
	trigger_giantClawSpawn = "Riesiges Klauententakel(.+) Erdriss", -- "Giant Claw Tentacle 's Ground Rupture",
	trigger_giantEyeSpawn = "Riesiges Augententakel(.+) Erdriss", -- "Giant Eye Tentacle 's Ground Rupture",
	trigger_tentacleParty = "^Augententakel Erdriss (.+)$", -- "Eye Tentacle's Ground Rupture hits Galo for 884.",
	trigger_weakened = "ist geschwächt", -- "is weakened!",
	trigger_vulnerabilityDirectTest = "^[%w]+[%ss]* ([%w%s:]+) ([%w]+) C'Thun für ([%d]+) ([%w]+) damage%.[%s%(]*([%d]*)",
	trigger_vulnerabilityDotsTest = "^C'Thun suffers ([%d]+) ([%w]+) damage from [%w]+[%s's]* ([%w%s:]+)%.[%s%(]*([%d]*)",
	trigger_digestiveAcid = "Ihr seid von Magensäure [%s%(]*([%d]*)", -- "You are afflicted by Digestive Acid (5).",

	-- messages
	msg_tentacle = "Tentakel in 5sec!", --"Tentacles in 5sec!",
	msg_darkGlareEnds = "Dunkles Starren endet in 5 sec", -- "Dark Glare ends in 5 sec",
	msg_darkGlareGroup = "Dunkles Starren auf Gruppe %s (%s)", -- "Dark Glare on group %s (%s)",
	msg_phase2 = "Das Auge ist tot! Phase 2 beginnt.", -- "The Eye is dead! Body incoming!",
	msg_giantEyeSoon = "Riesiges Augententakel Tentacle in 5 sec!",
	msg_giantEyeDown = "Riesiges Augententakel tot!",
	msg_weakened = "C'Thun ist für 45 sec geschwächt", --"C'Thun is weakened for 45 sec",
	msg_weakenedOverSoon = "Party endet in 5 sec", --"Party ends in 5 seconds",
	msg_weakenedOverNow = "Party vorbei - C'Thun unverwundbar", -- "Party over - C'Thun invulnerable",
	msg_digestiveAcid = "5 Säure Stacks",
	msg_darkGlare = "Dunkles Starren!", -- "Dark Glare!",

	-- bars
	bar_startRandomBeams = "Beginn zufälliger Strahlen!",
	bar_eyeBeam = "Augenstrahl auf %s", --"Eye Beam on %s",
	bar_tentacleParty = "Tentakel Party", --"Tentacle party!",
	bar_darkGlareNext = "Nächstes Dunkles Starren!", -- "Next Dark Glare!",
	bar_darkGlareEnd = "Dunkles Starren endet", -- Dark Glare ends",
	bar_darkGlareCast = "Zaubert Dunkles Starren", -- "Casting Dark Glare",
	bar_giantEye = "Mögliches Riesiges Augententakel!",
	bar_giantClaw = "Riesiges Klauententakel!",
	bar_weakened = "C'Thun ist geschwächt", --"C'Thun is weakened!",

	-- misc
	misc_gianteye = "Riesiges Augententakel",
	misc_fleshTentacle = "Fleischtentakel",
	misc_fleshTentacleFirst = "1. Fleischtentakel",
	misc_fleshTentacleSecond = "2. Fleischtentakel",
	misc_unknown = "Unbekannt", -- Eye Beam on Unknown
}
end)
