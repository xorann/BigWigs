------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.mc.ragnaros
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = { L["misc_addName"] }
module.toggleoptions = {"aoeknock", "submerge", "emerge", "adds", "bosskill"}

module.defaultDB = {
	adds = false,
}


-- locals
module.timer = {
	emerge_soon = 40.9,
	hammer_of_ragnaros = 11,
	emerge = 90,
	submerge = 180,
	knockback = 30,
}
local timer = module.timer

module.icon = {
	emerge_soon = "Inv_Hammer_Unique_Sulfuras",
	hammer_of_ragnaros = "Spell_Fire_Incinerate",
	emerge = "Spell_Fire_Volcano",
	submerge = "Spell_Fire_SelfDestruct",
	knockback = "Spell_Fire_SoulBurn",
	knockbackWarn = "Ability_Rogue_Sprint",
}
local icon = module.icon

module.syncName = {
	knockback = "RagnarosKnockback",
	sons = "RagnarosSonDeadX",
	submerge = "RagnarosSubmerge",
	emerge = "RagnarosEmerge",
	engageSoon = "RagnarosEngageSoon",
	hammer = "RagnarosHammer",
}
local syncName = module.syncName

module.firstKnockback = nil
module.sonsdead = nil
module.phase = nil


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.engageSoon then
		self:EngageSoon()
	elseif sync == syncName.sons and rest and rest ~= "" then
        rest = tonumber(rest)
        self:SonDeath(rest)
	elseif sync == syncName.knockback then
		self:Knockback()
	elseif sync == syncName.submerge then
		self:Submerge()
	elseif sync == syncName.emerge then
		self:Emerge()
	elseif sync == syncName.hammer then
		self:Hammer()		
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:EngageSoon()
	self:Bar(L["msg_combat"], timer.emerge_soon, icon.emerge_soon)
end

function module:SonDeath(number)
	if number and number <= 8 and module.sonsdead < number then
		module.sonsdead = number
		if self.db.profile.adds then
			self:Message(string.format(L["msg_sonDeath"], module.sonsdead), "Positive")
		end
		
		if module.sonsdead == 8 then
		end
		--self:TriggerEvent("BigWigs_SetCounterBar", self, "Sons dead", (8 - module.sonsdead))
	end
end

function module:Submerge()
    module.phase = "submerged"
	self:CancelScheduledEvent("bwragnarosaekbwarn")
	self:RemoveBar(L["bar_knockback"])
	
	if self.db.profile.submerge then
		self:Message(L["msg_submerge"], "Important")
	end
	if self.db.profile.emerge then
		self:Bar(L["bar_emerge"], timer.emerge, icon.emerge)
		self:DelayedMessage(timer.emerge - 15, L["msg_emergeSoon"], "Urgent", nil, nil, true)
	end
	self:ScheduleRepeatingEvent("bwragnarosemergecheck", self.EmergeCheck, 0.5, self)
	self:DelayedSync(timer.emerge, syncName.emerge)
    --self:TriggerEvent("BigWigs_StartCounterBar", self, "Sons dead", 8, "Interface\\Icons\\spell_fire_fire")
    --self:TriggerEvent("BigWigs_SetCounterBar", self, "Sons dead", (8 - 0.1))
end

function module:Emerge()
    module.phase = "emerged"
	module.firstKnockback = true
	module.sonsdead = 0 -- reset counter

	self:CancelDelayedSync(syncName.emerge)
	self:CancelScheduledEvent("bwragnarosemergecheck")
	self:CancelDelayedMessage(L["msg_emergeSoon"])
	self:RemoveBar(L["bar_emerge"])
	
	if self.db.profile.emerge then
		self:Message(L["msg_emergeNow"], "Attention")
	end
	
	self:Knockback()
	
	if self.db.profile.submerge then
		self:Bar(L["bar_submerge"], timer.submerge, icon.submerge)
		
		self:DelayedMessage(timer.submerge - 60, L["msg_submerge60"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.submerge - 30, L["msg_submerge30"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.submerge - 10, L["msg_submerge10"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.submerge - 5, L["msg_submerge5"], "Attention", nil, nil, true)
		
		self:DelayedSync(timer.submerge, syncName.submerge)
	end
    --self:TriggerEvent("BigWigs_StopCounterBar", self, "Sons dead")
end

function module:Knockback()
    if module.phase == "submerged" then
        self:Emerge()
    end
	if self.db.profile.aoeknock then
		if not module.firstKnockback then
			self:Message(L["msg_knockbackNow"], "Important")
		end
		module.firstKnockback = false
		
		self:Bar(L["bar_knockback"], timer.knockback, icon.knockback)
		self:DelayedMessage(timer.knockback - 5, L["msg_knockbackSoon"], "Urgent", true, "Alarm", nil, nil, true)
		self:DelayedWarningSign(timer.knockback - 5, icon.knockbackWarn, 5)
	end
end

function module:Hammer()
	self:Bar(L["bar_hammer"], timer.hammer_of_ragnaros, icon.hammer_of_ragnaros) -- isn't doing anything on nefarian
end


------------------------------
-- Utility Functions   		--
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


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:EmergeCheck()
	module:Hammer()
	module:Knockback()
	module:Emerge()
	module:Submerge()
	module:SonDeath(1)
	module:EngageSoon()
	
	module:BigWigs_RecvSync(syncName.engageSoon)
	module:BigWigs_RecvSync(syncName.sons, 1)
	module:BigWigs_RecvSync(syncName.knockback)
	module:BigWigs_RecvSync(syncName.submerge)
	module:BigWigs_RecvSync(syncName.emerge)
	module:BigWigs_RecvSync(syncName.hammer)
end
