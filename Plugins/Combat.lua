
assert( BigWigs, "BigWigs not found!")

-- /run BigWigsCombat:Start()

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsCombat")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Combat"] = true
} end)

L:RegisterTranslations("deDE", function() return {

} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsCombat = BigWigs:NewModule(L["Combat"])
BigWigsCombat.revision = 20008
BigWigsCombat.defaultDB = {
	log = {}
}
--BigWigsEnrage.consoleCmd = L["enrage"]


--[[BigWigsEnrage.consoleOptions = {
	type = "group",
	name = L["Enrage"],
	desc = L["Options for the enrage plugin."],
	args   = {
		anchor = {
			type = "execute",
			name = L["Show anchor"],
			desc = L["Show the bar anchor frame."],
            order = 1,
			func = function() BigWigsEnrage:BigWigs_ShowAnchors() end,
		},
	},
}]]

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
}

local startTime = GetTime()
local combatLog = {}
local nFights = 0
local nEntries = 0
local filter = {}

------------------------------
--      Initialization      --
------------------------------

function BigWigsCombat:OnEnable()
    self:RegisterEvent("BigWigs_RecvSync")
end


------------------------------
--      Event Handlers      --
------------------------------

function BigWigsCombat:Start()
	for k, event in pairs(Events) do 
        self:RegisterEvent(event, "EventHandler")
    end
    self:RegisterEvent("PLAYER_REGEN_DISABLED", "Save")
    self:RegisterEvent("PLAYER_REGEN_ENABLED", "Save")
	
    BigWigs:Print("BigWigsCombat started")
end

function BigWigsCombat:Stop()
    for k, event in pairs(Events) do 
        self:UnregisterEvent(event)
    end
    --self:UnregisterAllEvents()    
    --self:RegisterEvent("PLAYER_REGEN_DISABLED", "Save")
    BigWigs:Print("BigWigsCombat stoped")
end

function BigWigsCombat:EventHandler()
    if event then
        if not arg1 then
            arg1 = "no msg"
        end
        
        -- Filter
        for key, value in pairs(filter) do 
            --BigWigs:Print("key: " .. key .. ", value: " .. value)
            if string.find(arg1, value) then
                BigWigs:DebugMessage(event .. ": " .. arg1) 
            end
        end
		--BigWigs:Print(event .. ": " .. arg1)
        entry = {
            ["time"] = (GetTime() - startTime),
            ["event"] = event,
            ["msg"] = arg1
        }
        nEntries = nEntries + 1
        table.insert(combatLog, nEntries, entry)
	end
end
function BigWigsCombat:Save()
    startTime = GetTime()
    nFights = nFights + 1
    table.insert(self.db.profile.log, nFights, combatLog)
    BigWigs:Print("BigWigsCombat saved")
    combatLog = {}
end
function BigWigsCombat:Clear()
    self.db.profile.log = {}
end

function BigWigsCombat:SendLog(name)
    self:Sync("BigWigsCombatSendLog " .. "mylog")
end

function BigWigsCombat:AddFilter(msg)
    if msg then
        table.insert(filter, table.getn(filter) + 1, msg) 
    end
end
function BigWigsCombat:PrintFilters()
    for key, value in pairs(filter) do 
        BigWigs:Print("key: " .. key .. ", value: " .. value) 
    end
end

------------------------------
--      Synchronisation     --
------------------------------

function BigWigsCombat:SyncStart(name)
    if name then
        self:Sync("BigWigsCombatStart " .. name)
    end
end
function BigWigsCombat:SyncStop(name)
    if name then
        self:Sync("BigWigsCombatStop " .. name)
    end
end
function BigWigsCombat:SyncClear(name)
    if name then
        self:Sync("BigWigsCombatClear " .. name)
    end
end
function BigWigsCombat:GetLog(name)
    self:Sync("BigWigsCombatGetLog " .. name)
end
function BigWigsCombat:BigWigs_RecvSync(sync, rest, nick)
	if sync == "BigWigsCombatStart" then
        if rest and rest == UnitName("player") then
            self:Start() 
        end
    elseif sync == "BigWigsCombatStop" then
        if rest and rest == UnitName("player") then
            self:Stop() 
        end
    elseif sync == "BigWigsCombatClear" then
        if rest and rest == UnitName("player") then
            self:Clear() 
        end
    elseif sync == "BigWigsCombatGetLog" then
        if rest and rest == UnitName("player") then
            self:SendLog() 
        end
    elseif sync == "BigWigsCombatSendLog" and rest then
        BigWigs:DebugMessage("BigWigsCombatSendLog: " .. rest)
	end
end
