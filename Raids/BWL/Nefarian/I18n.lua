------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.bwl.nefarian
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Nefarian",
	
	-- commands
	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn for Shadow Flame",

	fear_cmd = "fear",
	fear_name = "Warn for Fear",
	fear_desc = "Warn when Nefarian casts AoE Fear",

	classcall_cmd = "classcall",
	classcall_name = "Class Call alert",
	classcall_desc = "Warn for Class Calls",

	otherwarn_cmd = "otherwarn",
	otherwarn_name = "Other alerts",
	otherwarn_desc = "Landing and Zerg warnings",
	
	mc_cmd = "mc",
	mc_name = "Mind Control Alert",
	mc_desc = "Warn for Mind Control",
	
	-- triggers
	trigger_engage = "Let the games begin!",
	trigger_landing = "Enough! Now you",
    trigger_landingNow = "courage begins to wane",
	trigger_zerg = "Impossible! Rise my",
	trigger_fear = "Nefarian begins to cast Bellowing Roar",
	trigger_fearGone = "Bellowing Roar",
	trigger_shadowFlame = "Nefarian begins to cast Shadow Flame",
	
	
	trigger_shamans	= "Shamans, show me",
	trigger_druid	= "Druids and your silly",
	trigger_warlock	= "Warlocks, you shouldn't be playing",
	trigger_priest	= "Priests! If you're going to keep",
	trigger_hunter	= "Hunters and your annoying",
	trigger_warrior	= "Warriors, I know you can hit harder",
	trigger_rogue	= "Rogues%? Stop hiding",
	trigger_paladin	= "Paladins",
	trigger_mage		= "Mages too%?",
	
	trigger_mindControl = "^([^%s]+) ([^%s]+) afflicted by Shadow Command.",
    trigger_nefCounter = "^([%w ]+) dies.",
	
	-- messages
	msg_fear = "Fear NOW!",
	msg_landing = "Nefarian is landing!",
	msg_landingSoon = "Nefarian is landing soon",
	msg_zerg = "Zerg incoming!",
	msg_fearCast = "Fear in 2 sec!",
	msg_fearSoon = "Possible fear in ~5 sec",
	msg_shadowFlame = "Shadow Flame incoming!",

	msg_classCall = "Class call incoming!",

	msg_shaman	= "Shamans - Totems spawned!",
	msg_druid	= "Druids - Stuck in cat form!",
	msg_warlock	= "Warlocks - Incoming Infernals!",
	msg_priest	= "Priests - Heals hurt!",
	msg_hunter	= "Hunters - Bows/Guns broken!",
	msg_warrior	= "Warriors - Stuck in berserking stance!",
	msg_rogue	= "Rogues - Ported and rooted!",
	msg_paladin	= "Paladins - Blessing of Protection!",
	msg_mage	= "Mages - Incoming polymorphs!",

	msg_mindControlPlayer = "%s is mindcontrolled!",
	
	-- bars
	bar_mobSpawn = "Mob Spawn",
	bar_shadowFlame = "Shadow Flame",
	bar_classCall = "Class call",
	bar_fear = "Possible fear",
	bar_mindControl = "%s is mindcontrolled",
	
	-- misc
	misc_you = "You",
	misc_are = "are",
	misc_drakonidsDead = true,
	
	["NefCounter_RED"] = "Red Drakonid",
	["NefCounter_GREEN"] = "Green Drakonid",
	["NefCounter_BLUE"] = "Blue Drakonid",
	["NefCounter_BRONZE"] = "Bronze Drakonid",
	["NefCounter_BLACK"] = "Black Drakonid",
	["NefCounter_CHROMATIC"] = "Chromatic Drakonid",
	
} end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	shadowflame_name = "Schattenflamme Warnung",
	shadowflame_desc = "Warnt vor Schattenflamme",

	fear_name = "Furcht Warnung",
	fear_desc = "Warnt wenn Nefarian die AoE Furcht zaubert",

	classcall_name = "Klassenruf Warnung",
	classcall_desc = "Warn for Class Calls",

	otherwarn_name = "Other alerts",
	otherwarn_desc = "Landing and Zerg warnings",
            
	mc_name = "Mind Control Alert",
	mc_desc = "Warn for Mind Control",
	
	-- triggers
	trigger_engage = "Lasst die Spiele beginnen!",
	trigger_landing = "GENUG! Nun sollt ihr Ungeziefer",
    trigger_landingNow = "Der Mut der Sterblichen scheint zu schwinden",
	trigger_zerg = "Unmöglich! Erhebt Euch, meine Diener!",
	trigger_fear = "Nefarian beginnt Dröhnendes Gebrüll zu wirken.",
	trigger_fearGone = "Dröhnendes Gebrüll",
	trigger_shadowFlame = "Nefarian beginnt Schattenflamme zu wirken.",

	trigger_shamans	= "Schamane",
	trigger_druid	= "Druiden",
	trigger_warlock	= "Hexenmeister",
	trigger_priest	= "Priester",
	trigger_hunter	= "Jäger",
	trigger_warrior	= "Krieger",
	trigger_rogue	= "Schurken",
	trigger_paladin	= "Paladine",
	trigger_mage		= "Magier",
	
	trigger_mindControl = "^([^%s]+) ([^%s]+) von Schattenbefehl betroffen.",
    trigger_nefCounter = "^([%w ]+) stirbt.",
	
	-- messages
	msg_fear = "Furcht JETZT!",
	msg_landing = "Nefarian landet!",
	msg_landingSoon = "Nefarian landet bald",
	msg_zerg = "Zerg kommt!",
	msg_fearCast = "Furcht in 2s!",
	msg_fearSoon = "Mögliche Furcht in 5s",
	msg_shadowFlame = "Schattenflamme!",
	bar_shadowFlame = "Schattenflamme",
	msg_classCall = "Classcall",
	
	msg_shaman	= "Schamanen - Totems spawned!",
	msg_druid	= "Druiden - stecken in Katzenform!",
	msg_warlock	= "Hexenmeister - Infernals!",
	msg_priest	= "Priester - Heilung schmerzt!",
	msg_hunter	= "Jäger - Bogen/Gewehr kaputt!",
	msg_warrior	= "Krieger - stecken in Berserkerhaltung!",
	msg_rogue	= "Schurken - teleportiert und gewurzelt!",
	msg_paladin	= "Paladine - Segen des Schutzes!",
	msg_mage	= "Magier - polymorphs!",
	
	msg_mindControlPlayer = "%s ist gedankenkontrolliert.",
	
	-- bars
	bar_mobSpawn = "Mob Spawn",
	bar_classCall = "Classcall",
	bar_fear = "Mögliche Furcht",
	bar_mindControl = "%s ist gedankenkontrolliert",
	
	-- misc
	misc_you = "Ihr",
	misc_are = "seid",
	misc_drakonidsDead = "Drakonide total",
	
	["NefCounter_RED"] = "Roter Drakonid",
	["NefCounter_GREEN"] = "Grüner Drakonid",
	["NefCounter_BLUE"] = "Blauer Drakonid",
	["NefCounter_BRONZE"] = "Bronzener Drakonid",
	["NefCounter_BLACK"] = "Schwarzer Drakonid",
	["NefCounter_CHROMATIC"] = "Chromatischer Drakonid",
} end)
