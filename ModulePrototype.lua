
assert( BigWigs, "BigWigs not found!")

local BB = BigWigs.BabbleBoss
local BZ = BigWigs.BabbleZone
local L = BigWigs.I18n["Core"]

--------------------------------
--      Module Prototype      --
--------------------------------

-- do not override
BigWigs.modulePrototype.core = BigWigs
BigWigs.modulePrototype.debugFrame = ChatFrame1
BigWigs.modulePrototype.engaged = false
BigWigs.modulePrototype.bossSync = nil -- "Ouro"

-- override
BigWigs.modulePrototype.revision = 1 -- To be overridden by the module!
BigWigs.modulePrototype.started = false
BigWigs.modulePrototype.zonename = nil -- AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
BigWigs.modulePrototype.enabletrigger = nil -- boss
BigWigs.modulePrototype.wipemobs = nil -- adds that will be considered in CheckForEngage
BigWigs.modulePrototype.toggleoptions = nil -- {"sweep", "sandblast", "scarab", -1, "emerge", "submerge", -1, "berserk", "bosskill"}
BigWigs.modulePrototype.proximityCheck = nil -- function(unit) return CheckInteractDistance(unit, 2) end
BigWigs.modulePrototype.proximitySilent = nil -- false

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
    
    -- workaround to trigger OnSetup if enabled manually
    self:RegisterEvent("Ace2_AddonEnabled")
end
function BigWigs.modulePrototype:Ace2_AddonEnabled(module)
    if module and type(module) == "table" and module:ToString() == self:ToString() and self:IsBossModule() then
        BigWigs:SetupModule(module:ToString())
    end
end


-- override
function BigWigs.modulePrototype:OnSetup()
end
function BigWigs.modulePrototype:OnEngage()
end
function BigWigs.modulePrototype:OnDisengage()
end

-- do not override
function BigWigs.modulePrototype:Engage()
    self:DebugMessage("Engage() " .. self:ToString())
    
    if not BigWigs:IsModuleActive(self) then
        BigWigs:EnableModule(self:ToString())
    end
    
    if self.bossSync and not self.engaged then
        self.engaged = true
		self:Message(string.format(L["%s engaged!"], self.translatedName), "Positive")
        BigWigsBossRecords:StartBossfight(self)
        self:KTM_SetTarget(self:ToString())
		
		self:OnEngage()
    end
end
function BigWigs.modulePrototype:Disengage()
    -- you already released but someone else was still sending syncs
    self:CancelAllScheduledEvents()
	
	if BigWigs:IsModuleActive(self) then
        self.engaged = false
        self.started = false
        
        
        self:KTM_ClearTarget()

        BigWigsAutoReply:EndBossfight()

        self:RemoveIcon()
		self:RemoveWarningSign("", true)
        BigWigsBars:Disable(self)
        BigWigsBars:BigWigs_HideCounterBars()
        
        self:RemoveProximity()
		
		self:OnDisengage()
    end
end
function BigWigs.modulePrototype:Victory()
    if self.engaged then
        if self.db.profile.bosskill then 
            self:Message(string.format(L["%s has been defeated"], self.translatedName), "Bosskill", nil, "Victory") 
        end
    
        BigWigsBossRecords:EndBossfight(self)

        self:DebugMessage("Boss dead, disabling module ["..self:ToString().."].")
        self.core:DisableModule(self:ToString())
    end
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
		self:Sync(self:GetEngageSync() .. " " .. self.bossSync)
    end
end

function BigWigs.modulePrototype:GetWipeSync()
	return "BossWipe"
end
--[[function BigWigs.modulePrototype:SendWipeSync()
    if self.bossSync then
        --self:TriggerEvent("BigWigs_SendSync", "BossEngaged "..self:ToString())
		self:Sync(self:GetWipeSync() .. " " .. self.bossSync)
    end
end]]

function BigWigs.modulePrototype:GetBossDeathSync()
	return "BossDeath"
end
function BigWigs.modulePrototype:SendBossDeathSync()
    if self.bossSync then
		self:Sync(self:GetBossDeathSync() .. " " .. self.bossSync)
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
    BigWigs:CheckForEngage(self)
end

function BigWigs.modulePrototype:CheckForWipe()
    BigWigs:CheckForWipe(self)
end

function BigWigs.modulePrototype:CheckForBossDeath(msg)
    BigWigs:CheckForBossDeath(msg, self)
end

-- override
function BigWigs.modulePrototype:BigWigs_RecvSync(sync, rest, nick)
end

-- test functions
function BigWigs.modulePrototype:TestDisable()
	self:CancelAllScheduledEvents()
	self:RemoveIcon()
	self:RemoveWarningSign("", true)
	BigWigsBars:Disable(self)
	BigWigsBars:BigWigs_HideCounterBars()
	self:RemoveProximity()

	BigWigs:TriggerEvent("BigWigs_RebootModule", self:ToString())
	BigWigs:DisableModule(self:ToString())
end
function BigWigs.modulePrototype:ModuleTest()
end
function BigWigs.modulePrototype:Test()
end

------------------------------
--      Provided API      --
------------------------------

local delayPrefix = "ScheduledEventPrefix"

function BigWigs.modulePrototype:Sync(sync)
	self:TriggerEvent("BigWigs_SendSync", sync)
end
function BigWigs.modulePrototype:DelayedSync(delay, sync)
	self:ScheduleEvent(delayPrefix .. "Sync" .. self:ToString() .. sync, "BigWigs_SendSync", delay, sync)
end
function BigWigs.modulePrototype:CancelDelayedSync(sync)
    self:CancelScheduledEvent(delayPrefix .. "Sync" .. self:ToString() .. sync)
end
function BigWigs.modulePrototype:ThrottleSync(throttle, sync)
    self:TriggerEvent("BigWigs_ThrottleSync", sync, throttle)
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

function BigWigs.modulePrototype:Bar(text, time, icon, otherColor, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10)
	self:TriggerEvent("BigWigs_StartBar", self, text, time, "Interface\\Icons\\" .. icon, otherColor, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10)
end
function BigWigs.modulePrototype:RemoveBar(text)
	self:TriggerEvent("BigWigs_StopBar", self, text)
end
function BigWigs.modulePrototype:IrregularBar(text, minTime, maxTime, icon, otherColor, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10)
	BigWigsBars:StartIrregularBar(self, text, minTime, maxTime, "Interface\\Icons\\" .. icon, otherColor, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10)
end
function BigWigs.modulePrototype:DelayedBar(delay, text, time, icon, otherColor, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10)
	return self:ScheduleEvent(delayPrefix .. "Bar" .. self:ToString() .. text, "BigWigs_StartBar", delay, self, text, time, "Interface\\Icons\\" .. icon, otherColor, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10)
end
function BigWigs.modulePrototype:CancelDelayedBar(text)
    self:CancelScheduledEvent(delayPrefix .. "Bar" .. self:ToString() .. text)
end
function BigWigs.modulePrototype:BarStatus(text)
    local registered, time, elapsed, running = BigWigsBars:GetBarStatus(self, text)
    return registered, time, elapsed, running
end
function BigWigs.modulePrototype:BarId(text)
    return BigWigsBars:GetBarId(self, text)
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

function BigWigs.modulePrototype:Icon(name, iconnumber, restoreTime)
	self:TriggerEvent("BigWigs_SetRaidIcon", name, iconnumber, restoreTime)
end
function BigWigs.modulePrototype:RemoveIcon()
	self:TriggerEvent("BigWigs_RemoveRaidIcon")
end
function BigWigs.modulePrototype:DelayedRemoveIcon(delay)
    self:ScheduleEvent(delayPrefix .. "Icon" .. self:ToString(), "BigWigs_RemoveRaidIcon", delay)
end


function BigWigs.modulePrototype:WarningSign(icon, duration, force)
	self:TriggerEvent("BigWigs_ShowWarningSign", "Interface\\Icons\\" .. icon, duration, force)
end
function BigWigs.modulePrototype:RemoveWarningSign(icon, forceHide)
	self:TriggerEvent("BigWigs_HideWarningSign", "Interface\\Icons\\" .. icon, forceHide)
end
function BigWigs.modulePrototype:DelayedWarningSign(delay, icon, duration, id)
	if not id then id = "_" end
	self:ScheduleEvent(delayPrefix .. "WarningSign" .. self:ToString() .. icon .. id, "BigWigs_ShowWarningSign", delay, "Interface\\Icons\\" .. icon, duration)
end
function BigWigs.modulePrototype:CancelDelayedWarningSign(icon, id)
    if not id then id = "_" end
    self:CancelScheduledEvent(delayPrefix .. "WarningSign" .. self:ToString() .. icon .. id)
end
function BigWigs.modulePrototype:WarningSignOnClick(func)
	BigWigsWarningSign:OnClick(func)
end


function BigWigs.modulePrototype:Say(msg)
	SendChatMessage(msg, "SAY")
end

-- proximity
function BigWigs.modulePrototype:Proximity()
    BigWigs:Proximity(self:ToString())
end

function BigWigs.modulePrototype:RemoveProximity()
    BigWigs:RemoveProximity()
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


-------------------------------
--      Module Handling      --
-------------------------------

BigWigs.i18n = {}
function BigWigs:ModuleDeclaration(bossName, zoneName)
	translatedName = AceLibrary("Babble-Boss-2.2")[bossName]
    local module = BigWigs:NewModule(translatedName)
    --local L = AceLibrary("AceLocale-2.2"):new("BigWigs" .. translatedName)
	BigWigs.I18n[bossName] = AceLibrary("AceLocale-2.2"):new("BigWigs" .. module.name)
	module.translatedName = translatedName
	
	--local name = string.gsub(bossName, "%s", "") -- untranslated, unique string
	module.bossSync = bossName
	    
    -- zone
    local raidZones = {"Blackwing Lair", "Ruins of Ahn'Qiraj", "Ahn'Qiraj", "Molten Core", "Naxxramas", "Zul'Gurub"}
    local isOutdoorraid = true
    for i, value in ipairs(raidZones) do
        if value == zoneName then
            module.zonename = AceLibrary("Babble-Zone-2.2")[zoneName]
            isOutdoorraid = false
            break
        end
    end
    if isOutdoorraid then
        module.zonename = { 
            AceLibrary("AceLocale-2.2"):new("BigWigs")["Outdoor Raid Bosses Zone"],
            AceLibrary("Babble-Zone-2.2")[zoneName]
        }
    end
    
    --return module, L
	return module, BigWigs.I18n[bossName]
end

function BigWigs:RegisterModule(name, module)
	--[[if module:IsRegistered() then
		error(string.format("%q is already registered.", name))
		return
	end]]

	if module:IsBossModule() then 
		self:ToggleModuleActive(module, false)
	end

	-- Set up DB
	local opts
	if module:IsBossModule() and module.toggleoptions then
		opts = {}
		for _,v in pairs(module.toggleoptions) do 
			if v ~= -1 then 
				opts[v] = true 
			end 
		end
	end

	if module.db and module.RegisterDefaults and type(module.RegisterDefaults) == "function" then
		module:RegisterDefaults("profile", opts or module.defaultDB or {})
	else
		self:RegisterDefaults(name, "profile", opts or module.defaultDB or {})
	end

	if not module.db then 
		module.db = self:AcquireDBNamespace(name) 
	end

	-- Set up AceConsole
	if module:IsBossModule() then
		local cons
		local revision = type(module.revision) == "number" and module.revision or -1
		local L2 = AceLibrary("AceLocale-2.2"):new("BigWigs"..name)
		if module.toggleoptions then
			local m = module
			cons = {
				type = "group",
				name = name,
				desc = string.format(L["Options for %s (r%s)."], name, revision),
				args = {
					[L["toggle"]] = {
						type = "toggle",
						name = L["Active"],
						order = 1,
						desc = L["Activate or deactivate this module."],
						get = function() return m.core:IsModuleActive(m) end,
						set = function() m.core:ToggleModuleActive(m) end,
					},
					[L["reboot"]] = {
						type = "execute",
						name = L["Reboot"],
						order = 2,
						desc = L["Reboot this module."],
						func = function() m.core:TriggerEvent("BigWigs_RebootModule", m:ToString()) end,
						hidden = function() return not m.core:IsModuleActive(m) end,
					},
					[L["rebootall"]] = {
						type = "execute",
						name = L["Reboot All"],
						desc = L["Forces the module to reset for everyone in the raid.\n\n(Requires assistant or higher)"],
						order = 3,
						func = function() if (IsRaidLeader() or IsRaidOfficer()) then m.core:TriggerEvent("BigWigs_SendSync", "RebootModule "..tostring(module)) end end,
						hidden = function() return not m.core:IsModuleActive(m) end,
					},
					[L["debug"]] = {
						type = "toggle",
						name = L["Debugging"],
						desc = L["Show debug messages."],
						order = 4,
						get = function() return m:IsDebugging() end,
						set = function(v) m:SetDebugging(v) end,
						hidden = function() return not m:IsDebugging() and not BigWigs:IsDebugging() end,
					},
				},
			}
			local x = 10
			for _,v in pairs(module.toggleoptions) do
				local val = v
				x = x + 1
				if x == 11 and v ~= "bosskill" then
					cons.args["headerblankspotthingy"] = {
						type = "header",
						order = 4,
					}
				end
				if v == -1 then
					cons.args["blankspacer"..x] = {
						type = "header",
						order = x,
					}
				else
					local l = v == "bosskill" and L or L2
					if l:HasTranslation(v.."_validate") then
						cons.args[l[v.."_cmd"]] = {
							type = "text",
							order = v == "bosskill" and -1 or x,
							name = l[v.."_name"],
							desc = l[v.."_desc"],
							get = function() return m.db.profile[val] end,
							set = function(v) m.db.profile[val] = v end,
							validate = l[v.."_validate"],
						}
					else
						cons.args[l[v.."_cmd"]] = {
							type = "toggle",
							order = v == "bosskill" and -1 or x,
							name = l[v.."_name"],
							desc = l[v.."_desc"],
							get = function() return m.db.profile[val] end,
							set = function(v) m.db.profile[val] = v end,
						}
					end
				end
			end
		end

		if cons or module.consoleOptions then
			local zonename = type(module.zonename) == "table" and module.zonename[1] or module.zonename
			local zone = zonename
			if BZ:HasReverseTranslation(zonename) and L:HasTranslation(BZ:GetReverseTranslation(zonename)) then
				zone = L[BZ:GetReverseTranslation(zonename)]
			elseif L:HasTranslation(zonename) then
				zone = L[zonename]
			end
			if not self.cmdtable.args[L["boss"]].args[zone] then
				self.cmdtable.args[L["boss"]].args[zone] = {
					type = "group",
					name = zonename,
					desc = string.format(L["Options for bosses in %s."], zonename),
					args = {},
				}
			end
			if module.external then
				self.cmdtable.args[L["extra"]].args[L2["cmd"]] = cons or module.consoleOptions
			else
				self.cmdtable.args[L["boss"]].args[zone].args[L2["cmd"]] = cons or module.consoleOptions
			end
		end
	elseif module.consoleOptions then
		if module.external then
			self.cmdtable.args[L["extra"]].args[module.consoleCmd or name] = cons or module.consoleOptions
		else
			self.cmdtable.args[L["plugin"]].args[module.consoleCmd or name] = cons or module.consoleOptions
		end
	end

	module.registered = true
	if module.OnRegister and type(module.OnRegister) == "function" then
		module:OnRegister()
	end

	-- Set up target monitoring, in case the monitor module has already initialized
	if module.zonename and module.enabletrigger then
		self:TriggerEvent("BigWigs_RegisterForTargetting", module.zonename, module.enabletrigger)
	end
end

function BigWigs:EnableModule(moduleName, nosync)
	--local name = BB:HasTranslation(moduleName) and BB[moduleName] or moduleName
	local m = self:GetModule(moduleName)
	if m and not self:IsModuleActive(moduleName) then
        self:ToggleModuleActive(moduleName, true)
		if m:IsBossModule() then
			--m.bossSync = m:ToString()
			if not m.translatedName then
				m.translatedName = m:ToString()
				self:DebugMessage("translatedName for module " .. m:ToString() .. " missing")
			end
			self:TriggerEvent("BigWigs_Message", string.format(L["%s mod enabled"], m.translatedName or "??"), "Core", true)
		end
		
		--if not nosync then self:TriggerEvent("BigWigs_SendSync", (m.external and "EnableExternal " or "EnableModule ") .. m.bossSync or (BB:GetReverseTranslation(moduleName))) end
		if not nosync then self:TriggerEvent("BigWigs_SendSync", (m.external and "EnableExternal " or "EnableModule ") .. (m.synctoken or BB:GetReverseTranslation(moduleName))) end
        
		self:SetupModule(moduleName)
    end
end

-- registers generic events
function BigWigs:SetupModule(moduleName)
	--local name = BB:HasTranslation(moduleName) and BB[moduleName] or moduleName
	local m = self:GetModule(moduleName)
	if m and m:IsBossModule() then
		--m.bossSync = m:ToString()
		--m.bossSync = BB:GetReverseTranslation(moduleName) -- untranslated string
		--self:Print("bossSync: " .. string.gsub(BB:GetReverseTranslation(moduleName), "%s", ""))
		--m.bossSync = string.gsub(BB:GetReverseTranslation(moduleName), "%s", "") -- untranslated, unique string without spaces
		
		m:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage") -- addition
		m:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
		m:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH", "CheckForWipe")
		m:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "CheckForBossDeath") -- addition
		
		m:RegisterEvent("BigWigs_RecvSync")
		
		m.engaged = false
		
		m:OnSetup()
	end
end

function BigWigs:DisableModule(moduleName)
	--local name = BB:HasTranslation(moduleName) and BB[moduleName] or moduleName
	local m = self:GetModule(moduleName)
	if m then
		if m:IsBossModule() then
			m:Disengage()
		end
		self:ToggleModuleActive(m, false)
	end
end

-- event handler
function BigWigs:BigWigs_RebootModule(moduleName)    
	local moduleName = BB:HasTranslation(moduleName) and BB[moduleName] or moduleName    
    local m = self:GetModule(moduleName)
	if m and m:IsBossModule() then
		self:DebugMessage("BigWigs:BigWigs_RebootModule(): " .. m:ToString())
		m:Disengage()
		self:SetupModule(moduleName)
	end
end

function BigWigs:Test()
	local count = 0
	for name, module in self:IterateModules() do
		local status, retval = pcall(module.ModuleTest)
		if not status then
			count = count + 1
			BigWigs:Print("|cffff0000" .. name .. "|r ModuleTest |cffff0000failed:|r " .. retval)
		end
	end

	local msg = ""
	if count == 0 then
		msg = "No errors found."
	else
		msg = tostring(count) .. " error(s) found"
	end
	BigWigs:Print(msg)
end