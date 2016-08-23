------------------------------
--      Are you local?      --
------------------------------

local boss =  AceLibrary("Babble-Boss-2.2")["Elder Mottled Boar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Elder-Mottled-Boar",

    engage_cmd = "engage", -- <name>_cmd
    engage_name = "Engage Alert", -- <name>_name
    engage_desc = "Warn for Engage", -- <name>_desc
    engage_msg = "Boar engaged! Be careful.",
            
    teleport_msg = "Teleport",        
    
    charge_cmd = "charge",
    charge_name = "Charge Alert",
    charge_desc = "Warn for Charge",
    charge_trigger = "gains Boar Charge",
    charge_msg = "Boar is charging!",
    charge_bar = "Charge",
            
    vulnerability_direct_test = "^[%w]+[%s's]* ([%w%s:]+) ([%w]+) Elder Mottled Boar for ([%d]+) ([%w]+) damage%.[%s%(]*([%d]*)",
    umlaut_test = "hits you for",
            
            
    proximity_cmd = "proximity",
    proximity_name = "Proximity Warning",
    proximity_desc = "Show Proximity Warning Frame",
     
} end )

L:RegisterTranslations("deDE", function() return {
    engage_name = "Pull Warnung",
    engage_desc = "Warnung beim Pull",
    engage_msg = "Eber gepullt! Sei vorsichtig.",
            
    teleport_msg = "Teleport",
            
    charge_name = "Ansturm Warnung",
    charge_desc = "Warnung f\195\188r anst\195\188rmen",
    charge_trigger = "gains Boar Charge", -- uebersetzung?
    charge_msg = "Eber st\195\188rmt an!",
    charge_bar = "Anst\195\188rmen",
            
    vulnerability_direct_test = "^[%w]+[%s's]* ([%w%s:]+) ([%w]+) Elder Mottled Boar for ([%d]+) ([%w]+) damage%.[%s%(]*([%d]*)",
    umlaut_test = "trifft Euch für",
            
    proximity_cmd = "proximity",
    proximity_name = "Nähe Warnungsfenster",
    proximity_desc = "Zeit das Nähe Warnungsfenster",
     
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsBoar = BigWigs:NewModule(boss)
BigWigsBoar.zonename = { 
    AceLibrary("AceLocale-2.2"):new("BigWigs")["Outdoor Raid Bosses Zone"], 
    AceLibrary("Babble-Zone-2.2")["Durotar"]
}
BigWigsBoar.enabletrigger = boss
BigWigsBoar.bossSync = "Boar"
BigWigsBoar.toggleoptions = {"engage", "charge", "proximity", "bosskill"}
BigWigsBoar.revision = tonumber(string.sub("$Revision: 13476 $", 12, -3))
BigWigsBoar.proximityCheck = function(unit) return CheckInteractDistance(unit, 3) end
BigWigsBoar.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function BigWigsBoar:OnEnable()
    --self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
    
	--self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	--self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	--self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
    --self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
    
    self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "PlayerDamageEvents")
    
    self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS", "UmlautCheck")
    
    self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
    
    self:RegisterEvent("UNIT_HEALTH")
    
    --self:RegisterEvent("BigWigs_RecvSync")
    self:RegisterEvent("BigWigs_RecvSync")
    
    --self:TriggerEvent("BigWigs_ThrottleSync", "TwinsTeleport", 28)
end

function BigWigsBoar:CheckForWipe(event)
    self:DebugMessage("BigWigsBoar:CheckForWipe()")
    BigWigs:CheckForWipe(self)
end

function BigWigsBoar:BigWigs_RecvSync( sync, rest, nick )
    self:DebugMessage("boar sync: " .. sync)
    
    if not self.started and sync == self:GetEngageSync() and rest and rest == boss then
        --self:KTM_SetTarget(boss)
        
		--if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then self:UnregisterEvent("PLAYER_REGEN_DISABLED") end
		if self.db.profile.engage then
			self:TriggerEvent("BigWigs_Message", L["engage_msg"], "Attention")
		end

        self:TriggerEvent("BigWigs_SendSync", "TwinsTeleport")
            
        BigWigsProximity:BigWigs_ShowProximity(self)
    elseif sync == "TwinsTeleport" then
        self:TriggerEvent("BigWigs_StartBar", self, L["teleport_msg"], 30, "Interface\\Icons\\Spell_Arcane_Blink")

        self:DelayedSound(20, "Ten")
        self:DelayedSound(27, "Three")
        self:DelayedSound(28, "Two")
        self:DelayedSound(29, "One")
        self:CancelScheduledEvent("TwinsTeleport")
        self:ScheduleEvent("BigWigs_SendSync", 30, "TwinsTeleport")

        self:KTM_Reset()
    end
end

function BigWigsBoar:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
    if self.db.profile.charge and string.find(arg1, L["charge_trigger"]) then        
        -- countdown
        self:Sound("Ten");
        self:DelayedSound(1, "Nine")
        self:DelayedSound(2, "Eight")
        self:DelayedSound(3, "Seven")
        self:DelayedSound(4, "Six")
        self:DelayedSound(5, "Five")
        self:DelayedSound(6, "Four")
        self:DelayedSound(7, "Three")
        self:DelayedSound(8, "Two")
        self:DelayedSound(9, "One")
        self:DelayedSound(10, "Beware")
        self:TriggerEvent("BigWigs_StartBar", self, L["charge_bar"], 10, "Interface\\Icons\\Spell_Frost_FrostShock")
    end
end

function BigWigsBoar:PlayerDamageEvents(msg)
    --DEFAULT_CHAT_FRAME:AddMessage("player damage :" .. msg)
    if not string.find(msg, "Eye of C'Thun") then
        local _, _, userspell, stype, dmg, school, partial = string.find(msg, L["vulnerability_direct_test"])
        if stype and dmg and school then
            if tonumber(dmg) > 300 then
                -- trigger weakend
                DEFAULT_CHAT_FRAME:AddMessage("C'Thun is weakened")
                self:Sound("Beware")
                self:Sound("Seven")
                --self:TriggerEvent("BigWigs_SendSync", "CThunWeakened1")
            end
        end
    end
end

function BigWigsBoar:UmlautCheck(msg) 
    if string.find(msg, L["umlaut_test"]) then
        --self:DebugMessage("umlaut test succesful")    
    else
        --self:DebugMessage("umlaut test not succesful")
    end
end

function BigWigsBoar:UNIT_HEALTH(arg1)
	if UnitName(arg1) == boss then
		local health = UnitHealth(arg1)
		--self:DebugMessage("health: " .. health)
	end
end


----------------------------------
--      Module Test Function    --
----------------------------------

function BigWigsBoar:Test()
    --[[local function sweep()
        if self.phase == "emerged" then
            BigWigsOuro:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["sweeptrigger"])
        end
    end
    local function sandblast()
        if self.phase == "emerged" then
            BigWigsOuro:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["sandblasttrigger"])
        end
    end
    local function submerge()
        if self.phase == "emerged" then
            ClearTarget()
        end
    end
    local function emerge()
        if self.phase == "submerged" then
            TargetUnit("player")
            BigWigsOuro:EmergeCheck(L["emergetrigger"])
        end
    end]]
    local function deactivate()
        self:Disable()
    end
    
    BigWigs:Print("BigWigsBoar Test started")
    BigWigs:Print("  Sweep Test after 5s")
    BigWigs:Print("  Sand Storm Test after 10s")
    BigWigs:Print("  Submerge Test after 32s")
    BigWigs:Print("  Emerge Test after 42s")
        
    -- immitate CheckForEngage
    self:Sync("StartFight "..self:ToString())
    self:SendEngageSync()    
    
    -- sweep after 5s
    local s = self:DelayedBar(2, "test", 7, "Spell_Frost_FrostShock")
    local s = self:DelayedBar(2, "test2", 7, "Spell_Frost_FrostShock")
    --self:DebugMessage("s: "..s.id.id)
    self:CancelDelayedBar("test")
end