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
local c = {
    -- currently displayed icon
    texture = "",       -- contains the texturePath
    endTime = 0,        -- to hide it appropriately
    force   = false,    -- will prevent it from being overwritten
}

----------------------------
--      Localization      --
----------------------------

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsWarningSign = BigWigs:NewModule("WarningSign")

------------------------------
--      Initialization      --
------------------------------

function BigWigsWarningSign:OnEnable()
    self:RegisterEvent("BigWigs_ShowWarningSign")
    self:RegisterEvent("BigWigs_HideWarningSign")
    self:RegisterEvent("PLAYER_DEAD")
end

BigWigsWarningSign.frame = CreateFrame("Frame", nil, UIParent)
BigWigsWarningSign.frame:SetFrameStrata("MEDIUM")
BigWigsWarningSign.frame:SetWidth(100) 
BigWigsWarningSign.frame:SetHeight(100)
BigWigsWarningSign.texture = BigWigsWarningSign.frame:CreateTexture(nil, "BACKGROUND")
BigWigsWarningSign.texture:SetAllPoints(BigWigsWarningSign.frame)
BigWigsWarningSign.frame:SetAlpha(0.8)
BigWigsWarningSign.frame:SetPoint("CENTER", 0, 250)
BigWigsWarningSign.frame:Hide()

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsWarningSign:BigWigs_ShowWarningSign(texturePath, duration, force)
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
        
        -- initialize the OnUpdate
        BigWigsWarningSign.frame:SetScript('OnUpdate', function()
                if GetTime() > c.endTime then
                    c.texture   = "";
                    BigWigsWarningSign.frame:Hide()
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
        BigWigsWarningSign.frame:Hide()
        BigWigsWarningSign.frame:SetScript('OnUpdate', nil)
    end
end

function BigWigsWarningSign:PLAYER_DEAD()
    -- this should hide all Icons upon your own death
     self:BigWigs_HideWarningSign("", true)
end