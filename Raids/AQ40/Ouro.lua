--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Ouro"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local berserkannounced

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Ouro",

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

	scarab_cmd = "scarab",
	scarab_name = "Scarab Despawn Alert",
	scarab_desc = "Warn for Scarab Despawn",

	berserk_cmd = "berserk",
	berserk_name = "Berserk",
	berserk_desc = "Warn for when Ouro goes berserk",

	sweeptrigger = "Ouro begins to cast Sweep",
	sweepannounce = "Sweep!",
	sweepwarn = "5 seconds until Sweep!",
	sweepbartext = "Sweep",

	sandblasttrigger = "Ouro begins to perform Sand Blast",
	sandblastannounce = "Incoming Sand Blast!",
	sandblastwarn = "5 seconds until Sand Blast!",
	sandblastbartext = "Sand Blast",

	engage_message = "Ouro engaged! Possible Submerge in 90sec!",
	possible_submerge_bar = "Possible submerge",

	--emergetrigger = "Dirt Mound casts Summon Ouro Scarabs.",
    emergetrigger = "Dirt Mound dies",
	emergeannounce = "Ouro has emerged!",
	emergewarn = "15 sec to possible submerge!",
	emergewarn2 = "15 sec to Ouro sumberge!",
	emergebartext = "Ouro submerge",

	scarabdespawn = "Scarabs despawn in 10 Seconds",
	scarabbar = "Scarabs despawn",

	submergetrigger = "Ouro casts Summon Ouro Mounds.",
	submergeannounce = "Ouro has submerged!",
	submergewarn = "5 seconds until Ouro Emerges!",
	submergebartext = "Ouro Emerge",

	berserktrigger = "%s goes into a berserker rage!",
	berserkannounce = "Berserk - Berserk!",
	berserksoonwarn = "Berserk Soon - Get Ready!",
            
    
} end )

L:RegisterTranslations("deDE", function() return {
	sweep_name = "Feger",
	sweep_desc = "Warnung, wenn Ouro Feger wirkt.",

	sandblast_name = "Sandsto\195\159",
	sandblast_desc = "Warnung, wenn Ouro Sandsto\195\159 wirkt.",

	emerge_name = "Auftauchen",
	emerge_desc = "Warnung, wenn Ouro auftaucht.",

	submerge_name = "Untertauchen",
	submerge_desc = "Warnung, wenn Ouro untertaucht.",

	scarab_name = "Scarab Despawn Alert", -- ?
	scarab_desc = "Warn for Scarab Despawn", -- ?

	berserk_name = "Berserk",
	berserk_desc = "Warn for when Ouro goes berserk",

	sweeptrigger = "Ouro begins to cast Sweep", -- ?
	sweepannounce = "Feger!",
	sweepwarn = "5 Sekunden bis Feger!",
	sweepbartext = "Feger",

	sandblasttrigger = "Ouro begins to perform Sand Blast", -- ?
	sandblastannounce = "Sandsto\195\159 in K\195\188rze!",
	sandblastwarn = "5 Sekunden bis Sandsto\195\159!",
	sandblastbartext = "Sandsto\195\159",

	engage_message = "Ouro engaged! Possible Submerge in 90sec!",
	possible_submerge_bar = "Possible submerge",

	emergetrigger = "Dirt Mound casts Summon Ouro Scarabs.", -- ?
	emergeannounce = "Ouro ist aufgetaucht!",
	emergewarn = "15 sec to possible submerge!",
	emergewarn2 = "15 sec to Ouro sumberge!",
	emergebartext = "Untertauchen",

	scarabdespawn = "Scarabs verschwinden in 10 Sekunden", -- ?
	scarabbar = "Scarabs despawn", -- ?

	submergetrigger = "Ouro casts Summon Ouro Mounds.", -- ?
	submergeannounce = "Ouro ist aufgetaucht!",
	submergewarn = "5 Sekunden bis Ouro auftaucht!",
	submergebartext = "Auftauchen",

	berserktrigger = "%s goes into a berserker rage!",
	berserkannounce = "Berserk - Berserk!",
	berserksoonwarn = "Berserkerwut in K\195\188rze - Bereit machen!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsOuro = BigWigs:NewModule(boss)
BigWigsOuro.zonename = AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
BigWigsOuro.enabletrigger = boss
BigWigsOuro.bossSync = "Ouro"
BigWigsOuro.toggleoptions = {"sweep", "sandblast", "scarab", -1, "emerge", "submerge", -1, "berserk", "bosskill"}
BigWigsOuro.revision = tonumber(string.sub("$Revision: 18120 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsOuro:OnEnable()
	berserkannounced = nil
	self.started = nil
    self.phase = nil
    self.submergeCheckName = self:ToString()

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
    self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "EmergeCheck")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("BigWigs_RecvSync")

	self:TriggerEvent("BigWigs_ThrottleSync", "OuroSweep", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "OuroSandblast", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "OuroEmerge2", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "OuroSubmerge", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "OuroBerserk", 10)
end


function BigWigsOuro:UNIT_HEALTH( msg )
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 20 and health <= 23 and not berserkannounced then
			if self.db.profile.berserk then
				self:TriggerEvent("BigWigs_Message", L["berserksoonwarn"], "Important")
			end
			berserkannounced = true
		elseif health > 30 and berserkannounced then
			berserkannounced = nil
		end
	end
end

function BigWigsOuro:BigWigs_RecvSync(sync, rest, nick)
	if not self.started and sync == "BossEngaged" and rest == self.bossSync then
		self:StartFight()
        
        self.phase = "emerged"
		self:ScheduleRepeatingEvent("bwourosubmergecheck", self.SubmergeCheck, 1, self)
        
        if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then self:UnregisterEvent("PLAYER_REGEN_DISABLED") end
		if self.db.profile.emerge then
			self:TriggerEvent("BigWigs_Message", L["engage_message"], "Attention")
			self:PossibleSubmerge()
		end
	elseif sync == "OuroSweep" then
		self:Sweep()
	elseif sync == "OuroSandblast" then
		self:Sandblast()
	elseif sync == "OuroEmerge2" then
		self:Emerge()
	elseif sync == "OuroSubmerge" then
		self:Submerge()
	elseif sync == "OuroBerserk" then
		self:Berserk()
	end
end

function BigWigsOuro:PossibleSubmerge()
	if self.db.profile.emerge then
		self:ScheduleEvent("bwouroemergewarn", "BigWigs_Message", 75, L["emergewarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["possible_submerge_bar"], 90, "Interface\\Icons\\Spell_Nature_Earthquake")
		--self:ScheduleEvent("bwouroemergewarn2", "BigWigs_Message", 165, L["emergewarn2"], "Important")
		--self:TriggerEvent("BigWigs_StartBar", self, L["emergebartext"], 180, "Interface\\Icons\\Spell_Nature_Earthquake")
	end
end

function BigWigsOuro:Berserk()
	self:CancelScheduledEvent("bwouroemergewarn")
	self:CancelScheduledEvent("bwouroemergewarn2")
	self:TriggerEvent("BigWigs_StopBar", self, L["emergebartext"])
	self:TriggerEvent("BigWigs_StopBar", self, L["possible_submerge_bar"])
	self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")

	if self.db.profile.berserk then
		self:TriggerEvent("BigWigs_Message", L["berserkannounce"], "Important")
	end
end

function BigWigsOuro:Sweep()
	if self.db.profile.sweep then
        self:Bar(L["sweepannounce"], 1.5, "Spell_Nature_Thorns")
		self:Message(L["sweepannounce"], "Important", true, "Alarm")
        --self:TriggerEvent("BigWigs_Message", L["sweepannounce"], "Important")
		--self:DelayedMessage(15, L["sweepwarn"], "Important")
        self:ScheduleEvent("bwourosweepwarn", "BigWigs_Message", 16, L["sweepwarn"], "Important")
		self:Bar(L["sweepbartext"], 20, "Spell_Nature_Thorns")
        --self:TriggerEvent("BigWigs_StartBar", self, L["sweepbartext"], 21, "Interface\\Icons\\Spell_Nature_Thorns")
	end
end

function BigWigsOuro:Sandblast()
	if self.db.profile.sandblast then
        self:Bar(L["sandblastannounce"], 2, "Spell_Nature_Cyclone")
		self:TriggerEvent("BigWigs_Message", L["sandblastannounce"], "Important", true, "Alert")
		self:ScheduleEvent("bwouroblastwarn", "BigWigs_Message", 17, L["sandblastwarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["sandblastbartext"], 22, "Interface\\Icons\\Spell_Nature_Cyclone")
	end
end

function BigWigsOuro:Emerge()
    self.phase = "emerged"
    
    self:CancelScheduledEvent("bwsubmergewarn")
    self:RemoveBar(L["submergebartext"])
    
	if self.db.profile.emerge then
		self:TriggerEvent("BigWigs_Message", L["emergeannounce"], "Important", false, "Beware")
		self:PossibleSubmerge()
	end

	if self.db.profile.sweep then
		self:ScheduleEvent("bwourosweepwarn", "BigWigs_Message", 15, L["sweepwarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["sweepbartext"], 20, "Interface\\Icons\\Spell_Nature_Thorns")
	end	

	if self.db.profile.sandblast then
		self:ScheduleEvent("bwouroblastwarn", "BigWigs_Message", 17, L["sandblastwarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["sandblastbartext"], 22, "Interface\\Icons\\Spell_Nature_Cyclone")
	end

	--[[if self.db.profile.scarab then
		self:ScheduleEvent("bwscarabdespawn", "BigWigs_Message", 50, L["scarabdespawn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["scarabbar"], 60, "Interface\\Icons\\INV_Scarab_Clay")
	end]]
end

function BigWigsOuro:Submerge()
	self:CancelScheduledEvent("bwourosweepwarn")
	self:CancelScheduledEvent("bwouroblastwarn")
	self:CancelScheduledEvent("bwouroemergewarn")
	self:CancelScheduledEvent("bwouroemergewarn2")

	self:TriggerEvent("BigWigs_StopBar", self, L["sweepbartext"])
	self:TriggerEvent("BigWigs_StopBar", self, L["sandblastbartext"])
	self:TriggerEvent("BigWigs_StopBar", self, L["emergebartext"])
	self:TriggerEvent("BigWigs_StopBar", self, L["possible_submerge_bar"])

    self.phase = "submerged"
    
	if self.db.profile.submerge then
		self:TriggerEvent("BigWigs_Message", L["submergeannounce"], "Important")
		self:ScheduleEvent("bwsubmergewarn", "BigWigs_Message", 25, L["submergewarn"], "Important" )
		self:TriggerEvent("BigWigs_StartBar", self, L["submergebartext"], 30, "Interface\\Icons\\Spell_Nature_Earthquake")
	end
end

function BigWigsOuro:IsOuroVisible()
	if UnitName("playertarget") == self.submergeCheckName then
		return true
	else
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitName("Raid"..i.."target") == self.submergeCheckName then
				return true
			end
		end
	end
    
    return false
end
function BigWigsOuro:SubmergeCheck()
    if self.phase == "emerged" then
        if not self:IsOuroVisible() then
            self:DebugMessage("OuroSubmerge")
            self:Sync("OuroSubmerge")
        end
    end
end

function BigWigsOuro:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if string.find(msg, L["emergetrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "OuroEmerge2")
	elseif string.find(msg, L["submergetrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "OuroSubmerge")
	end
end
function BigWigsOuro:EmergeCheck(msg)
    if string.find(msg, L["emergetrigger"]) then
        self:Sync("OuroEmerge2")
        --self:TriggerEvent("BigWigs_SendSync", "OuroEmerge2")
    end
end


function BigWigsOuro:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE( msg )
	if string.find(msg, L["sweeptrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "OuroSweep")
	elseif string.find(msg, L["sandblasttrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "OuroSandblast")
	elseif string.find(msg, L["submergetrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "OuroSubmerge")
	end
end

function BigWigsOuro:CHAT_MSG_MONSTER_EMOTE( msg )
	if msg == L["berserktrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "OuroBerserk")
	end
end


----------------------------------
--      Module Test Function    --
----------------------------------

function BigWigsOuro:Test()
    local function sweep()
        if self.phase == "emerged" then
            BigWigsOuro:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["sweeptrigger"])
        end
    end
    local function sandblast()
        if self.phase == "emerged" then
            BigWigsOuro:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["sandblasttrigger"])
        end
    end
    local function submerge()
        if self.phase == "emerged" then
            ClearTarget()
        end
    end
    local function emerge()
        if self.phase == "submerged" then
            TargetUnit("player")
            BigWigsOuro:EmergeCheck(L["emergetrigger"])
        end
    end
    
    BigWigs:Print("BigWigsOuro Test started")
    BigWigs:Print("Do not change your target!")
    BigWigs:Print("  Sweep Test after 5s")
    BigWigs:Print("  Sand Storm Test after 10s")
    BigWigs:Print("  Submerge Test after 32s")
    BigWigs:Print("  Emerge Test after 42s")
    
    TargetUnit("player")
    
    -- engage
    self:Sync("StartFight "..self:ToString())
    self:SendEngageSync()
    self.submergeCheckName = UnitName("player")
    
    
    -- sweep after 5s
    self:ScheduleEvent(self:ToString().."Test_sweep", sweep, 5, self)
    
    -- sand blast after 10s
    self:ScheduleEvent(self:ToString().."Test_sandblast", sandblast, 10, self)
    
    -- submerge after 32s
    self:ScheduleEvent(self:ToString().."Test_submerge", submerge, 32, self)
    
    -- emerge after 42s
    self:ScheduleEvent(self:ToString().."Test_emerge", emerge, 42, self)
end