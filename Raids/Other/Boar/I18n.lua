------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.other.boar
local L = BigWigs.i18n[bossName]


L:RegisterTranslations("enUS", function() return {
	cmd = "Elder-Mottled-Boar",

	-- commands	
    engage_cmd = "engage", -- <name>_cmd
    engage_name = "Engage Alert", -- <name>_name
    engage_desc = "Warn for Engage", -- <name>_desc
	
	charge_cmd = "charge",
    charge_name = "Charge Alert",
    charge_desc = "Warn for Charge",
	
	proximity_cmd = "proximity",
    proximity_name = "Proximity Warning",
    proximity_desc = "Show Proximity Warning Frame",
	
	-- triggers
	trigger_charge = "gains Boar Charge",
    trigger_vulnerability = "^[%w]+[%s's]* ([%w%s:]+) ([%w]+) Elder Mottled Boar for ([%d]+) ([%w]+) damage%.[%s%(]*([%d]*)",
    trigger_umlaut = "hits you for",
    
	-- messages
    msg_engage = "Boar engaged! Be careful.",
    msg_teleport = "Teleport", 
	msg_charge = "Boar is charging!",
    
	-- bars
	bar_charge = "Charge",
    
	-- misc
	
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	engage_name = "Pull Warnung",
    engage_desc = "Warnung beim Pull",
	
	charge_name = "Ansturm Warnung",
    charge_desc = "Warnung f\195\188r anst\195\188rmen",
	
    proximity_name = "Nähe Warnungsfenster",
    proximity_desc = "Zeit das Nähe Warnungsfenster",
	
	-- triggers
	trigger_charge = "bekommt 'Eberangriff'", -- uebersetzung?
	trigger_vulnerability = "^[%w]+[%s's]* ([%w%s:]+) ([%w]+) Elder Mottled Boar for ([%d]+) ([%w]+) damage%.[%s%(]*([%d]*)",
    trigger_umlaut = "trifft Euch für",
	
	-- messages
    msg_engage = "Eber gepullt! Sei vorsichtig.",
	msg_teleport = "Teleport",
	msg_charge = "Eber st\195\188rmt an!",
	
	-- bars
	bar_charge = "Anst\195\188rmen",
	
	-- misc

} end )
