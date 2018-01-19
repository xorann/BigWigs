------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.aq20.rajaxx
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Rajaxx",

	-- commands
	wave_cmd = "wave",
	wave_name = "Wave Alert",
	wave_desc = "Warn for incoming waves",

	-- triggers
	--[[trigger0 = "Remember, Rajaxx, when I said I'd kill you last?",
	trigger1 = "Kill first, ask questions later... Incoming!",
	trigger2 = "?????",  -- There is no callout for wave 2 ><
	trigger3 = "The time of our retribution is at hand! Let darkness reign in the hearts of our enemies!",
	trigger4 = "No longer will we wait behind barred doors and walls of stone! No longer will our vengeance be denied! The dragons themselves will tremble before our wrath!",
	trigger5 = "Fear is for the enemy! Fear and death!",
	trigger6 = "Staghelm will whimper and beg for his life, just as his whelp of a son did! One thousand years of injustice will end this day!",
	trigger7 = "Fandral! Your time has come! Go and hide in the Emerald Dream and pray we never find you!",
	trigger8 = "Impudent fool! I will kill you myself!",
	trigger10 = "I lied...",
    
    trigger2_2 = "Kill ",
      
	-- messages
    warn0 = "Wave 1/8", -- trigger for starting the event by pulling the first wave instead of talking to andorov
	warn1 = "Wave 1/8",
	warn2 = "Wave 2/8",
	warn3 = "Wave 3/8",
	warn4 = "Wave 4/8",
	warn5 = "Wave 5/8",
	warn6 = "Wave 6/8",
	warn7 = "Wave 7/8",
	warn8 = "Incoming General Rajaxx",]]
	
	-- bars
	
	-- misc

} end )


L:RegisterTranslations("deDE", function() return {
	-- commands
	wave_name = "Wellen",
	wave_desc = "Warnung vor den ankommenden Gegner Wellen.",

	-- triggers
    --[[trigger0 = "Erinnerst du dich daran, Rajaxx, wann ich dir das letzte Mal sagte, ich w\195\188rde dich t\195\182ten?",
	trigger1 = "Hier kommen sie. Bleibt am Leben, Welpen.",
	trigger2 = "?????",  -- There is no callout for wave 2 ><
	trigger3 = "Die Zeit der Vergeltung ist gekommen!",
	trigger4 = "Wir werden nicht l\195\164nger hinter verbarrikadierten Toren und Mauern aus Stein ausharren!",
	trigger5 = "Wir kennen keine Furcht!",
	trigger6 = "Staghelm wird winseln und um sein Leben betteln, genau wie sein r\195\164udiger Sohn!",
	trigger7 = "Fandral! Deine Zeit ist gekommen!",
	trigger8 = "Unversch\195\164mter Narr! Ich werde Euch h\195\182chstpers\195\182nlich t\195\182ten!",
	
	-- messages
    warn0 = "Welle 1/8", -- trigger for starting the event by pulling the first wave instead of talking to andorov
	warn1 = "Welle 1/8",
	warn2 = "Welle 2/8",
	warn3 = "Welle 3/8",
	warn4 = "Welle 4/8",
	warn5 = "Welle 5/8",
	warn6 = "Welle 6/8",
	warn7 = "Welle 7/8",
	warn8 = "General Rajaxx kommt!",]]
	
	-- bars
	
	-- misc
	
} end )