
local revision = 20019
local forkName = "Classic-WoW" -- please change this name if you forked this addon. must not contain spaces
local isDeveloperVersion = false

------------------------------
--      Are you local?      --
------------------------------

local BZ = AceLibrary("Babble-Zone-2.2")
local BB = AceLibrary("Babble-Boss-2.2")
local L = AceLibrary("AceLocale-2.2"):new("BigWigs")

local waterfall = AceLibrary("Waterfall-1.0")

local surface = AceLibrary("Surface-1.0")

surface:Register("Armory", "Interface\\AddOns\\BigWigs\\Textures\\Armory")
surface:Register("Otravi", "Interface\\AddOns\\BigWigs\\Textures\\otravi")
surface:Register("Smooth", "Interface\\AddOns\\BigWigs\\Textures\\smooth")
surface:Register("Glaze", "Interface\\AddOns\\BigWigs\\Textures\\glaze")
surface:Register("Charcoal", "Interface\\AddOns\\BigWigs\\Textures\\Charcoal")
surface:Register("BantoBar", "Interface\\AddOns\\BigWigs\\Textures\\default")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["%s mod enabled"] = true,
	["Target monitoring enabled"] = true,
	["Target monitoring disabled"] = true,
	["%s engaged!"] = true,
	["%s has been defeated"] = true,     -- "<boss> has been defeated"
	["%s have been defeated"] = true,    -- "<bosses> have been defeated"

	-- AceConsole strings
	["boss"] = true,
	["Bosses"] = true,
	["Options for boss modules."] = true,
	["Options for bosses in %s."] = true, -- "Options for bosses in <zone>"
	["Options for %s (r%s)."] = true,     -- "Options for <boss> (<revision>)"
	["plugin"] = true,
	["Plugins"] = true,
	["Options for plugins."] = true,
	["extra"] = true,
	["Extras"] = true,
	["Options for extras."] = true,
	["toggle"] = true,
	["Active"] = true,
	["Activate or deactivate this module."] = true,
	["reboot"] = true,
	["rebootall"] = true,
	["Reboot"] = true,
	["Reboot All"] = true,
	["Reboot this module."] = true,
	["debug"] = true,
	["Debugging"] = true,
	["Show debug messages."] = true,
	["Forces the module to reset for everyone in the raid.\n\n(Requires assistant or higher)"] = true,
	["%s has requested forced reboot for the %s module."] = true,
	bosskill_cmd = "kill",
	bosskill_name = "Boss death",
	bosskill_desc = "Announce when boss is defeated",

	["Other"] = true,
	["Load"] = true,
	["Load All"] = true,
	["Load all %s modules."] = true,
	
	-- AceConsole zone commands
	["Zul'Gurub"] = "ZG",
	["Molten Core"] = "MC",
	["Blackwing Lair"] = "BWL",
	["Ahn'Qiraj"] = "AQ40",
	["Ruins of Ahn'Qiraj"] = "AQ20",
	["Onyxia's Lair"] = "Onyxia",
	["Naxxramas"] = "Naxxramas",
	["Silithus"] = true,
	["Outdoor Raid Bosses"] = "Outdoor",
	["Outdoor Raid Bosses Zone"] = "Outdoor Raid Bosses", -- DO NOT EVER TRANSLATE untill I find a more elegant option
	
	--Name for exception bosses (neutrals that enable modules)
	["Vaelastrasz the Corrupt"] = true,
	["Lord Victor Nefarius"] = true,
	
    ["You have slain %s!"] = true,
	
	["You are using a developer version of BigWigs.\nPlease download a proper release at https://github.com/xorann/BigWigs/releases"] = true,
	["Close"] = true,
	["Cancel"] = true,
} end)

  
L:RegisterTranslations("deDE", function() return {
	["%s mod enabled"] = "%s Modul aktiviert",
	["Target monitoring enabled"] = "Zielüberwachung aktiviert",
	["Target monitoring disabled"] = "Zielüberwachung deaktiviert",
	["%s engaged!"] = "%s angegriffen!",
	["%s has been defeated"] = "%s wurde besiegt",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s wurden besiegt",    -- "<bosses> have been defeated"

	-- AceConsole strings
	-- ["boss"] = true,
	["Bosses"] = "Bosse",
	["Options for boss modules."] = "Optionen für Boss Module.",
	["Options for bosses in %s."] = "Optionen für Bosse in %s.", -- "Options for bosses in <zone>"
	["Options for %s (r%s)."] = "Optionen für %s (r%s).",     -- "Options for <boss> (<revision>)"
	-- ["plugin"] = true,
	["Plugins"] = "Plugins",
	["Options for plugins."] = "Optionen für Plugins.",
	-- ["extra"] = true,
	["Extras"] = "Extras",
	["Options for extras."] = "Optionen für Extras.",
	-- ["toggle"] = true,
	["Active"] = "Aktivieren",
	["Activate or deactivate this module."] = "Aktiviert oder deaktiviert dieses Modul.",
	-- ["reboot"] = true,
	["Reboot"] = "Neustarten",
	["Reboot All"] = "Alles Neustarten",
	["Reboot this module."] = "Startet dieses Modul neu.",
	-- ["debug"] = true,
	["Debugging"] = "Debugging",
	["Show debug messages."] = "Zeige Debug Nachrichten.",
	["Forces the module to reset for everyone in the raid.\n\n(Requires assistant or higher)"] = "Erzwingt dass das Modul für jeden im Raid zurückgesetzt wird.\n\n(Benötigt Schlachtzugleiter oder Assistent)",
	["%s has requested forced reboot for the %s module."] = "%s hat einen Zwangsneustart für das %s-Modul beantragt.",
	-- bosskill_cmd = "kill",
	bosskill_name = "Boss besiegt",
	bosskill_desc = "Melde, wenn ein Boss besiegt wurde.",

	-- AceConsole zone commands
	["Zul'Gurub"] = "ZG",
	["Molten Core"] = "MC",
	["Blackwing Lair"] = "BWL",
	["Ahn'Qiraj"] = "AQ40",
	["Ruins of Ahn'Qiraj"] = "AQ20",
	["Onyxia's Lair"] = "Onyxia",
	["Naxxramas"] = "Naxxramas",
	-- ["Silithus"] = true,
	["Outdoor Raid Bosses"] = "Outdoor",
	-- ["Outdoor Raid Bosses Zone"] = "Outdoor Raid Bosses", -- DO NOT EVER TRANSLATE untill I find a more elegant option
            
    ["You have slain %s!"] = "Ihr habt %s getötet!",
	
	["You are using a developer version of BigWigs.\nPlease download a proper release at https://github.com/xorann/BigWigs/releases"] = "Du verwendest eine Entwicklerversion von BigWigs.\nBitte downloade einen ordentlichen Release von https://github.com/xorann/BigWigs/releases",
	["Close"] = "Schliessen",
	["Cancel"] = "Abbrechen",
} end)


---------------------------------
--      Addon Declaration      --
---------------------------------

BigWigs = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDebug-2.0", "AceModuleCore-2.0", "AceConsole-2.0", "AceDB-2.0", "AceHook-2.1")
BigWigs.BabbleZone = BZ
BigWigs.BabbleBoss = BB
BigWigs.i18n = {}
BigWigs.i18n["Core"] = L

BigWigs:SetModuleMixins("AceDebug-2.0", "AceEvent-2.0", "CandyBar-2.1")
BigWigs:RegisterDB("BigWigsDB", "BigWigsDBPerChar")
BigWigs.cmdtable = {type = "group", handler = BigWigs, args = {
	[L["boss"]] = {
		type = "group",
		name = L["Bosses"],
		desc = L["Options for boss modules."],
		args = {},
		disabled = function() return not BigWigs:IsActive() end,
	},
	[L["plugin"]] = {
		type = "group",
		name = L["Plugins"],
		desc = L["Options for plugins."],
		args = {},
		disabled = function() return not BigWigs:IsActive() end,
	},
	[L["extra"]] = {
		type = "group",
		name = L["Extras"],
		desc = L["Options for extras."],
		args = {},
		disabled = function() return not BigWigs:IsActive() end,
	},
}}

BigWigs:RegisterChatCommand({"/bwcl", "/BigWigscl"}, BigWigs.cmdtable)
BigWigs:RegisterChatCommand({"/bw", "/BigWigs"}, function() waterfall:Open("BigWigs") end)
waterfall:Register('BigWigs', 'aceOptions',BigWigs.cmdtable, 'title','BigWigs', 'colorR', 0.2, 'colorG', 0.6, 'colorB', 0.2) 

BigWigs.debugFrame = ChatFrame1
BigWigs.revision = revision
BigWigs.forkName = forkName
BigWigs.isDeveloperVersion = isDeveloperVersion


function BigWigs:DebugMessage(msg, module)
    if not msg then msg = "" end
    local prefix = "|cfB34DFFf[BigWigs Debug]|r - ";
    local core = BigWigs
    local debugFrame = DEFAULT_CHAT_FRAME
    if module then
        if module.core then
            core = module.core
        end
        if module.debugFrame then
            debugFrame = self.debugFrame
        end
    end
    if core:IsDebugging() then
       (debugFrame or DEFAULT_CHAT_FRAME):AddMessage(prefix .. msg)
    end
end


------------------------------
-- Multi Server Support		--
------------------------------

BigWigs.server = {}
--[[
	BigWigs.server = {
		["Classic-WoW"] = {
			serverList = {
				["Nefarian"] = true
			},
			supportedBosses = {
				["The Twin Emperors"] = true, -- modulename
				["C'Thun"] = true
			}
		}
	}
]]
function BigWigs:RegisterServer(serverProjectName, serverName)
	if serverProjectName and serverName then
		-- check if server was already registered
		for aServerProjectName, aServerProject in pairs(BigWigs.server) do
			if aServerProject.serverList[serverName] then
				local function warning()
					BigWigs:Print("Server already registered by project " .. aServerProjectName)
				end
				BigWigs:ScheduleEvent("BigWigsRegisterServer"..serverProjectName, warning, 2)
				return
			end
		end

		-- server project already registered
		if BigWigs.server[serverProjectName] then
			-- server not registered
			if not BigWigs.server[serverProjectName].serverList[serverName] then
				BigWigs.server[serverProjectName].serverList[serverName] = true
			end
		-- server project not registered
		else
			BigWigs.server[serverProjectName] = {}
			BigWigs.server[serverProjectName].serverList = {}
			--table.insert(BigWigs.server[serverProjectName].serverList, serverName)
			BigWigs.server[serverProjectName].serverList[serverName] = true
			BigWigs.server[serverProjectName].supportedBosses = {}
		end
	end
end

function BigWigs:ServerProjectSupportsBoss(serverProjectName, bossName)
	if serverProjectName and bossName and BigWigs.server[serverProjectName] then
		BigWigs.server[serverProjectName].supportedBosses[bossName] = true
	else
		if not serverProjectName then
			serverProjectName = "nil"
		end
		if not bossName then
			bossName = "nil"
		end
		BigWigs:Print("(ServerProjectSupportsBoss) Unknown server. Could not add support for server " .. serverProjectName .. " and boss " .. bossName .. ". Please register server first using BigWigs:RegisterServer(serverProjectName, serverName)")
	end
end

--[[
--	returns true if the current server is registered for the serverProject
 ]]
function BigWigs:IsServerRegisteredForServerProject(serverProjectName)
	if serverProjectName then
		-- project registered
		if BigWigs.server[serverProjectName] then
			-- server registered for project
			if BigWigs.server[serverProjectName].serverList[GetRealmName()] then
				return true
			end
		end
	end

	return false
end

--[[
-- returns true if the boss is supported by the server project
 ]]
function BigWigs:IsBossSupportedByServerProject(bossName, serverProjectName)
	if bossName and serverProjectName then
		-- project registered
		if BigWigs.server[serverProjectName] then
			-- boss registered for project
			if BigWigs.server[serverProjectName].supportedBosses[bossName] then
				return true
			end
		end
	end

	return false
end

--[[
	returns nil if no server project registered the current server
	returns the server project as string if exactly one server project registered the current server
	returns a table of strings of all the server projects that registered the current server
 ]]
function BigWigs:IsServerRegisteredForAnyServerProject()
	-- any server project registered
	local project = nil
	if BigWigs.server then
		local currentServer = GetRealmName()
		for aServerProjectName, aServerProject in pairs(BigWigs.server) do
			if aServerProject.serverList[currentServer] then
				if project == nil then
					project = aServerProjectName
				elseif type(project) == "table" then
					table.insert(project, aServerProjectName)
				else
					local tmp = project
					project = {}
					table.insert(project, tmp)
					table.insert(project, aServerProjectName)
				end
			end
		end
	end

	return project
end

function BigWigs:IsBossSupportedByAnyServerProject(bossName)
	if bossName then
		if BigWigs.server then
			local currentServer = GetRealmName()
			for aServerProjectName, aServerProject in pairs(BigWigs.server) do
				if aServerProject.serverList[currentServer] then
					if aServerProject.supportedBosses[bossName] then
						return true
					end
				end
			end
		end
	end

	return false
end


------------------------------
--      KLHThreatMeter      --
------------------------------
local function IsKtmActive()
	if IsAddOnLoaded("KLHThreatMeter") and klhtm and klhtm.net and klhtm.target then
		return true
	end
	return false
end

function BigWigs:KTM_Reset()
	if IsKtmActive() then
        if IsRaidLeader() or IsRaidOfficer() then
            klhtm.net.clearraidthreat()
        end
    end
end

BigWigs.masterTarget = nil;
BigWigs.forceReset = nil;

function BigWigs:KTM_ClearTarget(forceReset)
    if IsKtmActive() and (IsRaidLeader() or IsRaidOfficer()) then
        klhtm.net.clearmastertarget()
        if forceReset then
            self:KTM_Reset()
        end
    end
end

function BigWigs:PLAYER_TARGET_CHANGED()
    if IsKtmActive() and BigWigs.masterTarget and (IsRaidLeader() or IsRaidOfficer()) then
        if klhtm.target.targetismaster(BigWigs.masterTarget) then
            -- the masterTarget was already setup correctly
            BigWigs:UnregisterEvent("PLAYER_TARGET_CHANGED")
            BigWigs.masterTarget   	= nil
            BigWigs.forceReset		= nil
            return
        end
        
        if UnitName("target") == BigWigs.masterTarget then
       	    -- our new target is the wanted target, setup masterTarget now
            klhtm.net.sendmessage("target " .. BigWigs.masterTarget)
            if BigWigs.forceReset then
                BigWigs:KTM_Reset()
                BigWigs.forceReset = nil
            end
            BigWigs.masterTarget   = nil
            BigWigs:UnregisterEvent("PLAYER_TARGET_CHANGED")
        end
    else
        BigWigs:UnregisterEvent("PLAYER_TARGET_CHANGED")
    end
end


--------------------------------------
-- Generic Boss Module Functions	--
--------------------------------------

--[[
	BigWigs.bossmods = {
		aq40 = {
			twins = "The Twin Emperors",
			cthun = "C'Thun"
		}
	}

	BigWigs.bossmods.aq40.twins
 ]]
BigWigs.bossmods = {}

function BigWigs:CheckForEngage(module)
    if module and module:IsBossModule() and not module.engaged then
        local function IsBossInCombat()
            local t = module.enabletrigger
            local a = module.wipemobs
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
        local running = module:IsEventScheduled(module:ToString().."_CheckStart")
        if inCombat then
            module:DebugMessage("Scan returned true, engaging ["..module:ToString().."].")
            module:CancelScheduledEvent(module:ToString().."_CheckStart")

            module:SendEngageSync()
        elseif not running then
            module:ScheduleRepeatingEvent(module:ToString().."_CheckStart", module.CheckForEngage, .5, module)
        end
    end
end

function BigWigs:CheckForWipe(module)    
    if module and module:IsBossModule() then
		local isInZone = false
		if type(module.zonename) == "string" and module.zonename == GetRealZoneText() then
			isInZone = true
		elseif type(module.zonename) == "table" then
			for _, v in pairs(module.zonename) do
				if v == GetRealZoneText() then
					isInZone = true
					break
				end
			end
		end
		if not isInZone then 
			BigWigs:DebugMessage("not in the zone: wipe")
			-- reset if you are not in the zone
			module:Wipe()
			return
		end
		
        --module:DebugMessage("BigWigs." .. module:ToString() .. ":CheckForWipe()")

        -- start wipe check in regular intervals
        local running = module:IsEventScheduled(module:ToString().."_CheckWipe")
        if not running then
            module:DebugMessage("CheckForWipe not running")
            module:ScheduleRepeatingEvent(module:ToString().."_CheckWipe", module.CheckForWipe, 5, module)
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
            module:DebugMessage("Wipe detected for module ["..module:ToString().."].")
            module:CancelScheduledEvent(module:ToString().."_CheckWipe")
            --self:TriggerEvent("BigWigs_RebootModule", module:ToString())
			module:Wipe()
			--module:SendWipeSync()
        end
    end
end

function BigWigs:CheckForBossDeath(msg, module)
    if module and module:IsBossModule() then
        if msg == string.format(UNITDIESOTHER, module:ToString()) or msg == string.format(L["You have slain %s!"], module.translatedName) then
            module:SendBossDeathSync()
        end
    end
end

-- proximity
function BigWigs:Proximity(moduleName)
    self:TriggerEvent("BigWigs_ShowProximity", moduleName)
end


function BigWigs:RemoveProximity()
    self:TriggerEvent("BigWigs_HideProximity")
end

--------------------------------------
-- Do not use a developer version	--
---------------------------------------

function BigWigs:CheckForDeveloperVersion()
	if self.isDeveloperVersion then
		BigWigs:Print(L["You are using a developer version of BigWigs.\nPlease download a proper release at https://github.com/xorann/BigWigs/releases"])
        
        local dialog = nil
        StaticPopupDialogs["BigWigsDeveloperVersionDialog"] = {
            text = L["You are using a developer version of BigWigs.\nPlease download a proper release at https://github.com/xorann/BigWigs/releases"],
            button1 = L["Close"],
            button2 = L["Cancel"],
            OnAccept = function()
                StaticPopup_Hide ("BigWigsDeveloperVersionDialog")
            end,
            OnCancel = function()
                StaticPopup_Hide ("BigWigsDeveloperVersionDialog")
            end,
            OnShow = function (self, data)
                local editbox = getglobal(this:GetName().."WideEditBox")
                editbox:SetText("https://github.com/xorann/BigWigs/releases")
                editbox:SetWidth(250)
                editbox:ClearFocus()
                editbox:HighlightText() 
                --self.editBox:SetText("Some text goes here")
                getglobal(this:GetName().."Button2"):Hide()
            end,
            hasEditBox = true,
            hasWideEditBox = true,
            maxLetters = 42,
            --EditBox:setText("Text"),
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
        }
        local dialog = StaticPopup_Show ("BigWigsDeveloperVersionDialog")
	end
end


------------------------------
--      Initialization      --
------------------------------

function BigWigs:OnInitialize()
	if not self.version then self.version = GetAddOnMetadata("BigWigs", "Version") end
	local rev = self.revision
	for name, module in self:IterateModules() do
		--self:RegisterModule(name,module)
		rev = math.max(rev, module.revision)
	end
	self.version = (self.version or "2.0").. " |cffff8888r"..rev.."|r"
	--self:RegisterEvent("ADDON_LOADED")
	
	self.loading = true
	-- Activate ourselves, or at least try to. If we were disabled during a reloadUI, OnEnable isn't called,
	-- and self.loading will never be set to something else, resulting in a BigWigs that doesn't enable.
	self:ToggleActive(true)
	
	-- show dialog if a developer version is being used
	BigWigs:CheckForDeveloperVersion()
end


function BigWigs:OnEnable()
	if AceLibrary("AceEvent-2.0"):IsFullyInitialized() then
		self:AceEvent_FullyInitialized()
	else
		self:RegisterEvent("AceEvent_FullyInitialized")
	end
end

function BigWigs:AceEvent_FullyInitialized()
	if GetNumRaidMembers() > 0 or not self.loading then
		-- Enable all disabled modules that are not boss modules.
		for name, module in self:IterateModules() do
			if type(module.IsBossModule) ~= "function" or not module:IsBossModule() then
				self:ToggleModuleActive(module, true)
			end
		end
		
		if BigWigsLoD then
			self:CreateLoDMenu()
		end
	
		self:TriggerEvent("BigWigs_CoreEnabled")
	
		self:RegisterEvent("BigWigs_TargetSeen")
		self:RegisterEvent("BigWigs_RebootModule")
	
		self:RegisterEvent("BigWigs_RecvSync")
        
		--self:RegisterEvent("AceEvent_FullyInitialized", function() self:TriggerEvent("BigWigs_ThrottleSync", "BossEngaged", 5) end )

	else
		self:ToggleActive(false)
	end
	self.loading = nil
end

function BigWigs:OnDisable()
	-- Disable all modules
	for name, module in self:IterateModules() do
		self:ToggleModuleActive(module, false)
	end

	self:TriggerEvent("BigWigs_CoreDisabled")
end


-------------------------------
--      External Modules     --
-------------------------------

function BigWigs:ADDON_LOADED(addon)
	local gname = GetAddOnMetadata(addon, "X-BigWigsModule")
	if not gname then return end

	local g = getglobal(gname)
	if not g or not g.name then return end

	g.external = true

	self:RegisterModule(g.name, g)
end


-------------------------------
--      Event Handler        --
-------------------------------

function BigWigs:BigWigs_RecvSync(sync, moduleName, nick)
    local s, m, n, playername = "-", "-", "-", UnitName("player")
    if sync then
        if type(sync) == "string" then
            s = sync
        else
            s = type(sync)
        end
    end
    if moduleName then
        if type(moduleName) == "string" then
            m = moduleName
        else
            m = type(moduleName)
        end
    end
    if nick then
        if type(nick) == "string" then
            if nick == playername then
                n = "you"
            else
                n = nick
            end
        else
            n = type(nick)
        end
    end
    self:DebugMessage("sync: " .. s .. " rest: " .. m .. " nick: " .. n)
    
    
	local moduleName = BB:HasTranslation(moduleName) and BB[moduleName] or moduleName
	local module = nil
	if self:HasModule(moduleName) then
		module = self:GetModule(moduleName)
	end
	
	if module and sync == "EnableModule" then        
		moduleName = BB:HasTranslation(moduleName) and BB[moduleName] or moduleName
        
        local isInZone = false
        if type(module.zonename) == "string" and module.zonename == GetRealZoneText() then
            isInZone = true
        elseif type(module.zonename) == "table" then
            for _, v in pairs(module.zonename) do
                if v == GetRealZoneText() then
                    isInZone = true
                    break
                end
            end
        end
            
		if isInZone then self:EnableModule(moduleName, true) end
	elseif module and sync == "EnableExternal" then        
        if module.zonename == GetRealZoneText() then      
            self:EnableModule(moduleName, true)
        end
	elseif sync == "RebootModule" and moduleName then
        if nick ~= UnitName("player") then
			self:Print(string.format(L["%s has requested forced reboot for the %s module."], nick, moduleName))
		end
		self:TriggerEvent("BigWigs_RebootModule", moduleName)
    elseif module and sync == module:GetEngageSync() then
        if module:IsBossModule() then
			module:Engage() 
		end
	--[[elseif module and sync == module:GetWipeSync() then
		if module:IsBossModule() and BigWigs:IsModuleActive(module) then
			self:TriggerEvent("BigWigs_RebootModule", moduleName)
		end]]
    elseif module and sync == module:GetBossDeathSync() then
		if module:IsBossModule() and BigWigs:IsModuleActive(module) then
            module:Victory()
        end
	end
end

function BigWigs:BigWigs_TargetSeen(mobname, unit)
	for name,module in self:IterateModules() do
		if module:IsBossModule() and self:ZoneIsTrigger(module, GetRealZoneText()) and self:MobIsTrigger(module, mobname) 
			and (not module.VerifyEnable or module:VerifyEnable(unit)) then
				self:EnableModule(name)
            
            --[[if UnitExists(unit.."target") then
                -- if this is true the boss is apparantely already in combat!
                -- this situation can happen on bosses which spawn the same time they enter combat (Arlokk/Mandokir) or when a player without BigWigs engages the boss
                module:SendEngageSync()
            end]]
		end
	end
end

-------------------------------
--      	Utility		     --
-------------------------------

function BigWigs:ZoneIsTrigger(module, zone)
	local t = module.zonename
	if type(t) == "string" then return zone == t
	elseif type(t) == "table" then
		for _,mzone in pairs(t) do if mzone == zone then return true end end
	end
end


function BigWigs:MobIsTrigger(module, name)
	local t = module.enabletrigger
	if type(t) == "string" then
		return name == t
	elseif type(t) == "table" then
		for _,mob in pairs(t) do
			if mob == name then
				return true
			end
		end
	end
end


function BigWigs:CreateLoDMenu()
	local zonelist = BigWigsLoD:GetZones()
	for k,v in pairs( zonelist ) do
		if type(v) ~= "table" then
			self:AddLoDMenu( k )
		else
			self:AddLoDMenu( L["Other"] )
		end
	end
end


function BigWigs:AddLoDMenu( zonename )
	local zone = nil
	if L:HasTranslation(zonename) then
		zone = L[zonename]
	else
		zone = L["Other"]
	end
	if zone then
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
				args = {}
			}
		end
		-- if zone == L["Other"] then
			-- local zones = BigWigsLoD:GetZones()
			-- zones = zones[L["Other"]]
			-- self.cmdtable.args[L["boss"]].args[zone].args[L["Load"]] = {
				-- type = "execute",
				-- name = L["Load All"],
				-- desc = string.format( L["Load all %s modules."], zonename ),
				-- order = 1,
				-- func = function()
						-- for z, v in pairs( zones ) do
							-- BigWigsLoD:LoadZone( z )
							-- if self.cmdtable.args[L["boss"]].args[z] and self.cmdtable.args[L["boss"]].args[z].args[L["Load"]] then
								-- self.cmdtable.args[L["boss"]].args[z].args[L["Load"]] = nil
							-- end
						-- end
						-- self.cmdtable.args[L["boss"]].args[zone] = nil
					-- end
			-- }
		-- else
			-- self.cmdtable.args[L["boss"]].args[zone].args[L["Load"]] = {
				-- type = "execute",
				-- name = L["Load All"],
				-- desc = string.format( L["Load all %s modules."], zonename ),
				-- order = 1,
				-- func = function()
						-- BigWigsLoD:LoadZone( zonename )
						-- self.cmdtable.args[L["boss"]].args[zone].args[L["Load"]] = nil
					-- end
			-- }
		-- end
	end
end
