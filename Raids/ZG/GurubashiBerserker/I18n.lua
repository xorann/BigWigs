------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.zg.gurubashiBerserker
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Berserker",
	
	-- commands
	fear_cmd = "fear",
	fear_name = "Fear",
	fear_desc = "Show Timer Bar for Fear",
	
	knockback_cmd = "knockback",
	knockback_name = "Knockback",
	knockback_desc = "Show Timer Bar for Knockback",
	
	-- trigger
	trigger_fearHit = "afflicted by Intimidating Roar",
	trigger_fearImmune = "Intimidating Roar fail(.+) immune.",
	trigger_fearResist = "Intimidating Roar was resisted",
	
	trigger_knockback = "Gurubashi Berserker's Knock Away",
	
	-- bars
	bar_knockback = "KnockBack",
	bar_fear = "Fear",
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	--fear_cmd = "fear",
	fear_name = "Furch",
	fear_desc = "Zeige Timer für Furcht",
	
	--knockback_cmd = "knockback",
	knockback_name = "Rückstoss",
	knockback_desc = "Zeige Timer für Rückstoss",
	
	-- triggers
	trigger_fearHit = "afflicted by Intimidating Roar",
	trigger_fearImmune = "Intimidating Roar fail(.+) immune.",
	trigger_fearResist = "Intimidating Roar was resisted",
	
	trigger_knockback = "Gurubashi Berserker's Knock Away",
	
	-- bars
	bar_knockback = "Rückstoss",
	bar_fear = "Furcht",
} end )
