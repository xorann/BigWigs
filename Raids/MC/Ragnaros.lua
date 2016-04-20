
------------------------------
--      Event Handlers      --
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Ragnaros"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	knockback_trigger = "^TASTE",
	submerge_trigger = "^COME FORTH,",
	engage_trigger = "^NOW FOR YOU",
    engage_soon_trigger = "Imprudent whelps!",
    hammer_trigger = "^BY FIRE BE PURGED!",

	knockback_message = "Knockback!",
	knockback_soon_message = "5 sec to knockback!",
	submerge_message = "Ragnaros submerged. Incoming Sons of Flame!",
	emerge_soon_message = "15 sec until Ragnaros emerges!",
	emerge_message = "Ragnaros emerged, 3 minutes until submerge!",
	submerge_60sec_message = "60 sec to submerge!",
	submerge_30sec_message = "30 sec to submerge!",
	submerge_10sec_message = "10 sec to submerge!",
	submerge_5sec_message = "5 sec to submerge!",

	knockback_bar = "AoE knockback",
	emerge_bar = "Ragnaros emerge",
	submerge_bar = "Ragnaros submerge",

	sonofflame = "Son of Flame",
	sonsdeadwarn = "%d/8 Sons of Flame dead!",

	cmd = "Ragnaros",

	emerge_cmd = "emerge",
	emerge_name = "Emerge alert",
	emerge_desc = "Warn for Ragnaros Emerge",

	adds_cmd = "adds",
	adds_name = "Son of Flame dies",
	adds_desc = "Warn when a son dies",

	submerge_cmd = "submerge",
	submerge_name = "Submerge alert",
	submerge_desc = "Warn for Ragnaros Submerge",

	aoeknock_cmd = "aoeknock",
	aoeknock_name = "Knockback alert",
	aoeknock_desc = "Warn for Wrath of Ragnaros knockback",
} end)

L:RegisterTranslations("deDE", function() return {
	knockback_trigger = "^TASTE",
	submerge_trigger = "^COME FORTH,",
	engage_trigger = "^NOW FOR YOU",
    engage_soon_trigger = "Imprudent whelps!",
    hammer_trigger = "^BY FIRE BE PURGED!",

	knockback_message = "R\195\188cksto\195\159!",
	knockback_soon_message = "5 Sekunden bis R\195\188cksto\195\159!",
	submerge_message = "Ragnaros ist untergetaucht! Son of Flame kommen!",
	emerge_soon_message = "15 Sekunden bis Ragnaros auftaucht",
	emerge_message = "Ragnaros ist aufgetaucht, Untertauchen in 3 Minuten!",
	submerge_60sec_message = "Auftauchen in 60 Sekunden!",
	submerge_30sec_message = "Auftauchen in 30 Sekunden!",
	submerge_10sec_message = "Auftauchen in 10 Sekunden!",
	submerge_5sec_message = "Auftauchen in 5 Sekunden!",

	knockback_bar = "AoE R\195\188cksto\195\159",
	emerge_bar = "Ragnaros taucht auf",
	submerge_bar = "Ragnaros taucht unter",

	sonofflame = "Son of Flame",
	sonsdeadwarn = "%d/8 Son of Flame tot!",

	cmd = "Ragnaros",

	emerge_cmd = "emerge",
	emerge_name = "Alarm f\195\188r Abtauchen",
	emerge_desc = "Warnen, wenn Ragnaros auftaucht",

	adds_cmd = "adds",
	adds_name = "Z\195\164hler f\195\188r tote Adds",
	adds_desc = "Verk\195\188ndet Sons of Flames Tod",

	submerge_cmd = "submerge",
	submerge_name = "Alarm f\195\188r Untertauchen",
	submerge_desc = "Warnen, wenn Ragnaros untertaucht",

	aoeknock_cmd = "aoeknock",
	aoeknock_name = "Alarm f\195\188r R\195\188cksto\195\159",
	aoeknock_desc = "Warnen, wenn Zorn des Ragnaros zur\195\188ckst\195\182\195\159t",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRagnaros = BigWigs:NewModule(boss)
BigWigsRagnaros.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsRagnaros.enabletrigger = boss
BigWigsRagnaros.bossSync = "Ragnaros"
BigWigsRagnaros.wipemobs = { L["sonofflame"] }
BigWigsRagnaros.toggleoptions = { "aoeknock", "submerge", "emerge", "adds", "bosskill" }
BigWigsRagnaros.revision = tonumber(string.sub("$Revision: 11203 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsRagnaros:OnEnable()
	self.started = nil
	self.sonsdead = 0
    
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "RagnarosKnockback", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsRagnaros:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if string.find(msg, L["sonofflame"]) then
		self:TriggerEvent("BigWigs_SendSync", "RagnarosSonDeadX " .. tostring(self.sonsdead + 1))
	end
end

function BigWigsRagnaros:BigWigs_RecvSync(sync, rest, nick)
	if not self.started and sync == "BossEngaged" and rest == self.bossSync then
		self:StartFight()
		if self.db.profile.aoeknock then
			self:TriggerEvent("BigWigs_SendSync", "RagnarosKnockback")
		end
	elseif sync == "RagnarosSonDeadX" and rest and rest ~= "" then
        rest = tonumber(rest)
        if rest <= 8 and self.sonsdead < rest then
            self.sonsdead = rest
            if self.db.profile.adds then
                self:TriggerEvent("BigWigs_Message", string.format(L["sonsdeadwarn"], self.sonsdead), "Positive")
            end
            if self.sonsdead == 8 then
                self:CancelScheduledEvent("bwragnarosemerge")
                self:TriggerEvent("BigWigs_StopBar", L["emerge_bar"])
                self.sonsdead = 0
            end
            self:TriggerEvent("BigWigs_SetCounterBar", self, "Sons dead", (8 - self.sonsdead))
        end
	elseif sync == "RagnarosKnockback" then
		self:ScheduleEvent("bwragnarosaekbwarn", "BigWigs_Message", 24, L["knockback_soon_message"], "Urgent", true, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["knockback_bar"], 29, "Interface\\Icons\\Spell_Fire_SoulBurn")
        self:ScheduleEvent("BigWigs_ShowIcon", 24, "Interface\\Icons\\Ability_Rogue_Sprint", 5)
	end
end

function BigWigsRagnaros:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["knockback_trigger"]) and self.db.profile.aoeknock then
		self:TriggerEvent("BigWigs_Message", L["knockback_message"], "Important")
		self:ScheduleEvent("bwragnarosaekbwarn", "BigWigs_Message", 23, L["knockback_soon_message"], "Urgent", true, "Alarm")
        self:ScheduleEvent("BigWigs_ShowIcon", 23, "Interface\\Icons\\Ability_Rogue_Sprint", 5)
		self:TriggerEvent("BigWigs_StartBar", self, L["knockback_bar"], 28, "Interface\\Icons\\Spell_Fire_SoulBurn")
	elseif string.find(msg, L["submerge_trigger"]) then
		self:Submerge()
	elseif string.find(msg, L["engage_trigger"]) then
		self:Emerge()
    elseif string.find(msg,L["engage_soon_trigger"]) then
        self:TriggerEvent("BigWigs_StartBar", self, "Combat", 64.5, "Interface\\Icons\\Inv_Hammer_Unique_Sulfuras")
    elseif string.find(msg,L["hammer_trigger"]) then
        self:TriggerEvent("BigWigs_StartBar", self, "Hammer of Ragnaros", 25, "Interface\\Icons\\Spell_Fire_Incinerate")
	end
end

function BigWigsRagnaros:Submerge()
	self:CancelScheduledEvent("bwragnarosaekbwarn")
	self:TriggerEvent("BigWigs_StopBar", self, L["knockback_bar"])
	if self.db.profile.submerge then
		self:TriggerEvent("BigWigs_Message", L["submerge_message"], "Important")
	end
	if self.db.profile.emerge then
		self:ScheduleEvent("bwragnarosemergewarn", "BigWigs_Message", 75, L["emerge_soon_message"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["emerge_bar"], 90, "Interface\\Icons\\Spell_Fire_Volcano")
	end
	self:ScheduleRepeatingEvent("bwragnarosemergecheck", self.EmergeCheck, 2, self)
	self:ScheduleEvent("bwragnarosemerge", self.Emerge, 90, self)
    self:TriggerEvent("BigWigs_StartCounterBar", self, "Sons dead", 8, "Interface\\Icons\\spell_fire_fire")
    self:TriggerEvent("BigWigs_SetCounterBar", self, "Sons dead", (8 - 0.1))
end

function BigWigsRagnaros:EmergeCheck()
	if UnitExists("target") and UnitName("target") == boss and UnitExists("targettarget") then
		if started == nil then
			self:TriggerEvent("BigWigs_SendSync", "RagnarosKnockback")		
		else
			sonsdead = 0 -- reset counter
			self:Emerge()
			return
		end
	end
	local num = GetNumRaidMembers()
	for i = 1, num do
		local raidUnit = string.format("raid%starget", i)
		if UnitExists(raidUnit) and UnitName(raidUnit) == boss and UnitExists(raidUnit.."target") then
			sonsdead = 0 -- reset counter
			self:Emerge()
			return
		end
	end
end

function BigWigsRagnaros:Emerge()
	self:CancelScheduledEvent("bwragnarosemergecheck")
	self:CancelScheduledEvent("bwragnarosemergewarn")
	self:TriggerEvent("BigWigs_StopBar", self, L["emerge_bar"])
	if self.db.profile.emerge then
		self:TriggerEvent("BigWigs_Message", L["emerge_message"], "Attention")
	end
	if self.db.profile.submerge then
		self:ScheduleEvent("bwragnarosaekbwarn", "BigWigs_Message", 20, L["knockback_soon_message"], "Urgent", true, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["knockback_bar"], 25, "Interface\\Icons\\Spell_Fire_SoulBurn")
		self:ScheduleEvent("BigWigs_Message", 120, L["submerge_60sec_message"], "Attention")
		self:ScheduleEvent("BigWigs_Message", 150, L["submerge_30sec_message"], "Attention")
		self:ScheduleEvent("BigWigs_Message", 170, L["submerge_10sec_message"], "Attention")
		self:ScheduleEvent("BigWigs_Message", 175, L["submerge_5sec_message"], "Attention")
		self:TriggerEvent("BigWigs_StartBar", self, L["submerge_bar"], 180, "Interface\\Icons\\Spell_Fire_SelfDestruct")
	    self:ScheduleEvent("bwragnarossubmerge", self.Submerge, 180, self)
	end
    self:TriggerEvent("BigWigs_StopCounterBar", self, "Sons dead")
end
