------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.other.kazzak
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Kazzak",
	
	-- commands
	supreme_cmd = "supreme",
	supreme_name = "Supreme Alert",
	supreme_desc = "Warn for Supreme Mode.",

	voidbolt_cmd = "voidbolt",
	voidbolt_name = "Void Bolt",
	voidbolt_desc = "Show notifications for Void Bolt.",

	corruptsoul_cmd = "corruptsoul",
	corruptsoul_name = "Corrupt Soul",
	corruptsoul_desc = "Warn when boss gets healed from random deaths.",

	markofkazzak_cmd = "markofkazzak",
	markofkazzak_name = "Mark of Kazzak",
	markofkazzak_desc = "Warn when people get the mana drain debuff from the boss.",
	
	twistedreflection_cmd = "twistedreflection",
	twistedreflection_name = "Twisted Reflection",
	twistedreflection_desc = "Warn when people get the debuff that heals the boss for 25000 HP each time it hits them.",

	puticon_cmd = "puticon",
	puticon_name = "Raid Icon on Mark target",
	puticon_desc = "Put a Raid Icon on the person who got Mark of Kazzak.\n\n(Requires assistant or higher)",
	
	-- triggers
	trigger_engage1 = "All mortals will perish!",
	trigger_engage2 = "The Legion will conquer all!",
	trigger_markYouGain = "You are afflicted by Mark of Kazzak.",
	trigger_markOtherGain = "(.*) is afflicted by Mark of Kazzak.",
	trigger_markYouGone = "Mark of Kazzak fades from you.",
	trigger_markOtherGone = "Mark of Kazzak fades from (.*).",
	trigger_reflectionYouGain = "You are afflicted by Twisted Reflection.",
	trigger_reflectionOtherGain = "(.*) is afflicted by Twisted Reflection.",
	trigger_reflectionYouGone = "Twisted Reflection fades from you.",
	trigger_reflectionOtherGone = "Twisted Reflection fades from (.*).",
	trigger_deathYou = "You die\.",
	trigger_deathOther = "(.*) dies.",
	trigger_voidbolt = "Lord Kazzak begins to cast Void Bolt.",
	trigger_attack1 = "Lord Kazzak attacks",
	trigger_attack2 = "Lord Kazzak misses",
	trigger_attack3 = "Lord Kazzak hits",
	trigger_attack4 = "Lord Kazzak crits",
	trigger_enrage = "Lord Kazzak gains Berserk.",
	trigger_supreme = "Kazzak is supreme!",
	trigger_bosskill = "The Legion... will never... fall.",
	
	-- messages
	msg_engage = "Lord Kazzak engaged! 3mins until Supreme!",
	msg_enrage = "Lord Kazzak is supreme!",
	msg_mark = "%s has Mark of Kazzak! Decurse!",
	msg_reflection = "%s has Twisted Reflection! Dispel!",
	msg_markYou = "You have Mark of Kazzak! Don't go out of mana!",
	msg_reflectionYou = "You have Twisted Reflection!",
	msg_corruptSoulOther = "%s has healed Lord Kazzak by dying!",
	msg_corruptSoulYou = "You have healed Lord Kazzak by dying!",

	msg_supreme1min = "Supreme mode in 1 minute!",
	msg_supreme30 = "Supreme mode in 30 seconds!",
	msg_supreme10 = "Supreme mode in 10 seconds!",
	
	-- bars
	bar_enrage = "Supreme mode",
	bar_voidbolt = "Void Bolt",
	bar_mark = "%s: Mark of Kazzak",
	bar_reflection = "%s: Twisted Reflection",
	
	-- misc
	
} end )
