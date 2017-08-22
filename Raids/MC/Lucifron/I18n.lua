------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.mc.lucifron
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Lucifron",
	
	-- commands
	adds_cmd = "adds",
	adds_name = "Dead adds counter",
	adds_desc = "Announces dead Flamewaker Protectors",
	
	mc_cmd = "mc",
	mc_name = "Dominate Mind",
	mc_desc = "Alert when someone is mind controlled.",
	
	curse_cmd = "curse",
	curse_name = "Lucifron's Curse alert",
	curse_desc = "Warn for Lucifron's Curse",
	
	doom_cmd = "doom",
	doom_name = "Impending Doom alert",
	doom_desc = "Warn for Impending Doom",
	
	-- triggers
	trigger_curseHit = "afflicted by Lucifron",
	trigger_doomHit = "afflicted by Impending Doom",
	trigger_curseResist = " Lucifron(.*) Curse was resisted",
	trigger_doomResist = "s Impending Doom was resisted",
	trigger_mindControlYou = "You are afflicted by Dominate Mind.",
	trigger_mindControlOther = "(.*) is afflicted by Dominate Mind.",
	trigger_mindControlYouGone = "Dominate Mind fades from you.",
	trigger_mindControlOtherGone = "Dominate Mind fades from (.*).",
	trigger_deathYou = "You die.",
	trigger_deathOther = "(.*) dies.",
	trigger_deathAdd = "Flamewaker Protector dies",
	
	-- messages
	msg_curseSoon = "5 seconds until Lucifron's Curse!",
	--msg_curseNow = "Lucifron's Curse - 20 seconds until next!",
	msg_doomSoon = "5 seconds until Impending Doom!",
	--msg_doomNow = "Impending Doom - 15 seconds until next!",
	msg_mindControlOther = "%s is mindcontrolled!",
	msg_mindControlYou = "You are mindcontrolled!",
	msg_add = "%d/2 Flamewaker Protectors dead!",
	
	-- bars
	bar_mindControl = "MC: %s",
	bar_curse = "Lucifron's Curse",
	bar_doom = "Impending Doom",
	
	-- misc
	misc_addName = "Flamewaker Protector",
	
} end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	adds_name = "Zähler für tote Adds",
	adds_desc = "Verkündet Feuerschuppenbeschützer Tod",
	
	mc_name = "Gedankenkontrolle",
	mc_desc = "Warnen, wenn jemand übernommen ist",
	
	curse_name = "Alarm für Lucifrons Fluch",
	curse_desc = "Warnen vor Lucifrons Fluch",
	
	doom_name = "Alarm für Drohende Verdammnis",
	doom_desc = "Warnen vor Drohender Verdammnis",
	
	-- triggers
	trigger_curseHit = "von Lucifrons Fluch betroffen",
	trigger_doomHit = "von Drohende Verdammnis betroffen",
	trigger_curseResist = "Lucifrons Fluch wurde von(.+) widerstanden",
	trigger_doomResist = "Drohende Verdammnis wurde von(.+) widerstanden",
	trigger_mindControlYou = "Ihr seid von Gedanken beherrschen betroffen.",
	trigger_mindControlOther = "(.*) ist von Gedanken beherrschen betroffen.",
	trigger_mindControlYouGone = "Gedanken beherrschen\' schwindet von Euch.",
	trigger_mindControlOtherGone = "Gedanken beherrschen schwindet von (.*).",
	trigger_deathYou = "Ihr sterbt.",
	trigger_deathOther = "(.*) stirbt.",
	trigger_deathAdd = "Feuerschuppenbeschützer stirbt", --"Besch\195\188tzer der Flammensch\195\188rer stirbt.",
	
	-- messages
	msg_curseSoon = "5 Sekunden bis Lucifrons Fluch!",
	--msg_curseNow = "Lucifrons Fluch - 20 Sekunden bis zum nächsten!",
	msg_doomSoon = "5 Sekunden bis Drohende Verdammnis!",
	--msg_doomNow = "Drohende Verdammnis - 15 Sekunden bis zur nächsten!",
	msg_mindControlOther = "%s ist gedankenkontrolliert!",
	msg_mindControlYou = "Du bist gedankenkontrolliert!",
	msg_add = "%d/2 Feuerschuppenbeschützer tot!",
	
	-- bars
	bar_mindControl = "GK: %s",
	bar_curse = "Lucifrons Fluch",
	bar_doom = "Drohende Verdammnis",
	
	-- misc
	misc_addName = "Feuerschuppenbeschützer",

} end)
