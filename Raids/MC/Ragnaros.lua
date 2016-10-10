
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Ragnaros", "Molten Core")

module.revision = 20006 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.toggleoptions = {"aoeknock", "submerge", "emerge", "adds", "bosskill"}

module.defaultDB = {
	adds = false,
}

-- Proximity Plugin
-- module.proximityCheck = function(unit) return CheckInteractDistance(unit, 2) end
-- module.proximitySilent = false

---------------------------------
--      Module specific Locals --
---------------------------------

local timer = {
	emerge_soon = 40.9, -- 46:30:17 - 47:11:14 = 40.9
	hammer_of_ragnaros = 11,
	emerge = 90,
	submerge = 180,
	knockback = 30,
}
local icon = {
	emerge_soon = "Inv_Hammer_Unique_Sulfuras",
	hammer_of_ragnaros = "Spell_Fire_Incinerate",
	emerge = "Spell_Fire_Volcano",
	submerge = "Spell_Fire_SelfDestruct",
	knockback = "Spell_Fire_SoulBurn",
	knockbackWarn = "Ability_Rogue_Sprint",
}
local syncName = {
	knockback = "RagnarosKnockback",
	sons = "RagnarosSonDeadX",
	submerge = "RagnarosSubmerge",
	emerge = "RagnarosEmerge",
}

local firstKnockback = true
local sonsdead = 0
local phase = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	knockback_trigger = "^TASTE",
	submerge_trigger = "^COME FORTH,",
	engage_trigger = "^NOW FOR YOU",
    engage_soon_trigger = "TOO SOON! YOU HAVE AWAKENED ME TOO SOON",
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
    
    ["Combat"] = true,
} end)

L:RegisterTranslations("deDE", function() return {
	knockback_trigger = "DIE FLAMMEN VON SULFURON",
	submerge_trigger = "^Kommt herbei, meine Diener!",
	engage_trigger = "^NUN ZU EUCH,",
    engage_soon_trigger = "ZU FRÜH!",
    hammer_trigger = "^DAS FEUER WIRD EUCH!",

	knockback_message = "Rücksto\195\159!",
	knockback_soon_message = "5 Sekunden bis Rücksto\195\159!",
	submerge_message = "Ragnaros ist untergetaucht! Söhne der Flamme kommen!",
	emerge_soon_message = "15 Sekunden bis Ragnaros auftaucht",
	emerge_message = "Ragnaros ist aufgetaucht, Untertauchen in 3 Minuten!",
	submerge_60sec_message = "Auftauchen in 60 Sekunden!",
	submerge_30sec_message = "Auftauchen in 30 Sekunden!",
	submerge_10sec_message = "Auftauchen in 10 Sekunden!",
	submerge_5sec_message = "Auftauchen in 5 Sekunden!",

	knockback_bar = "AoE Rücksto\195\159",
	emerge_bar = "Ragnaros taucht auf",
	submerge_bar = "Ragnaros taucht unter",

	sonofflame = "Sohn der Flamme",
	sonsdeadwarn = "%d/8 Sohn der Flamme tot!",

	--cmd = "Ragnaros",

	--emerge_cmd = "emerge",
	emerge_name = "Alarm für Abtauchen",
	emerge_desc = "Warnen, wenn Ragnaros auftaucht",

	--adds_cmd = "adds",
	adds_name = "Zähler für tote Adds",
	adds_desc = "Verkündet Sohn der Flamme Tod",

	--submerge_cmd = "submerge",
	submerge_name = "Alarm für Untertauchen",
	submerge_desc = "Warnen, wenn Ragnaros untertaucht",

	--aoeknock_cmd = "aoeknock",
	aoeknock_name = "Alarm für Rücksto\195\159",
	aoeknock_desc = "Warnen, wenn Zorn des Ragnaros zurückstö\195\159t",
            
    ["Combat"] = "Kampf beginnt",
} end)

------------------------------
--      Initialization      --
------------------------------

module.wipemobs = { L["sonofflame"] }
--module:RegisterYellEngage(L["start_trigger"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	
	self:ThrottleSync(5, syncName.knockback)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	
	self.started = nil	
	firstKnockback = true
	sonsdead = 0
end

-- called after boss is engaged
function module:OnEngage()
	self:Emerge()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	BigWigs:CheckForBossDeath(msg, self)

	if string.find(msg, L["sonofflame"]) then
		self:Sync(syncName.sons .. " " .. tostring(sonsdead + 1))
	end
end

function module:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["knockback_trigger"]) and self.db.profile.aoeknock then
		self:Sync(syncName.knockback)
	elseif string.find(msg, L["submerge_trigger"]) then
		self:Sync(syncName.submerge)
	elseif string.find(msg, L["engage_trigger"]) then
		self:SendEngageSync()
    elseif string.find(msg, L["engage_soon_trigger"]) then
        self:Bar(L["Combat"], timer.emerge_soon, icon.emerge_soon)
    elseif string.find(msg ,L["hammer_trigger"]) then
        --self:Bar("Hammer of Ragnaros", timer.hammer_of_ragnaros, icon.hammer_of_ragnaros) -- doesn't do anything on nefarian
	end
end

------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.sons and rest and rest ~= "" then
        rest = tonumber(rest)
        if rest <= 8 and sonsdead < rest then
            sonsdead = rest
            if self.db.profile.adds then
                self:Message(string.format(L["sonsdeadwarn"], sonsdead), "Positive")
            end
            if sonsdead == 8 then
            end
            --self:TriggerEvent("BigWigs_SetCounterBar", self, "Sons dead", (8 - sonsdead))
        end
	elseif sync == syncName.knockback then
		self:Knockback()
	elseif sync == syncName.submerge then
		self:Submerge()
	elseif sync == syncName.emerge then
		self:Emerge()
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:Submerge()
    phase = "submerged"
	self:CancelScheduledEvent("bwragnarosaekbwarn")
	self:RemoveBar(L["knockback_bar"])
	
	if self.db.profile.submerge then
		self:Message(L["submerge_message"], "Important")
	end
	if self.db.profile.emerge then
		self:Bar(L["emerge_bar"], timer.emerge, icon.emerge)
		self:DelayedMessage(timer.emerge - 15, L["emerge_soon_message"], "Urgent", nil, nil, true)
	end
	self:ScheduleRepeatingEvent("bwragnarosemergecheck", self.EmergeCheck, 1, self)
	self:DelayedSync(timer.emerge, syncName.emerge)
    --self:TriggerEvent("BigWigs_StartCounterBar", self, "Sons dead", 8, "Interface\\Icons\\spell_fire_fire")
    --self:TriggerEvent("BigWigs_SetCounterBar", self, "Sons dead", (8 - 0.1))
end

function module:Emerge()
    phase = "emerged"
	firstKnockback = true
	sonsdead = 0 -- reset counter

	self:CancelDelayedSync(syncName.emerge)
	self:CancelScheduledEvent("bwragnarosemergecheck")
	self:CancelDelayedMessage(L["emerge_soon_message"])
	self:RemoveBar(L["emerge_bar"])
	
	if self.db.profile.emerge then
		self:Message(L["emerge_message"], "Attention")
	end
	
	self:Knockback()
	
	if self.db.profile.submerge then
		self:Bar(L["submerge_bar"], timer.submerge, icon.submerge)
		
		self:DelayedMessage(timer.submerge - 60, L["submerge_60sec_message"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.submerge - 30, L["submerge_30sec_message"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.submerge - 10, L["submerge_10sec_message"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.submerge - 5, L["submerge_5sec_message"], "Attention", nil, nil, true)
		
		self:DelayedSync(timer.submerge, syncName.submerge)
	end
    --self:TriggerEvent("BigWigs_StopCounterBar", self, "Sons dead")
end

function module:Knockback()
    if phase == "submerged" then
        self:Emerge()
    end
	if self.db.profile.aoeknock then
		if not firstKnockback then
			self:Message(L["knockback_message"], "Important")
		end
		firstKnockback = false
		
		self:Bar(L["knockback_bar"], timer.knockback, icon.knockback)
		self:DelayedMessage(timer.knockback - 5, L["knockback_soon_message"], "Urgent", true, "Alarm", nil, nil, true)
		self:DelayedWarningSign(timer.knockback - 5, icon.knockbackWarn, 5)
	end
end


------------------------------
--      Utility	Functions   --
------------------------------

function module:EmergeCheck()
	if UnitExists("target") and UnitName("target") == boss and UnitExists("targettarget") then
		self:Sync(syncName.emerge)
		return
	end
	
	local num = GetNumRaidMembers()
	for i = 1, num do
		local raidUnit = string.format("raid%starget", i)
		if UnitExists(raidUnit) and UnitName(raidUnit) == boss and UnitExists(raidUnit .. "target") then
			self:Sync(syncName.emerge)
			return
		end
	end
end