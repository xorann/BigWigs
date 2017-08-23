------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.other.emeriss
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Emeriss",

	-- commands
	noxious_cmd = "noxious",
	noxious_name = "Noxious breath alert",
	noxious_desc = "Warn for noxious breath",

	volatileyou_cmd = "volatileyou",
	volatileyou_name = "Voltile infection on you alert",
	volatileyou_desc = "Warn for volatile infection on you",

	volatileother_cmd = "volatileother",
	volatileother_name = "Volatile infection on others alert",
	volatileother_desc = "Warn for volatile infection on others",

	-- triggers
	trigger_volatileInfection = "^([^%s]+) ([^%s]+) afflicted by Volatile Infection",
	trigger_noxiousBreath = "afflicted by Noxious Breath",
	trigger_engage = "Hope is a DISEASE of the soul! This land shall wither and die!",
	trigger_corruption = "Taste your world's corruption!",

	-- messages
	msg_volatileInfectionYou = "You are afflicted by Volatile Infection!",
	msg_volatileInfectionOther = "%s is afflicted by Volatile Infection!",
	msg_noxiousBreathSoon = "5 seconds until Noxious Breath!",
	msg_noxiousBreathNow = "Noxious Breath! 18 seconds till next!",
	msg_engage = "Emeriss engaged! 8 seconds till Noxious Breath!",
	msg_corruption = "Corruption of the Earth! Heal NoW!",

	-- bars
	bar_noxiousBreath = "Noxious Breath",
	bar_corruption = "Corruption of the Earth",
	
	-- misc
	misc_you = "You",
	misc_are = "are",

} end )
