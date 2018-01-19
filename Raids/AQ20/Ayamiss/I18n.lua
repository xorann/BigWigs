------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.aq20.ayamiss
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Ayamiss",
	
	-- commands
	sacrifice_cmd = "sacrifice",
	sacrifice_name = "Sacrifice Alert",
	sacrifice_desc = "Warn for Sacrifice",
	
	-- triggers
	trigger_sacrifice = "^([^%s]+) ([^%s]+) afflicted by Paralyze",
	
	-- messages
	msg_sacrifice = " is being Sacrificed!",
	
	-- bars
	
	-- misc
	misc_you = "You",
	misc_are = "are",	
		
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	sacrifice_name = "Opferung",
	sacrifice_desc = "Warnung, wenn ein Spieler geopfert wird.",
	
	-- triggers
	trigger_sacrifice = "^([^%s]+) ([^%s]+) von Paralisieren betroffen.",
	
	-- messages
	msg_sacrifice = " wird geopfert!",
	
	-- bars
	
	-- misc
	misc_you = "Ihr",
	misc_are = "seid",	
	
} end )
