--[[
    by Dorann
--]]


assert( BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------
local L = AceLibrary("AceLocale-2.2"):new("BigWigsCombatlogFilter")

local Events = {
	"CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS",
	"CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES",
	"CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS",
	"CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES",
	"CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS",
	"CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES",
	"CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS",
	"CHAT_MSG_COMBAT_FRIENDLYPLAYER_MISSES",
	"CHAT_MSG_COMBAT_HONOR_GAIN",
	"CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS",
	"CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES",
	"CHAT_MSG_COMBAT_LOG_ERROR",
	"CHAT_MSG_COMBAT_LOG_MISC_INFO",
	"CHAT_MSG_COMBAT_MISC_INFO",
	"CHAT_MSG_COMBAT_PARTY_HITS",
	"CHAT_MSG_COMBAT_PARTY_MISSES",
	"CHAT_MSG_COMBAT_PET_HITS",
	"CHAT_MSG_COMBAT_PET_MISSES",
	"CHAT_MSG_COMBAT_SELF_HITS",
	"CHAT_MSG_COMBAT_SELF_MISSES",
	"CHAT_MSG_COMBAT_FRIENDLY_DEATH",
	"CHAT_MSG_COMBAT_HOSTILE_DEATH",
	"CHAT_MSG_SPELL_AURA_GONE_OTHER",
	"CHAT_MSG_SPELL_AURA_GONE_PARTY",
	"CHAT_MSG_SPELL_AURA_GONE_SELF",
	"CHAT_MSG_SPELL_BREAK_AURA",
	"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF",
	"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
	"CHAT_MSG_SPELL_CREATURE_VS_PARTY_BUFF",
	"CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE",
	"CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF",
	"CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE",
	"CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS",
	"CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF",
	"CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF",
	"CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF",
	"CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_PARTY_BUFF",
	"CHAT_MSG_SPELL_PARTY_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS",
	"CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS",
	"CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS",
	"CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS",
	"CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
	"CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
	"CHAT_MSG_SPELL_PET_BUFF",
	"CHAT_MSG_SPELL_PET_DAMAGE",
	"CHAT_MSG_SPELL_SELF_BUFF",
	"CHAT_MSG_SPELL_SELF_DAMAGE",
	
	"LOOT_OPENED",
	"MINIMAP_ZONE_CHANGED",
	"PLAYER_AURAS_CHANGED",
    
    "SPELLCAST_START",
	"SPELLCAST_STOP",
	"SPELLCAST_INTERRUPTED",
	"SPELLCAST_FAILED",
	"SPELLCAST_DELAYED",
	"SPELLCAST_CHANNEL_START",
	"SPELLCAST_CHANNEL_STOP",
	"SPELLCAST_CHANNEL_UPDATE",
	"UI_ERROR_MESSAGE",
	"CHAT_MSG_SPELL_FAILED_LOCALPLAYER",
	
	"SPELLS_CHANGED", 

	--"UNIT_AURA",
	"UNIT_AURASTATE",
	"UNIT_SPELLMISS",
	
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_EMOTE",
	"CHAT_MSG_MONSTER_YELL",
}

local filter = {}
local stopwatch = {}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["CombatlogFilter"] = true,
	["combatlogFilter"] = true,
} end)

--[[L:RegisterTranslations("deDE", function() return {
    
} end)
]]
----------------------------------
--      Module Declaration      --
----------------------------------

local module = BigWigs:NewModule(L["CombatlogFilter"])
module.revision = 20014
module.defaultDB = {
}
module.consoleCmd = L["combatlogFilter"]

--[[module.consoleOptions = {
	type = "group",
	name = L["EventHandler"],
	desc = L["Reduces the terrain distance to the minimum in Naxxramas to avoid screen freezes."],
	args   = {
        active = {
			type = "toggle",
			name = L["Active"],
			desc = L["Activate the plugin."],
			order = 1,
			get = function() return BigWigsFarclip.db.profile.active end,
			set = function(v) BigWigsFarclip.db.profile.active = v end,
			--passValue = "reverse",
		}
	}
}]]

------------------------------
--      Initialization      --
------------------------------

function module:OnEnable()
    for k, event in pairs(Events) do 
        self:RegisterEvent(event, "CombatlogFilter")
    end
	--self:RegisterAllEvents("CombatlogFilter")
end

function module:AddFilter(aModuleName, aFilter, callback, addStopwatch)
	if aModuleName and type(aModuleName) == "string" 
		and aFilter and type(aFilter) == "string"
		and callback and type (callback) == "function" then
		
		if addStopwatch then
			module:AddStopwatch(aModuleName, aFilter)
		end
		
		if not filter[aModuleName] then
			filter[aModuleName] = {}
		end
		
		if not filter[aModuleName][aFilter] then
			filter[aModuleName][aFilter] = callback
		
			return true
		end
	end
	
	return false
end

function module:RemoveFilter(aModuleName, aFilter)
	if aModuleName and type(aModuleName) == "string" 
		and aFilter and type(aFilter) == "string" then
		
		if filter[aModuleName] and filter[aModuleName][aFilter] then
			filter[aModuleName][aFilter] = nil
		
			return true
		end
	end
	
	return false
end

function module:RemoveAllFilters(aModuleName)
	if aModuleName and type(aModuleName) == "string" then
		if filter[aModuleName] then
			filter[aModuleName] = nil
		
			return true
		end
	end
	
	return false
end



function module:CombatlogFilter()	
	if event and arg1 then		
		-- iterate modules
		for aModuleName, moduleFilters in filter do
			-- iterate filters
			for aFilter, callback in moduleFilters do
				if string.find(arg1, aFilter) then
					callback(self, arg1, event, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
					module:MeassureTime(aModuleName, aFilter)
				end
			end
		end		
	end
	
	--[[
	local msg = ""
	if event then msg = msg .. "e: " .. event end
	if arg1 then msg = msg .. " arg1: " .. arg1 end
	if arg2 then msg = msg .. " arg2: " .. arg2 end
	if arg3 then msg = msg .. " arg3: " .. arg3 end
	if arg4 then msg = msg .. " arg4: " .. arg4 end
	if arg5 then msg = msg .. " arg5: " .. arg5 end
	if arg6 then msg = msg .. " arg6: " .. arg6 end
	if arg7 then msg = msg .. " arg7: " .. arg7 end
	BigWigs:Print(msg)]]
end


function module:OnEngage(aModuleName)
	if aModuleName and type(aModuleName) == "string" then
		if stopwatch[aModuleName] then
			local present = GetTime()
			--stopwatch[aModuleName]["EngageTime"] = present
			
			for aFilter, v in stopwatch[aModuleName] do
				stopwatch[aModuleName][aFilter] = present
			end
		end
	end
end

function module:AddStopwatch(aModuleName, aFilter)
	if not stopwatch[aModuleName] then
		stopwatch[aModuleName] = {}
	end
	
	if not stopwatch[aModuleName][aFilter] then
		stopwatch[aModuleName][aFilter] = GetTime()
	end
end

function module:MeassureTime(aModuleName, aFilter)
	if stopwatch[aModuleName] and stopwatch[aModuleName][aFilter] then
		local past = stopwatch[aModuleName][aFilter]
		local present = GetTime()
		local difference = present - past
		
		-- throttle
		if difference > 0.5 then 
			BigWigs:DebugMessage("Stopwatch - " .. aFilter .. ": " .. difference)
			stopwatch[aModuleName][aFilter] = present
		end
	end
end