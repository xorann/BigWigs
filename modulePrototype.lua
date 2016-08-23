
--------------------------------
--      Module Prototype      --
--------------------------------

BigWigs.modulePrototype.core = BigWigs
BigWigs.modulePrototype.debugFrame = ChatFrame1
BigWigs.modulePrototype.revision = 1 -- To be overridden by the module!
BigWigs.modulePrototype.engaged = false
BigWigs.modulePrototype.started = false

-- override
BigWigsOuro.zonename = nil -- AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
BigWigsOuro.enabletrigger = nil -- boss
BigWigsOuro.bossSync = nil -- "Ouro"
BigWigsOuro.toggleoptions = nil -- {"sweep", "sandblast", "scarab", -1, "emerge", "submerge", -1, "berserk", "bosskill"}
BigWigsCThun.proximityCheck = nil -- function(unit) return CheckInteractDistance(unit, 2) end
BigWigsCThun.proximitySilent = nil -- false

-- do not override
function BigWigs.modulePrototype:IsBossModule()
	return self.zonename and self.enabletrigger and true
end
-- do not override
function BigWigs.modulePrototype:DebugMessage(msg)
    self.core:DebugMessage(msg, self)
end
-- do not override
function BigWigs.modulePrototype:OnInitialize()
	-- Unconditionally register, this shouldn't happen from any other place
	-- anyway.
	self.core:RegisterModule(self.name, self)

	-- Notify observers that we have loaded.
	self:TriggerEvent("BigWigs_ModuleLoaded", self.name, self)
end

function BigWigs.modulePrototype:OnSetup()
end

function BigWigs.modulePrototype:Engage()
    self:DebugMessage("Engage() " .. self:ToString())
    
    if not BigWigs:IsModuleActive(self) then
        BigWigs:EnableModule(self:ToString())
    end
    
    if self.bossSync and not self.engaged then
        self.engaged = true
		self:Message(string.format(L["%s engaged!"], self:ToString()), "Positive")
        --self:TriggerEvent("BigWigs_Message", string.format(L["%s engaged!"], self:ToString()), "Positive")
        BigWigsBossRecords:StartBossfight(self)
        self:KTM_SetTarget(self:ToString())
    end
end
function BigWigs.modulePrototype:Disengage()
    if BigWigs:IsModuleActive(self) then
        self.engaged = false
        self.started = false
        
        self:CancelAllScheduledEvents()
        
        self:KTM_ClearTarget()

        BigWigsAutoReply:EndBossfight()

        self:RemoveIcon()
		self:RemoveWarningSign("", true)
        BigWigsBars:Disable(self)
        BigWigsBars:BigWigs_HideCounterBars()
    end
end
function BigWigs.modulePrototype:Victory()
    if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(L["%s has been defeated"], self:ToString()), "Bosskill", nil, "Victory") end
    
    BigWigsBossRecords:EndBossfight(self)
    
    self:DebugMessage("Boss dead, disabling module ["..self:ToString().."].")
    self:Disable()
end
function BigWigs.modulePrototype:Disable()
    self:Disengage()
    self.core:ToggleModuleActive(self, false)
end

-- synchronize functions
function BigWigs.modulePrototype:GetEngageSync()
	return "BossEngaged"
end
function BigWigs.modulePrototype:SendEngageSync()
    if self.bossSync then
        --self:TriggerEvent("BigWigs_SendSync", "BossEngaged "..self:ToString())
		self:Sync(self:GetEngageSync() .. " " .. self:ToString())
    end
end

function BigWigs.modulePrototype:GetWipeSync()
	return "BossWipe"
end
function BigWigs.modulePrototype:SendWipeSync()
    if self.bossSync then
        --self:TriggerEvent("BigWigs_SendSync", "BossEngaged "..self:ToString())
		self:Sync(self:GetWipeSync() .. " " .. self:ToString())
    end
end

function BigWigs.modulePrototype:GetBossDeathSync()
	return "BossDeath"
end
function BigWigs.modulePrototype:SendBossDeathSync()
    if self.bossSync then
        --self:TriggerEvent("BigWigs_SendSync", "Bosskill "..self.bossSync)
		self:Sync(self:GetBossDeathSync() .. " " .. self:ToString())
    end
end

-- event handler
local yellTriggers = {} -- [i] = {yell, bossmod}
function BigWigs.modulePrototype:RegisterYellEngage(yell)
    -- Bosses with Yells as Engagetrigger should go through even when the bossmod isn't active yet.
    tinsert(yellTriggers, {yell, self})
end
function BigWigs:CHAT_MSG_MONSTER_YELL(msg)
    for i=1, table.getn(yellTriggers) do
        local yell  = yellTriggers[i][1]
        local mod   = yellTriggers[i][2]
        if string.find(msg, yell) then
            -- enable and engage
            self:EnableModule(mod:ToString())
			--self:TriggerEvent("BigWigs_SendSync", "BossEngaged "..self:ToString())
            mod:SendEngageSync()
        end
    end
end
BigWigs:RegisterEvent("CHAT_MSG_MONSTER_YELL")

function BigWigs.modulePrototype:CheckForEngage()
	local function IsBossInCombat()
		local t = self.enabletrigger
		local a = self.wipemobs
		if not t then return false end
		if type(t) == "string" then t = {t} end
		if a then
			if type(a) == "string" then a = {a} end
			for k,v in pairs(a) do table.insert(t, v) end
		end

		if UnitExists("target") and UnitAffectingCombat("target") then
			local target = UnitName("target")
			for _, mob in pairs(t) do
				if target == mob then
					return true
				end
			end
		end

		local num = GetNumRaidMembers()
		for i = 1, num do
			local raidUnit = string.format("raid%starget", i)
			if UnitExists(raidUnit) and UnitAffectingCombat(raidUnit) then
				local target = UnitName(raidUnit)
				for _, mob in pairs(t) do
					if target == mob then
						return true
					end
				end
			end
		end
		return false
	end

	local inCombat = IsBossInCombat()
	local running = self:IsEventScheduled(self:ToString().."_CheckStart")
	if inCombat then
        self:DebugMessage("Scan returned true, engaging ["..self:ToString().."].")
		self:CancelScheduledEvent(self:ToString().."_CheckStart")

        self:SendEngageSync()
	elseif not running then
		self:ScheduleRepeatingEvent(self:ToString().."_CheckStart", self.CheckForEngage, .5, self)
	end
end
function BigWigs.modulePrototype:CheckForWipe()    
    if not self or not self:IsBossModule() then return end
    self:DebugMessage("BigWigs." .. self:ToString() .. ":CheckForWipe()")
	
    -- start wipe check in regular intervals
    local running = self:IsEventScheduled(self:ToString().."_CheckWipe")
    if not running then
		self:ScheduleRepeatingEvent(self:ToString().."_CheckWipe", self.CheckForWipe, 5, self)
        return
	end
    
    local function RaidMemberInCombat()
        if UnitAffectingCombat("player") then
            return true
        end

        local num = GetNumRaidMembers()
        for i = 1, num do
            local raidUnit = string.format("raid%s", i)
            if UnitExists(raidUnit) and UnitAffectingCombat(raidUnit) then
                return true
            end
        end
        
        return false
    end
    
	local inCombat = RaidMemberInCombat()
	if not inCombat then
        self:DebugMessage("Wipe detected for module ["..self:ToString().."].")
        self:CancelScheduledEvent(self:ToString().."_CheckWipe")
		self:SendWipeSync()
	end
end
function BigWigs.modulePrototype:CheckForBossDeath(msg)
    if msg == string.format(UNITDIESOTHER, self:ToString()) or msg == string.format(L["You have slain %s!"], self:ToString()) then
        self:SendBosskillSync()
    end
end

------------------------------
--      Provided API      --
------------------------------

local delayPrefix = "ScheduledEventPrefix"

function BigWigs.modulePrototype:Bar(text, time, icon, otherColor, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10)
	self:TriggerEvent("BigWigs_StartBar", self, text, time, "Interface\\Icons\\" .. icon, otherColor, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10)
end
function BigWigs.modulePrototype:RemoveBar(text)
	self:TriggerEvent("BigWigs_StopBar", self, text)
end
function BigWigs.modulePrototype:DelayedBar(delay, text, time, icon, otherColor, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10)
	return self:ScheduleEvent(delayPrefix .. "Bar" .. self:ToString() .. text, "BigWigs_StartBar", delay, self, text, time, "Interface\\Icons\\" .. icon, otherColor, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10)
end
function BigWigs.modulePrototype:CancelDelayedBar(text)
    self:CancelScheduledEvent(delayPrefix .. "Bar" .. self:ToString() .. text)
end

function BigWigs.modulePrototype:Icon(name, iconnumber)
	self:TriggerEvent("BigWigs_SetRaidIcon", name, iconnumber)
end
function BigWigs.modulePrototype:RemoveIcon()
	self:TriggerEvent("BigWigs_RemoveRaidIcon")
end

function BigWigs.modulePrototype:Message(text, priority, noRaidSay, sound, broadcastOnly)
	self:TriggerEvent("BigWigs_Message", text, priority, noRaidSay, sound, broadcastOnly)
end
function BigWigs.modulePrototype:DelayedMessage(delay, text, priority, noRaidSay, sound, broadcastOnly)
	return self:ScheduleEvent(delayPrefix .. "Message" .. self:ToString() .. text, "BigWigs_Message", delay, text, priority, noRaidSay, sound, broadcastOnly)
end
function BigWigs.modulePrototype:CancelDelayedMessage(text)
    self:CancelScheduledEvent(delayPrefix .. "Message" .. self:ToString() .. text)
end

function BigWigs.modulePrototype:Sound(sound)
	self:TriggerEvent("BigWigs_Sound", sound)
end
function BigWigs.modulePrototype:DelayedSound(delay, sound, id)
    if not id then id = "_" end
	return self:ScheduleEvent(delayPrefix .. "Sound" .. self:ToString() .. sound .. id, "BigWigs_Sound", delay, sound)
end
function BigWigs.modulePrototype:CancelDelayedSound(sound, id)
    if not id then id = "_" end
    self:CancelScheduledEvent(delayPrefix .. "Sound" .. self:ToString() .. sound .. id)
end

function BigWigs.modulePrototype:Sync(sync)
	self:TriggerEvent("BigWigs_SendSync", sync)
end
function BigWigs.modulePrototype:DelayedSync(delay, sync)
	self:ScheduleEvent("BigWigs_SendSync", delay, sync)
end
function BigWigs.modulePrototype:CancelDelayedSync(sync)
    self:CancelScheduledEvent(delayPrefix .. "Sync" .. self:ToString() .. sync)
end

function BigWigs.modulePrototype:WarningSign(texturePath, duration, force)
	self:TriggerEvent("BigWigs_ShowWarningSign", texturePath, duration, force)
end
function BigWigs.modulePrototype:RemoveWarningSign(texturePath, forceHide)
	self:TriggerEvent("BigWigs_HideWarningSign", texturePath, forceHide)
end

function BigWigs.modulePrototype:Say(msg)
	SendChatMessage(msg, "SAY")
end

-- KLHThreatMeter
function BigWigs.modulePrototype:KTM_Reset()
    BigWigs:KTM_Reset()
end
function BigWigs.modulePrototype:KTM_ClearTarget(forceReset)
	BigWigs:KTM_ClearTarget(forceReset)
end
function BigWigs.modulePrototype:KTM_SetTarget(targetName, forceReset)
	if IsAddOnLoaded("KLHThreatMeter") then
        if targetName and type(targetName) == "string" and (IsRaidLeader() or IsRaidOfficer()) then
            if UnitName("target") == targetName then
                klhtm.net.sendmessage("target " .. targetName)
                if forceReset then
                    self:KTM_Reset()
                end
            else
                -- we need to delay the setting mastertarget, as KTM only allows it to work if the person
                -- calling the mastertarget sync has the unit as target
                BigWigs:RegisterEvent("PLAYER_TARGET_CHANGED")
                BigWigs.masterTarget    = targetName
                BigWigs.forceReset      = forceReset
            end
        end
    end
end
