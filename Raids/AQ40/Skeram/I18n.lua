----------------------------
-- 		Localization      --
----------------------------

local bossName = BigWigs.bossmods.aq40.skeram
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Skeram",

	-- commands
	mc_cmd = "mc",
	mc_name = "Mind Control Alert",
	mc_desc = "Warn for Mind Control",
	split_cmd = "split",
	split_name = "Split Alert",
	split_desc = "Warn before Splitting",
	
	arcaneExplosion_cmd = "arcaneExplosion",
	arcaneExplosion_name = "Arcane Explosion",
	arcaneExplosion_desc = "Warn for Arcane Explosion",

	-- triggers
	trigger_mcGainPlayer = "You are afflicted by True Fulfillment.",
	trigger_mcGainOther = "(.*) is afflicted by True Fulfillment.",
	trigger_mcPlayerGone = "True Fulfillment fades from you.",
	trigger_mcOtherGone = "True Fulfillment fades from (.*).",
	trigger_deathPlayer = "You die.",
	trigger_deathOther = "(.*) dies.",
	trigger_arcaneExplosion = "The Prophet Skeram begins to cast Arcane Explosion.",
	["You have slain %s!"] = true,

	-- messages
	msg_mcPlayer = "You are mindcontrolled!",
	msg_mcOther = "%s is mindcontrolled!",
	msg_splitSoon = "Split soon! Get ready!",
	msg_split = "Split!",

	-- bars
	bar_mc = "MC: %s",
	bar_arcaneExplosion = "Arcane Explosion",

	-- misc
}
end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	mc_name = "Gedankenkontrolle",
	mc_desc = "Warnen, wenn jemand übernommen ist",
	split_name = "Abbilder",
	split_desc = "Alarm vor der Aufteilung",

	-- triggers
	trigger_mcGainPlayer = "Ihr seid von Wahre Erfüllung betroffen.",
	trigger_mcGainOther = "(.*) ist von Wahre Erfüllung betroffen.",
	trigger_mcPlayerGone = "Wahre Erfüllung\' schwindet von Euch.",
	trigger_mcOtherGone = "Wahre Erfüllung schwindet von (.*).",
	trigger_deathPlayer = "Du stirbst.",
	trigger_deathOther = "(.*) stirbt.",
	["You have slain %s!"] = "Ihr habt %s getötet!",

	-- messages
	msg_mcPlayer = "Ihr seid von Wahre Erfüllung betroffen.",
	msg_mcOther = "%s steht unter Gedankenkontrolle!",
	msg_splitSoon = "Abbilder bald! Sei bereit!",
	msg_split = "Abbilder!",

	-- bars
	bar_mc = "GK: %s",

	-- misc
}
end)
