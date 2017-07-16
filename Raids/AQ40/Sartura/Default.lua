local bossName = BigWigs.bossmods.aq40.sartura
if BigWigs:IsBossSupportedByAnyServerProject(bossName) then
	return
end
-- no implementation found => use default implementation
--BigWigs:Print("default " .. bossName)

------------------------------
-- Variables     			--
------------------------------

local module = BigWigs:GetModule(bossName)
local L = BigWigs.i18n[bossName]
local timer = module.timer
local icon = module.icon
local syncName = module.syncName

-- module variables
module.revision = 20013 -- To be overridden by the module!

-- timers should be overridden
timer.berserk = 600
timer.firstWhirlwind = 20.3
timer.whirlwind = 15
timer.nextWhirlwind = {
	min = 25,
	max = 30
}


------------------------------
-- Initialization      		--
------------------------------

module:RegisterYellEngage(L["trigger_start"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")

	self:ThrottleSync(3, syncName.whirlwind)
	self:ThrottleSync(3, syncName.whirlwindOver)
	self:ThrottleSync(5, syncName.enrage)
	self:ThrottleSync(5, syncName.berserk)
	self:ThrottleSync(2, syncName.add)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.guard = 0

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.berserk then
		self:Bar(L["bar_berserk"], timer.berserk, icon.berserk)
		self:DelayedMessage(timer.berserk - 5 * 60, L["msg_berserk5m"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.berserk - 3 * 60, L["msg_berserk3m"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.berserk - 90, L["msg_berserk90"], "Urgent", nil, nil, true)
		self:DelayedMessage(timer.berserk - 60, L["msg_berserk60"], "Urgent", nil, nil, true)
		self:DelayedMessage(timer.berserk - 30, L["msg_berserk30"], "Important", nil, nil, true)
		self:DelayedMessage(timer.berserk - 10, L["msg_berserk10"], "Important", nil, nil, true)
	end
	if self.db.profile.whirlwind then
		self:Bar(L["bar_firstWhirlwind"], timer.firstWhirlwind, icon.whirlwind)
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
-- Event Handlers      		--
------------------------------
function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["trigger_whirlwindGain"] then
		self:Sync(syncName.whirlwind)
	elseif msg == L["trigger_enrage2"] then
		self:Sync(syncName.enrage)
	elseif msg == L["trigger_enrage"] then
		self:Sync(syncName.berserk)
	end
end

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	BigWigs:CheckForBossDeath(msg, self)

	if msg == L["trigger_addDeath"] then
		self:Sync(syncName.add)
	end
end

function module:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, L["trigger_enrageEmote"]) then
		self:Sync(syncName.enrage)
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if msg == L["trigger_whirlwindGone"] then
		self:Sync(syncName.whirlwindOver)
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

	-- check trigger functions
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_whirlwindGain"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_enrage2"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_enrage"])
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(L["trigger_addDeath"])
	module:CHAT_MSG_MONSTER_EMOTE(L["trigger_enrageEmote"])
	module:CHAT_MSG_SPELL_AURA_GONE_OTHER(L["trigger_whirlwindGone"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
