--[[
    by Dorann
    https://github.com/xorann/BigWigs
    
	This is a small plugin to help mages track their ignite stack and hopefully prevents them from drawing aggro.
--]]

-- todo: sulfuron kill doesn't open the window

assert( BigWigs, "BigWigs not found!")

-----------------------------------------------------------------------
--      Are you local?
-----------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsIgnite")

local frame = nil
local playerClass = nil

-----------------------------------------------------------------------
--      Localization
-----------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
    ["Ignite"] = true,
	["ignite"] = true,
	["Disabled"] = true,
    ["Options for the ignite Display."] = true,
    ["Show frame"] = true,
    ["Show the ignite frame."] = true,
    ["Reset position"] = true,
	["Reset the frame position."] = true,
    ["font"] = "Fonts\\FRIZQT__.TTF",
	
	["Stacks"] = true,
	["Damage"] = true,
	["Owner"] = true,
	["Threat"] = true,
	["n/a"] = true, -- no threat data available
	
	vulnerability_direct_test = "^[%w]+[%s's]* ([%w%s:]+) ([%w]+) Chromaggus for ([%d]+) ([%w]+) damage%.[%s%(]*([%d]*)", -- [Fashu's] [Firebolt] [hits] Battleguard Sartura for [44] [Fire] damage. ([14] resisted)
	direct_test = "^[%w]+[%s's]* ([%w%s:]+) crits [%w] for ([%d]+) Fire damage.", -- [Skrilla]['s] [Fireball] crits [Battleguard Sartura] for [3423] Fire damage.
	vulnerability_dots_test = "^Chromaggus suffers ([%d]+) ([%w]+) damage from [%w]+[%s's]* ([%w%s:]+)%.[%s%(]*([%d]*)",
	
	["Fireball"] = true,
	["Scorch"] = true,
	["Fire Blast"] = true,
	["Blastwave"] = true,
	["Flamestrike"] = true,
} end)

L:RegisterTranslations("deDE", function() return {
	["Disabled"] = "Deaktivieren",
    ["Show frame"] = "Fenster anzeigen",
    ["Reset position"] = "Position zurücksetzen",
	["Reset the frame position."] = "Die Fensterposition zurücksetzen (bewegt das Fenster zur Ursprungsposition).",
} end)

-----------------------------------------------------------------------
--      Module Declaration
-----------------------------------------------------------------------

BigWigsIgnite = BigWigs:NewModule("Ignite")
BigWigsIgnite.revision = 20004
BigWigsIgnite.external = true
BigWigsIgnite.defaultDB = {
    posx = nil,
	posy = nil,
    isVisible = nil,
}
BigWigsIgnite.stacks = 0
BigWigsIgnite.damage = 0
BigWigsIgnite.owner = ""
BigWigsIgnite.threat = 0

BigWigsIgnite.consoleCmd = L["Ignite"]
BigWigsIgnite.consoleOptions = {
	type = "group",
	name = L["Ignite"],
	desc = L["Options for the ignite Display."],
	handler = BigWigsIgnite,
	pass = true,
	get = function(key)
		return BigWigsIgnite.db.profile[key]
	end,
	set = function(key, value)
		BigWigsIgnite.db.profile[key] = value
		if key == "disabled" then
			if value then
				BigWigsIgnite:Hide()
			else
				BigWigsIgnite:Show()
			end
		end
	end,
	args = {
        show = {
            type = "toggle",
            name = L["Show frame"],
            desc = L["Show the ignite frame."],
            order = 100,
            get = function() return BigWigsIgnite.db.profile.isVisible end,
            set = function(v) 
                BigWigsIgnite.db.profile.isVisible = v
                if v then
                    BigWigsIgnite:Show()
                else
                    BigWigsIgnite:Hide()
                end
            end,
        },
        reset = {
            type = "execute",
			name = L["Reset position"],
			desc = L["Reset the frame position."],
			order = 103,
			func = function() BigWigsIgnite:ResetPosition() end,
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

function BigWigsIgnite:OnRegister()
	--BigWigs:RegisterBossOption("proximity", L["proximity"], L["proximity_desc"], OnOptionToggled)
	playerClass = UnitClass("player")
end

function BigWigsIgnite:OnEnable()
    self.db.profile.isVisible = false
    
	self:RegisterEvent("BigWigsIgnite_Show", "Show")
	self:RegisterEvent("BigWigsIgnite_Hide", "Hide")
	
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "PlayerDamageEvents")
	
	self:SetupFrames()
	playerClass = UnitClass("player")

	self.stacks = 0
	self.damage = 0
	self.owner = ""
	self.threat = 0
end

function BigWigsIgnite:OnDisable()
	self:Hide()
end

-----------------------------------------------------------------------
--      Event Handlers
-----------------------------------------------------------------------

function BigWigsIgnite:Show()
    if not frame then
        self:SetupFrames()
    end
    self:Update() -- reset if necessary
    frame:Show()
    BigWigsIgnite.db.profile.isVisible = true
end

function BigWigsIgnite:Hide()
    if frame then 
        frame:Hide() 
        self:DebugMessage("BigWigsIgnite:Hide()")
        BigWigsIgnite.db.profile.isVisible = false
    end
end

function BigWigsIgnite:PlayerDamageEvents(msg)
	--vulnerability_direct_test = "^[%w]+[%s's]* ([%w%s:]+) ([%w]+) Chromaggus for ([%d]+) ([%w]+) damage%.[%s%(]*([%d]*)", -- [Fashu's] [Firebolt] [hits] Battleguard Sartura for [44] [Fire] damage. ([14] resisted)
	--local name, s, spell, hitType, dmg, school, partial = string.find(msg, L["vulnerability_direct_test"]) 


	--direct_test = "^[%w]+[%s's]* ([%w%s:]+) crits [%w] for ([%d]+) Fire damage.", -- [Skrilla]['s] [Fireball] crits [Battleguard Sartura] for [3423] Fire damage.
	--local name, s, spell, hitType, victim, dmg = string.find(msg, L["direct_test"]) 
    
    -- check for fire spell crit
    local fire_test = "^([%w]+)'s ([%w%s:]+) crits ([%w%s:]+) for ([%d]+) ([%w]+) damage."
    local start, ending, name, spell, victim, dmg, school = string.find(msg, fire_test) 
	if self:IsMage(name) and self:IsIgniteSpell(spell) and UnitName("target") == victim then
		self:DebugMessage("mage fire spell crit")
	end
    
    -- check for ignite stacks
    local ignite_test = "^([%w%s:]+) is afflicted by Ignite.[%s%(]*([%d]*)"
    local start, ending, victim, stacks = string.find(msg, ignite_test)
    if victim then
        if not stacks or stacks == "" then
            stacks = 1
        end
        self:DebugMessage(stacks .. " ignite stacks")
        self.stacks = stacks
        
        self:Update()
    end
    
    -- check for ignite damage
    local ignite_test = "^([%w%s:]+) suffers ([%d]+) Fire damage from ([%w]+)'s Ignite."
    local start, ending, victim, damage, owner = string.find(msg, ignite_test)
    if victim and damage and owner then
        self:DebugMessage("Ignite damage: owner: " .. owner .. " damage: " .. damage .. " victim: " .. victim)
        self.owner = owner
        self.damage = damage
        
        self:Update()
    end
    
    -- check for ignite fade
    local fade_test = "^Ignite fades from ([%w%s:]+)."
    local start, ending, victim = string.find(msg, fade_test)
    if victim then
        self:DebugMessage("Ignite fades: victim: " .. victim)
        self.owner = ""
        self.damage = 0
        self.stacks = 0
        
        self:Update()
    end
    
    -- /run BigWigsIgnite:PlayerDamageEvents("Coyra's Fireball crits Ragged Timber Wolf for 3423 Fire damage.")
    -- /run BigWigsIgnite:PlayerDamageEvents("Ragged Timber Wolf is afflicted by Ignite.")
    -- /run BigWigsIgnite:PlayerDamageEvents("Ragged Timber Wolf suffers 2812 Fire damage from Coyra's Ignite.")
    -- /run BigWigsIgnite:PlayerDamageEvents("Ignite fades from Ragged Timber Wolf.")
end

--[[
Battleguard Sartura is afflicted by Ignite.
Battleguard Sartura is afflicted by Ignite (2).
Battleguard Sartura suffers 2812 Fire damage from Rokhart's Ignite.
Ignite fades from Battleguard Sartura.

Skrilla's Fireball crits Battleguard Sartura for 3423 Fire damage.
Nifexx's Scorch crits Battleguard Sartura for 1198 Fire damage.
Murc's Fire Blast crits Battleguard Sartura for 1857 Fire damage.

Blast Wave?
Flamestrike?
anything else?
]]

-----------------------------------------------------------------------
--      Util
-----------------------------------------------------------------------
function BigWigsIgnite:IsMage(aName) 
	if aName then
		local num = GetNumRaidMembers()
		for i = 1, num do
			local raidUnit = string.format("raid%s", i)
			if UnitExists(raidUnit) then
				local name = UnitName(raidUnit)
				if name == aName then
                    local class = UnitClass(raidUnit)
					if class == "Mage" 
                        or class == "Warlock" then --fix this
                        return true
                    end
				end
			end
		end
	end
	return false
end
function BigWigsIgnite:IsIgniteSpell(spell)
	if spell == L["Fireball"] or spell == L["Scorch"] or spell == L["Fire Blast"] or spell == L["Blastwave"] or spell == L["Flamestrike"] then
		return true
	end
	return false
end

function BigWigsIgnite:Update()
	--[[
	Stacks: 5
	Damage: 1234
	Owner: Nifexx
	Threat: 99% (5s)
	]]

	self:UpdateThreat(self.owner)	
	
	local text = ""
    text = L["Stacks"] .. ": " .. self.stacks .."\n"
	text = text .. L["Damage"] .. ": " .. self.damage .."\n"
	text = text .. L["Owner"] .. ": " .. self.owner .."\n"
	text = text .. L["Threat"] .. ": " .. self.threat
	
	if not frame then 
		self:SetupFrames() 
	end
    frame.text:SetText(tostring(text))
	
	
	
    -- update displayed text
    local function red(t)
        return "|cffff0000" .. t .. "|r"
    end
    local function green(t)
        return "|cff00ff00" .. t .. "|r"
    end
end

function BigWigsIgnite:UpdateThreat(name)
	if name and IsAddOnLoaded("KLHThreatMeter") then
		local data, playerCount, threat100 = KLHTM_GetRaidData()
		local okay = false
		for i = 1, table.getn(data) do
			if name == data[i].name then
				self.threat = data[i].threat / threat100 * 100
				self.threat = tonumber(string.format("%.0f", self.threat))
				self.threat = self.threat .. "%"
				okay = true
				break
			end
		end
		
		if not okay then
			self.threat = L["n/a"]
		end
	else
		self.threat = L["n/a"]
	end
end


------------------------------
--    Create the Frame     --
------------------------------

function BigWigsIgnite:SetupFrames()
	if frame then return end

    frame = CreateFrame("Frame", "BigWigsIgniteFrame", UIParent)
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
	cheader:SetText(L["Ignite"])
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

function BigWigsIgnite:ResetPosition()
	if not frame then self:SetupFrames() end
	frame:ClearAllPoints()
	--frame:SetPoint("CENTER", UIParent, "CENTER")
    frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 1000, 500)
	self.db.profile.posx = nil
	self.db.profile.posy = nil
end

function BigWigsIgnite:SavePosition()
	if not frame then self:SetupFrames() end

	local s = frame:GetEffectiveScale()
	self.db.profile.posx = frame:GetLeft() * s
	self.db.profile.posy = frame:GetTop() * s
end

