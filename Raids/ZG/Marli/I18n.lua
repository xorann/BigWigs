------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.zg.marli
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Marli",
	
	-- commands
	spider_cmd = "spider",
	spider_name = "Spider Alert",
	spider_desc = "Warn when spiders spawn",

	volley_cmd = "volley",
	volley_name = "Poison Bolt Volley Alert",
	volley_desc = "Warn for Poison Bolt Volleys\n\n(Disclaimer: this bar has a \194\1772 seconds error)",

	drain_cmd = "drain",
	drain_name = "Drain Life Alert",
	drain_desc = "Warn for life drain",
	
	phase_cmd = "phase",
	phase_name = "Phase Notification",
	phase_desc = "Announces the boss' phase transition",
	
	-- triggers
	trigger_spiders = "Aid me my brood!",
	trigger_drainLifeYouGain = "You are afflicted by Drain Life\.",
	trigger_drainLifeOtherGain = "(.+) is afflicted by Drain Life\.",
	trigger_drainLifeYouGone = "Drain Life fades from you\.",
	trigger_drainLifeOtherGone = "Drain Life fades from (.+)\.",
	trigger_poisonHit1 = "afflicted by Poison Bolt Volley",
	trigger_poisonHit2 = "High Priestess Mar'li 's Poison Bolt Volley hits",
	trigger_poisonResist = "High Priestess Mar'li 's Poison Bolt Volley was resisted(.+)",
	trigger_poisonImmune = "High Priestess Mar'li 's Poison Bolt Volley fail(.+) immune",
	trigger_drainLife = "Drain Life",
	trigger_phaseTroll = "The brood shall not fall",
	trigger_spiderTroll1 = "Draw me to your web mistress Shadra",
	trigger_spiderTroll2 = "Shadra, make of me your avatar",
	
	-- messages
	msg_spiders = "Spiders spawned!",
	msg_drainLife = "Drain Life! Interrupt/dispel it!",
	msg_phaseTroll = "Troll phase",
	msg_phaseSpider = "Spider phase",
	
	-- bars
	bar_poison = "Poison Bolt Volley",
	bar_drainLife = "Drain Life",
	
	-- misc
	misc_spawnName = "Spawn of Mar'li",
	misc_you = "you",
	
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	spider_name = "Alarm f\195\188r Spinnen",
	spider_desc = "Warnung wenn Spinnen erscheinen",

	volley_name = "Alarm f\195\188r Giftblitzsalve",
	volley_desc = "Warnen vor Giftblitzsalve\n\n(Dementi: Dieser Balken hat eine \194\1772 Sekunden Fehler)",

	drain_name = "Alarm f\195\188r Blutsauger",
	drain_desc = "Warnen vor Blutsauger",
	
	phase_name = "Phasen-Benachrichtigung",
	phase_desc = "Verk\195\188ndet den Phasenwechsel des Bosses",
	
	-- triggers
	trigger_spiders = "Aid me my brood!",
	trigger_drainLifeYouGain = "Ihr seid von Blutsauger betroffen\.",
	trigger_drainLifeOtherGain = "(.+) ist von Blutsauger betroffen\.",
	trigger_drainLifeYouGone = "\'Blutsauger\' schwindet von Euch\.",
	trigger_drainLifeOtherGone = "Blutsauger schwindet von (.+)\.",
	trigger_poisonHit1 = "von Giftblitzsalve betroffen",
	trigger_poisonHit2 = "Giftblitzsalve(.+) Naturschaden\.",
	trigger_poisonResist = "Giftblitzsalve(.+) widerstanden",
	trigger_poisonImmune = "Giftblitzsalve(.+) immun",
	trigger_drainLife = "Blutsauger",
	trigger_phaseTroll = "The brood shall not fall",
	trigger_spiderTroll1 = "Draw me to your web mistress Shadra",
	trigger_spiderTroll2 = "Shadra, make of me your avatar",
	
	-- messages
	msg_spiders = "Spinnen erscheinen!",
	msg_drainLife = "Blutsauger! Unterbreche sie/entferne magie!",
	msg_phaseTroll = "Troll-Phase",
	msg_phaseSpider = "Spinnen-Phase",
	
	-- bars
	bar_poison = "Giftblitzsalve",
	
	-- misc
	misc_spawnName = "Spawn of Mar'li",
	misc_you = "Euch",

} end )
