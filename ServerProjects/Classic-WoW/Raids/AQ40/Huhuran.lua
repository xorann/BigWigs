local bossName = BigWigs.bossmods.aq40.huhuran
local serverProjectName = "Classic-WoW"
if not BigWigs:IsServerRegisteredForServerProject(serverProjectName) or not BigWigs:IsBossSupportedByServerProject(bossName, serverProjectName) then
	return
end

--BigWigs:Print("classic-wow " .. bossName)


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
timer.berserk = 300
timer.sting = {
	min = 15,
	max = 20
}
timer.frenzy = 10

module.berserkannounced = false


------------------------------
-- Initialization      		--
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "StingCheck")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "StingCheck")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "StingCheck")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "FrenzyCheck")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "FrenzyCheck")

	self:ThrottleSync(5, syncName.sting)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.berserkannounced = false
end

-- called after boss is engaged
function module:OnEngage()
	self:WarnForBerserk()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
-- Event Handlers      		--
------------------------------
function module:FrenzyCheck(msg)
	if msg == L["trigger_frenzyGain"] then
		self:Sync(syncName.frenzy)
	elseif msg == L["trigger_frenzyGone"] then
		self:Sync(syncName.frenzyOver)
	end
end

function module:CHAT_MSG_MONSTER_EMOTE(arg1)
	if arg1 == L["trigger_berserk"] then
		self:Sync(syncName.berserk)
	end
end

function module:UNIT_HEALTH(arg1)
	if UnitName(arg1) == module.translatedName then
		local health = UnitHealth(arg1) / UnitHealthMax(arg1)
		if health > 30 and health <= 33 and not module.berserkannounced then
			self:Sync(syncName.berserkSoon)
		end
	end
end

function module:StingCheck(arg1)
	if string.find(arg1, L["trigger_sting"]) then
		self:Sync(syncName.sting)
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
	module:FrenzyCheck(L["trigger_frenzyGain"])
	module:FrenzyCheck(L["trigger_frenzyGone"])
	module:CHAT_MSG_MONSTER_EMOTE(L["trigger_berserk"])
	module:UNIT_HEALTH("player")
	module:StingCheck(L["trigger_sting"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
