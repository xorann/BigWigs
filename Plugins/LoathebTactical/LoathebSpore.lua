assert(BigWigs, "BigWigs not found!")

--[[

Big Wigs Strategy Module for Loatheb in Naxxramas.

by Dorann
https://github.com/xorann/BigWigs

]]

--[[
	todo:
		- whisper next player
]]

--[[
-- BigWigs Events
OnEnable
	SetupFrame
		ResetFramePosition
	CreatePlayerFrameList
		AddPlayer
			CreateHealer
		CreateCSV
		UpdatePlayerFrame
			CsvToTable
			ActivatePlayer
			DeactivatePlayer
		>>SYNC<< RequestUpdate
			>>SYNC<< SendUpdate

-- User Input
HealerFrameButton:OnClick
	TogglePlayer
		>>SYNC<< SendUpdate
			UpdatePlayerFrame
				CsvToTable
				ActivatePlayer
				DeactivatePlayer
HealerFrame:OnDragStop
	CreateCSV
	UpdatePlayerFrame
	>>SYNC<< SendUpdate
		UpdatePlayerFrame
			CsvToTable
			ActivatePlayer
			DeactivatePlayer

-- API Events	
RAID_ROSTER_UPDATE
	CreatePlayerFrameList
		AddPlayer
			CreateHealer
		CreateCSV
		UpdatePlayerFrame
			CsvToTable
			ActivatePlayer
			DeactivatePlayer
]]

----------------------------------
--      Module Declaration      --
----------------------------------
local myname = "Loatheb Tactical"
local module = BigWigs:GetModule(myname)
local L = module.L
local timer = module.timer
local icon = module.icon
local syncName = module.syncName


---------------------------------
--      	Variables 		   --
---------------------------------
module.defaultDB = {
	posx = nil,
	posy = nil,
	disabled = nil,
	csv = nil,
}

local announce = false

local frame = nil
local frameWidth = 250
local playerHeight = 20
local playerNameWidth = 80
local buttonWidth = 19
local footerHeight = 30

local lastAnnouncedPlayer = nil

local timetable = nil

---------------------------------
--      	Variables 		   --
---------------------------------

-- Function decToHex (renamed, updated): http://lua-users.org/lists/lua-l/2004-09/msg00054.html
local function decToHex(IN)
	local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
	while IN>0 do
    	I=I+1
    	IN,D=math.floor(IN/B),math.mod(IN,B)+1
    	OUT=string.sub(K,D,D)..OUT
	end
	return OUT
end
-- Function rgbToHex: http://gameon365.net/index.php
local function rgbToHex(r,g,b)
	local output = decToHex(r) .. decToHex(g) .. decToHex(b);
	return output
end

local hexColors = {}
for k, v in pairs(RAID_CLASS_COLORS) do
    hexColors[k] = string.format("|cff%02x%02x%02x ", v.r * 255, v.g * 255, v.b * 255)
end

-- Helper table to cache colored player names.
local coloredNames = setmetatable({}, {__index =
	function(self, unit)
		if type(unit) == "nil" then return nil end
		local _, class = UnitClass(unit)
        local name, _ = UnitName(unit)
		if class then
			self[name] = hexColors[class] .. name .. "|r"
			return self[name]
		else
			return name
		end
	end
})


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnableSpore()
	
	self:RegisterEvent("RAID_ROSTER_UPDATE")
	
	module:SetupFrame()
	frame:Show()
	module:CreatePlayerFrameList()
	module:UpdatePlayerFrame(self.db.profile.csv)
	module:RequestUpdate()
	announce = true
end

-- called after module is enabled and after each wipe
function module:OnSetupSpore()
	announce = false
	timetable = {}
end

-- called after boss is engaged
function module:OnEngageSpore()
	announce = true
	module:AnnounceNextGroup()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengageSpore()
	announce = false
end

function module:OnDisableSpore()
	frame:Hide()
	announce = false
end

------------------------------
--      Event Handlers	    --
------------------------------
function module:RAID_ROSTER_UPDATE(msg)
	self:CreatePlayerFrameList()
end


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync_Spore(sync, rest, nick)
	if sync == syncName.listUpdate and rest then
		-- do not update our own updates
		if nick ~= UnitName("player") then
			self:UpdatePlayerFrame(rest)
		end
	elseif sync == syncName.requestUpdate then
		-- do not update our own update request
		if nick ~= UnitName("player") then
			self:SendUpdate()
		end
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------
function module:UpdatePlayerFrame(csv)
	if csv then	
		-- cancel update timeout
		self:CancelScheduledEvent("BigWigsLoathebTacticalUpdateTimeout")
		
		local aTable = self:CsvToTable(csv)
		for position, player in pairs(aTable) do
			if frame.player and frame.player[player.name] then
				local playerFrame = frame.player[player.name].frame
				playerFrame:ClearAllPoints()
				playerFrame:SetPoint("TOPLEFT", playerFrame:GetParent(), "TOPLEFT", 0, 0 - (position - 1) * playerHeight)
				playerFrame.text:SetText(module:GetPlayerText(position, player.name))

				if player.isActive then
					self:ActivatePlayer(frame.player[player.name])
				else
					self:DeactivatePlayer(frame.player[player.name])
				end
			end
		end
	end
end

local function GetUnitId(name)
	for i = 1, GetNumRaidMembers(), 1 do
		local aName = GetRaidRosterInfo(i)
		if aName == name then
			return "Raid" .. i
		end
	end
	return nil
end

------------------------------
--      Utility	Functions   --
------------------------------
function module:TableSize(aTable)
	local s = 0
	for k, v in pairs(aTable) do
		s = s + 1
	end
	return s
end

function module:AddPlayer(name)
	if not frame.player[name] then
		frame.player[name] = {}
		local i = module:TableSize(frame.player)

		frame.player[name].frame = module:CreatePlayer(frame.body, i, name)
		frame.player[name].isActive = true
	end
end

function module:CreatePlayerFrameList()
	local oldList = {}
	local newList = {}
	for name, aTable in pairs(frame.player) do
		table.insert(oldList, name)
	end
	
	-- add all players to temporary list
	for i = 1, GetNumRaidMembers(), 1 do
		local name = GetRaidRosterInfo(i)
		table.insert(newList, name)
		for index, aName in pairs(oldList) do
			if name == aName then
				table.remove(oldList, index)
			end
		end
	end
	
	-- remove player, apparantly they are not in the raid anymore
	for index, aName in pairs(oldList) do
		if frame.player[aName] then
			frame.player[aName].frame:Hide()
			frame.player[aName].frame = nil
			frame.player[aName] = nil
		end
	end
	
	-- add frames
	for key, aName in pairs(newList) do
		self:AddPlayer(aName)
	end
		
	-- update frame height
	local size = module:TableSize(frame.player)
	frame:SetHeight(size * playerHeight + 32 + footerHeight)
	frame.body:SetHeight(size * playerHeight)
end

function module:GetPlayerText(position, player)
	local unitId = GetUnitId(player)
	local coloredName = tostring(coloredNames[unitId])
	return position .. ": " .. coloredName
end


-- 31f,29t -- raidId 31, active false
function module:CreateCSV()
	if not frame then
		return
	end

	-- get position of every player
	local list = {}
	for name, player in pairs(frame.player) do
		local pos = player.frame:GetTop()
		if not pos then
			pos = 0
		end
		
		table.insert(list, { ['name'] = name, ['yPos'] = pos })
	end
	
	-- sort list
	local function compare(w1, w2)
		return w1.yPos > w2.yPos
	end
	table.sort(list, compare)
		
	-- create csv
	local csv = nil
	for position, entry in pairs(list) do
		local name = entry.name
		local raidId = string.sub(GetUnitId(name), 5)
		local text = ""
		
		
		-- raidId
		if string.len(raidId) == 1 then
			raidId = "0" .. raidId -- add leading zero
		end	
		text = text .. raidId
	
		-- active
		if frame.player[name].isActive then
			text = text .. "t"
		else
			text = text .. "f"
		end
	
		-- add to csv
		if not csv then
			csv = text
		else
			csv = csv .. "," .. text
		end
	end
	
	self.db.profile.csv = csv
end

function module:SendUpdate()
	-- delay the sync. otherwise updates will not be send if the last one happend less than a second ago.
	if self.db.profile.csv then
		self:CancelDelayedSync(syncName.listUpdate .. " " .. self.db.profile.csv)
	end
	self:CreateCSV()
	self:DelayedSync(1.1, syncName.listUpdate .. " " .. self.db.profile.csv)
end
function module:RequestUpdate()
	self:Sync(syncName.requestUpdate)
	
	-- if after 3s no one responds we send our list to the entire raid
	self:ScheduleEvent("BigWigsLoathebTacticalUpdateTimeout", self.SendUpdate, 3, self)
end

function module:ActivatePlayer(player)
	if player and player.frame then
		player.isActive = true
		player.frame.texture:SetTexture("Interface\\Icons\\spell_chargepositive")
		player.frame:SetBackdropColor(27/255, 120/255, 50/255)
	end
end
function module:DeactivatePlayer(player)
	if player and player.frame then
		player.isActive = false
		player.frame.texture:SetTexture("Interface\\Icons\\spell_chargenegative")
		player.frame:SetBackdropColor(171/255, 61/255, 54/255)
	end
end
function module:TogglePlayer(button)
	if button and frame and frame.player then
		local player = nil
		for name, aPlayer in pairs(frame.player) do
			if button:GetParent() == aPlayer.frame then
				player = aPlayer
				break
			end
		end
		if player.isActive then
			self:DeactivatePlayer(player)
			--player.isActive = false
		else
			self:ActivatePlayer(player)
			--player.isActive = true
		end

		self:SendUpdate()
	end
end
function module:HighlightPlayer(name)
	if name and frame and frame.player and frame.player[name] and frame.player[name].frame then
		frame.player[name].frame:SetBackdropColor(57/255, 255/255, 106/255)
	end
end
function module:RemoveHighlight(name)
	if name and frame and frame.player and frame.player[name] then
		-- is the player active or inactive
		if frame.player[name].isActive then
			self:ActivatePlayer(frame.player[name])
		else
			self:DeactivatePlayer(frame.player[name])
		end
	end
end

function module:CsvToTable(csv)
	local aTable = {}
	if csv then
		local position = 0
		local old_index = 0
		local index = 1

		local list = {}

		while true do
			index = string.find(csv, ",", index + 1)
			if not index then
				index = string.len(csv) + 1
			end
			local text = string.sub(csv, old_index + 1, index - 1) -- text = 31f (raidId (31), isActive (f))

			local raidId = tonumber(string.sub(text, 1, 2))
			local isActive = string.sub(text, 3, 3)
			
			local name = GetRaidRosterInfo(raidId)

			if isActive == "t" then
				isActive = true
			else
				isActive = false
			end

			old_index = index

			table.insert(aTable, {["name"] = name, ["isActive"] = isActive})

			if index == string.len(csv) + 1 then
				break
			end
		end
	end

	return aTable
end
function module:AnnouncePlayerOrder()
	self:CreateCSV()
	local aTable = self:CsvToTable(self.db.profile.csv)
	local msg = ""
	local pos = 1

	for position, player in pairs(aTable) do
		if player.isActive then
			if msg ~= "" then
				msg = msg .. " - "
			end
			msg = msg .. pos .. ". " .. player.name
			pos = pos + 1
		end
	end

	-- todo: change to raid warning
	BigWigs:Print(msg)
	-- SendChatMessage(msg, "RAID")
end

function module:AnnounceNextGroup()
	self:CreateCSV()
	local aTable = self:CsvToTable(self.db.profile.csv)
	local nFoundPlayers = 0
	local index = nil
	local msg = L["Next Spore Group"] .. ": "
	local currentTime = GetTime()
	
	-- remove highlights
	for position, player in pairs(aTable) do
		module:RemoveHighlight(player.name)
	end
	
	-- get position of lastAnnouncedPlayer
	if lastAnnouncedPlayer then
		for position, player in pairs(aTable) do
			if lastAnnouncedPlayer == player.name then
				index = position + 1
				break
			end
		end
	else
		index = 1
	end
	
	-- get the next five players
	local function CheckPlayer(player)
		local raidId = GetUnitId(player.name)
		-- dead or disconnected players don't need a spore
		if not UnitIsDeadOrGhost(raidId) and UnitIsConnected(raidId) then
			-- only get a new spore if the old one is soon running out
			if not timetable[player.name] or timetable[player.name] + 90 - timer.spore < currentTime then
				nFoundPlayers = nFoundPlayers + 1
				lastAnnouncedPlayer = player.name
				timetable[player.name] = currentTime
				
				self:Icon(player.name, nFoundPlayers + 1, timer.sporeMark)
				module:HighlightPlayer(player.name)
				
				if nFoundPlayers > 1 then
					msg = msg .. ", "
				end
				msg = msg .. player.name
			end
		end
	end
	
	-- iterate raid
	for position, player in pairs(aTable) do
		if index <= position then
			CheckPlayer(player)
			
			if nFoundPlayers >= 5 then
				break
			end
		end
	end
	
	if nFoundPlayers < 5 then
		-- iterate again, we found less than five players
		for position, player in pairs(aTable) do
			if index > position then
				CheckPlayer(player)
					
				if nFoundPlayers >= 5 then
					break
				end
			end
		end
	end
	
	-- announce to raid
	if not self.db.profile.nospore then
		BigWigs:Print(msg)
		-- SendChatMessage(msg, "RAID")
	end
end

------------------------------
--      Frame			    --
------------------------------
function module:CreateHeader(title)
	local header = frame:CreateFontString(nil, "OVERLAY")
	header:ClearAllPoints()
	header:SetWidth(240)
	header:SetHeight(15)
	header:SetPoint("TOP", frame, "TOP", 0, -14)
	header:SetFont(L["font"], 12)
	header:SetJustifyH("LEFT")
	header:SetText(title)
	header:SetShadowOffset(.8, -.8)
	header:SetShadowColor(0, 0, 0, 1)
	
	return header
end

function module:CreateBody(parent)
	local body = CreateFrame("Frame", nil, parent)
	body:Show()
	
	body:SetWidth(parent:GetWidth())
	body:SetHeight(parent:GetHeight() - 32 - footerHeight)
	--[[body:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 1,
		insets = {left = 1, right = 1, top = 1, bottom = 1},
	})
	body:SetBackdropColor(24/255, 240/255, 24/255)]]
	body:ClearAllPoints()
	body:SetPoint("TOP", parent, "TOP", 0, -32)

	return body
end

function module:CreateFooter(parent)
	local footer = CreateFrame("Frame", nil, parent)
	footer:Show()

	footer:SetWidth(parent:GetWidth())
	footer:SetHeight(footerHeight)
	--[[footer:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 1,
		insets = {left = 1, right = 1, top = 1, bottom = 1},
	})
	footer:SetBackdropColor(24/255, 24/255, 240/255)]]

	footer:ClearAllPoints()
	footer:SetPoint("BOTTOM", parent, "BOTTOM", 0, 0)

	-- button
	local button = CreateFrame("Button", nil, footer)
	button.owner = self
	button:SetWidth(140)
	button:SetHeight(25)
	button:SetPoint("LEFT", footer, "LEFT", 10, 0)
	button:SetScript("OnClick", function()
		local m = BigWigs:GetModule("Loatheb Tactical")
		m:AnnouncePlayerOrder()
	end)

	local texture = button:CreateTexture()
	texture:SetWidth(150)
	texture:SetHeight(26)
	texture:SetPoint("CENTER", button, "CENTER")
	texture:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	texture:SetTexCoord(0, 0.625, 0, 0.6875)
	button:SetNormalTexture(texture)

	texture = button:CreateTexture(nil, "BACKGROUND")
	texture:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	texture:SetTexCoord(0, 0.625, 0, 0.6875)
	texture:SetAllPoints(button)
	button:SetPushedTexture(texture)

	texture = button:CreateTexture()
	texture:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	texture:SetTexCoord(0, 0.625, 0, 0.6875)
	texture:SetAllPoints(button)
	texture:SetBlendMode("ADD")
	button:SetHighlightTexture(texture)
	
	local buttontext = button:CreateFontString(nil,"OVERLAY")
	buttontext:SetFontObject(GameFontHighlight)
	buttontext:SetText(L["Announce order"])
	buttontext:SetAllPoints(button)
end

function module:CreatePlayer(parent, position, name)
	if not parent or not position or not name then 
		return nil 
	end
	
	local width = frameWidth
	local height = playerHeight
	
	local frame = CreateFrame("Frame", nil, parent)
	frame:Show()
	frame:SetFrameStrata("LOW")
	
	-- size
	frame:SetWidth(width)
	frame:SetHeight(height)
	
	-- background
	frame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		insets = {left = 1, right = 1, top = 0, bottom = 1},
	})
	frame:SetBackdropColor(38/255, 171/255, 71/255)
	
	-- position
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0 - (position - 1) * height)
	
	-- drag and drop
	frame:EnableMouse(true)
	frame:SetClampedToScreen(true) -- can't move it outside of the screen
	frame:RegisterForDrag("LeftButton")
	frame:SetMovable(true)
	frame:SetScript("OnDragStart", function() this:StartMoving() end)
	frame:SetScript("OnDragStop", function()
		this:StopMovingOrSizing()
		
		-- update self
		self:CreateCSV()
		self:UpdatePlayerFrame(self.db.profile.csv)
		
		-- update others
		self:SendUpdate()
	end)

	-- deactivate button
	local button = CreateFrame("Button", "testButton", frame)
	button:Show()
	button:SetPoint("TOPLEFT", 1, 0)
	button:SetWidth(buttonWidth)
	button:SetHeight(19)
	--[[button:SetBackdrop({
		--bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		--bgFile = "Interface\\Icons\\spell_chargepositive", tile = true, tileSize = 20,
		insets = {left = 1, right = 1, top = 1, bottom = 1},
	})]]
	--button:SetBackdropColor(240/255, 24/255, 24/255)
	button:SetFrameStrata("HIGH")
	button:EnableMouse(true)
	button:RegisterForClicks("LeftButtonUp")
	button:SetScript("OnClick", function()
		local m = BigWigs:GetModule("Loatheb Tactical")
		m:TogglePlayer(this)
	end)
	frame.button = button

	local texture = frame:CreateTexture(nil, "OVERLAY")
	texture:SetAllPoints(button)
	--texture:SetTexture("Interface\\AddOns\\BigWigs\\Icons\\ReadyCheck-NotReady", false)
	texture:SetTexture("Interface\\Icons\\spell_chargepositive")
	texture:SetTexCoord(0.08, 0.92, 0.08, 0.92) -- zoom in to hide border
	frame.texture = texture

	-- player name
	local text = frame:CreateFontString(nil, "ARTWORK")
	text:SetParent(frame)
	text:ClearAllPoints()
	text:SetWidth(playerNameWidth)
	text:SetHeight(height)
	text:SetPoint("Left", frame, "LEFT", 22, 0)
	text:SetJustifyH("LEFT")
	text:SetJustifyV("CENTER")
	text:SetFont(L["font"], 12)
	text:SetText(module:GetPlayerText(position, name))
	frame.text = text

	return frame
end

function module:SetupFrame()
	if frame then return end

	frame = CreateFrame("Frame", "BigWigsLoathebTacticalFrame", UIParent)
	frame:Show()

	-- size
	frame:SetWidth(frameWidth)
	frame:SetHeight(100)

	-- background
	frame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 1,
		edgeFile = "Interface\\AddOns\\BigWigs\\Textures\\otravi-semi-full-border", edgeSize = 32,
        --edgeFile = "", edgeSize = 32,
		insets = {left = 1, right = 1, top = 20, bottom = 1},
	})
	frame:SetBackdropColor(24/255, 24/255, 24/255)
	frame:SetFrameStrata("LOW")

	-- position
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	
	-- drag and drop
	frame:EnableMouse(true)
	frame:SetClampedToScreen(true) -- can't move it outside of the screen
	frame:RegisterForDrag("LeftButton")
	frame:SetMovable(true)
	frame:SetScript("OnDragStart", function() this:StartMoving() end)
	frame:SetScript("OnDragStop", function()
		this:StopMovingOrSizing()
		self:SaveFramePosition()
	end)
	
	-- close button
	local close = frame:CreateTexture(nil, "ARTWORK")
	close:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\otravi-close")
	close:SetTexCoord(0, .625, 0, .9333)

	close:SetWidth(20)
	close:SetHeight(14)
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -7, -15)

	local closebutton = CreateFrame("Button", nil)
	closebutton:SetParent(frame)
	closebutton:SetWidth(20)
	closebutton:SetHeight(14)
	closebutton:SetPoint("CENTER", close, "CENTER")
	closebutton:SetScript( "OnClick", function() frame:Hide() end )
	
	-- content
	frame.header = module:CreateHeader(L["Loatheb Tactical"])
	frame.body = module:CreateBody(frame)
	frame.player = {}
	frame.footer = module:CreateFooter(frame)
	
	local x = self.db.profile.posx
	local y = self.db.profile.posy
	if x and y then
		local scale = frame:GetEffectiveScale()
		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / scale, y / scale)
	else
		self:ResetFramePosition()
	end
end

function module:ResetFramePosition()
	if not frame then 
		self:SetupFrame() 
	end
	frame:ClearAllPoints()
	--frame:SetPoint("CENTER", UIParent, "CENTER")
    frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	self.db.profile.posx = nil
	self.db.profile.posy = nil
end

function module:SaveFramePosition()
	if not frame then 
		self:SetupFrame() 
	end

	local scale = frame:GetEffectiveScale()
	self.db.profile.posx = frame:GetLeft() * scale
	self.db.profile.posy = frame:GetTop() * scale
end


----------------------------------
--      Module Test Function    --
----------------------------------

-- /run local m=BigWigs:GetModule("Loatheb Tactical");m.core:EnableModule(m:ToString())m:TestConsumables()
