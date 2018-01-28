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

local L = AceLibrary("AceLocale-2.2"):new("BigWigsAFKick")
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
	["<player name>"] = true,
	
	-- request messages
	["You have to be the raid leader or an assistant."] = true,
	["<BigWigs> %s sent a request to logout %s."] = true,
	["%s is not in your raid"] = true,
	["Please provide a name."] = true,
	["Your AFKick Request for %s was not acknowledged. %s is probably not using a compatible version of BigWigs."] = true,
	["%s is already offline."] = true,
	
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
BigWigsAFKick.external = true

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
			set = function(name) BigWigsAFKick:SendRequest(name) end,
			usage = L["<player name>"],
			disabled = function() return (not IsRaidLeader() and not IsRaidOfficer()) and UnitInRaid("player") end,
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

function BigWigsAFKick:SendRequest(name)
	if name then

		name = string.gsub(name, "^%l", string.upper) -- first character uppercase
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
				if UnitIsConnected("Raid" .. i) then
					self:Sync("AFKick " .. name) -- send request
					self:ScheduleEvent("AFKickWaitForAcknowledge" .. name, self.NoAcknowledge, 10, self, name)
				else
					BigWigs:Print(string.format(L["%s is already offline."], name))
				end
				
				return
			end
		end
		
		BigWigs:Print(string.format(L["%s is not in your raid"], name))
	else 
		BigWigs:Print(L["Please provide a name."])
	end
end

function BigWigsAFKick:BigWigs_RecvSync(sync, rest, nick)
    if sync == "AFKick" and rest and nick then
        self:RequestReceived(rest, nick)
    elseif sync == "AFKickAcknowledge" and rest and nick then
		self:Acknowledge(rest, nick)
	end
end

function BigWigsAFKick:RequestReceived(name, requester)
	if name == UnitName("player") then
		-- Check the author of this Sync first
		-- only RaidOfficers are allowed to use this function
		for i = 1, GetNumRaidMembers(), 1 do
			local aName, rank = GetRaidRosterInfo(i)
			if aName and aName == requester then
				if rank > 0 then
					-- the author is at least an assistant
					self:Logout(requester)
					break
				else
					-- the author is a fucktard trying to abuse my system
					return
				end
			end
		end
	end
end

function BigWigsAFKick:Acknowledge(requester, name)
	if requester == UnitName("player") and name then
		self:CancelScheduledEvent("AFKickWaitForAcknowledge" .. name)
		SendChatMessage(string.format(L["<BigWigs> %s sent a request to logout %s."], UnitName("player"), name), "RAID") -- inform the raid
	end
end

function BigWigsAFKick:NoAcknowledge(name)
	BigWigs:Print(string.format(L["Your AFKick Request for %s was not acknowledged. %s is probably not using a compatible version of BigWigs."], name, name))
end

function BigWigsAFKick:Logout(requester)
	-- Quit() -- normal exit game, 20s warning
	-- ForceQuit() -- immidiate exit
	-- Logout() -- normal logout, 20s warning
	-- Camp() ?? -- does not work
	
	self:Sync("AFKickAcknowledge " .. requester)
	
	local dialog = nil
	StaticPopupDialogs["BigWigsAFKickDialog"] = {
		text = string.format(L["%s sent a request to log you out. Press \"Ok\" to logout or \"Cancel\" to stay logged in. You will logout automatically in 20 seconds."], requester),
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
	dialog = StaticPopup_Show("BigWigsAFKickDialog")
	--Logout()
	
	--self:ScheduleEvent("AFKickQuit", "BigWigs_SendSync", delay, sync)
	self:ScheduleEvent("AFKickQuit", self.Quit, 21, self)
	
    return false
end

function BigWigsAFKick:Quit()
	Logout() -- normal exit game, 20s warning
	self:ScheduleEvent("AFKickForceQuit", self.ForceQuit, 22, self)
end

function BigWigsAFKick:ForceQuit()
	ForceQuit() -- immidiate exit
end
