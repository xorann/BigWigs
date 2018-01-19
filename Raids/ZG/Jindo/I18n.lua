------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.zg.jindo
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Jindo",

	--commands
	brainwash_cmd = "brainwash",
	brainwash_name = "Brain Wash Totem Alert",
	brainwash_desc = "Warn when Jin'do summons Brain Wash Totems.",

	healingward_cmd = "healingward",
	healingward_name = "Healing Totem Alert",
	healingward_desc = "Warn when Jin'do summons Powerful Healing Wards.",

	curse_cmd = "curse",
	curse_name = "Curse Alert",
	curse_desc = "Warn when players get Delusions of Jin'do.",
	
	hex_cmd = "hex",
	hex_name = "Hex Alert",
	hex_desc = "Warn when players get Hex.",

	puticon_cmd = "puticon",
	puticon_name = "Raid icon on cursed players",
	puticon_desc = "Place a raid icon on the player with Delusions of Jin'do.\n\n(Requires assistant or higher)",
	
	-- triggers
    trigger_engage = "Welcome to da great show friends",
	trigger_brainWash = "Jin'do the Hexxer casts Summon Brain Wash Totem.",
	trigger_healing = "Jin'do the Hexxer casts Powerful Healing Ward.",
	trigger_curseYou = "You are afflicted by Delusions of Jin'do.",
	trigger_curseOther = "(.+) is afflicted by Delusions of Jin'do.",
	trigger_hexYou = "You are afflicted by Hex.",
	trigger_hexOther = "(.+) is afflicted by Hex.",
	trigger_hexYouGone = "Hex fades from you.",
	trigger_hexOtherGone = "Hex fades from (.+).",
	trigger_bossDeath = "Jin'do the Hexxer dies.",
	trigger_brainWashDeath = "Brain Wash Totem dies.",
	trigger_healingDeath = "Powerful Healing Ward dies.",
	
	-- messages
	msg_brainWash = "Brain Wash Totem!",
	msg_healing = "Healing Totem!",
	msg_curseWhisper = "You are cursed! Kill the Shades!",
	msg_curseOther = "%s is cursed!",
	msg_hex = "%s has Hex! Dispel it!",
	
	-- bars
	bar_brainWash = "Brain Wash Totem",
	bar_healing = "Powerful Healing Ward",
    bar_brainWashNext = "Next Brain Wash Totem",
	bar_healingNext = "Next Powerful Healing Ward",
	bar_hex = "Hex: %s",
	
	-- misc
	
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	brainwash_name = "Alarm f\195\188r Gehirnw\195\164schetotem",
	brainwash_desc = "Warnung, wenn Jin'do Gehirnw\195\164schetotem beschw\195\182rt.",

	healingward_name = "Alarm f\195\188r Heiltotem",
	healingward_desc = "Warnung, wenn Jin'do Heiltotem beschw\195\182rt.",

	curse_name = "Alarm f\195\188r Fluch",
	curse_desc = "Warnung, wenn Spieler Irrbilder von Jin'do bekommen.",
	
	hex_name = "Alarm f\195\188r Verhexung",
	hex_desc = "Warnung, wenn Spieler Verhexung bekommen.",

	puticon_name = "Schlachtzugsymbol auf die Spieler",
	puticon_desc = "Versetzt eine Schlachtzugsymbol auf der Spieler, der verflucht ist.\n\n(Ben\195\182tigt Schlachtzugleiter oder Assistent)",
	
	-- triggers
    trigger_engage      = "Welcome to da great show friends",
	trigger_brainWash = "von Gehirnw\195\164sche betroffen", -- Jin'do the Hexxer casts Summon Brain Wash Totem. stupid workaround
	trigger_healing = "Jin'do the Hexxer wirkt M\195\164chtiger Heilungszauberschutz.", -- NOTHING to detect this totem spawn in combatlog. Not even mana usage from the boss.
	trigger_curseYou = "Ihr seid von Irrbilder von Jin'do betroffen.",
	trigger_curseOther = "(.+) ist von Irrbilder von Jin'do betroffen.",
	trigger_hexYou = "Ihr seid von Verhexung betroffen.",
	trigger_hexOther = "(.+) ist von Verhexung betroffen.",
	trigger_hexYouGone = "'Verhexung' schwindet von Euch.",
	trigger_hexOtherGone = "Verhexung schwindet von (.+).",
	trigger_bossDeath = "Jin'do the Hexxer stirbt.",
	trigger_brainWashDeath = "Brain Wash Totem stirbt.",
	trigger_healingDeath = "Powerful Healing Ward stirbt.",
	
	-- messagesmsg_brainWash = "Gehirnw\195\164schetotem!",
	msg_healing = "M\195\164chtiger Heilungszauberschutz!",
	msg_curseWhisper = "Du bist verflucht! T\195\182te die Schemengestalten!",
	msg_curseOther = "%s ist verflucht!",
	msg_hex = "%s ist verhext! Entfernt es!",
	
	-- bars
	bar_brainWash = "Gehirnw\195\164schetotem",
	bar_healing = "M\195\164chtiger Heilungszauberschutz",
    bar_brainWashNext = "Nächstes Gehirnw\195\164schetotem",
	bar_healingNext = "Nächster M\195\164chtiger Heilungszauberschutz",
	bar_hex = "Verhexung: %s",
	
	-- misc
		
} end )
