------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.aq40.ouro
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Ouro",

	-- commands
	sweep_cmd = "sweep",
	sweep_name = "Sweep Alert",
	sweep_desc = "Warn for Sweeps",
	sandblast_cmd = "sandblast",
	sandblast_name = "Sandblast Alert",
	sandblast_desc = "Warn for Sandblasts",
	emerge_cmd = "emerge",
	emerge_name = "Emerge Alert",
	emerge_desc = "Warn for Emerge",
	submerge_cmd = "submerge",
	submerge_name = "Submerge Alert",
	submerge_desc = "Warn for Submerge",
	berserk_cmd = "berserk",
	berserk_name = "Berserk",
	berserk_desc = "Warn for when Ouro goes berserk",

	-- triggers
	trigger_sweep = "Ouro begins to cast Sweep",
	trigger_sandBlast = "Ouro begins to perform Sand Blast",
	trigger_emerge = "Dirt Mound dies",
	--trigger_emerge = "Dirt Mound casts Summon Ouro Scarabs.",
	trigger_submerge = "Ouro casts Summon Ouro Mounds.",
	trigger_bersek = "Ouro gains Berserk.",

	-- messages
	msg_sweep = "Sweep!",
	msg_sweepSoon = "5 seconds until Sweep!",
	msg_sandBlastNow = "Incoming Sand Blast!",
	msg_sandBlastSoon = "5 seconds until Sand Blast!",
	msg_emerge = "Ouro has emerged!",
	msg_submergeSoon = "15 sec to possible submerge!",
	msg_submerge = "Ouro has submerged!",
	msg_emergeSoon = "5 seconds until Ouro Emerges!",
	msg_berserk = "Berserk - Berserk!",
	msg_berserkSoon = "Berserk Soon - Get Ready!",

	-- bars
	bar_sweepFirst = "Possible Sweep",
	bar_sweep = "Sweep",
	bar_sandBlast = "Possible Sand Blast",
	bar_submerge = "Possible submerge",
	bar_emerge = "Ouro Emerge",

	-- misc
}
end)

L:RegisterTranslations("deDE", function() return {
	-- commands
	sweep_name = "Feger",
	sweep_desc = "Warnung, wenn Ouro Feger wirkt.",
	sandblast_name = "Sandsto\195\159",
	sandblast_desc = "Warnung, wenn Ouro Sandsto\195\159 wirkt.",
	emerge_name = "Auftauchen",
	emerge_desc = "Warnung, wenn Ouro auftaucht.",
	submerge_name = "Untertauchen",
	submerge_desc = "Warnung, wenn Ouro untertaucht.",
	berserk_name = "Berserk",
	berserk_desc = "Warnung, wenn Ouro Berserkerwut bekommt.",

	-- triggers
	trigger_sweep = "Ouro beginnt Feger zu wirken.", -- ?
	trigger_sandBlast = "Ouro beginnt Sandstoß auszuführen.", -- ?
	--trigger_emerge = "Dirt Mound casts Summon Ouro Scarabs.",
	trigger_emerge = "Erdhaufen stirbt.", -- ?
	trigger_submerge = "Ouro casts Summon Ouro Mounds.", -- ?
	trigger_bersek = "Ouro bekommt 'Berserker'.",

	-- messages
	msg_sweep = "Feger!",
	msg_sweepSoon = "5 Sekunden bis Feger!",
	msg_sandBlastNow = "Sandsto\195\159 in K\195\188rze!",
	msg_sandBlastSoon = "5 Sekunden bis Sandsto\195\159!",
	msg_emerge = "Ouro ist aufgetaucht!",
	msg_submergeSoon = "15 sek bis mögliches Untertauchen!",
	msg_submerge = "Ouro ist aufgetaucht!",
	msg_emergeSoon = "5 Sekunden bis Ouro auftaucht!",
	msg_berserk = "Berserk - Berserk!",
	msg_berserkSoon = "Berserkerwut in K\195\188rze - Bereit machen!",

	-- bars
	bar_sweep = "Feger",
	bar_sweepFirst = "Möglicher Feger",
	bar_sandBlast = "Möglicher Sandsto\195\159",
	bar_submerge = "Mögliches Untertauchen",
	bar_emerge = "Auftauchen",

	-- misc
}
end)
