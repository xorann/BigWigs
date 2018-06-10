------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.naxx.horsemen
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Horsemen",

	-- commands
	mark_cmd = "mark",
	mark_name = "Mark Alerts",
	mark_desc = "Warn for marks",

	shieldwall_cmd  = "shieldwall",
	shieldwall_name = "Shieldwall Alerts",
	shieldwall_desc = "Warn for shieldwall",

	void_cmd = "void",
	void_name = "Void Zone Alerts",
	void_desc = "Warn on Lady Blaumeux casting Void Zone.",

	meteor_cmd = "meteor",
	meteor_name = "Meteor Alerts",
	meteor_desc = "Warn on Thane casting Meteor.",

	wrath_cmd = "wrath",
	wrath_name = "Holy Wrath Alerts",
	wrath_desc = "Warn on Zeliek casting Wrath.",

	-- triggers
	trigger_mark = "is afflicted by Mark of ",
	trigger_void = "Lady Blaumeux casts Void Zone.",
	trigger_meteor = "Thane Korth'azz's Meteor hits ",
	trigger_wrath = "Sir Zeliek's Holy Wrath hits ",
	trigger_shieldWall = "(.*) gains Shield Wall.",
	--trigger_voidHit = "Void Zone's Consumption hits you"
	-- messages
	msg_markNow = "Mark %d!",
	msg_markSoon = "Mark %d in 5 sec",
	msg_voidZone = "Void Zone Incoming",
	msg_meteor = "Meteor!",
	msg_wrath = "Holy Wrath!",
	msg_engage = "The Four Horsemen Engaged! Mark in ~17 sec",
	msg_shieldWallGain = "%s - Shield Wall for 20 sec",
	msg_shieldWallGone = "%s - Shield Wall GONE!",
	
	-- bars
	bar_mark = "Mark %d",
	bar_void = "Void Zone",
	bar_meteor = "Meteor",
	bar_wrath = "Holy Wrath",
	bar_shieldWall = "%s - Shield Wall",
	
	-- misc

} end )
