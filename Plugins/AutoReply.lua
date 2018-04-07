--[[
    by Dorann
    
    This is a small plugin which is inspired by LYQ and later Bossmod versions which included a module to reply
    to whispers incoming during encounters.
    It can be used to inform that the player can not reply at the moment or to get a status of the
    current fight.
--]]

------------------------------
--      Are you local?      --
------------------------------
local L = AceLibrary("AceLocale-2.2"):new("BigWigsAutoReply")
local cache = {
    replied = {
        -- this is a list of players which we've already informed once to prevent spam
    },
	currentBoss = nil
}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
    -- commands
    statusRequest_cmd = "statusRequest",
	statusRequest_name = "Status Request",
	statusRequest_desc = "Allow querying the Boss Status",
	
	-- messages
	msg_statusRequest = "status",
	msg_prefix = "<BigWigs> ", -- do not translate
	msg_autoReply = "I am currently busy fighting against %s. Send \"status\" to get the status of the current engagement.",
    msg_victory = "The fight against %s has ended. We won :)",
	msg_wipe = "The fight against %s has ended. We lost :(",
	
	msg_percentage = "%s is at %s%% health", -- first parameter is the boss name, second parameter is the health percentage
	msg_percentageUnknown = "Health of %s is unknown",
	msg_alive = "%d/%d players are alive.",
	msg_noStatus = "I am currently not fighting any bosses.",
	
	-- misc
	misc_unknown = "Unknown",
	
	["autoreply"] = true,
	["AutoReply"] = true,
	["Replies whispers during an encounter."] = true,
	["Enabled"] = true,
	["Enable Plugin."] = true,
	["Hide outgoing messages"] = true,
	["Hides all automatically generated outgoing whisper messages."] = true,
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsAutoReply = BigWigs:NewModule("AutoReply", "AceHook-2.1")
BigWigsAutoReply.external = true

BigWigsAutoReply.defaultDB = {
    enabled = true,
	hide = false,
}
BigWigsAutoReply.consoleCmd = L["autoreply"]

BigWigsAutoReply.consoleOptions = {
	type = "group",
	name = L["AutoReply"],
	desc = L["Replies whispers during an encounter."],
	args = {
		enable = {
			type = "toggle",
			name = L["Enabled"],
			desc = L["Enable Plugin."],
			order = 1,
			get = function() return BigWigsAutoReply.db.profile.enabled end,
			set = function(v) BigWigsAutoReply.db.profile.enabled = v end,
		},
		hide = {
			type = "toggle",
			name = L["Hide outgoing messages"],
			desc = L["Hides all automatically generated outgoing whisper messages."],
			order = 2,
			get = function() return BigWigsAutoReply.db.profile.hide end,
			set = function(v) BigWigsAutoReply.db.profile.hide = v end,
		},
	},
}
BigWigsAutoReply.toggleoptions = { "statusRequest" }

------------------------------
--      Initialization      --
------------------------------

function BigWigsAutoReply:OnEnable()
    self:RegisterEvent("CHAT_MSG_WHISPER")
	
	if ChatFrame_MessageEventHandler ~= nil and type(ChatFrame_MessageEventHandler) == "function" then
		self:Hook("ChatFrame_MessageEventHandler", "ChatFrame_OnEvent", true)
	else
		self:Hook("ChatFrame_OnEvent", true)
	end
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsAutoReply:IsRaidMember(name)
	if name then
		for i = 1, GetNumRaidMembers(), 1 do
            local aName = GetRaidRosterInfo(i)
            if aName and aName == name then
                return true
            end
        end
	end
	
	return false
end

function BigWigsAutoReply:CHAT_MSG_WHISPER(msg, name)
	if self.db.profile.enabled and name and not self:IsRaidMember(name) then
		if string.lower(msg) == L["msg_statusRequest"] then
			self:SendStatus(name)
		else
			self:Reply(name)
		end
	end
end

function BigWigsAutoReply:SendStatus(name)
	if --[[self.db.profile.statusRequest and]] name then
		if cache.currentBoss and cache.currentBoss:IsBossModule() then
			local percentage, alive, members = cache.currentBoss:GetStatus()
			local msg = L["msg_prefix"]
						
			if percentage then
				--BigWigs:Print(percentage)
				--BigWigs:Print(cache.currentBoss:ToString())
				msg = msg .. string.format(L["msg_percentage"], cache.currentBoss:ToString(), percentage)
			else
				msg = msg .. string.format(L["msg_percentageUnknown"], cache.currentBoss:ToString())
			end
			
			msg = msg .. ". " .. string.format(L["msg_alive"], alive, members)
			
			SendChatMessage(msg, "WHISPER", nil, name)
		else
			SendChatMessage(L["msg_prefix"] .. L["msg_noStatus"], "WHISPER", nil, name)
		end
	end
end

function BigWigsAutoReply:Reply(name)
	-- only autoreply during a boss encounter
	if cache.currentBoss and cache.currentBoss:IsBossModule() then
		-- only autoreply once
		if name and not cache.replied[name] then
			cache.replied[name] = true
			
			--self:Whisper(L["msg_prefix"] .. L["msg_autoReply"], name) -- the default BigWigs whisper function only whispers members of the raid
			SendChatMessage(L["msg_prefix"] .. string.format(L["msg_autoReply"], cache.currentBoss:ToString()), "WHISPER", nil, name)
		end
	end
end

function BigWigsAutoReply:StartBossfight(mod)
	if mod and mod:IsBossModule() and mod:ToString() then
		cache.currentBoss = mod
	end
end

function BigWigsAutoReply:Victory(mod)
    --local boss = L["misc_unknown"]
	if cache.currentBoss then
		local boss = cache.currentBoss:ToString()
		local msg = L["msg_prefix"] .. string.format(L["msg_victory"], boss)
		
		self:EndBossfight(msg)
	end
end

function BigWigsAutoReply:Wipe(mod)
    local boss = L["misc_unknown"]
	
	if cache and cache.currentBoss then
		boss = cache.currentBoss:ToString()
	end
	local msg = L["msg_prefix"] .. string.format(L["msg_wipe"], boss)
	
	self:EndBossfight(msg)
end

function BigWigsAutoReply:EndBossfight(msg)
	if self.db.profile.enabled then
		-- send whisper that the fight ended to cache.replied and then reset cache.replied
		for name, value in pairs(cache.replied) do
			--self:Whisper(msg, name)
			SendChatMessage(msg, "WHISPER", nil, name)
		end
	end
	
	-- reset cache
	cache.replied = {}
	cache.currentBoss = nil
end

---------------
function BigWigsAutoReply:ChatFrame_OnEvent(event)
	--BigWigs:Print(event)
	if self.db.profile.hide and event and event == "CHAT_MSG_WHISPER_INFORM" then
		if self:IsSpam(arg1) then
			--BigWigs:Print("hide message", event, arg1)
			return
		end
	end
	
	if event then
		--[[if strsub(event, 1, 8) == "CHAT_MSG" and not arg4 then
			BigWigs:Print("buggy event: " .. event)
			if arg1 then BigWigs:Print("arg1 " .. arg1) end
			if arg2 then BigWigs:Print("arg2 " .. arg2) end
			if arg3 then BigWigs:Print("arg3 " .. arg3) end
			if arg4 then BigWigs:Print("arg4 " .. arg4) end
			if arg5 then BigWigs:Print("arg5 " .. arg5) end
			if arg6 then BigWigs:Print("arg6 " .. arg6) end
			if arg7 then BigWigs:Print("arg7 " .. arg7) end
			if arg8 then BigWigs:Print("arg8 " .. arg8) end
			if arg9 then BigWigs:Print("arg9 " .. arg9) end
			if arg10 then BigWigs:Print("arg10 " .. arg10) end
			if arg11 then BigWigs:Print("arg11 " .. arg11) end			
		end]]
		
		if type(self.hooks["ChatFrame_OnEvent"]) == "function" then
			--BigWigs:DebugMessage("ChatFrame_OnEvent " .. event)
			self.hooks["ChatFrame_OnEvent"](event)
		else
			return self.hooks["ChatFrame_MessageEventHandler"](event)
		end
	end
end

function BigWigsAutoReply:IsSpam(text)
	if not text then 
		return false
	end
	
	local start = string.find(text, L["msg_prefix"])
	if start == 1 then
		return true
	end
	
	return false
end
