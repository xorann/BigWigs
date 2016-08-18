------------------------------
--      Are you local?      --
------------------------------

local veklor = AceLibrary("Babble-Boss-2.2")["Emperor Vek'lor"]
local veknilash = AceLibrary("Babble-Boss-2.2")["Emperor Vek'nilash"]
local boss = AceLibrary("Babble-Boss-2.2")["The Twin Emperors"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs" .. boss)
local twinstarted = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Twins",

	bug_cmd = "bug",
	bug_name = "Exploding Bug Alert",
	bug_desc = "Warn for exploding bugs",

	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for Teleport",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	heal_cmd = "heal",
	heal_name = "Heal Alert",
	heal_desc = "Warn for Twins Healing",
            
    blizzard_cmd = "blizzard",
    blizzard_name = "Blizzard Warning",
    blizzard_desc = "Shows an Icon if you are standing in a Blizzard",

	porttrigger = "casts Twin Teleport.",
	portwarn = "Teleport!",
	portdelaywarn = "Teleport in 5 seconds!",
	portdelaywarn10 = "Teleport in 10 seconds!",
	bartext = "Teleport",
	explodebugtrigger = "gains Explode Bug",
	explodebugwarn = "Bug exploding nearby!",
	enragetrigger = "becomes enraged.",
	trigger = "Blizzard",
	enragewarn = "Twins are enraged",
	healtrigger1 = "'s Heal Brother heals",
	healtrigger2 = " Heal Brother heals",
	healwarn = "Casting Heal!",
	startwarn = "Twin Emperors engaged! Enrage in 15 minutes!",
	enragebartext = "Enrage",
	warn1 = "Enrage in 10 minutes",
	warn2 = "Enrage in 5 minutes",
	warn3 = "Enrage in 3 minutes",
	warn4 = "Enrage in 90 seconds",
	warn5 = "Enrage in 60 seconds",
	warn6 = "Enrage in 30 seconds",
	warn7 = "Enrage in 10 seconds",
    
    blizzard_trigger = "You are afflicted by Blizzard.",
    blizzard_gone_trigger = "Blizzard fades from you",
	blizzard_warn = "Run from Blizzard!",
            
            
    pull_trigger1 = "Ah, lambs to the slaughter.",
    pull_trigger2 = "Prepare to embrace oblivion!",
    pull_trigger3 = "Join me brother, there is blood to be shed.",
    pull_trigger4 = "To decorate our halls.",
    pull_trigger5 = "Let none survive!",
    pull_trigger6 = "It's too late to turn away.",
    pull_trigger7 = "Look brother, fresh blood.",
    pull_trigger8 = "Like a fly in a web.",
    pull_trigger9 = "Shall be your undoing!",
    pull_trigger10 = "Your brash arrogance",
            
    kill_trigger = "My brother...NO!",
} end )

L:RegisterTranslations("deDE", function() return {

	bug_name = "Explodierende K\195\164fer",
	bug_desc = "Warnung vor explodierenden K\195\164fern.",

	teleport_name = "Teleport",
	teleport_desc = "Warnung, wenn die Zwillings Imperatoren sich teleportieren.",

	enrage_name = "Wutanfall",
	enrage_desc = "Warnung, wenn die Zwillings Imperatoren w\195\188tend werden.",

	heal_name = "Heilung",
	heal_desc = "Warnung, wenn die Zwillings Imperatoren sich heilen.",

    blizzard_name = "Blizzard Warnung",
    blizzard_desc = "Zeigt ein Icon wenn du im Blizzard stehst",
            
	porttrigger = "wirkt Zwillingsteleport.",
	portwarn = "Teleport!",
	portdelaywarn = "Teleport in ~5 Sekunden!",
	portdelaywarn10 = "Teleport in ~10 Sekunden!",
	bartext = "Teleport",
	explodebugtrigger = "bekommt 'K\195\164fer explodieren lassen'",
	explodebugwarn = "K\195\164fer explodiert!",
	enragetrigger = "wird w\195\188tend.", -- ? "bekommt 'Wutanfall'"
	enragewarn = "Zwillings Imperatoren sind w\195\188tend!",
	healtrigger1 = "'s Bruder heilen heilt",
	healtrigger2 = " Bruder heilen heilt",
	healwarn = "Heilung gewirkt!",
	startwarn = "Zwillings Imperatoren angegriffen! Wutanfall in 15 Minuten!",
	enragebartext = "Wutanfall",
	warn1 = "Wutanfall in 10 Minuten",
	warn2 = "Wutanfall in 5 Minuten",
	warn3 = "Wutanfall in 3 Minuten",
	warn4 = "Wutanfall in 90 Sekunden",
	warn5 = "Wutanfall in 60 Sekunden",
	warn6 = "Wutanfall in 30 Sekunden",
	warn7 = "Wutanfall in 10 Sekunden",
    
    blizzard_trigger = "Ihr seid von Blizzard betroffen.",
    blizzard_gone_trigger = "Blizzard schwindet von Euch.",
	blizzard_warn = "Lauf aus Blizzard!",
            
    pull_trigger1 = "Ihr seid nichts weiter als",
    pull_trigger2 = "Seid bereit in die",
    pull_trigger3 = "Komm Bruder",
    pull_trigger4 = "Um unsere Hallen",
    pull_trigger5 = "Niemand wird",
    pull_trigger6 = "Nun gibt es kein",
    pull_trigger7 = "Sieh Bruder",
    pull_trigger8 = "Wie eine Fliege",
    pull_trigger9 = "Wird euer Untergang",
    pull_trigger10 = "Eure unversch",
            
    kill_trigger = "Mein Bruder...",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsTwins = BigWigs:NewModule(boss)
BigWigsTwins.zonename = AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
BigWigsTwins.enabletrigger = {veklor, veknilash}
BigWigsTwins.bossSync = "The Twin Emperors"
BigWigsTwins.toggleoptions = {"bug", "teleport", "enrage", "heal", "blizzard", "bosskill"}
BigWigsTwins.revision = tonumber(string.sub("$Revision: 16970 $", 12, -3))
BigWigsTwins:RegisterYellEngage(L["pull_trigger1"])
BigWigsTwins:RegisterYellEngage(L["pull_trigger2"])
BigWigsTwins:RegisterYellEngage(L["pull_trigger3"])
BigWigsTwins:RegisterYellEngage(L["pull_trigger4"])
BigWigsTwins:RegisterYellEngage(L["pull_trigger5"])
BigWigsTwins:RegisterYellEngage(L["pull_trigger6"])
BigWigsTwins:RegisterYellEngage(L["pull_trigger7"])
BigWigsTwins:RegisterYellEngage(L["pull_trigger8"])
BigWigsTwins:RegisterYellEngage(L["pull_trigger9"])
BigWigsTwins:RegisterYellEngage(L["pull_trigger10"])

------------------------------
--      Initialization      --
------------------------------

function BigWigsTwins:OnEnable()
	self.started = nil
    self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "TwinsTeleport43", 28)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsTwins:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["pull_trigger1"]) or string.find(msg, L["pull_trigger2"]) or string.find(msg, L["pull_trigger3"]) or string.find(msg, L["pull_trigger4"]) or string.find(msg, L["pull_trigger5"]) or string.find(msg, L["pull_trigger6"]) or string.find(msg, L["pull_trigger7"]) or string.find(msg, L["pull_trigger8"]) or string.find(msg, L["pull_trigger9"]) or string.find(msg, L["pull_trigger10"]) then
        
        if not twinstarted then
            twinstarted = true
        
            if self:IsEventRegistered("CHAT_MSG_MONSTER_YELL") then
                self:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
            end

            if self.db.profile.teleport then
                self:TriggerEvent("BigWigs_SendSync", "TwinsTeleport43")
                self:DelayedSound(20, "Ten")
                self:DelayedSound(27, "Three")
                self:DelayedSound(28, "Two")
                self:DelayedSound(29, "One")
            end
            if self.db.profile.enrage then
                self:TriggerEvent("BigWigs_StartBar", self, L["enragebartext"], 900, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
            end
        end
    elseif string.find(msg, L["kill_trigger"]) then
        if self.db.profile.bosskill then 
            self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.2"):new("BigWigs")["%s have been defeated"], boss), "Bosskill", nil, "Victory") 
        end
		self.core:ToggleModuleActive(self, false)
    end
end

function BigWigsTwins:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, veklor) or msg == string.format(UNITDIESOTHER, veknilash) then
		if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.2"):new("BigWigs")["%s have been defeated"], boss), "Bosskill", nil, "Victory") end
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsTwins:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(msg)
	if string.find(msg, L["blizzard_trigger"]) then
		self:TriggerEvent("BigWigs_Message", L["blizzard_warn"], "Personal", true, "Alarm")
        self:TriggerEvent("BigWigs_ShowWarningSign", "Interface\\Icons\\Spell_Frost_IceStorm", 10)
	        --BigWigsThaddiusArrows:Direction("Blizzard")
	end
end

function BigWigsTwins:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
	if string.find(msg, L["blizzard_gone_trigger"]) then
        self:TriggerEvent("BigWigs_HideWarningSign", "Interface\\Icons\\Spell_Frost_IceStorm")
	end
end

--[[function BigWigsTwins:Stopb()
            BigWigsThaddiusArrows:Blizzardstop()
end]]

function BigWigsTwins:BigWigs_RecvSync(sync, rest, nick)
	if not twinstarted and sync == "BossEngaged" and rest == self.bossSync then
		twinstarted = true
        --self:StartFight()
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
        if self:IsEventRegistered("CHAT_MSG_MONSTER_YELL") then
			self:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
		end
		if self.db.profile.teleport then
	        self:Sync("TwinsTeleport43")
		end
		if self.db.profile.enrage then
	                --self:ScheduleRepeatingEvent("bwtwinstelebar", self.Telebar, 30.1, self)
			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["enragebartext"], 900, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
			self:ScheduleEvent("bwtwinswarn1", "BigWigs_Message", 300, L["warn1"], "Attention")
			self:ScheduleEvent("bwtwinswarn2", "BigWigs_Message", 600, L["warn2"], "Attention")
			self:ScheduleEvent("bwtwinswarn3", "BigWigs_Message", 720, L["warn3"], "Attention")
			self:ScheduleEvent("bwtwinswarn4", "BigWigs_Message", 810, L["warn4"], "Urgent")
			self:ScheduleEvent("bwtwinswarn5", "BigWigs_Message", 840, L["warn5"], "Urgent")
			self:ScheduleEvent("bwtwinswarn6", "BigWigs_Message", 870, L["warn6"], "Important")
			self:ScheduleEvent("bwtwinswarn7", "BigWigs_Message", 890, L["warn7"], "Important")
		end
        self:DebugMessage("BossEngaged")
	elseif sync == "TwinsTeleport43" and self.db.profile.teleport then
        self:TriggerEvent("BigWigs_StartBar", self, L["bartext"], 30, "Interface\\Icons\\Spell_Arcane_Blink")
        
        self:ScheduleEvent("BigWigs_SendSync", 30, "TwinsTeleport")
        self:ScheduleEvent("BigWigs_SendSync", 30, "TwinsTeleport43")
        self:KTM_Reset()
        
        self:DelayedSound(20, "Ten")
        self:DelayedSound(27, "Three")
        self:DelayedSound(28, "Two")
        self:DelayedSound(29, "One")
        self:DelayedMessage(30, L["portwarn"], "Attention", true, "Alarm")
	end
end

--[[function BigWigsTwins:Telebar()
            --klhtm:ResetRaidThreat()
	        --self:ScheduleEvent(function() BigWigsThaddiusArrows:Direction("Noth") end, 25)
		self:ScheduleEvent("BigWigs_Message", 20, L["portdelaywarn10"], "Urgent")
		self:ScheduleEvent("BigWigs_Message", 25, L["portdelaywarn"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["bartext"], 30.1, "Interface\\Icons\\Spell_Arcane_Blink")
end	]]

function BigWigsTwins:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if (string.find(msg, L["porttrigger"])) then
		self:TriggerEvent("BigWigs_SendSync", "TwinsTeleport")
        self:TriggerEvent("BigWigs_SendSync", "TwinsTeleport43")
        self:DebugMessage("real port trigger")
	end
end

function BigWigsTwins:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if (string.find(msg, L["explodebugtrigger"]) and self.db.profile.bug) then
		self:TriggerEvent("BigWigs_Message", L["explodebugwarn"], "Personal", true)
	end
end

function BigWigsTwins:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if (not self.prior and (string.find(msg, L["healtrigger1"]) or string.find(msg, L["healtrigger2"])) and self.db.profile.heal) then
		self:TriggerEvent("BigWigs_Message", L["healwarn"], "Important")
		self.prior = true
		self:ScheduleEvent(function() BigWigsTwins.prior = nil end, 10)
	end
end

function BigWigsTwins:CHAT_MSG_MONSTER_EMOTE(msg)
	if (string.find(msg, L["enragetrigger"]) and self.db.profile.enrage) then
		self:TriggerEvent("BigWigs_Message", L["enragewarn"], "Important")
	end
end

