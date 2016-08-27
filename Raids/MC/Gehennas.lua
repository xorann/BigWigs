
----------------------------------
--      Module Declaration      --
----------------------------------

-- override
local bossName = "Gehennas"

-- do not override
local boss = AceLibrary("Babble-Boss-2.2")[bossName]
local module = BigWigs:NewModule(boss)
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
--module.bossSync = bossName -- untranslated string

-- override
module.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
module.revision = 20003 -- To be overridden by the module!
module.enabletrigger = boss -- string or table {boss, add1, add2}
module.toggleoptions = {"adds", "curse", "bosskill"}


---------------------------------
--      Module specific Locals --
---------------------------------

local timer = {
	firstCurse = 12,
	firstRain = 10,
	rainTick = 2,
	rainDuration = 6,
	nextRain = 15,
	curse = 31,
}
local icon = {
	curse = "Spell_Shadow_BlackPlague",
	rain = "Spell_Shadow_RainOfFire",
}
local syncName = {
	curse = "GehennasCurse",
	add = "GehennasAddDead"
}

local flamewaker = 0


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	curse_trigger = "afflicted by Gehennas",
	--bolt_trigger = "Gehennas begins to cast Shadow Bolt",
	rain_trigger = "You are afflicted by Rain of Fire",
	rain_run_trigger = "You suffer (%d+) (.+) from "..boss.." 's Rain of Fire.",
	curse_trigger2 = "Gehennas' Curse was resisted",
	dead1 = "Flamewaker dies",
	addmsg = "%d/2 Flamewakers dead!",
	flamewaker_name = "Flamewaker",

    barNextRain = "Next Rain",
            
	curse_warn_soon = "5 seconds until Gehennas' Curse!",
	curse_warn_now = "Gehennas' Curse - Decurse NOW!",

	curse_bar = "Gehennas' Curse",
	firewarn = "Move from FIRE!",

	cmd = "Gehennas",
	
	adds_cmd = "adds",
	adds_name = "Dead adds counter",
	adds_desc = "Announces dead Flamewakers",
	
	curse_cmd = "curse",
	curse_name = "Gehennas' Curse alert",
	curse_desc = "Warn for Gehennas' Curse",
} end)

L:RegisterTranslations("deDE", function() return {
	curse_trigger = "von Gehennas(.+)Fluch betroffen",
	--bolt_trigger = "Gehennas beginnt Schattenblitz",
	rain_trigger = "Ihr seid von Feuerregen betroffen",
	rain_run_trigger = "Ihr erleidet (%d+) (.+) von "..boss.." Feuerregen.",	
	
	curse_trigger2 = "Gehennas\' Fluch(.+) widerstanden",
	dead1 = "Feuerschuppe stirbt",
	addmsg = "%d/2 Feuerschuppe tot!",
	flamewaker_name = "Feuerschuppe",

    barNextRain = "N\195\164chster Regen",
            
	curse_warn_soon = "5 Sekunden bis Gehennas' Fluch!",
	curse_warn_now = "Gehennas' Fluch - JETZT Entfluchen!",

	curse_bar = "Gehennas' Fluch",
	firewarn = "Raus aus dem Feuer!",

	cmd = "Gehennas",
	
	adds_cmd = "adds",
	adds_name = "Z\195\164hler f\195\188r tote Adds",
	adds_desc = "Verk\195\188ndet Feuerschuppe Tod",
	
	curse_cmd = "curse",
	curse_name = "Alarm f\195\188r Gehennas' Fluch",
	curse_desc = "Warnen vor Gehennas' Fluch",
} end)


------------------------------
--      Initialization      --
------------------------------

module.wipemobs = { L["flamewaker_name"] }

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",        "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE",            "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_FRIENDLYPLAYER_DAMAGE",  "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE",              "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE",     "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",               "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
    self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	
	self:ThrottleSync(10, syncName.curse)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.started = false
	flamewaker = 0
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.curse then
		self:DelayedMessage(timer.firstCurse - 5, L["curse_warn_soon"], "Urgent")
		self:Bar(L["curse_bar"], timer.firstCurse, icon.curse)
	end
	self:Bar(L["barNextRain"], timer.firstRain, icon.rain)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

function module:Event(msg)
    if string.find(msg, L["rain_run_trigger"]) then
        -- I found no better way to trigger this, it will autohide after 2s which is the time between Rain of Fire ticks
        self:WarningSign(icon.rain, timer.rainTick)
    elseif ((string.find(msg, L["curse_trigger"])) or (string.find(msg, L["curse_trigger2"]))) then
		self:Sync(syncName.curse)
	elseif (string.find(msg, L["rain_trigger"])) then
        -- this will not trigger, but I will leave it in case they fix this combatlog event/message
		self:Message(L["firewarn"], "Attention", "Alarm")
        self:WarningSign(icon.rain, timer.rainDuration)
        self:DelayedBar(timer.rainDuration, L["barNextRain"], timer.nextRain - timer.rainDuration, icon.rain)
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
    if string.find(msg, "Rain of Fire") then
        -- this will not trigger, but I will leave it in case they fix this combatlog event/message
        self:RemoveWarningSign(icon.rain)
    end
end

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
    --DEFAULT_CHAT_FRAME:AddMessage("CHAT_MSG_COMBAT_HOSTILE_DEATH: " .. msg)
	if string.find(msg, L["dead1"]) then
		self:Sync(syncName.add .. " " .. tostring(flamewaker + 1))
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.curse and self.db.profile.curse then
		self:DelayedMessage(timer.curse - 5, L["curse_warn_soon"], "Urgent")
		self:Bar(self, L["curse_bar"], timer.curse, icon.curse)
	elseif sync == syncName.add and rest and rest ~= "" then
        rest = tonumber(rest)
        if rest <= 2 and flamewaker < rest then
            flamewaker = rest
            self:Message(string.format(L["addmsg"], flamewaker), "Positive")
        end
	end
end
