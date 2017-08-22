------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.aq20.ossirian
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Ossirian",

	-- commands
	supreme_cmd = "supreme",
	supreme_name = "Supreme Alert",
	supreme_desc = "Warn for Supreme Mode",

	debuff_cmd = "debuff",
	debuff_name = "Debuff Alert",
	debuff_desc = "Warn for Defuff",

	-- triggers
	trigger_supreme = "Ossirian the Unscarred gains Strength of Ossirian.",
	trigger_debuff = "Ossirian the Unscarred is afflicted by (.+) Weakness.",
	trigger_crystal = "Ossirian Crystal Trigger dies.",
	trigger_expose = "Expose",

	-- messages
	msg_supreme = "Ossirian Supreme Mode!",
	msg_supremeSoon = "Supreme in %d seconds!",
	msg_debuff = "Ossirian now weak to %s!",
	
	-- bars
	bar_supreme = "Supreme",
	
	-- misc
	["Shadow"] = true,
	["Fire"] = true,
	["Frost"] = true,
	["Nature"] = true,
	["Arcane"] = true,
	
	["ShadowIcon"] = "Spell_Shadow_ChillTouch",
	["FireIcon"] = "Spell_Fire_Fire",
	["FrostIcon"] = "Spell_Frost_ChillingBlast",
	["NatureIcon"] = "Spell_Nature_Acid_01",
	["ArcaneIcon"] = "Spell_Arcane_PortalOrgrimmar",
	
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	supreme_name = "Stärke des Ossirian",
	supreme_desc = "Warnung vor Stärke des Ossirian.",

	debuff_name = "Debuff",
	debuff_desc = "Warnung vor Debuff.",

	-- triggers
	trigger_supreme = "Ossirian der Narbenlose bekommt 'Stärke des Ossirian'.",
	trigger_debuff = "Ossirian der Narbenlose ist von (.*)schwäche betroffen.",
	trigger_crystal = "Ossirian Crystal Trigger dies.", -- translation missing
	trigger_expose = "Schwäche",

	-- messages
	msg_supreme = "Stärke des Ossirian!",
	msg_supremeSoon = "Stärke des Ossirian in %d Sekunden!",
	msg_debuff = "Ossirian für 45 Sekunden anfällig gegen: %s",
	
	-- bars
	bar_supreme = "Stärke des Ossirian",
	
	-- misc	
	["Shadow"] = "Schatten",
	["Fire"] = "Feuer",
	["Frost"] = "Frost",
	["Nature"] = "Natur",
	["Arcane"] = "Arkan",
	
	["ShadowIcon"] = "Spell_Shadow_ChillTouch",
	["FireIcon"] = "Spell_Fire_Fire",
	["FrostIcon"] = "Spell_Frost_ChillingBlast",
	["NatureIcon"] = "Spell_Nature_Acid_01",
	["ArcaneIcon"] = "Spell_Arcane_PortalOrgrimmar",
	
} end )
