local bossName = BigWigs.bossmods.mc.sulfuron
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


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Events")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Events")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Events")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	
	self:ThrottleSync(1, syncName.heal)
    self:ThrottleSync(5, syncName.knockback)
    self:ThrottleSync(5, syncName.flame_spear)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	
    module.deadpriests = 0
end

-- called after boss is engaged
function module:OnEngage()
    if self.db.profile.knockback then
        self:Bar(L["bar_knockback"], timer.firstKnockback, icon.knockback)
        self:DelayedMessage(timer.firstKnockback - 3, L["msg_knockbackSoon"], "Urgent")
    end
    --self:TriggerEvent("BigWigs_StartCounterBar", self, "Priests dead", 4, "Interface\\Icons\\Spell_Holy_BlessedRecovery")
    --self:TriggerEvent("BigWigs_SetCounterBar", self, "Priests dead", (4 - 0.1))
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	BigWigs:CheckForBossDeath(msg, self)
	
	if string.find(msg, L["trigger_addDeath"]) then
		self:Sync(syncName.add_dead .. " " .. tostring(module.deadpriests + 1))
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if string.find(msg, L["trigger_heal"]) then
		self:Sync(syncName.heal)
	end
end

function module:Events(msg)
	if (string.find(msg, L["trigger_knockbackHit1"]) or string.find(msg, L["trigger_knockbackHit2"]) or string.find(msg, L["trigger_knockbackResist"]) or string.find(msg, L["trigger_knockbackAbsorb1"]) or string.find(msg, L["trigger_knockbackAbsorb2"]) or string.find(msg, L["trigger_knockbackImmune"])) then
		self:Sync(syncName.knockback)
    elseif string.find(msg, L["trigger_spear"]) then
        self:Sync(syncName.flame_spear)
	end
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
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(L["trigger_addDeath"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(L["trigger_heal"])
	module:Events(L["trigger_knockbackHit1"])
	module:Events(L["trigger_knockbackHit2"])
	module:Events(L["trigger_knockbackResist"])
	module:Events(L["trigger_knockbackAbsorb1"])
	module:Events(L["trigger_knockbackAbsorb2"])
	module:Events(L["trigger_knockbackImmune"])
	module:Events(L["trigger_spear"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
