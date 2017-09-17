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
	
	msg_percentage = "%s is at %s%%%% health", -- first parameter is the boss name, second parameter is the health percentage
	msg_percentageUnknown = "Health of %s is unknown",
	msg_alive = "%d/%d players are alive.",
	msg_noStatus = "I am currently not fighting any bosses.",
	
	-- misc
	misc_unknown = "Unknown",
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsAutoReply = BigWigs:NewModule("AutoReply")
BigWigsAutoReply.toggleoptions = { "statusRequest" }

------------------------------
--      Initialization      --
------------------------------

function BigWigsAutoReply:OnEnable()
    self:RegisterEvent("CHAT_MSG_WHISPER")
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
	if name and not self:IsRaidMember(name) then
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
    --local boss = L["misc_unknown"]
	local boss = cache.currentBoss:ToString()
	local msg = L["msg_prefix"] .. string.format(L["msg_wipe"], boss)
	
	self:EndBossfight(msg)
end

function BigWigsAutoReply:EndBossfight(msg)
	-- send whisper that the fight ended to cache.replied and then reset cache.replied
	for name, value in pairs(cache.replied) do
		--self:Whisper(msg, name)
		SendChatMessage(msg, "WHISPER", nil, name)
	end
	
	-- reset cache
	cache.replied = {}
	cache.currentBoss = nil
end