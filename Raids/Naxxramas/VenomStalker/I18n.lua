--[[
    Created by Vnm-Kronos - https://github.com/Vnm-Kronos
    modified by Dorann
--]]

------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.venomstalker
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "SpiderTrash",
	
	-- commands
	charge_cmd = "charge",
	charge_name = "Poison Charge",
	charge_desc = "Displays a cooldown for Poison Charge.",
	
	-- triggers
	trigger_charge = "(.+) (.+) afflicted by Poison Charge.",
	--trigger_chargeGone = "Poison Charge fades from (.+)",
	
	-- messages
	
	-- bars
	bar_charge = "Poison Charge Cooldown %s",
	
	-- misc
	misc_You = "You",
	misc_you = "you",
	misc_are = "are",
	misc_is = "is",
} end )

L:RegisterTranslations("deDE", function() return {
	--cmd = "SpiderTrash",
	
	-- commands
	--charge_cmd = "charge",
	charge_name = "Giftangriff",
	charge_desc = "Zeigt Cooldown von Giftangriff an.",
	
	-- triggers
	trigger_charge = "(.+) (.+) von Giftangriff betroffen.",
	--trigger_chargeGone = "Poison Charge fades from (.+)",
	
	-- messages
	
	-- bars
	bar_charge = "Giftangriff Cooldown %s",
	
	-- misc
	misc_You = "Ihr",
	misc_you = "ihr",
	misc_are = "seid",
	misc_is = "ist",
} end )