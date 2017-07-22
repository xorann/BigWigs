local bossName = BigWigs.bossmods.aq40.cthun
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

-- override timers if necessary
--timer.berserk = 300


------------------------------
-- Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "Emote")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE", "Emote")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CheckEyeBeam")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "CheckTentacleSpawn")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "CheckTentacleSpawn")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckDigestiveAcid")

	self:ThrottleSync(20, syncName.p2Start)
	self:ThrottleSync(50, syncName.weaken)
	self:ThrottleSync(3, syncName.giantEyeDown)
	self:ThrottleSync(600, syncName.weakenOver)
	self:ThrottleSync(30, syncName.giantClawSpawn)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

	module.cthunstarted = nil
	module.firstGlare = nil
	module.phase2started = nil
	module.doCheckForWipe = false

	timer.tentacleParty = timer.p1Tentacle

	self:RemoveProximity()
end

-- called after boss is engaged
function module:OnEngage()
	self:CThunStart()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
	self:RemoveFleshTentacle()
end


----------------------
-- Event Handlers  --
----------------------
function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	BigWigs:CheckForBossDeath(msg, self)

	if (msg == string.format(UNITDIESOTHER, module.eyeofcthun)) then
		self:Sync(syncName.p2Start)
	elseif (msg == string.format(UNITDIESOTHER, L["misc_gianteye"])) then
		self:Sync(syncName.giantEyeDown)
	elseif msg == string.format(UNITDIESOTHER, L["misc_fleshTentacle"]) then
		self:Sync(syncName.fleshTentacleDeath)
	end
end

function module:CheckForWipe(event)
	if module.doCheckForWipe then
		BigWigs:CheckForWipe(self)
	end
end

function module:Emote(msg)
	if string.find(msg, L["trigger_weakened"]) then
		self:Sync(syncName.weaken)
	end
end

function module:CheckEyeBeam(msg)
	if string.find(msg, L["trigger_eyeBeamGiantEye"]) then
		self:Sync(syncName.giantEyeEyeBeam)
	elseif string.find(msg, L["trigger_eyeBeamCthun"]) then
		self:Sync(syncName.cthunEyeBeam)
		if not module.cthunstarted then
			self:SendEngageSync()
		end
	end
end

function module:CheckTentacleSpawn(msg)
	if string.find(msg, L["trigger_giantClawSpawn"]) then
		self:Sync(syncName.giantClawSpawn)
	elseif string.find(msg, L["trigger_giantEyeSpawn"]) then
		self:Sync(syncName.giantEyeSpawn)
	elseif string.find(msg, L["trigger_tentacleParty"]) then
		self:Sync(syncName.tentaleParty)
	end
end

function module:CheckDigestiveAcid(msg)
	local _, _, stacks = string.find(msg, L["trigger_digestiveAcid"])

	if stacks then
		if tonumber(stacks) == 5 then
			self:DigestiveAcid()
		end
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
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(string.format(UNITDIESOTHER, module.eyeofcthun))
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(string.format(UNITDIESOTHER, L["misc_gianteye"]))
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(string.format(UNITDIESOTHER, L["misc_fleshTentacle"]))
	module:CheckForWipe()
	module:Emote(L["trigger_weakened"])
	module:CheckEyeBeam(L["trigger_eyeBeamGiantEye"])
	module:CheckEyeBeam(L["trigger_eyeBeamCthun"])
	module:CheckTentacleSpawn(L["trigger_giantClawSpawn"])
	module:CheckTentacleSpawn(L["trigger_giantEyeSpawn"])
	module:CheckTentacleSpawn(L["trigger_tentacleParty"])
	module:CheckDigestiveAcid(L["trigger_digestiveAcid"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
