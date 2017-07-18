local bossName = BigWigs.bossmods.bwl.vaelastrasz
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


------------------------------
-- Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:ThrottleSync(2, syncName.adrenaline)
	self:ThrottleSync(3, syncName.flamebreath)
	self:ThrottleSync(5, syncName.tankburn)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
	self.barstarted = false
end

-- called after boss is engaged
function module:OnEngage()
	self:Tankburn()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
-- Event Handlers      		--
------------------------------
function module:CheckForEngage()
	local function IsHostile()
		if UnitExists("target") and UnitName("target") == self:ToString() and UnitIsEnemy("player", "target") then
			return true
		end

		local num = GetNumRaidMembers()
		for i = 1, num do
			local raidUnit = string.format("raid%starget", i)
			if UnitExists(raidUnit) and UnitName(raidUnit) == self:ToString() and UnitIsEnemy("raid" .. i, raidUnit) then
				return true
			end
		end

		return false
	end

	if IsHostile() then
		BigWigs:CheckForEngage(self)
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["trigger_flamebreath"] then
		self:Sync(syncName.flamebreath)
	end
end

function module:CHAT_MSG_COMBAT_FRIENDLY_DEATH(msg)
	BigWigs:CheckForWipe(self)

	local _, _, deathother = string.find(msg, L["trigger_deathOther"])
	if msg == L["trigger_deathYou"] then
		module:PlayerDeath(UnitName("player"))
	elseif deathother then
		module:PlayerDeath(deathother)
	end
end

function module:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["trigger_yell1"]) then
		self:StartSoon(timer.start1)
	elseif string.find(msg, L["trigger_yell2"]) then
		self:StartSoon(timer.start2)
	elseif string.find(msg, L["trigger_yell3"]) then
		self:StartSoon(timer.start3)
	end
end

function module:Event(msg)
	local _, _, name, detect = string.find(msg, L["trigger_adrenaline"])
	if name and detect then
		if detect == L["misc_are"] then
			name = UnitName("player")
		end
		self:Sync(syncName.adrenaline .. " " .. name)
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
	module:CheckForEngage()
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_flamebreath"])
	module:CHAT_MSG_COMBAT_FRIENDLY_DEATH(L["trigger_deathOther"])
	module:CHAT_MSG_COMBAT_FRIENDLY_DEATH(L["trigger_deathYou"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_yell1"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_yell2"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_yell3"])
	module:Event(L["trigger_adrenaline"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
