--[[
    by Dorann
    https://github.com/xorann/BigWigs
    
    This is a small plugin which is inspired by Sulfuras of Mesmerize (Warsong/Feenix) and LYQ.
    It gives the RaidOfficers the opportunity to "disconnect" RaidMembers who are AFK flagged.

    The initial version of Sulfuras could be abused to kick random players in your or other raidgroups
    and therefore this feature was seen as abuse but the intent of it isn't that wrong after all.

    I therefore recreated the feature using his idea and implemented it with a couple of
    safety measures from my side.
--]]

------------------------------
--      Are you local?      --
------------------------------
local lastAFKickRequest = nil


----------------------------
--      Localization      --
----------------------------
L:RegisterTranslations("enUS", function() return {
	-- plugin description
	["AFKick"] = true,
	["Allows you to logout other players that are AFK. The player has 20s to react and cancel the request."] = true,
	
	-- console
	["Send Request"] = true,
	["Send Request to log someone out."] = true,
	
	-- request messages
	["You have to be the raid leader or an assistant."] = true,
	["<BigWigs> %s sent a request to logout %s."] = true,
	["%s is not in your raid"] = true,
	["Please provide a name."] = true,
	
	-- dialog
	["%s sent a request to log you out. Press \"Ok\" to logout or \"Cancel\" to stay logged in. You will logout automatically in 20 seconds."] = true,
	["Ok"] = true,
	["Cancel"] = true,
}
end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsAFKick = BigWigs:NewModule("AFKick")

BigWigsAFKick.consoleOptions = {
	type = "group",
	name = L["AFKick"],
	desc = L["Allows you to logout other players that are AFK. The player has 20s to react and cancel the request."],
	args = {
		kick = {
			type = "text",
			name = L["Send Request"],
			desc = L["Send Request to log someone out."],
			order = 1,
			get = false,
			set = function(name) BigWigsBars:SendRequest(name) end,
		},
	},
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsAFKick:OnEnable()
    self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsBars:SendRequest(name)
	if name then
		local myName = UnitName("player")
		
		-- Raid officers only
		for i = 1, GetNumRaidMembers(), 1 do
            local name, rank = GetRaidRosterInfo(i)
            if name and name == myName then
                if rank > 0 then
                    -- the author is at least assistant
                    break
                else
                    -- not a raid officer
					BigWigs:Print(L["You have to be the raid leader or an assistant."])
                    return
                end
            end
        end
	
		-- check the name
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitName("Raid" .. i) == name then
				self:Sync("AFKick", name) -- send request
				SendChatMessage(string.format(L["<BigWigs> %s sent a request to logout %s."], UnitName("player"), name), "RAID") -- inform the raid
				return
			end
		end
		
		BigWigs:Print(string.format(L["%s is not in your raid"], name))
	else 
		BigWigs:Print(L["Please provide a name."])
	end
end

function BigWigsAFKick:BigWigs_RecvSync(sync, rest, nick)
    if sync == "AFKick" and rest and rest == UnitName("player") then
        -- Check the author of this Sync first
        -- only RaidOfficers are allowed to use this function
        for i = 1, GetNumRaidMembers(), 1 do
            local name, rank = GetRaidRosterInfo(i)
            if name and name == nick then
                if rank > 0 then
                    -- the author is at least an assistant
					self:Logout(nick)
                    break
                else
                    -- the author is a fucktard trying to abuse my system
                    return
                end
            end
        end
    end
end

function BigWigsAFKick:Logout(requester)
	-- Quit() -- normal exit game, 20s warning
	-- ForceQuit() -- immidiate exit
	-- Logout() -- normal logout, 20s warning
	-- Camp() ?? -- does not work
	
	local dialog = nil
	StaticPopupDialogs["BigWigsAFKickDialog"] = {
		text = L["%s sent a request to log you out. Press \"Ok\" to logout or \"Cancel\" to stay logged in. You will logout automatically in 20 seconds."],
		button1 = L["Ok"],
		button2 = L["Cancel"],
		OnAccept = function()
			StaticPopup_Hide ("BigWigsAFKickDialog")
			BigWigsAFKick:CancelScheduledEvent("AFKickQuit")
			BigWigsAFKick:CancelScheduledEvent("AFKickForceQuit")
			BigWigsAFKick:Quit()
		end,
		OnCancel = function()
			StaticPopup_Hide ("BigWigsAFKickDialog")
			BigWigsAFKick:CancelScheduledEvent("AFKickQuit")
			BigWigsAFKick:CancelScheduledEvent("AFKickForceQuit")
		end,
		OnShow = function (self, data)
			--local editbox = getglobal(this:GetName().."WideEditBox")
			--editbox:SetText("https://github.com/xorann/BigWigs/releases")
			--editbox:SetWidth(250)
			--editbox:ClearFocus()
			--editbox:HighlightText() 
			--self.editBox:SetText("Some text goes here")
			--getglobal(this:GetName().."Button2"):Hide()
		end,
		--hasEditBox = true,
		--hasWideEditBox = true,
		--maxLetters = 42,
		--EditBox:setText("Text"),
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}
	local dialog = StaticPopup_Show ("BigWigsAFKickDialog")
	Logout()
	
	--self:ScheduleEvent("AFKickQuit", "BigWigs_SendSync", delay, sync)
	self:ScheduleEvent("AFKickQuit", self.Quit, 21, self)
	
    return false
end

function BigWigsAFKick:Quit()
	Quit() -- normal exit game, 20s warning
	self:ScheduleEvent("AFKickForceQuit", self.ForceQuit, 21, self)
end

function BigWigsAFKick:ForceQuit()
	ForceQuit() -- immidiate exit
end
