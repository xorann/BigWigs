------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.mc.sulfuron
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Sulfuron",
	
	-- commands	
	knockback_cmd = "knockback",
	knockback_name = "Hand of Ragnaros announce",
	knockback_desc = "Show timer for knockbacks",
	
	heal_cmd = "heal",
	heal_name = "Adds' heals",
	heal_desc = "Announces Flamewaker Priests' heals",
	
	adds_cmd = "adds",
	adds_name = "Dead adds counter",
	adds_desc = "Announces dead Flamewaker Priests",
	
	-- triggers
	trigger_addDeath = "Flamewaker Priest dies",
	trigger_heal = "begins to cast Dark Mending",
    trigger_spear = "begins to perform Flame Spear",
	trigger_knockbackHit1 = "Hand of Ragnaros hits",
	trigger_knockbackHit2 = "Hand of Ragnaros hits",
	trigger_knockbackResist = "Hand of Ragnaros was resisted",
	trigger_knockbackAbsorb1 = "absorb (.+) Hand of Ragnaros",
	trigger_knockbackAbsorb2 = "Hand of Ragnaros is absorbed",
	trigger_knockbackImmune = "Hand of Ragnaros (.+) immune",
	
	-- messages
	msg_knockbackSoon = "3 seconds until knockback!",
	msg_heal = "Healing!",
	msg_adds = "%d/4 Flamewaker Priests dead!",
	
	-- bars
	bar_heal = "Dark Mending",
	bar_knockback = "Possible Knockback",
	bar_flameSpear = "Flame Spear",
	
	-- misc
	misc_addName = "Flamewaker Priest",

} end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	knockback_name = "Verkündet Hand von Ragnaros",
	knockback_desc = "Zeige Timer für Rückstö\195\159e",
	
	heal_name = "Heilung der Adds",
	heal_desc = "Verkündet Heilung der Flamewaker Priest",
	
	adds_name = "Zähler für tote Adds",
	adds_desc = "Verkündet Flamewaker Priests Tod",
	
	-- triggers
	trigger_addDeath = "Flamewaker Priest stirbt",
	trigger_heal = "beginnt Dunkle Besserung",
    trigger_spear = "beginnt Flammenspeer zu wirken",
	trigger_knockbackHit1 = "trifft(.+)Hand von Ragnaros",
	trigger_knockbackHit2 = "Hand von Ragnaros(.+)trifft",
	trigger_knockbackResist = "Hand von Ragnaros(.+)widerstanden",
	trigger_knockbackAbsorb1 = "absorbiert (.+) Hand von Ragnaros",
	trigger_knockbackAbsorb2 = "Hand von Ragnaros (.+) absorbiert",
	trigger_knockbackImmune = "Hand von Ragnaros(.+) immun",
	
	-- messages
	msg_knockbackSoon = "3 Sekunden bis Rückstoss!",
	msg_heal = "Heilung!",
	msg_adds = "%d/4 Flamewaker Priest tot!",
	
	-- bars
	bar_heal = "Dunkle Besserung",
	bar_knockback = "Möglicher Rückstoss",
	bar_flameSpear = "Flammenspeer",
	
	-- misc
	misc_addName = "Flamewaker Priest",

} end)
