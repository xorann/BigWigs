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

BigWigsWarnIcon = BigWigs:NewModule("WarnIcon")

------------------------------
--      Initialization      --
------------------------------

function BigWigsWarnIcon:OnEnable()
    self:RegisterEvent("BigWigs_ShowIcon")
    self:RegisterEvent("BigWigs_HideIcon")
    self:RegisterEvent("PLAYER_DEAD")
end

BigWigsWarnIcon.frame = CreateFrame("Frame", nil, UIParent)
BigWigsWarnIcon.frame:SetFrameStrata("MEDIUM")
BigWigsWarnIcon.frame:SetWidth(100) 
BigWigsWarnIcon.frame:SetHeight(100)
BigWigsWarnIcon.texture = BigWigsWarnIcon.frame:CreateTexture(nil, "BACKGROUND")
BigWigsWarnIcon.texture:SetAllPoints(BigWigsWarnIcon.frame)
BigWigsWarnIcon.frame:SetAlpha(0.8)
BigWigsWarnIcon.frame:SetPoint("CENTER", 0, 250)
BigWigsWarnIcon.frame:Hide()

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsWarnIcon:BigWigs_ShowIcon(texturePath, duration, force)
    -- force will overwrite the current icon shown, else it will do nothing
    if not type(texturePath) == "string" or not type(duration) == "number" then return end
    
    -- check if there is currently an icon displayed or if the force flags allow to overwrite
    -- addition: if texturePath is the same as currently displayed then reset the timer to duration
    if c.texture == "" or (force and not c.force) or c.texture == texturePath then
        c.texture   = texturePath;
        c.endTime   = GetTime() + duration;
        c.force     = force;
        
        BigWigsWarnIcon.texture:SetTexture(texturePath)
        BigWigsWarnIcon.frame:Show()
        
        -- initialize the OnUpdate
        BigWigsWarnIcon.frame:SetScript('OnUpdate', function()
                if GetTime() > c.endTime then
                    c.texture   = "";
                    BigWigsWarnIcon.frame:Hide()
                    BigWigsWarnIcon.frame:SetScript('OnUpdate', nil)
                end
            end)
    end
end

function BigWigsWarnIcon:BigWigs_HideIcon(texturePath, forceHide)
    -- will only work if texturePath is still the icon displayed, this might not be the case when an icon gets forced
    -- forceHide is used upon BossDeath to hide no matter what is being displayed
    if forceHide or c.texture == texturePath then
        c.texture   = "";
        BigWigsWarnIcon.frame:Hide()
        BigWigsWarnIcon.frame:SetScript('OnUpdate', nil)
    end
end

function BigWigsWarnIcon:PLAYER_DEAD()
    -- this should hide all Icons upon your own death
     self:BigWigs_HideIcon("", true)
end