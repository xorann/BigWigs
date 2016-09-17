--[[
    by Dorann
    https://github.com/xorann/BigWigs
    
	This is a small plugin to show which runes in Molten Core are already doused. By default the window is shown after a boss with a rune was killed or a rune was doused.
--]]

-- todo: sulfuron kill doesn't open the window

assert( BigWigs, "BigWigs not found!")

-----------------------------------------------------------------------
--      Are you local?
-----------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsDousedRunes")

local frame = nil

-----------------------------------------------------------------------
--      Localization
-----------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
    ["DousedRunes"] = true,
	["Doused Runes"] = true,
	["Disabled"] = true,
    ["Options for the doused runes Display."] = true,
    ["Show frame"] = true,
    ["Show the doused runes frame."] = true,
    ["Show on douse"] = true,
    ["Show the display after a rune is doused."] = true,
    ["Show on Boss Kill"] = true,
	["Show the display after a boss has been killed."] = true,
    ["Reset position"] = true,
	["Reset the frame position."] = true,
    ["font"] = "Fonts\\FRIZQT__.TTF",     
            
    ["Ich habe die Rune von (%w+) gel"] = true, -- douse trigger (always german on Nefarian)
} end)

L:RegisterTranslations("deDE", function() return {
    ["DousedRunes"] = "runen",
	["Doused Runes"] = "Gelöschte Runen",
	["Disabled"] = "Deaktivieren",
    ["Options for the doused runes Display."] = "Optionen für die Anzeige der gelöschten Runen",
    ["Show frame"] = "Fenster anzeigen",
    ["Show the doused runes frame."] = "Fenster der gelöschten Runen anzeigen.",
    ["Show on douse"] = "Anzeigen beim Löschen",
    ["Show the display after a rune is doused."] = "Das Fenster anzeigen, wenn eine Rune gelöscht wird.",
    ["Show on Boss Kill"] = "Anzeigen nach Boss Kill",
	["Show the display after a boss has been killed."] = "Das Fenster nach einen Boss Kill anzeigen.",
    ["Reset position"] = "Position zurücksetzen",
	["Reset the frame position."] = "Die Fensterposition zurücksetzen (bewegt das Fenster zur Ursprungsposition).",
} end)

-----------------------------------------------------------------------
--      Module Declaration
-----------------------------------------------------------------------

BigWigsDousedRunes = BigWigs:NewModule("DousedRunes")
BigWigsDousedRunes.revision = tonumber(string.sub("$Revision: 20003 $", 12, -3))
BigWigsDousedRunes.external = true
BigWigsDousedRunes.defaultDB = {
    posx = nil,
	posy = nil,
    isVisible = nil,
    showOnDouse = true,
    showOnBossKill = true,
    
    time = time(),
    runes = {
        ["Magmadar"] = false,
        ["Gehennas"] = false,
        ["Garr"] = false,
        ["Geddon"] = false,
        ["Shazzrah"] = false,
        ["Sulfuron"] = false,
        ["Golemagg"] = false,
    },
}

BigWigsDousedRunes.consoleCmd = L["DousedRunes"]
BigWigsDousedRunes.consoleOptions = {
	type = "group",
	name = L["Doused Runes"],
	desc = L["Options for the doused runes Display."],
	handler = BigWigsDousedRunes,
	pass = true,
	get = function(key)
		return BigWigsDousedRunes.db.profile[key]
	end,
	set = function(key, value)
		BigWigsDousedRunes.db.profile[key] = value
		if key == "disabled" then
			if value then
				BigWigsDousedRunes:Hide()
			else
				BigWigsDousedRunes:Show()
			end
		end
	end,
	args = {
        show = {
            type = "toggle",
            name = L["Show frame"],
            desc = L["Show the doused runes frame."],
            order = 100,
            get = function() return BigWigsDousedRunes.db.profile.isVisible end,
            set = function(v) 
                BigWigsDousedRunes.db.profile.isVisible = v
                if v then
                    BigWigsDousedRunes:Show()
                else
                    BigWigsDousedRunes:Hide()
                end
            end,
        },
        showOnDouse = {
			type = "toggle",
			name = L["Show on douse"],
			desc = L["Show the display after a rune is doused."],
			order = 101,
            get = function() return BigWigsDousedRunes.db.profile.showOnDouse end,
            set = function(v) BigWigsDousedRunes.db.profile.showOnDouse = v end,
		},
        showOnBossKill = {
			type = "toggle",
			name = L["Show on Boss Kill"],
			desc = L["Show the display after a boss has been killed."],
			order = 102,
            get = function() return BigWigsDousedRunes.db.profile.showOnBossKill end,
            set = function(v) BigWigsDousedRunes.db.profile.showOnBossKill = v end,
		},
        reset = {
            type = "execute",
			name = L["Reset position"],
			desc = L["Reset the frame position."],
			order = 103,
			func = function() BigWigsDousedRunes:ResetPosition() end,
        },
		--[[spacer = {
			type = "header",
			name = " ",
			order = 104,
		},]]
	}
}

-----------------------------------------------------------------------
--      Initialization
-----------------------------------------------------------------------

function BigWigsDousedRunes:OnRegister()
	--BigWigs:RegisterBossOption("proximity", L["proximity"], L["proximity_desc"], OnOptionToggled)
end

function BigWigsDousedRunes:OnEnable()
    self.db.profile.isVisible = false
    self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
    self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
    
	self:RegisterEvent("Ace2_AddonDisabled")
	self:RegisterEvent("BigWigsDousedRunes_Show", "Show")
	self:RegisterEvent("BigWigsDousedRunes_Hide", "Hide")
end

function BigWigsDousedRunes:OnDisable()
	self:Hide()
end

-----------------------------------------------------------------------
--      Event Handlers
-----------------------------------------------------------------------

function BigWigsDousedRunes:CHAT_MSG_MONSTER_YELL(msg)
    local _, _, rune = string.find(msg, L["Ich habe die Rune von (%w+) gel"])
    
    if rune then
        self:Update(rune)
        
        if self.db.profile.showOnDouse then
            self:Show()
        end
    end
end

function BigWigsDousedRunes:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
    if self.db.profile.showOnBossKill then
        for key, value in pairs(self.db.profile.runes) do
            if string.find(msg, key) then
                self:Show()
            end
        end
    end
end

function BigWigsDousedRunes:Show()
    self:DebugMessage("BigWigsDousedRunes:Show() 1")
    if not frame then
        self:SetupFrames()
    end
	self:DebugMessage("BigWigsDousedRunes:Show() 2")
    self:Update() -- reset if necessary
	self:DebugMessage("BigWigsDousedRunes:Show() 3")
    frame:Show()
	self:DebugMessage("BigWigsDousedRunes:Show() 4")
    BigWigsDousedRunes.db.profile.isVisible = true
end

function BigWigsDousedRunes:Hide()
    if frame then 
        frame:Hide() 
        self:DebugMessage("BigWigsDousedRunes:Hide()")
        BigWigsDousedRunes.db.profile.isVisible = false
    end
end

function BigWigsDousedRunes:Ace2_AddonDisabled(module)
    self:DebugMessage("BigWigsDousedRunes:Ace2_AddonDisabled(" .. module:ToString() .. ")")
    --self:Hide()
end

-----------------------------------------------------------------------
--      Util
-----------------------------------------------------------------------

function BigWigsDousedRunes:Update(rune)
    -- check whether the data is too old (3h) and reset if necessary
    if time() - self.db.profile.time > 60 * 60 * 3 then
        -- reset all runes
        for key, value in pairs(self.db.profile.runes) do
            self.db.profile.runes[key] = false
        end
    end
    
    -- update doused runes
    if rune and type(rune) == "string" then 
        self:DebugMessage("BigWigsDousedRunes:Update("..rune..")")
        for key, value in pairs(self.db.profile.runes) do
            if rune == key then
                self.db.profile.runes[key] = true
            end            
        end
        
        self.db.profile.time = time()
    end
    
    -- update displayed text
    local function red(t)
        return "|cffff0000" .. t .. "|r"
    end
    local function green(t)
        return "|cff00ff00" .. t .. "|r"
    end

    local text = ""
    for key, value in pairs(self.db.profile.runes) do
        if value then
            text = text .. green(key) .. "\n"
        else
            text = text .. red(key) .. "\n"
        end         
    end

    if not frame then self:SetupFrames() end
    frame.text:SetText(text)
end


------------------------------
--    Create the Frame     --
------------------------------

function BigWigsDousedRunes:SetupFrames()
	if frame then return end

    frame = CreateFrame("Frame", "BigWigsDousedRunesFrame", UIParent)
	frame:Hide()

	frame:SetWidth(130)
	frame:SetHeight(130)

	frame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\AddOns\\BigWigs\\Textures\\otravi-semi-full-border", edgeSize = 32,
        --edgeFile = "", edgeSize = 32,
		insets = {left = 1, right = 1, top = 20, bottom = 1},
	})

	frame:SetBackdropColor(24/255, 24/255, 24/255)
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetMovable(true)
	frame:SetScript("OnDragStart", function() this:StartMoving() end)
	frame:SetScript("OnDragStop", function()
		this:StopMovingOrSizing()
		self:SavePosition()
	end)

	local cheader = frame:CreateFontString(nil, "OVERLAY")
	cheader:ClearAllPoints()
	cheader:SetWidth(120)
	cheader:SetHeight(15)
	cheader:SetPoint("TOP", frame, "TOP", 0, -14)
	cheader:SetFont(L["font"], 12)
	cheader:SetJustifyH("LEFT")
	cheader:SetText(L["Doused Runes"])
	cheader:SetShadowOffset(.8, -.8)
	cheader:SetShadowColor(0, 0, 0, 1)
	frame.cheader = cheader

	local text = frame:CreateFontString(nil, "OVERLAY")
	text:ClearAllPoints()
	text:SetWidth( 120 )
	text:SetHeight( 130 )
	text:SetPoint( "TOP", frame, "TOP", 0, -35 )
	text:SetJustifyH("CENTER")
	text:SetJustifyV("TOP")
	text:SetFont(L["font"], 12)
	frame.text = text

	local close = frame:CreateTexture(nil, "ARTWORK")
	close:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\otravi-close")
	close:SetTexCoord(0, .625, 0, .9333)

	close:SetWidth(20)
	close:SetHeight(14)
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -7, -15)

	local closebutton = CreateFrame("Button", nil)
	closebutton:SetParent( frame )
	closebutton:SetWidth(20)
	closebutton:SetHeight(14)
	closebutton:SetPoint("CENTER", close, "CENTER")
	closebutton:SetScript( "OnClick", function() self:Hide() end )

	local x = self.db.profile.posx
	local y = self.db.profile.posy
	if x and y then
		local s = frame:GetEffectiveScale()
		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	else
		self:ResetPosition()
	end
    
    self:Update()
end

function BigWigsDousedRunes:ResetPosition()
	if not frame then self:SetupFrames() end
	frame:ClearAllPoints()
	--frame:SetPoint("CENTER", UIParent, "CENTER")
    frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 1000, 500)
	self.db.profile.posx = nil
	self.db.profile.posy = nil
end

function BigWigsDousedRunes:SavePosition()
	if not frame then self:SetupFrames() end

	local s = frame:GetEffectiveScale()
	self.db.profile.posx = frame:GetLeft() * s
	self.db.profile.posy = frame:GetTop() * s
end

