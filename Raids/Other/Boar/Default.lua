local bossName = BigWigs.bossmods.other.boar
if BigWigs:IsBossSupportedByAnyServerProject(bossName) then
	return
end
-- no implementation found => use default implementation
--BigWigs:Print("default " .. bossName)


------------------------------
-- Variables     			--
------------------------------

local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]
local timer = module.timer
local icon = module.icon
local syncName = module.syncName

-- module variables
module.revision = 20014 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300

-- Proximity Plugin
module.proximityCheck = function(unit) return CheckInteractDistance(unit, 3) end
module.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")

    self:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS", "PlayerDamageEvents")
    self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "PlayerDamageEvents")
    
    self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS", "UmlautCheck")

    self:RegisterEvent("UNIT_HEALTH")
    
end

-- called after module is enabled and after each wipe
function module:OnSetup()    
    self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH") -- CHAT_MSG_COMBAT_HOSTILE_DEATH is registered in the SetupModule function for the CheckBossDeath function. To make sure we are overriding it, we have to register the event in the OnSetup function of the module and add the CheckBossDeath functionality there.
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.engage then
		self:Message(L["msg_engage"], "Attention")
	end

	self:Sync("TwinsTeleport")
    self:TriggerEvent("BigWigs_Enrage", 30, self.translatedName)
		
	self:Proximity()
    
    BigWigsEnrage:Start(20, self.translatedName)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
    self:RemoveProximity()
    BigWigsEnrage:Stop()
end


------------------------------
--      Event Handlers      --
------------------------------

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
    BigWigs:CheckForBossDeath(msg, self)
    BigWigs:Print("hostile death: " .. msg) 
end

function module:CheckForWipe(event)
    self:DebugMessage("BigWigsBoar:CheckForWipe()")
    BigWigs:CheckForWipe(self)
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
    if self.db.profile.charge and string.find(arg1, L["trigger_charge"]) then        
        -- countdown
        self:Sound("Ten");
        self:DelayedSound(timer.charge - 9, "Nine")
        self:DelayedSound(timer.charge - 8, "Eight")
        self:DelayedSound(timer.charge - 7, "Seven")
        self:DelayedSound(timer.charge - 6, "Six")
        self:DelayedSound(timer.charge - 5, "Five")
        self:DelayedSound(timer.charge - 4, "Four")
        self:DelayedSound(timer.charge - 3, "Three")
        self:DelayedSound(timer.charge - 2, "Two")
        self:DelayedSound(timer.charge - 1, "One")
        self:DelayedSound(timer.charge, "Beware")
		self:Bar(L["bar_charge"], timer.charge, icon.charge)
    end
end

function module:PlayerDamageEvents(msg)
    if not string.find(msg, "Eye of C'Thun") then
        local _, _, userspell, stype, dmg, school, partial = string.find(msg, L["trigger_vulnerability"])
        --if GetLocale() == "deDE" then
		--	if string.find(stype, L["crit"]) then stype = L["crit"] else stype = L["hit"] end
		--	school = string.gsub(school, "schaden", "")
		--end
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

function module:UmlautCheck(msg) 
    if string.find(msg, L["trigger_umlaut"]) then
        --self:DebugMessage("umlaut test succesful")    
    else
        --self:DebugMessage("umlaut test not succesful")
    end
end

function module:UNIT_HEALTH(arg1)
	if UnitName(arg1) == boss then
		local health = UnitHealth(arg1)
		--self:DebugMessage("health: " .. health)
	end
end

-- /run local m=BigWigs:GetModule("Elder Mottled Boar");m:RaidIconTest()
function module:RaidIconTest()
	self:Icon("Dorann")
	self:DelayedSync(0.5, "BigWigsRaidIconTest")
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModule()
	module:OnEnable()
	module:OnSetup()
	module:OnEngage()

	module:TestModuleCore()

	-- check event handlers
	module:CHAT_MSG_MONSTER_YELL(L["trigger_teleport"])
	module:CHAT_MSG_SPELL_AURA_GONE_OTHER(L["trigger_shieldGone"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_shieldGain"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
