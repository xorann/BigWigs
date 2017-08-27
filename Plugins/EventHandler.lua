--[[
    by Dorann
--]]


assert( BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------
local L = AceLibrary("AceLocale-2.2"):new("BigWigsEventHandler")

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
	"SPELLCAST_CHANNEL_START",
	"SPELLCAST_STOP",
	"SPELLCAST_FAILED",
	"SPELLCAST_INTERRUPTED",

	"SPELLS_CHANGED", 

	--"UNIT_AURA",
	"UNIT_AURASTATE",
	"UNIT_SPELLMISS",
	
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_EMOTE",
	"CHAT_MSG_MONSTER_YELL",
}

local filter = {}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["EventHandler"] = true,
	["eventHandler"] = true,
} end)

--[[L:RegisterTranslations("deDE", function() return {
    
} end)
]]
----------------------------------
--      Module Declaration      --
----------------------------------

local module = BigWigs:NewModule(L["EventHandler"])
module.revision = 20014
module.defaultDB = {
}
module.consoleCmd = L["eventHandler"]

module.consoleOptions = {
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
}

------------------------------
--      Initialization      --
------------------------------

function module:OnEnable()
    for k, event in pairs(Events) do 
        self:RegisterEvent(event, "EventHandler")
    end
end

function module:AddFilter(aModuleName, filter, callback)
	if aModuleName and type(aModuleName) == "string" 
		and filter and type(filter) == "string"
		and callback and type (callback) == "function" then
		
		if not filter[aModuleName] then
			filter[aModuleName] = {}
		end
		
		if not filter[aModuleName][filter] then
			filter[aModuleName][filter] = callback
		
			return true
		end
	end
	
	return false
end

function module:RemoveFilter(aModuleName, filter)
	if aModuleName and type(aModuleName) == "string" 
		and filter and type(filter) == "string" then
		
		if filter[aModuleName] and filter[aModuleName][filter] then
			filter[aModuleName][filter] = nil
		
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



function module:EventHandler()
	if event and arg1 then		
		-- iterate modules
		for aModuleName, moduleFilters in filter do
			-- iterate filters
			for filter, callback in moduleFilters do
				if string.find(arg1, filter) then
					callback(arg1, event)
				end
			end
		end		
	end
end
