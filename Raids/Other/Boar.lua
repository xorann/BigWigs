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
BigWigsBoar.toggleoptions = {"engage", "charge", "bosskill"}
BigWigsBoar.revision = tonumber(string.sub("$Revision: 13476 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsBoar:OnEnable()
    started = nil
    
    self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
    
	--self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	--self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	--self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
    --self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
    
    self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "PlayerDamageEvents")
    
    --self:RegisterEvent("BigWigs_RecvSync")
    self:RegisterEvent("BigWigs_RecvSync")
end

function BigWigsBoar:BigWigs_RecvSync( sync, rest, nick )
    self:DebugMessage("sync: " .. sync)
    if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
        self:KTM_SetTarget(boss)
        
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then self:UnregisterEvent("PLAYER_REGEN_DISABLED") end
		if self.db.profile.engage then
        --if true then
			self:TriggerEvent("BigWigs_Message", L["engage_msg"], "Attention")
            self:TriggerEvent("BigWigs_SendSync", "TwinsTeleport")
			--self:PossibleSubmerge()
		end
	--[[elseif sync == "OuroSweep" then
		self:Sweep()
	elseif sync == "OuroSandblast" then
		self:Sandblast()
	elseif sync == "OuroEmerge" then
		self:Emerge()
	elseif sync == "OuroSubmerge" then
		self:Submerge()--]]
	
    elseif sync == "TwinsTeleport" then
        self:TriggerEvent("BigWigs_StartBar", self, L["teleport_msg"], 30, "Interface\\Icons\\Spell_Arcane_Blink")
        
        --[[self:ScheduleEvent("teleCoundtdown10", "BigWigs_Message", 20, "", "Urgent", true, "Ten")
        self:ScheduleEvent("teleCoundtdown3", "BigWigs_Message", 27, "", "Urgent", true, "Three")
        self:ScheduleEvent("teleCoundtdown2", "BigWigs_Message", 28, "", "Urgent", true, "Two")
        self:ScheduleEvent("teleCoundtdown1", "BigWigs_Message", 29, "", "Urgent", true, "One")
        self:ScheduleEvent("teleCoundtdown0", "BigWigs_Message", 30, L["teleport_msg"], "Urgent", true, "Alarm")]]
        self:DelayedSound(20, "Ten")
        self:DelayedSound(27, "Three")
        self:DelayedSound(28, "Two")
        self:DelayedSound(29, "One")
        self:ScheduleEvent("BigWigs_SendSync", 30, "TwinsTeleport")
        
        self:KTM_Reset()
    end
end

--[[function BigWigsBoar:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.teleport and string.find(msg, L["trigger1"]) then
		self:TriggerEvent("BigWigs_Message", L["warn1"], "Important")
	end
end--]]

--[[function BigWigsBoar:CHAT_MSG_SPELL_AURA_GONE_OTHER( msg )
	if self.db.profile.shield and string.find(msg, L["trigger2"]) then
		self:TriggerEvent("BigWigs_Message", L["warn2"], "Attention")
	end
end--]]

function BigWigsBoar:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
    if self.db.profile.charge and string.find(arg1, L["charge_trigger"]) then
        self:DebugMessage("charge")
        --self:TriggerEvent("BigWigs_Message", L["charge_msg"], "Urgent")
        --self:TriggerEvent("BigWigs_Message", "", "Urgent", true, "One")
        
        -- countdown
        --[[self:TriggerEvent("BigWigs_Message", L["charge_msg"], "Urgent", true, "Ten")
        self:ScheduleEvent("coundtdown9", "BigWigs_Message", 1, "", "Urgent", true, "Nine")
        self:ScheduleEvent("coundtdown8", "BigWigs_Message", 2, "", "Urgent", true, "Eight")
        self:ScheduleEvent("coundtdown7", "BigWigs_Message", 3, "", "Urgent", true, "Seven")
        self:ScheduleEvent("coundtdown6", "BigWigs_Message", 4, "", "Urgent", true, "Six")
        self:ScheduleEvent("coundtdown5", "BigWigs_Message", 5, "", "Urgent", true, "Five")
        self:ScheduleEvent("coundtdown4", "BigWigs_Message", 6, "", "Urgent", true, "Four")
        self:ScheduleEvent("coundtdown3", "BigWigs_Message", 7, "", "Urgent", true, "Three")
        self:ScheduleEvent("coundtdown2", "BigWigs_Message", 8, "", "Urgent", true, "Two")
        self:ScheduleEvent("coundtdown1", "BigWigs_Message", 9, "", "Urgent", true, "One")
        self:ScheduleEvent("coundtdown0", "BigWigs_Message", 10, "Alarm", "Urgent", true, "Beware")
        ]]
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
    
	--[[if self.db.profile.shield and string.find(arg1, L["trigger3"]) then
		self:TriggerEvent("BigWigs_Message", L["warn3"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["shieldbar"], 10, "Interface\\Icons\\Spell_Frost_FrostShock")
	end--]]
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