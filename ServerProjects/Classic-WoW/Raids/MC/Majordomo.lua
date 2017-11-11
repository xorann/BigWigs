local bossName = BigWigs.bossmods.mc.majordomo
local serverProjectName = "Classic-WoW"
if not BigWigs:IsServerRegisteredForServerProject(serverProjectName) or not BigWigs:IsBossSupportedByServerProject(bossName, serverProjectName) then
	return
end


--BigWigs:Print("classic-wow " .. bossName)


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

module:RegisterYellEngage(L["trigger_engage"])

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	
	self:ThrottleSync(2, syncName.dmg)
	self:ThrottleSync(2, syncName.magic)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	
	self.healerDead = 0
	self.eliteDead = 0
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.magic or self.db.profile.dmg then
		self:Bar(L["bar_nextShield"], timer.firstShield, icon.shield)
		self:DelayedMessage(timer.firstShield - 5, L["msg_shieldSoon"], "Urgent", nil, nil, true)
	end
	
	--self:TriggerEvent("BigWigs_StartCounterBar", self, "Priests dead", 4, "Interface\\Icons\\Spell_Holy_BlessedRecovery")
	--self:TriggerEvent("BigWigs_SetCounterBar", self, "Priests dead", (4 - 0.1))
	--self:TriggerEvent("BigWigs_StartCounterBar", self, "Elites dead", 4, "Interface\\Icons\\Ability_Hunter_Harass")
	--self:TriggerEvent("BigWigs_SetCounterBar", self, "Elites dead", (4 - 0.1))
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["trigger_victory"]) then
		self:SendBossDeathSync()
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if string.find(msg, L["trigger_magic"]) then
		self:Sync(syncName.magic)
	elseif string.find(msg, L["trigger_dmg"]) then
		self:Sync(syncName.dmg)
	end
end

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	BigWigs:CheckForBossDeath(msg, self)
	
	if string.find(msg, L["trigger_healerDeath"]) then
		self:Sync(syncName.healerDead .. " " .. tostring(self.healerDead + 1))
	elseif string.find(msg, L["trigger_eliteDeath"]) then
        self:Sync(syncName.eliteDead .. " " .. tostring(self.eliteDead + 1))
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
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_magic"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_dmg"])
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(L["trigger_healerDeath"])
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(L["trigger_eliteDeath"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_victory"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
