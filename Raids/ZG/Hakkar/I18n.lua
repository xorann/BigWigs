------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.zg.hakkar
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Hakkar",
	
	-- commands
	siphon_cmd = "siphon",
	siphon_name = "Blood Siphon",
	siphon_desc = "Shows bars, warnings and timers for Hakkar's Blood Siphon.",

	enrage_cmd = "enrage",
	enrage_name = "Enrage",
	enrage_desc = "Lets you know when the 10 minutes are up!",

	mc_cmd = "mc",
	mc_name = "Mind Control",
	mc_desc = "Alert when players have Cause Insanity.",
	
	aspectjeklik_cmd = "aspectjeklik",
	aspectjeklik_name = "Aspect of Jeklik",
	aspectjeklik_desc = "Warnings for the extra ability Hakkar gains when High Priestess Jeklik is still alive.",
	
	aspectvenoxis_cmd = "aspectvenoxis",
	aspectvenoxis_name = "Aspect of Venoxis",
	aspectvenoxis_desc = "Warnings for the extra ability Hakkar gains when High Priest Venoxis is still alive.",
	
	aspectmarli_cmd = "aspectmarli",
	aspectmarli_name = "Aspect of Mar'li",
	aspectmarli_desc = "Warnings for the extra ability Hakkar gains when High Priestess Mar'li is still alive.",
	
	aspectthekal_cmd = "aspectthekal",
	aspectthekal_name = "Aspect of Thekal",
	aspectthekal_desc = "Warnings for the extra ability Hakkar gains when High Priest Thekal is still alive.",

	aspectarlokk_cmd = "aspectarlokk",
	aspectarlokk_name = "Aspect of Arlokk",
	aspectarlokk_desc = "Warnings for the extra ability Hakkar gains when High Priestess Arlokk is still alive.",
	
	puticon_cmd = "puticon",
	puticon_name = "Raid icon on MCed players",
	puticon_desc = "Place a raid icon on the player with Cause Insanity.\n\n(Requires assistant or higher)",
	
	-- triggers
	trigger_engage = "FACE THE WRATH OF THE SOULFLAYER!",
	trigger_siphon = "Hakkar gains Blood Siphon.",
	trigger_poisonousBlood = "You are afflicted by Poisonous Blood.",
	trigger_mindControlYou = "You are afflicted by Cause Insanity.",
	trigger_mindControlOther = "(.+) is afflicted by Cause Insanity.",
	trigger_flee = "Fleeing will do you no good, mortals!",
	trigger_aspectOfThekal = "Hakkar gains Aspect of Thekal.",
	trigger_aspectOfThekalGone = "Aspect of Thekal fades from Hakkar.",
	trigger_aspectOfMarliYou = "You are afflicted by Aspect of Mar'li.",
	trigger_aspectOfMarliYouImmune = "Hakkar 's Aspect of Mar'li failed. You are immune.",
	trigger_aspectOfMarliOther = "(.+) is afflicted by Aspect of Mar'li.",
	trigger_aspectOfMarliOtherImmune = "Hakkar 's Aspect of Mar'li fails. (.+) is immune.",
	trigger_aspectOfMarliGeneralAvoid = "Hakkar 's Aspect of Mar'li",
	trigger_aspectOfJeklikYou = "You are afflicted by Aspect of Jeklik.",
	trigger_aspectOfJeklikYouImmune = "Hakkar 's Aspect of Jeklik failed. You are immune.",
	trigger_aspectOfJeklikOther = "(.+) is afflicted by Aspect of Jeklik.",
	trigger_aspectOfJeklikOtherImmune = "Hakkar 's Aspect of Jeklik fails. (.+) is immune.",
	trigger_aspectOfJeklikGeneralAvoid = "Hakkar 's Aspect of Jeklik",
	trigger_aspectOfArlokkYou = "You are afflicted by Aspect of Arlokk.",
	trigger_aspectOfArlokkYouImmune = "Hakkar 's Aspect of Arlokk failed. You are immune.",
	trigger_aspectOfArlokkOther = "(.+) is afflicted by Aspect of Arlokk.",
	trigger_aspectOfArlokkOtherImmune = "Hakkar 's Aspect of Arlokk fails. (.+) is immune.",
	trigger_aspectOfArlokkGeneralAvoid = "Hakkar 's Aspect of Arlokk",
	trigger_aspectOfVenoxisYou = "Hakkar 's Aspect of Venoxis hits you for",
	trigger_aspectOfVenoxisYouResist = "Hakkar 's Aspect of Venoxis was resisted.",
	trigger_aspectOfVenoxisOther = "Hakkar 's Aspect of Venoxis hits",
	trigger_aspectOfVenoxisOtherResist = "Hakkar 's Aspect of Venoxis was resisted by",
	
	-- messages
	msg_siphonSoon = "Blood Siphon in %d seconds!",
	msg_siphonNow = "Blood Siphon - next one in 90 seconds!",
	msg_enrage5m = "Enrage in 5 minutes!",
	msg_enrage1m = "Enrage in 1 minute!",
	msg_enrageSeconds = "Enrage in %d seconds!",

	msg_mindControlOther = "%s is mindcontrolled!",
	msg_mindControlYou = "You are mindcontrolled!",
	msg_aspectOfThekal = "Frenzy! Tranq now!",
	
	-- bars
	bar_mindControl = "MC: %s",
	bar_firstMindControl = "First MC",
	bar_nextMindControl = "Next MC",
	bar_enrage = "Enrage",
	bar_siphon = "Blood Siphon",
	bar_aspectOfThekalNext = "Next Frenzy",
	bar_aspectOfThekal = "Frenzy - Aspect of Thekal",
	bar_aspectOfMarliNext = "Next Stun",
	bar_aspectOfMarliDebuff = "Stun: %s - Aspect of Mar'li",
	bar_aspectOfJeklikNext = "Next Silence",
	bar_aspectOfJeklikDebuff = "Silence - Aspect of Jeklik",
	bar_aspectOfArlokkNext = "Next Vanish",
	bar_aspectOfArlokkDebuff = "Vanish: %s - Aspect of Arlokk",
	bar_aspectOfVenoxisNext = "Next Poison",
	bar_aspectOfVenoxisDebuff = "Poison - Aspect of Venoxis",
	
	-- misc

} end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	siphon_name = "Blood Siphon",
	siphon_desc = "Shows bars, warnings and timers for Hakkar's Blood Siphon.",

	enrage_name = "Enrage",
	enrage_desc = "Lets you know when the 10 minutes are up!",

	mc_name = "Mind Control",
	mc_desc = "Alert when players have Cause Insanity.",
	
	aspectjeklik_name = "Aspect of Jeklik",
	aspectjeklik_desc = "Warnings for the extra ability Hakkar gains when High Priestess Jeklik is still alive.",
	
	aspectvenoxis_name = "Aspect of Venoxis",
	aspectvenoxis_desc = "Warnings for the extra ability Hakkar gains when High Priest Venoxis is still alive.",
	
	aspectmarli_name = "Aspect of Mar'li",
	aspectmarli_desc = "Warnings for the extra ability Hakkar gains when High Priestess Mar'li is still alive.",
	
	aspectthekal_name = "Aspect of Thekal",
	aspectthekal_desc = "Warnings for the extra ability Hakkar gains when High Priest Thekal is still alive.",

	aspectarlokk_name = "Aspect of Arlokk",
	aspectarlokk_desc = "Warnings for the extra ability Hakkar gains when High Priestess Arlokk is still alive.",
	
	puticon_name = "Raid icon on MCed players",
	puticon_desc = "Place a raid icon on the player with Cause Insanity.\n\n(Requires assistant or higher)",
	
	-- triggers
	trigger_engage = "FACE THE WRATH OF THE SOULFLAYER!",
	trigger_siphon = "Hakkar gains Blood Siphon.",
	trigger_poisonousBlood = "You are afflicted by Poisonous Blood.",
	trigger_mindControlYou = "You are afflicted by Cause Insanity.",
	trigger_mindControlOther = "(.+) is afflicted by Cause Insanity.",
	trigger_flee = "Fleeing will do you no good, mortals!",
	trigger_aspectOfThekal = "Hakkar gains Aspect of Thekal.",
	trigger_aspectOfThekalGone = "Aspect of Thekal fades from Hakkar.",
	trigger_aspectOfMarliYou = "You are afflicted by Aspect of Mar'li.",
	trigger_aspectOfMarliYouImmune = "Hakkar 's Aspect of Mar'li failed. You are immune.",
	trigger_aspectOfMarliOther = "(.+) is afflicted by Aspect of Mar'li.",
	trigger_aspectOfMarliOtherImmune = "Hakkar 's Aspect of Mar'li fails. (.+) is immune.",
	trigger_aspectOfMarliGeneralAvoid = "Hakkar 's Aspect of Mar'li",
	trigger_aspectOfJeklikYou = "You are afflicted by Aspect of Jeklik.",
	trigger_aspectOfJeklikYouImmune = "Hakkar 's Aspect of Jeklik failed. You are immune.",
	trigger_aspectOfJeklikOther = "(.+) is afflicted by Aspect of Jeklik.",
	trigger_aspectOfJeklikOtherImmune = "Hakkar 's Aspect of Jeklik fails. (.+) is immune.",
	trigger_aspectOfJeklikGeneralAvoid = "Hakkar 's Aspect of Jeklik",
	trigger_aspectOfArlokkYou = "You are afflicted by Aspect of Arlokk.",
	trigger_aspectOfArlokkYouImmune = "Hakkar 's Aspect of Arlokk failed. You are immune.",
	trigger_aspectOfArlokkOther = "(.+) is afflicted by Aspect of Arlokk.",
	trigger_aspectOfArlokkOtherImmune = "Hakkar 's Aspect of Arlokk fails. (.+) is immune.",
	trigger_aspectOfArlokkGeneralAvoid = "Hakkar 's Aspect of Arlokk",
	trigger_aspectOfVenoxisYou = "Hakkar 's Aspect of Venoxis hits you for",
	trigger_aspectOfVenoxisYouResist = "Hakkar 's Aspect of Venoxis was resisted.",
	trigger_aspectOfVenoxisOther = "Hakkar 's Aspect of Venoxis hits",
	trigger_aspectOfVenoxisOtherResist = "Hakkar 's Aspect of Venoxis was resisted by",
	
	-- messages
	msg_siphonSoon = "Blood Siphon in %d seconds!",
	msg_siphonNow = "Blood Siphon - next one in 90 seconds!",
	msg_enrage5m = "Enrage in 5 minutes!",
	msg_enrage1m = "Enrage in 1 minute!",
	msg_enrageSeconds = "Enrage in %d seconds!",

	msg_mindControlOther = "%s is mindcontrolled!",
	msg_mindControlYou = "You are mindcontrolled!",
	
	msg_aspectOfThekal = "Frenzy! Tranq now!",
	
	-- bars
	bar_mindControl = "MC: %s",
	bar_firstMindControl = "First MC",
	bar_nextMindControl = "Next MC",
	bar_enrage = "Enrage",
	bar_siphon = "Blood Siphon",
	bar_aspectOfThekalNext = "Next Frenzy",
	bar_aspectOfThekal = "Frenzy - Aspect of Thekal",
	bar_aspectOfMarliNext = "Next Stun",
	bar_aspectOfMarliDebuff = "Stun: %s - Aspect of Mar'li",
	bar_aspectOfJeklikNext = "Next Silence",
	bar_aspectOfJeklikDebuff = "Silence - Aspect of Jeklik",
	bar_aspectOfArlokkNext = "Next Vanish",
	bar_aspectOfArlokkDebuff = "Vanish: %s - Aspect of Arlokk",
	bar_aspectOfVenoxisNext = "Next Poison",
	bar_aspectOfVenoxisDebuff = "Poison - Aspect of Venoxis",
	
	-- misc

} end)
