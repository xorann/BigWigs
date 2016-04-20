--[[
    by LYQ(Virose / MOUZU)
    https://github.com/MOUZU/BigWigs
    
    This is a small plugin to make the ReadyCheck from later expansions usable.
--]]

------------------------------
--      Are you local?      --
------------------------------
local c = {
    lastReadyCheck  = 0,
    amReady         = false,
    statusList      = {
        -- this list is resetting every finished ready check
        -- it keeps track of the results from the ongoing ready check
        -- [player] = response,
        --      -1  =   ??
        --      0   =   not ready
        --      1   =   ready
    },
    statusListIndex = {},
    initialized     = false,    -- init process(overwrite things)
    
    ackList         = {
        -- this should list the acknowledges which we received
        -- to determine who is not using a compatible version
    },
    withoutAddOn    = {
        -- this shall cache who is not using a compatible version
    },
}
local f = CreateFrame("Frame")

----------------------------
--      Localization      --
----------------------------


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsReadyCheck = BigWigs:NewModule("ReadyCheck")

------------------------------
--      Initialization      --
------------------------------

function BigWigsReadyCheck:OnEnable()
    self:RegisterEvent("BigWigs_RecvSync")
    self:RegisterEvent("RAID_ROSTER_UPDATE", "UpdateButton")
    self:RegisterEvent("PARTY_CONVERTED_TO_RAID", "UpdateButton")
    self:ScheduleEvent(self.SetupFrames,2)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsReadyCheck:BigWigs_RecvSync(sync, rest, nick)
    --[[
        we consider four different scenarios:
        - a raidmember does not have this addon, he will not acknowledge the request
        - a raidmember does have it, but is not responding in time (AFK), he will acknowledge but neither confirm nor deny
        - a raidmember does have it and confirms it, he will acknowledge and confirm
        - a raidmember does have it and denies it(he is not ready but not afk), he will acknowledge and deny
    --]]
    if sync == "ReadyCheckRequest" and nick ~= UnitName("player") then
        -- a RaidOfficer started a ReadyCheck, we acknowledge his request
        self:TriggerEvent("BigWigs_SendSync", "ReadyCheckAcknowledge")
        
        -- we clear the result table
        for unit=1, GetNumRaidMembers() do
            local name = GetRaidRosterInfo(unit)
            c.statusList[name] = -1
        end
        -- we clear the ack table because we want to know only the results of this current raid setup
        for i=1, table.getn(c.ackList) do
            c.ackList[i] = nil
        end
        
        -- setting up the popup window
        for i=1, MAX_RAID_MEMBERS do
            local name = GetRaidRosterInfo(i)
            if name and name == rest then
                SetPortraitTexture(ReadyCheckPortrait, "raid"..i)
                break
            end
        end
        ReadyCheckFrameText:SetText(format(READY_CHECK_MESSAGE, rest))        
        ReadyCheckFrame:Show()
        c.lastReadyCheck    = GetTime()
        c.amReady           = false
        PlaySound("ReadyCheck")
        
        f:Show()
        
        
        -- TODO: setup OnUpdate to hide the frame after 29s again
        --          if the time runs out and the player did not respond, make a message that the player missed a readycheck
    elseif sync == "ReadyCheckAcknowledge" then
        -- another raidmember acknowledged the request
        tinsert(c.ackList, nick)
        if not c.statusList[nick] then
            c.statusList[nick] = -1
        end
        -- TODO: display a question mark on his raidframe
    elseif sync == "ReadyCheckConfirm" then
        
        if nick == UnitName("player") then
            c.amReady = true
        end
        
        if rest == "Y" then
            c.statusList[nick] = 1
            -- TODO: display a green check sign on his raidframe (hide the question mark)
        elseif rest == "N" then
            c.statusList[nick] = 0
            -- TODO: display a red cross on his raidframe (hide the question mark)
        end
        
        -- 8seconds is the minimum time for a readycheck. I expect the ackList to be full by then
        if (c.lastReadyCheck + 8) < GetTime() and table.getn(c.statusListIndex) == table.getn(c.ackList) then
            -- check who is not using the addon
            for i=1, GetNumRaidMembers() do
                if not c.statusList[UnitName("raid"..i)] then
                    for j=1, table.getn(c.withoutAddOn) do
                        if c.withoutAddOn[j] == UnitName("raid"..i) then
                            -- TODO btw if case is probably not what I want
                        end
                    end
                end
            end
            
            -- check the results of the ones with the addon
            
        end
        
    end
end

function BigWigsReadyCheck:SetupFrames()
    -- I'm overwriting the related Button scripts to use my sync
    if not c.initialized then
        -- lol this button below fired a nil value, I guess it's only being setup when joining a raid or opening raid frame
        RaidFrameReadyCheckButton:SetScript('OnClick', function()
                
                -- init onupdate and possibly enable readycheck for raid assistants too, need to make the button for them visible beforehand too
                -- OnUpdate for - disabling the button for 30s while the current ReadyCheck is ongoing. and analyzing the results of it.
                -- if time is up and raidmember did ack but not respond make him display as denied.
                -- how long should the results be visible after the time is up or all ack members responded? 5s? 10s?
                -- TODO: check for compatibility of Grid, sRaidFrames and LunaRaidFrames
                -- TO RETHINK: option to display AFK players in raidchat or maybe players without the addon?, these options should only be for RL
                
                BigWigsReadyCheck:TriggerEvent("BigWigs_SendSync", "ReadyCheckRequest " .. UnitName("player"))
                c.lastReadyCheck    = GetTime()
                c.amReady           = true
                f:Show()
            end)
        
        ReadyCheckFrameYesButton:SetScript('OnClick', function()
                ReadyCheckFrame:Hide()
                BigWigsReadyCheck:TriggerEvent("BigWigs_SendSync", "ReadyCheckConfirm Y")
            end)
        ReadyCheckFrameNoButton:SetScript('OnClick', function()
                ReadyCheckFrame:Hide()
                BigWigsReadyCheck:TriggerEvent("BigWigs_SendSync", "ReadyCheckConfirm N")
            end)
        -- the following is the popup window update, it was only used to alert the player if he missed a check - this does not suffice in our case
        ReadyCheckFrame:SetScript('OnUpdate', nil)
        f:SetScript('OnUpdate', function()
                if c.lastReadyCheck > 0 and (c.lastReadyCheck + 30) < GetTime() then
                    c.lastReadyCheck = 0
                    ReadyCheckFrame:Hide()
                    BigWigsReadyCheck:CheckResults()
                    
                    f:Hide()
                end
            end)
        f:Hide()
        
        for i=1, 40 do
            -- setup the readycheck result textures now
            local this      = getglobal("RaidGroupButton"..i)
            this.ReadyCheck = CreateFrame("Frame", nil, this)
            this.ReadyCheck:SetWidth(11)
            this.ReadyCheck:SetHeight(11)
            this.ReadyCheckTex = this.ReadyCheck:CreateTexture(nil, "ARTWORK")
            this.ReadyCheckTex:SetAllPoints(this.ReadyCheck)
            this.ReadyCheck:SetPoint("CENTER", this)
            
            --[[
            BigWigsWarnIcon.frame = CreateFrame("Frame", nil, UIParent)
            BigWigsWarnIcon.frame:SetFrameStrata("MEDIUM")
            BigWigsWarnIcon.frame:SetWidth(100) 
            BigWigsWarnIcon.frame:SetHeight(100)
            BigWigsWarnIcon.texture = BigWigsWarnIcon.frame:CreateTexture(nil, "BACKGROUND")
            BigWigsWarnIcon.texture:SetAllPoints(BigWigsWarnIcon.frame)
            BigWigsWarnIcon.frame:SetAlpha(0.8)
            BigWigsWarnIcon.frame:SetPoint("CENTER", 0, 250)
            BigWigsWarnIcon.frame:Hide()
            
            /run RaidGroupButton2.ReadyCheckTex:SetTexture("Interface\\AddOns\\BigWigs\\Icons\\ReadyCheck-Ready")
/run RaidGroupButton2.ReadyCheckTex:SetTexture("Interface\\Icons\\Spell_Fire_Fireball")

/run RaidGroupButton2.ReadyCheckTex:SetBlendMode("BLEND")

/run RaidGroupButton2.ReadyCheck:SetPoint("CENTER", UIParent)
            ]]
        end
        
        BigWigsReadyCheck:UpdateButton()
        
        c.initialized = true
    end
end

function BigWigsReadyCheck:UpdateButton()
    -- by default this is hidden and on this update it would hide the button again
    if GetNumRaidMembers() > 0 and IsRaidOfficer() then
        RaidFrameReadyCheckButton:Show()
    else
        RaidFrameReadyCheckButton:Hide()
    end
end

function BigWigsReadyCheck:CheckResults()
    
end

function BigWigsReadyCheck:DisplayResult(raidIndex, response)
    --[[
        -1  Acknowledge received, but no result yet
        0   not ready
        1   ready
    --]]
    if response == -1 then
        --Interface\\AddOns\\BigWigs\\Icons\\ReadyCheck-Waiting
    elseif response == 0 then
        --Interface\\AddOns\\BigWigs\\Icons\\ReadyCheck-NotReady
    elseif response == 1 then
        --Interface\\AddOns\\BigWigs\\Icons\\ReadyCheck-Ready
    end
end