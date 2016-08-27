
----------------------------------
--      Module Declaration      --
----------------------------------

-- override
local bossName = "Shazzrah"

-- do not override
local boss = AceLibrary("Babble-Boss-2.2")[bossName]
local module = BigWigs:NewModule(boss)
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
--module.bossSync = bossName -- untranslated string

-- override
module.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
module.revision = 20003 -- To be overridden by the module!
module.enabletrigger = boss -- string or table {boss, add1, add2}
module.toggleoptions = {"curse", "deaden", "blink", "counterspell", "bosskill"}

-- Proximity Plugin
-- module.proximityCheck = function(unit) return CheckInteractDistance(unit, 2) end
-- module.proximitySilent = false

---------------------------------
--      Module specific Locals --
---------------------------------

local timer = {
	cs = 12.5,
    firstCS = 10,
    curse =  22, 
    firstCurse = 10,
    blink = 45,
    firstBlink = 30,
    deaden = 30,
    firstDeaden = 24,
}
local icon = {
    cs = "Spell_Frost_IceShock",
    curse = "Spell_Shadow_AntiShadow",
    blink = "Spell_Arcane_Blink",
    deaden = "Spell_Holy_SealOfSalvation",
}
local syncName = {
	cs = "ShazzrahCounterspell1",
    curse = "ShazzrahCurse1",
    blink = "ShazzrahBlink1",
    deaden = "ShazzrahDeadenMagicOn",
    deadenOver = "ShazzrahDeadenMagicOff",
}

local _, playerClass = UnitClass("player")
local firstblink = true

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	blink_trigger = "casts Gate of Shazzrah",
	deaden_trigger = "Shazzrah gains Deaden Magic",
	curse_trigger = "afflicted by Shazzrah",
	cs_trigger2 = "Shazzrah casts Counterspell",
    cs_trigger = "Shazzrah(.+) Counterspell was resisted by",
	curse_trigger2 = "Shazzrah(.+) Curse was resisted",
	deaden_over_trigger = "Deaden Magic fades from Shazzrah",

	blink_warn = "Blink - 45 seconds until next one!",
	blink_soon_warn = "3 seconds to Blink!",
	deaden_warn = "Deaden Magic is up! Dispel it!",
	curse_warn = "Shazzrah's Curse! Decurse NOW!",
	cs_now_warn = "Counterspell! ~18 seconds until next one!",
	cs_soon_warn = "3 seconds until Counterspell!",

	blink_bar = "Possible Blink",
	deaden_bar = "Deaden Magic",
	curse_bar = "Shazzrah's Curse",
	cs_bar = "Counterspell",

	cmd = "Shazzrah",
	
            
    -- counterspell after blink 2s later
	counterspell_cmd = "counterspell",
	counterspell_name = "Counterspell alert",
	counterspell_desc = "Warn for Shazzrah's Counterspell",
	
	curse_cmd = "curse",
	curse_name = "Shazzrah's Curse alert",
	curse_desc = "Warn for Shazzrah's Curse",
	
	deaden_cmd = "deaden",
	deaden_name = "Deaden Magic alert",
	deaden_desc = "Warn when Shazzrah has Deaden Magic",
	
	blink_cmd = "blink",
	blink_name = "Blink alert",
	blink_desc = "Warn when Shazzrah Blinks",
} end)

L:RegisterTranslations("deDE", function() return {
	blink_trigger = "Shazzrah wirkt Portal von Shazzrah",
	deaden_trigger = "Shazzrah bekommt \'Magie d\195\164mpfen",
	curse_trigger = "von Shazzrahs Fluch betroffen",
	cs_trigger2 = "Shazzrah wirkt Gegenzauber",
    cs_trigger = "Shazzrahs Gegenzauber wurde von (.+) widerstanden",
	curse_trigger2 = "Shazzrahs Fluch(.)widerstanden",
	deaden_over_trigger = "Magie d\195\164mpfen schwindet von Shazzrah",

	blink_warn = "Blinzeln! N\195\164chstes in ~45 Sekunden!",
	blink_soon_warn = "Blinzeln in ~5 Sekunden!",
	deaden_warn = "Magie d\195\164mpfen auf Shazzrah! Entferne magie!",
	curse_warn = "Shazzrahs Fluch! Entfluche JETZT!",
	cs_now_warn = "Gegenzauber - 40 Sekunden bis zum n\195\164chsten!",
	cs_soon_warn = "3 Sekunden bis Gegenzauber!",

	blink_bar = "Mögliches Blinzeln",
	deaden_bar = "Magie d\195\164mpfen",
	curse_bar = "N\195\164chster Fluch",
	cs_bar = "N\195\164chster Gegenzauber",
	
	cmd = "Shazzrah",
	
	counterspell_cmd = "Gegenzauber",
	counterspell_name = "Alarm f\195\188r Gegenzauber",
	counterspell_desc = "Warnen vor Shazzrahs Gegenzauber",
	
	curse_cmd = "curse",
	curse_name = "Alarm f\195\188r Shazzrahs Fluch",
	curse_desc = "Warnen vor Shazzrahs Fluch",
	
	deaden_cmd = "deaden",
	deaden_name = "Alarm f\195\188r Magie d\195\164mpfen",
	deaden_desc = "Warnen wenn Shazzrah Magie d\195\164mpfen hat",
	
	blink_cmd = "blink",
	blink_name = "Alarm f\195\188r Blinzeln",
	blink_desc = "Warnen wenn Shazzrah blinzelt",
} end)


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_BUFF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
	
	self:ThrottleSync(10, syncName.blink)
    self:ThrottleSync(10, syncName.curse)
    self:ThrottleSync(5, syncName.deaden)
    self:ThrottleSync(5, syncName.deadenOver)
    self:ThrottleSync(5, syncName.cs)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	firstblink = true
end

-- called after boss is engaged
function module:OnEngage()        
    if self.db.profile.counterspell then
        self:Bar(L["cs_bar"], timer.firstCS, icon.cs)
    end
    self:DelayedSync(timer.firstCS, syncName.cs)
    
    if self.db.profile.blink then
        self:Bar(L["blink_bar"], timer.firstBlink, icon.blink)
    end
    self:DelayedSync(timer.firstBlink, syncName.blink)
    
    if self.db.profile.curse then
        self:Bar(L["curse_bar"], timer.firstCurse, icon.curse)
    end
    if self.db.profile.deaden then
        self:Bar(L["deaden_bar"], timer.firstDeaden, icon.deaden)
    end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end

------------------------------
--      Event Handlers      --
------------------------------

function module:Event(msg)
	if (string.find(msg, L["deaden_trigger"])) then
		self:Sync(syncName.deaden)
	elseif (string.find(msg, L["deaden_over_trigger"])) then
		self:Sync(syncName.deadenOver)
	elseif (string.find(msg, L["blink_trigger"])) then
		self:Sync(syncName.blink)
	elseif (string.find(msg, L["cs_trigger2"]) or string.find(msg, L["cs_trigger"])) then
		self:Sync(syncName.cs)
	elseif (string.find(msg, L["curse_trigger"]) or string.find(msg, L["curse_trigger2"])) then
		self:Sync(syncName.curse)
	end
end

------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.blink then
        self:Blink()
	elseif sync == syncName.deaden  then
        self:DeadenMagic()
	elseif sync == syncName.deadenOver then
		self:DeadenMagicOver()
	elseif sync == syncName.curse then
		self:Curse()
	elseif sync == syncName.cs then
		self:Counterspell()
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:Counterspell()
    if self.db.profile.counterspell then
        self:Bar(L["cs_bar"], timer.cs, icon.cs)
    end
    self:DelayedSync(timer.cs, syncName.cs)
end

function module:Curse()
    self:Message(L["curse_warn"], "Attention", "Alarm")
    self:Bar(L["curse_bar"], timer.curse, icon.curse)
end

function module:Blink()
	firstblink = false
    self:KTM_Reset()
    
    if self.db.profile.blink then
        self:Message(L["blink_warn"], "Important")
        self:Bar(L["blink_bar"], timer.blink, icon.blink)
        
        self:DelayedMessage(timer.blink - 5, L["blink_soon_warn"], "Attention", "Alarm")
    end
    
    self:DelayedSync(timer.blink, syncName.blink)
end

function module:DeadenMagic()
    if self.db.profile.deaden then
        self:RemoveBar(L["deaden_bar"])
        self:Message(L["deaden_warn"], "Important")
        self:Bar(L["deaden_bar"], timer.deaden, icon.deaden)
        if playerClass == "SHAMAN" or playerClass == "PRIEST" then
            self:WarningSign(icon.deaden, timer.deaden)
        end
    end
end

function module:DeadenMagicOver()
    if self.db.profile.deaden then
        self:RemoveBar(L["deaden_bar"])
        if playerClass == "SHAMAN" or playerClass == "PRIEST" then
            self:RemoveWarningSign(icon.deaden)
        end
    end
end