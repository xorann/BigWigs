local bossName = BigWigs.bossmods.onyxia.onyxia
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

-- override timers if necessary
--timer.berserk = 300


------------------------------
-- Initialization      --
------------------------------

module:RegisterYellEngage(L["trigger_engage"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")

	self:ThrottleSync(10, syncName.deepbreath)
	self:ThrottleSync(10, syncName.phase2)
	self:ThrottleSync(10, syncName.phase3)
	self:ThrottleSync(5, syncName.flamebreath)
	self:ThrottleSync(2, syncName.fireball)
	self:ThrottleSync(5, syncName.fear)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.transitioned = false
	module.phase = 0
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.phase and not self.started then
		self:Message(L["msg_phase1"], "Attention")
	end
	module.phase = 1
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end

------------------------------
-- Event Handlers      --
------------------------------
function module:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if string.find(msg, L["trigger_deepBreath"]) then
		self:Sync(syncName.deepbreath)
	end
end

function module:CHAT_MSG_MONSTER_YELL(msg)
	if (string.find(msg, L["trigger_phase2"])) then
		self:Sync(syncName.phase2)
	elseif (string.find(msg, L["trigger_phase3"])) then
		self:Sync(syncName.phase3)
	end
end

function module:UNIT_HEALTH(arg1) --temporary workaround until Phase2 yell gets fixed
	if UnitName(arg1) == boss then
		local health = UnitHealth(arg1)
		if health > 60 and health <= 65 and not module.transitioned then
			self:Sync(syncName.phase2)
		elseif health > 65 then
			module.transitioned = false
		end
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["trigger_fear"] then
		self:Sync(syncName.fear)
	elseif msg == L["trigger_flameBreath"] then
		self:Sync(syncName.flamebreath)
	elseif msg == L["trigger_wingBuffet"] and self.db.profile.wingbuffet then -- made local because 1s cast, with sync it would not be very accurate
		self:Bar(L["bar_wingBuffet"], timer.wingbuffet, icon.wingbuffet, true, BigWigsColors.db.profile.significant)
	elseif msg == L["trigger_fireball"] then
		self:Sync(syncName.fireball)
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
	if string.find(msg, L["trigger_fearGone"]) then
		self:RemoveWarningSign(icon.fear)
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
	module:CHAT_MSG_RAID_BOSS_EMOTE(L["trigger_deepBreath"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_phase2"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_phase3"])
	module:UNIT_HEALTH("player")
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_fear"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_flameBreath"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_wingBuffet"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_fireball"])
	module:CHAT_MSG_SPELL_AURA_GONE_SELF(L["trigger_fearGone"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
