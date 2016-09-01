--[[
    by LYQ(Virose / MOUZU)
    https://github.com/MOUZU/BigWigs
    
    This is a small plugin which is inspried by ThaddiusArrows and how Sulfuras of Mesmerize (Warsong/Feenix) used it.
    I wanted to convert his idea in a more dynamic, flexible and easy to use plugin.

    At the current state it is built to only display one Icon at a time, at the moment I can not think of
    a situation where it would be needed to display more than one.
--]]

------------------------------
--      Are you local?      --
------------------------------
local name = "WarningSign"
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..name)

local c = {
    -- currently displayed icon
    texture = "",       -- contains the texturePath
    endTime = 0,        -- to hide it appropriately
    force   = false,    -- will prevent it from being overwritten
}


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
    ["WarningSign"] = true, -- console cmd
	["Warning Sign"] = true, -- module name
	["Options for the Warning Sign."] = true, 
	["Show test Icon"] = true,
	["Show test Icon to change the position."] = true,
	["Reset position"] = true,
	["Reset the frame position."] = true,
} end)

L:RegisterTranslations("deDE", function() return {
    ["WarningSign"] = "warnzeichen", -- console cmd
	["Warning Sign"] = "Warnzeichen", -- module name
	["Options for the Warning Sign."] = "Optionen für das Warnzeichen.", 
	["Show test Icon"] = "Zeige Test-Warnzeichen",
	["Show test Icon to change the position."] = "Zeige Test-Warnzeichen um die Position zu verändern.",
	["Reset position"] = "Position zurücksetzen",
	["Reset the frame position."] = "Die Position des Warnzeichens zurücksetzen.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsWarningSign = BigWigs:NewModule(name)
BigWigsWarningSign.defaultDB = {
    posx = nil,
	posy = nil,
    isVisible = nil,
}
BigWigsWarningSign.consoleCmd = L["WarningSign"]
BigWigsWarningSign.consoleOptions = {
	type = "group",
	name = L["Warning Sign"],
	desc = L["Options for the Warning Sign."],
	handler = BigWigsWarningSign,
	pass = true,
	get = function(key)
		return BigWigsWarningSign.db.profile[key]
	end,
	set = function(key, value)
		BigWigsWarningSign.db.profile[key] = value
	end,
	args = {
        show = {
            type = "toggle",
            name = L["Show test Icon"],
            desc = L["Show test Icon to change the position."],
            order = 100,
            get = function() return BigWigsWarningSign.db.profile.isVisible end,
            set = function(v) 
                BigWigsWarningSign.db.profile.isVisible = v
                if v then
                    BigWigsWarningSign:BigWigs_ShowWarningSign("Interface\\Icons\\Inv_Hammer_Unique_Sulfuras", 60)
                else
                    BigWigsWarningSign:BigWigs_HideWarningSign("", true)
                end
            end,
        },
        reset = {
            type = "execute",
			name = L["Reset position"],
			desc = L["Reset the frame position."],
			order = 102,
			func = function() BigWigsWarningSign:ResetPosition() end,
        },
		--[[spacer = {
			type = "header",
			name = " ",
			order = 103,
		},]]
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsWarningSign:OnEnable()
	self.db.profile.isVisible = false
	
    self:RegisterEvent("BigWigs_ShowWarningSign")
    self:RegisterEvent("BigWigs_HideWarningSign")
    self:RegisterEvent("PLAYER_DEAD")
end



------------------------------
--      Event Handlers      --
------------------------------

function BigWigsWarningSign:BigWigs_ShowWarningSign(texturePath, duration, force)
	if not BigWigsWarningSign.frame then
        self:SetupFrames()
    end

    -- force will overwrite the current icon shown, else it will do nothing
    if not type(texturePath) == "string" or not type(duration) == "number" then return end
    
    -- check if there is currently an icon displayed or if the force flags allow to overwrite
    -- addition: if texturePath is the same as currently displayed then reset the timer to duration
    if c.texture == "" or (force and not c.force) or c.texture == texturePath then
        c.texture   = texturePath;
        c.endTime   = GetTime() + duration;
        c.force     = force;
        
        BigWigsWarningSign.texture:SetTexture(texturePath)
        BigWigsWarningSign.frame:Show()
		self.db.profile.isVisible = true
        
        -- initialize the OnUpdate
        BigWigsWarningSign.frame:SetScript('OnUpdate', function()
			if GetTime() > c.endTime then
				c.texture   = "";
				BigWigsWarningSign.frame:Hide()
				self.db.profile.isVisible = false
				BigWigsWarningSign.frame:SetScript('OnUpdate', nil)
			end
		end)
    end
end

function BigWigsWarningSign:BigWigs_HideWarningSign(texturePath, forceHide)
    -- will only work if texturePath is still the icon displayed, this might not be the case when an icon gets forced
    -- forceHide is used upon BossDeath to hide no matter what is being displayed
    if forceHide or c.texture == texturePath then
        c.texture   = "";
		
		if BigWigsWarningSign.frame then 
			BigWigsWarningSign.frame:Hide()
			self.db.profile.isVisible = false
			BigWigsWarningSign.frame:SetScript('OnUpdate', nil)
		end
    end
end

function BigWigsWarningSign:PLAYER_DEAD()
    -- this should hide all Icons upon your own death
     self:BigWigs_HideWarningSign("", true)
end


------------------------------
--    Create the Frame     --
------------------------------

function BigWigsWarningSign:SetupFrames()
	BigWigsWarningSign.frame = CreateFrame("Frame", "BigWigsWarningSignFrame", UIParent)
	BigWigsWarningSign.frame:Hide()
	self.db.profile.isVisible = false
	
	BigWigsWarningSign.frame:SetFrameStrata("MEDIUM")
	BigWigsWarningSign.frame:SetWidth(100) 
	BigWigsWarningSign.frame:SetHeight(100)
	BigWigsWarningSign.frame:SetAlpha(0.8)
	BigWigsWarningSign.frame:SetPoint("CENTER", 0, 150)
	
	BigWigsWarningSign.frame:EnableMouse(true)
	BigWigsWarningSign.frame:SetClampedToScreen(true)
	BigWigsWarningSign.frame:RegisterForDrag("LeftButton")
	BigWigsWarningSign.frame:SetMovable(true)
	BigWigsWarningSign.frame:SetScript("OnDragStart", function() this:StartMoving() end)
	BigWigsWarningSign.frame:SetScript("OnDragStop", function()
		this:StopMovingOrSizing()
		self:SavePosition()
	end)

	BigWigsWarningSign.texture = BigWigsWarningSign.frame:CreateTexture(nil, "BACKGROUND")
	BigWigsWarningSign.texture:SetAllPoints(BigWigsWarningSign.frame)
	BigWigsWarningSign.texture:SetTexCoord(0.08, 0.92, 0.08, 0.92) -- zoom in to hide border
	
	local x = self.db.profile.posx
	local y = self.db.profile.posy
	if x and y then
		local s = BigWigsWarningSign.frame:GetEffectiveScale()
		BigWigsWarningSign.frame:ClearAllPoints()
		BigWigsWarningSign.frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	else
		self:ResetPosition()
	end
end

function BigWigsWarningSign:ResetPosition()
	if not BigWigsWarningSign.frame then 
		self:SetupFrames() 
	end
	BigWigsWarningSign.frame:ClearAllPoints()
	--frame:SetPoint("CENTER", UIParent, "CENTER")
	--BigWigsWarningSign.frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 1000, 500)
    BigWigsWarningSign.frame:SetPoint("CENTER", 0, 150)
	self.db.profile.posx = nil
	self.db.profile.posy = nil
end

function BigWigsWarningSign:SavePosition()
	if not BigWigsWarningSign.frame then 
		self:SetupFrames() 
	end

	local s = BigWigsWarningSign.frame:GetEffectiveScale()
	self.db.profile.posx = BigWigsWarningSign.frame:GetLeft() * s
	self.db.profile.posy = BigWigsWarningSign.frame:GetTop() * s
end