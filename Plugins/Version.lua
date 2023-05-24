assert(BigWigs, "BigWigs not found!")

local BWL = nil
local BZ = AceLibrary("Babble-Zone-2.2")
local L = AceLibrary("AceLocale-2.2"):new("BigWigsVersionQuery")
local tablet = AceLibrary("Tablet-2.0")
local dewdrop = AceLibrary("Dewdrop-2.0")

local COLOR_GREEN = "00ff00"
local COLOR_RED = "ff0000"
local COLOR_WHITE = "ffffff"

local isInitialQuery = true

---------------------------------
--      Localization           --
---------------------------------

L:RegisterTranslations("enUS", function() return {
	["versionquery"] = true,
	["Version Query"] = true,
	["Commands for querying the raid for Big Wigs versions."] = true,
	["Query already running, please wait 5 seconds before trying again."] = true,
	["Querying versions for "] = true,
	["Big Wigs Version Query"] = true,
	["Close window"] = true, -- I know, it's really a Tablet.
	["Showing version for "] = true,
	["Green versions are newer than yours, red are older, and white are the same."] = true,
	["Player"] = true,
	["Version"] = true,
	["Current zone"] = true,
	["<zone>"] = true,
	["Version query done."] = true,
	["Runs a version query on your current zone."] = true,
	["Closes the version query window."] = true,
	["current"] = true,
	["Runs a version query on the given zone."] = true,
	["Zone"] = true,
	["zone"] = true,
	["N/A"] = true,
	["BigWigs"] = true,
	["Runs a version query on the BigWigs core."] = true,
	["Nr Replies"] = true,
	["Ancient"] = true,
            
    ["Your version of Big Wigs Classic-WoW is out of date!\nPlease visit https://github.com/xorann/BigWigs/releases to get the latest version."] = true,
    ["Close"] = true,
    ["Cancel"] = true,
	
	["Gathering Data, please wait..."] = true,
	["<BigWigs> Everyone has the current version of BigWigs Classic-WoW. I'm proud of you!"] = true,
	["<BigWigs> Players without BigWigs Classic-WoW:"] = true,
	["<BigWigs> no one"] = true,
	["<BigWigs> Players with an outdated version of BigWigs Classic-WoW:"] = true,
	["<BigWigs> Players using a version of BigWigs intended for a different server:"] = true,
	["<BigWigs> Please download the newest version of BigWigs Classic-WoW from https://github.com/xorann/BigWigs/releases"] = true,
    ["Notify old versions"] = true,
	["Lists players with an old version in raid chat."] = true,
	["notifyOldVersions"] = true,
} end )

L:RegisterTranslations("ruRU", function() return {

	["Version Query"] = "Запрос версии",
	["Commands for querying the raid for Big Wigs versions."] = "Команда для проверки игроков в рейде на версию Big Wigs",
	["Query already running, please wait 5 seconds before trying again."] = "Выполняется проверка версии, пожалуйста, подождите 5 сек. и попробуйте еще раз.",
	["Querying versions for "] = "Запрос версии для ",
	["Big Wigs Version Query"] = "Запрос версии Big Wigs",
	["Close window"] = "Закрыть окно", -- I know, it's really a Tablet.
	["Showing version for "] = "Отображение версии для ",
	["Green versions are newer than yours, red are older, and white are the same."] = "\nЗеленый - версия новее вашей.\nКрасный - старее вашей.\nБелый - идентична вашей.",
	["Player"] = "Игрок",
	["Version"] = "Версия",
	["Current zone"] = "Текущая зона",
	["<zone>"] = "<зона>",
	["Version query done."] = "Запрос версии завершен.",
	["Runs a version query on your current zone."] = "Запускает запрос версии в текущей зоне.",
	["Closes the version query window."] = "Закрыть окно запроса версии.",
	["current"] = "current",
	["Runs a version query on the given zone."] = "Запускает запрос версии в данной зоне.",
	["Zone"] = "Зона",
	-- ["zone"] = "zone",
	["N/A"] = "Н/Д",
	["BigWigs"] = "BigWigs",
	["Runs a version query on the BigWigs core."] = "Запускает запрос версии в ядре BigWigs.",
	["Nr Replies"] = "Без Ответа",
	["Ancient"] = "Старая",

	["Your version of Big Wigs Classic-WoW is out of date!\nPlease visit https://github.com/xorann/BigWigs/releases to get the latest version."] = "Ваша версия Big Wigs Classic-WoW устарела!\nПожалуйста, посетите https://github.com/xorann/BigWigs/releases чтобы получить последнюю версию.",
	["Close"] = "Закрыть",
	["Cancel"] = "Отмена",

	["Gathering Data, please wait..."] = "Сбор данных, пожалуйста, подождите ...",
	["<BigWigs> Everyone has the current version of BigWigs Classic-WoW. I'm proud of you!"] = "<BigWigs> У всех есть актуальная версия BigWigs Classic-WoW. Я горжусь тобой!",
	["<BigWigs> Players without BigWigs Classic-WoW:"] = "<BigWigs> Игроки без BigWigs Classic-WoW:",
	["<BigWigs> no one"] = "<BigWigs> ни у кого",
	["<BigWigs> Players with an outdated version of BigWigs Classic-WoW:"] = "<BigWigs> Игроки с устаревшей версией BigWigs Classic-WoW:",
	["<BigWigs> Players using a version of BigWigs intended for a different server:"] = "<BigWigs> Игроки, использующие версию BigWigs, предназначенную для другого сервера:",
	["<BigWigs> Please download the newest version of BigWigs Classic-WoW from https://github.com/xorann/BigWigs/releases"] = "<BigWigs> Пожалуйста, загрузите новейшую версию BigWigs Classic-WoW с https://github.com/xorann/BigWigs/releases",
	["Notify old versions"] = "Уведомить старые версии",
	["Lists players with an old version in raid chat."] = "Список игроков со старой версией в рейдовом чате.",

} end )

L:RegisterTranslations("deDE", function() return {
	["versionquery"] = "Versionsabfrage",
	["Version Query"] = "Versionsabfrage",
	["Commands for querying the raid for Big Wigs versions."] = "Kommandos um den Schlachtzug nach verwendeten BigWigs Versionen abzufragen.",
	["Query already running, please wait 5 seconds before trying again."] = "Abfrage läuft bereits, bitte 5 Sekunden warten bis zum nächsten Versuch.",
	["Querying versions for "] = "Frage Versionen ab für ",
	["Big Wigs Version Query"] = "BigWigs Versionsabfrage",
	["Close window"] = "Schlie\195\159e Fenster", -- I know, it's really a Tablet.
	["Showing version for "] = "Zeige Version für ",
	["Green versions are newer than yours, red are older, and white are the same."] = "Grüne Versionen sind neuer, rote sind älter, wei\195\159e sind gleich.",
	["Player"] = "Spieler",
	["Version"] = "Version",
	["Current zone"] = "Momentane Zone",
	["<zone>"] = "<zone>",
	["Version query done."] = "Versionsabfrage beendet.",
	["Runs a version query on your current zone."] = "Versionsabfrage für die momentane Zone starten.",
	["Closes the version query window."] = "Schlie\195\159t das Versionsabfrage-Fenster.",
	["current"] = "gegenw\195\164rtig",
	["Runs a version query on the given zone."] = "Versionsabfrage in für eine gegebene Zone starten.",
	["Zone"] = "Zone",
	["zone"] = "Zone",
	["N/A"] = "N/A",
	["BigWigs"] = "BigWigs",
	["Runs a version query on the BigWigs core."] = "Versionsabfrage für die BigWigs Kernkomponente starten.",
	["Nr Replies"] = "Anzahl der Antworten",
	["Ancient"] = "Alt",
            
    ["Your version of Big Wigs Classic-WoW is out of date!\nPlease visit https://github.com/xorann/BigWigs/releases to get the latest version."] = "Deine Version von Big Wigs Classic-WoW ist veraltet! Bitte downloade die neuste Version von https://github.com/xorann/BigWigs/releases",
    ["Close"] = "Schliessen",
    ["Cancel"] = "Abbrechen",
	
	["Gathering Data, please wait..."] = "Daten werden gesammelt, bitte warten...",
	["<BigWigs> Everyone has the current version of BigWigs Classic-WoW. I'm proud of you!"] = "<BigWigs> Alle haben die aktuelle Version von BigWigs Classic-WoW. Ich bin stolz auf euch!",
	["<BigWigs> Players without BigWigs Classic-WoW:"] = "<BigWigs> Spieler ohne BigWigs Classic-WoW:",
	["<BigWigs> no one"] = "<BigWigs> Niemand",
	["<BigWigs> Players with an outdated version of BigWigs Classic-WoW:"] = "<BigWigs> Spieler mit einer veralteten Version von BigWigs Classic-WoW:",
	["<BigWigs> Players using a version of BigWigs intended for a different server:"] = "<BigWigs> Spieler welche eine Version von BigWigs verwenden, welche für einen anderen Server gedacht ist:",
	["<BigWigs> Please download the newest version of BigWigs Classic-WoW from https://github.com/xorann/BigWigs/releases"] = "<BigWig> Bitte downloade die neuste Version von BigWigs Classic-WoW von https://github.com/xorann/BigWigs/releases",
	["Notify old versions"] = "Alte Versionen abfragen",
	["Lists players with an old version in raid chat."] = "Liste alle Spieler mit einer alten Version im Raidchat auf.",
	["notifyOldVersions"] = "alteVersionenAbfragen",
} end )


---------------------------------
--      Addon Declaration      --
---------------------------------

BigWigsVersionQuery = BigWigs:NewModule("Version Query")

BigWigsVersionQuery.consoleCmd = L["versionquery"]
BigWigsVersionQuery.consoleOptions = {
	type = "group",
	name = L["Version Query"],
	desc = L["Commands for querying the raid for Big Wigs versions."],
	args = {
		[L["BigWigs"]] = {
			type = "execute",
			name = L["BigWigs"],
			desc = L["Runs a version query on the BigWigs core."],
			func = function() BigWigsVersionQuery:QueryVersion("BigWigs") end,
		},
		[L["current"]] = {
			type = "execute",
			name = L["Current zone"],
			desc = L["Runs a version query on your current zone."],
			func = function() BigWigsVersionQuery:QueryVersion() end,
		},
		[L["zone"]] = {
			type = "text",
			name = L["Zone"],
			desc = L["Runs a version query on the given zone."],
			usage = L["<zone>"],
			get = false,
			set = function(zone) BigWigsVersionQuery:QueryVersion(zone) end,
		},
		[L["notifyOldVersions"]] = {
			type = "execute",
			name = L["Notify old versions"],
			desc = L["Lists players with an old version in raid chat."],
			func = function() BigWigsVersionQuery:NotifyOldVersions() end,
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsVersionQuery:Test()
    BigWigsVersionQuery:QueryVersion("BigWigs")
end

function BigWigsVersionQuery:OnEnable()
	self.queryRunning = nil
	self.responseTable = {}
	self.zoneRevisions = nil
	self.currentZone = ""
	self.OutOfDateShown = false
	isInitialQuery = true -- reset after /console reloadui

	BWL = AceLibrary("AceLocale-2.2"):new("BigWigs")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BWVQ", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "BWVR", 0)
	
	--BigWigsVersionQuery:QueryVersion("BigWigs")
    self:ScheduleEvent("versionquerytest", BigWigsVersionQuery.Test, 1, self) -- check version in 1s
end

function BigWigsVersionQuery:PopulateRevisions()
	self.zoneRevisions = {}
	for name, module in self.core:IterateModules() do
		if module:IsBossModule() and module.zonename and type(module.zonename) == "string" then
			-- Make sure to get the enUS zone name.
			local zone = BZ:HasReverseTranslation(module.zonename) and BZ:GetReverseTranslation(module.zonename) or module.zonename
			-- Get the abbreviated name from BW Core.
			local zoneAbbr = BWL:HasTranslation(zone) and BWL:GetTranslation(zone) or nil
			if not self.zoneRevisions[zone] or module.revision > self.zoneRevisions[zone] then
				self.zoneRevisions[zone] = module.revision
			end
			if zoneAbbr and (not self.zoneRevisions[zoneAbbr] or module.revision > self.zoneRevisions[zoneAbbr]) then
				self.zoneRevisions[zoneAbbr] = module.revision
			end
		end
	end
	self.zoneRevisions["BigWigs"] = self.core.revision
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsVersionQuery:UpdateTablet()
    if not tablet:IsRegistered("BigWigs_VersionQuery") then
		tablet:Register("BigWigs_VersionQuery",
			"children", function() tablet:SetTitle(L["Big Wigs Version Query"])
				self:OnTooltipUpdate() end,
			"clickable", true,
			"showTitleWhenDetached", true,
			"showHintWhenDetached", true,
			"cantAttach", true,
			"menu", function()
					dewdrop:AddLine(
						"text", L["BigWigs"],
						"tooltipTitle", L["BigWigs"],
						"tooltipText", L["Runs a version query on the BigWigs core."],
						"func", function() self:QueryVersion("BigWigs") end)
					dewdrop:AddLine(
						"text", L["Current zone"],
						"tooltipTitle", L["Current zone"],
						"tooltipText", L["Runs a version query on your current zone."],
						"func", function() self:QueryVersion() end)
					dewdrop:AddLine(
						"text", L["Notify old versions"],
						"tooltipTitle", L["Notify old versions"],
						"tooltipText", L["Lists players with an old version in raid chat."],
						"func", function() self:NotifyOldVersions() end)
					dewdrop:AddLine(
						"text", L["Close window"],
						"tooltipTitle", L["Close window"],
						"tooltipText", L["Closes the version query window."],
						"func", function() tablet:Attach("BigWigs_VersionQuery"); dewdrop:Close() end)
				end
		)
	end
	if tablet:IsAttached("BigWigs_VersionQuery") then
		tablet:Detach("BigWigs_VersionQuery")
	else
		tablet:Refresh("BigWigs_VersionQuery")
	end
end
function BigWigsVersionQuery:UpdateVersions()
    -- only check if this version is outdated if it is the same fork
	for name, data in pairs(self.responseTable) do
		if not self.zoneRevisions then return end
		if data.forkName and data.forkName == self.core.forkName and self.zoneRevisions[self.currentZone] and data.rev > self.zoneRevisions[self.currentZone] then
			self:IsOutOfDate()
		end
	end
    
	if not isInitialQuery then
        self:UpdateTablet()
    end
end

function BigWigsVersionQuery:IsOutOfDate()
	if not self.OutOfDateShown then
		self.OutOfDateShown = true
		BigWigs:Print(L["Your version of Big Wigs Classic-WoW is out of date!\nPlease visit https://github.com/xorann/BigWigs/releases to get the latest version."])
        
        local dialog = nil
        StaticPopupDialogs["BigWigsOutOfDateDialog"] = {
            text = L["Your version of Big Wigs Classic-WoW is out of date!\nPlease visit https://github.com/xorann/BigWigs/releases to get the latest version."],
            button1 = L["Close"],
            button2 = L["Cancel"],
            OnAccept = function()
                StaticPopup_Hide ("BigWigsOutOfDateDialog")
            end,
            OnCancel = function()
                StaticPopup_Hide ("BigWigsOutOfDateDialog")
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
        local dialog = StaticPopup_Show ("BigWigsOutOfDateDialog")
        
	end
end


local function Blame()
	-- no BigWigs at all
	local noBigWigs = nil
	local outdated = nil
	local differentFork = nil
	
	if not BigWigsVersionQuery.responseTable then
		BigWigs:Print("that didn't work...")		
		return
	end

	for i = 1, GetNumRaidMembers(), 1 do
		local name = UnitName("Raid" .. i)
		local data = BigWigsVersionQuery.responseTable[name]

		
		if data and data.rev and (data.forkName and data.forkName == BigWigs.forkName or not data.forkName) then
			-- has bigwigs
			if BigWigs.revision and data.rev < BigWigs.revision then
				-- bigwigs is out of date
				if not outdated then
					outdated = name
				else
					outdated = outdated .. ", " .. name
				end
			end
		elseif data and data.forkName and data.forkName ~= BigWigs.forkName then
			-- different fork
			if not differentFork then
				differentFork = name
			else
				differentFork = differentFork .. ", " .. name
			end
		else
			-- does not have bigwigs
			if not noBigWigs then
				noBigWigs = name
			else
				noBigWigs = noBigWigs .. ", " .. name
			end
		end
	end
	
	-- inform raid
	if not noBigWigs and not outdated and not differentFork then
		SendChatMessage(L["<BigWigs> Everyone has the current version of BigWigs Classic-WoW. I'm proud of you!"], "RAID")
	else
		if noBigWigs then
			SendChatMessage(L["<BigWigs> Players without BigWigs Classic-WoW:"], "RAID")
			SendChatMessage("<BigWigs> " .. noBigWigs, "RAID")
		end
		
		if outdated then
			SendChatMessage(L["<BigWigs> Players with an outdated version of BigWigs Classic-WoW:"], "RAID")
			SendChatMessage("<BigWigs> " .. outdated, "RAID")
		end
		
		if differentFork then
			SendChatMessage(L["<BigWigs> Players using a version of BigWigs intended for a different server:"], "RAID")
			SendChatMessage("<BigWigs> " .. differentFork, "RAID")
		end
		
		SendChatMessage(L["<BigWigs> Please download the newest version of BigWigs Classic-WoW from https://github.com/xorann/BigWigs/releases"], "RAID")
	end
end

function BigWigsVersionQuery:NotifyOldVersions()
	self:QueryVersion("BigWigs")
	self:ScheduleEvent(Blame, 5)
	BigWigs:Print(L["Gathering Data, please wait..."])
end

function BigWigsVersionQuery:OnTooltipUpdate()
	local zoneCat = tablet:AddCategory(
		"columns", 1,
		"text", L["Zone"],
		"child_justify1", "LEFT"
	)
	zoneCat:AddLine("text", self.currentZone)
	local playerscat = tablet:AddCategory(
		"columns", 1,
		"text", L["Nr Replies"],
		"child_justify1", "LEFT"
	)
	playerscat:AddLine("text", self.responses)
	local cat = tablet:AddCategory(
		"columns", 2,
		"text", L["Player"],
		"text2", L["Version"],
		"child_justify1", "LEFT",
		"child_justify2", "RIGHT"
	)
	for name, data in pairs(self.responseTable) do
		if data.rev == -1 then -- bigwigs installed but module not found
			cat:AddLine("text", name, "text2", "|cff"..COLOR_RED..L["N/A"].."|r")
		elseif data.forkName and data.forkName ~= self.core.forkName then -- different fork
			cat:AddLine("text", name, "text2", "|cff" .. COLOR_WHITE .. data.rev .. " (" .. data.forkName .. ")|r")
		else -- out of date or different fork
			if not self.zoneRevisions then 
				self:PopulateRevisions() 
			end
			
			local color = COLOR_WHITE
			if self.zoneRevisions[self.currentZone] and data.rev > self.zoneRevisions[self.currentZone] then
				if data.forkName == self.core.forkName then
					color = COLOR_GREEN
					self:IsOutOfDate()
				end
			elseif self.zoneRevisions[self.currentZone] and data.rev < self.zoneRevisions[self.currentZone] then
				color = COLOR_RED
			end
			cat:AddLine("text", name, "text2", "|cff"..color..data.rev.."|r")
		end
	end

	tablet:SetHint(L["Green versions are newer than yours, red are older, and white are the same."])
end

function BigWigsVersionQuery:QueryVersionAndShowWindow(zone)
    self:QueryVersion(zone)
	self:UpdateVersions()
end
function BigWigsVersionQuery:QueryVersion(zone)
	if self.queryRunning then
		self.core:Print(L["Query already running, please wait 5 seconds before trying again."])
		return
	end
	if not zone or zone == "" or type(zone) ~= "string" then zone = GetRealZoneText() end
	-- If this is a shorthand zone, convert it to enUS full.
	-- Also, if this is a shorthand, we can't really know if the user is enUS or not.

	if not BWL then BWL = AceLibrary("AceLocale-2.2"):new("BigWigs") end
	if BWL ~= nil and zone ~= nil and type(zone) == "string" and BWL:HasReverseTranslation(zone) then
		zone = BWL:GetReverseTranslation(zone)
		-- If there is a translation for this to GetLocale(), get it, so we can
		-- print the zone name in the correct locale.
		if BZ:HasTranslation(zone) then
			zone = BZ:GetTranslation(zone)
		end
	end
    
	if not zone then
		error("The given zone is invalid.")
		return
	end

	-- ZZZ |zone| should be translated here.
	if not isInitialQuery then
        self.core:Print(L["Querying versions for "].."|cff"..COLOR_GREEN..zone.."|r.")
    end

	-- If this is a non-enUS zone, convert it to enUS.
	if BZ:HasReverseTranslation(zone) then zone = BZ:GetReverseTranslation(zone) end

	self.currentZone = zone

	self.queryRunning = true
	self:ScheduleEvent(	function()
            self.queryRunning = nil
            if not isInitialQuery then
                self.core:Print(L["Version query done."])
            end
            isInitialQuery = false
        end, 5)

	self.responseTable = {}

	if not self.zoneRevisions then self:PopulateRevisions() end
	if not self.zoneRevisions[zone] then
		self.responseTable[UnitName("player")] = { rev = -1, forkName = self.core.forkName }
	else
		self.responseTable[UnitName("player")] = { rev = self.zoneRevisions[zone], forkName = self.core.forkName }
	end
	self.responses = 1
	self:TriggerEvent("BigWigs_SendSync", "BWVQ " .. zone)
end

--[[ Parses the newest style reply, which is "<rev> <nick> <forkName>" ]]
function BigWigsVersionQuery:ParseReply3(reply)
	-- If there's no space, it's just a version number we got.
	local _, _, rev, nick, fork = string.find(reply, "(.+) (.+) (.+)")
	if not rev or not nick or not fork then 
		return reply, nil, nil
	end

	return tonumber(rev), nick, fork
end

--[[ Parses the new style reply, which is "1111 <nick>" ]]
function BigWigsVersionQuery:ParseReply2(reply)
	-- If there's no space, it's just a version number we got.
	local first, last = string.find(reply, " ")
	if not first or not last then return reply, nil end

	local rev = string.sub(reply, 1, first)
	local nick = string.sub(reply, last + 1, string.len(reply))

	-- We need to check if rev or nick contains ':' - if it does, this is an old
	-- style reply.
	if tonumber(rev) == nil or string.find(rev, ":") or string.find(nick, ":") then
		return self:ParseReply(reply), nil
	end
	return tonumber(rev), nick
end

--[[ Parses the old style reply, which was MC:REV BWL:REV, etc. ]]
function BigWigsVersionQuery:ParseReply(reply)
	if not string.find(reply, ":") then return -1 end
	local zone = BWL:HasTranslation(self.currentZone) and BWL:GetTranslation(self.currentZone) or self.currentZone

	local zoneIndex, zoneEnd = string.find(reply, zone)
	if not zoneIndex then return -1 end

	local revision = string.sub(reply, zoneEnd + 2, zoneEnd + 6)
	local convertedRev = tonumber(revision)
	if revision and convertedRev ~= nil then return convertedRev end

	return -1
end

--[[
-- Version reply syntax history:
--  Old Style:           MC:REV BWL:REV ZG:REV
--  First Working Style: REV
--  New Style:           REV QuereeNick
--]]

function BigWigsVersionQuery:BigWigs_RecvSync(sync, rest, nick)
	if sync == "BWVR2" and self.queryRunning and nick and rest then
		-- reply received
		local revision, queryNick, fork = self:ParseReply3(rest)
		if queryNick == UnitName("player") then
			if not self.responseTable[nick] then
				self.responses = self.responses + 1
			end
			self.responseTable[nick] = { rev = tonumber(revision), forkName = fork }
			self:UpdateVersions()
		end
	elseif sync == "BWVQ" and nick ~= UnitName("player") and rest then
		-- query, send reply
		if not self.zoneRevisions then 
            self:PopulateRevisions() 
        end
		if not self.zoneRevisions[rest] then
			self:TriggerEvent("BigWigs_SendSync", "BWVR2 -1 ".. nick .. " " .. self.core.forkName)
			self:TriggerEvent("BigWigs_SendSync", "BWVR -1 ".. nick)
		else
			self:TriggerEvent("BigWigs_SendSync", "BWVR2 " .. self.zoneRevisions[rest] .. " " .. nick .. " " .. self.core.forkName)
			self:TriggerEvent("BigWigs_SendSync", "BWVR " .. self.zoneRevisions[rest] .. " " .. nick)
		end
	elseif sync == "BWVR" and self.queryRunning and nick and rest then
		-- reply received
		
		-- Means it's either a old style or new style reply.
		-- The "working style" is just the number, which was the second type of
		-- version reply we had.
		local revision, queryNick = nil, nil, nil
		if tonumber(rest) == nil then
			revision, queryNick = self:ParseReply2(rest)
		else
			revision = tonumber(rest)
		end
		if queryNick == nil or queryNick == UnitName("player") then
			if not self.responseTable[nick] then
				self.responseTable[nick] = { rev = tonumber(revision), forkName = nil }
				self.responses = self.responses + 1
			end
			self:UpdateVersions()
		end
	end
end

