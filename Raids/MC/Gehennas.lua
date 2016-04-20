------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Gehennas"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	trigger1 = "afflicted by Gehennas",
	--trigger2 = "Gehennas begins to cast Shadow Bolt",
	trigger3 = "You are afflicted by Rain of Fire",
	trigger4 = "Gehennas' Curse was resisted",
	dead1 = "Flamewaker dies",
	addmsg = "%d/2 Flamewakers dead!",
	flamewaker_name = "Flamewaker",

	warn1 = "5 seconds until Gehennas' Curse!",
	warn2 = "Gehennas' Curse - Decurse NOW!",

	bar1text = "Gehennas' Curse",
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
	trigger1 = "von Gehennas(.+)Fluch betroffen",
	--trigger2 = "Gehennas beginnt Schattenblitz",
	trigger3 = "Ihr seid von Feuerregen betroffen",
	trigger4 = "Gehennas\' Fluch(.+) widerstanden",
	dead1 = "Flammensch\195\188rer stirbt",
	addmsg = "%d/2 Flammensch\195\188rer tot!",
	flamewaker_name = "Flammensch\195\188rer",

	warn1 = "5 Sekunden bis Gehennas' Fluch!",
	warn2 = "Gehennas' Fluch - JETZT Entfluchen!",

	bar1text = "Gehennas' Fluch",
	firewarn = "Raus aus dem Feuer!",

	cmd = "Gehennas",
	
	adds_cmd = "adds",
	adds_name = "Z\195\164hler f\195\188r tote Adds",
	adds_desc = "Verk\195\188ndet Flammensch\195\188rer Tod",
	
	curse_cmd = "curse",
	curse_name = "Alarm f\195\188r Gehennas' Fluch",
	curse_desc = "Warnen vor Gehennas' Fluch",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGehennas = BigWigs:NewModule(boss)
BigWigsGehennas.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsGehennas.enabletrigger = boss
BigWigsGehennas.bossSync = "Gehennas"
BigWigsGehennas.wipemobs = { L["flamewaker_name"] }
BigWigsGehennas.toggleoptions = {"adds", "curse", "bosskill"}
BigWigsGehennas.revision = tonumber(string.sub("$Revision: 11204 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGehennas:OnEnable()
    self.started    = false
	self.flamewaker = 0
	
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",        "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE",            "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_FRIENDLYPLAYER_DAMAGE",  "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE",              "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE",     "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",               "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
    self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
    self:RegisterEvent("PLAYER_REGEN_DISABLED",     "CheckForEngage")
    self:RegisterEvent("BigWigs_RecvSync")
    self:TriggerEvent("BigWigs_ThrottleSync",       "GehennasCurse",    10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsGehennas:BigWigs_RecvSync(sync, rest, nick)
	if not self.started and sync == "BossEngaged" and rest == self.bossSync then
        self:StartFight()
        
		if self.db.profile.curse then
			self:ScheduleEvent("messagewarn2", "BigWigs_Message", 7, L["warn1"], "Urgent")
			self:TriggerEvent("BigWigs_StartBar", self, L["bar1text"], 12, "Interface\\Icons\\Spell_Shadow_BlackPlague")
		end
        self:TriggerEvent("BigWigs_StartBar", self, "Next Rain", 10, "Interface\\Icons\\Spell_Shadow_RainOfFire")
	elseif sync == "GehennasCurse" and self.db.profile.curse then
		self:ScheduleEvent("messagewarn1", "BigWigs_Message", 26, L["warn1"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["bar1text"], 31, "Interface\\Icons\\Spell_Shadow_BlackPlague")
	elseif sync == "GehennasAddDead" and rest and rest ~= "" then
        rest = tonumber(rest)
        if rest <= 2 and self.flamewaker < rest then
            self.flamewaker = rest
            self:TriggerEvent("BigWigs_Message", string.format(L["addmsg"], self.flamewaker), "Positive")
        end
	end
end


function BigWigsGehennas:Event(msg)
    if string.find(msg, "You suffer (%d+) (.+) from "..boss.." 's Rain of Fire.") then
        -- I found no better way to trigger this, it will autohide after 2s which is the time between Rain of Fire ticks
        self:TriggerEvent("BigWigs_ShowIcon", "Interface\\Icons\\Spell_Shadow_RainOfFire", 2)
    elseif ((string.find(msg, L["trigger1"])) or (string.find(msg, L["trigger4"]))) then
		self:TriggerEvent("BigWigs_SendSync", "GehennasCurse")
	elseif (string.find(msg, L["trigger3"])) then
        -- this will not trigger, but I will leave it in case they fix this combatlog event/message
		self:TriggerEvent("BigWigs_Message", L["firewarn"], "Attention", "Alarm")
        self:ScheduleEvent("BigWigs_StartBar", 6, self, "Next Rain", 9, "Interface\\Icons\\Spell_Shadow_RainOfFire")
        self:TriggerEvent("BigWigs_ShowIcon", "Interface\\Icons\\Spell_Shadow_RainOfFire", 6)
	end
end

function BigWigsGehennas:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
    if string.find(msg,"Rain of Fire") then
        -- this will not trigger, but I will leave it in case they fix this combatlog event/message
        self:TriggerEvent("BigWigs_HideIcon", "Interface\\Icons\\Spell_Shadow_RainOfFire")
    end
end

function BigWigsGehennas:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if string.find(msg, L["dead1"]) then
		self:TriggerEvent("BigWigs_SendSync", "GehennasAddDead " .. tostring(self.flamewaker + 1))
	end
end
