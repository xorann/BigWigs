------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.thaddius
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Thaddius",

	-- commands
	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	phase_cmd = "phase",
	phase_name = "Phase Alerts",
	phase_desc = "Warn for Phase transitions",

	polarity_cmd = "polarity",
	polarity_name = "Polarity Shift Alert",
	polarity_desc = "Warn for polarity shifts",

	power_cmd = "power",
	power_name = "Power Surge Alert",
	power_desc = "Warn for Stalagg's power surge",

	adddeath_cmd = "adddeath",
	adddeath_name = "Add Death Alert",
	adddeath_desc = "Alerts when an add dies.",

	charge_cmd = "charge",
	charge_name = "Charge Alert",
	charge_desc = "Warn about Positive/Negative charge for yourself only.",

	throw_cmd = "throw",
	throw_name = "Throw Alerts",
	throw_desc = "Warn about tank platform swaps.",

	-- triggers
	trigger_enrage = "%s goes into a berserker rage!",
	trigger_engage1 = "Stalagg crush you!",
	trigger_engage2 = "Feed you to master!",
	trigger_phase2_1 = "EAT YOUR BONES",
	trigger_phase2_2 = "BREAK YOU!",
	trigger_phase2_3 = "KILL!",
	trigger_addDeathFeugen = "No... more... Feugen...",
	trigger_addDeathStalagg = "Master save me...",
	trigger_polarityShift = "Now YOU feel pain!",
	trigger_polarityShiftCast = "Thaddius begins to cast Polarity Shift",
	--trigger_charge = "You are afflicted by (%w+) Charge.",
	trigger_stalagg = "Stalagg gains Power Surge.",

	-- messages
	msg_enrage = "Enrage!",
	msg_phase1 = "Thaddius Phase 1",
	msg_phase2 = "Thaddius Phase 2, Enrage in 5 minutes!",
	msg_bossActive = "Thaddius incoming in 10-20sec!",
	msg_polarityShiftNow = "Thaddius begins to cast Polarity Shift! - CHECK DEBUFF!",
	msg_polarityShift3 = "3 seconds to Polarity Shift!",
	msg_positiveCharge = "You changed to a Positive Charge!",
	msg_negativeCharge = "You changed to a Negative Charge!",
	msg_noChange = "Your debuff did not change!",
	msg_enrage3m = "Enrage in 3 minutes",
	msg_enrage90 = "Enrage in 90 seconds",
	msg_enrage60 = "Enrage in 60 seconds",
	msg_enrage30 = "Enrage in 30 seconds",
	msg_enrage10 = "Enrage in 10 seconds",
	msg_stalagg = "Power Surge on Stalagg!",
	msg_throw = "Throw in ~5 seconds!",
	
	-- bars
	bar_polarityTick = "Polarity tick",
	bar_enrage = "Enrage",
	bar_powerSurge = "Power Surge",
	bar_throw = "Throw",
	bar_polarityShiftCast = "Polarity Shift",
	bar_polarityShiftNext = "Next Polarity Shift",
	bar_bossActive = "Boss active",
	
	-- misc
	misc_positiveCharge = "Spell_ChargePositive", -- Interface\\Icons\\Spell_ChargePositive
	misc_negativeCharge = "Spell_ChargeNegative", -- Interface\\Icons\\Spell_ChargeNegative

} end )

L:RegisterTranslations("deDE", function() return {
	--cmd = "Thaddius",

	-- commands
	--enrage_cmd = "enrage",
	enrage_name = "Wutanfall Alarm",
	enrage_desc = "Warnung für Wutanfall",

	--phase_cmd = "phase",
	phase_name = "Phasen Alarm",
	phase_desc = "Warnung für Phasenübergang",

	--polarity_cmd = "polarity",
	polarity_name = "Polaritätsveränderung Alarm",
	polarity_desc = "Warung für Polaritätsveränderung",

	--power_cmd = "power",
	power_name = "Power Surge Alert",
	power_desc = "Warn for Stalagg's power surge",

	--adddeath_cmd = "adddeath",
	adddeath_name = "Add Tot Alarm",
	adddeath_desc = "Warnung wenn ein Add stirbt.",

	--charge_cmd = "charge",
	charge_name = "Ladung Alarm",
	charge_desc = "Warnung für positive/negative Ladung auf dir selber.",

	--throw_cmd = "throw",
	throw_name = "Wurf Alaram",
	throw_desc = "Warnung für die Tankplatformwechsel.",

	-- triggers
	trigger_enrage = "%s goes into a berserker rage!",
	trigger_engage1 = "Stalagg crush you!",
	trigger_engage2 = "Feed you to master!",
	trigger_phase2_1 = "EAT YOUR BONES",
	trigger_phase2_2 = "BREAK YOU!",
	trigger_phase2_3 = "KILL!",
	trigger_addDeathFeugen = "No... more... Feugen...",
	trigger_addDeathStalagg = "Master save me...",
	trigger_polarityShift = "Now YOU feel pain!",
	trigger_polarityShiftCast = "Thaddius beginnt Polaritätsveränderung zu wirken.",
	--trigger_charge = "You are afflicted by (%w+) Charge.",
	trigger_stalagg = "Stalagg gains Power Surge.",

	-- messages
	msg_enrage = "Wutanfall!",
	msg_phase1 = "Thaddius Phase 1",
	msg_phase2 = "Thaddius Phase 2, Wutanfall in 5 Minuten!",
	msg_bossActive = "Thaddius aktiv in 20s!",
	msg_polarityShiftNow = "Polaritätsveränderung! - DEBUFF KONTROLLIEREN!",
	msg_polarityShift3 = "3 Sekunden bis Polaritätsveränderung!",
	msg_positiveCharge = "Positiven Aufladung!",
	msg_negativeCharge = "Negative Aufladung!",
	msg_noChange = "Dein Debuff ist gleich geblieben!",
	msg_enrage3m = "Wutanfall in 3 Minuten",
	msg_enrage90 = "Wutanfall in 90 Sekunden",
	msg_enrage60 = "Wutanfall in 60 Sekunden",
	msg_enrage30 = "Wutanfall in 30 Sekunden",
	msg_enrage10 = "Wutanfall in 10 Sekunden",
	msg_stalagg = "Power Surge on Stalagg!",
	msg_throw = "Wurf in 5 Sekunden!",
	
	-- bars
	bar_polarityTick = "Polaritätstick",
	bar_enrage = "Wutanfall",
	bar_powerSurge = "Power Surge",
	bar_throw = "Wurf",
	bar_polarityShift = "Polaritätsveränderung",
	bar_bossActive = "Boss aktiv",
	
	-- misc
	misc_positiveCharge = "Spell_ChargePositive", -- Interface\\Icons\\Spell_ChargePositive
	misc_negativeCharge = "Spell_ChargeNegative", -- Interface\\Icons\\Spell_ChargeNegative

} end )