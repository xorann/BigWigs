
local bossName = BigWigs.bossmods.aq40.skeram
if BigWigs:IsBossSupportedByAnyServerProject(bossName) then
	return
end
-- no implementation found => use default implementation
--BigWigs:Print("default skeram")

------------------------------
--      Variables     		--
------------------------------

local module = BigWigs:GetModule(bossName)
local L = BigWigs.i18n[bossName]
local timer = module.timer
local icon = module.icon
local syncName = module.syncName

-- module variables
module.revision = 20013 -- To be overridden by the module!

-- timers should be overridden
timer.mc = 20


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
	--self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH", "Event")
	self:RegisterEvent("UNIT_HEALTH")


	self:ThrottleSync(1, syncName.mc)
	self:ThrottleSync(1, syncName.mcOver)

	self:ThrottleSync(100, syncName.split80)
	self:ThrottleSync(100, syncName.split75)
	self:ThrottleSync(100, syncName.split55)
	self:ThrottleSync(100, syncName.split50)
	self:ThrottleSync(100, syncName.split30)
	self:ThrottleSync(100, syncName.split25)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.splittime = false
end

-- called after boss is engaged
function module:OnEngage()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

-- override
function module:CheckForBossDeath(msg)
	if msg == string.format(UNITDIESOTHER, self:ToString())
			or msg == string.format(L["You have slain %s!"], self.translatedName) then
		-- check that it wasn't only a copy
		local function IsBossInCombat()
			local t = module.enabletrigger
			if not t then return false end
			if type(t) == "string" then t = {t} end

			if UnitExists("target") and UnitAffectingCombat("target") then
				local target = UnitName("target")
				for _, mob in pairs(t) do
					if target == mob then
						return true
					end
				end
			end

			local num = GetNumRaidMembers()
			for i = 1, num do
				local raidUnit = string.format("raid%starget", i)
				if UnitExists(raidUnit) and UnitAffectingCombat(raidUnit) then
					local target = UnitName(raidUnit)
					for _, mob in pairs(t) do
						if target == mob then
							return true
						end
					end
				end
			end
			return false
		end

		if not IsBossInCombat() then
			self:SendBossDeathSync()
		end
	end
end

function module:Event(msg)
	local _,_, mindcontrolother, mctype = string.find(msg, L["trigger_mcGainOther"])
	local _,_, mindcontrolotherend, mctype = string.find(msg, L["trigger_mcOtherGone"])
	local _,_, mindcontrolotherdeath,mctype = string.find(msg, L["trigger_deathOther"])
	if string.find(msg, L["trigger_mcGainPlayer"]) then
		self:Sync(syncName.mc .. " " .. UnitName("player"))
	elseif string.find(msg, L["trigger_mcPlayerGone"]) then
		self:Sync(syncName.mcOver .. " " .. UnitName("player"))
	elseif string.find(msg, L["trigger_deathPlayer"]) then
		self:Sync(syncName.mcOver .. " " .. UnitName("player"))
	elseif mindcontrolother then
		self:Sync(syncName.mc .. " " .. mindcontrolother)
	elseif mindcontrolotherend then
		self:Sync(syncName.mcOver .. " " .. mindcontrolotherend)
	elseif mindcontrolotherdeath then
		self:Sync(syncName.mcOver .. " " .. mindcontrolotherdeath)
	end
end

function module:UNIT_HEALTH(arg1)
	if UnitName(arg1) == boss then
		local health = UnitHealth(arg1)
		local maxhealth = UnitHealthMax(arg1)
		if (health > 424782 and health <= 453100) and maxhealth == 566375 and not module.splittime then
			self:Sync("SkeramSplit80Soon")
		elseif (health > 283188 and health <= 311507) and maxhealth == 566375 and not module.splittime then
			self:Sync("SkeramSplit55Soon")
		elseif (health > 141594 and health <= 169913) and maxhealth == 566375 and not module.splittime then
			self:Sync("SkeramSplit30Soon")
		elseif (health > 311508 and health <= 424781) and maxhealth == 566375 and module.splittime then
			self:Sync("SkeramSplit75Now")
		elseif (health > 169914 and health <= 283187) and maxhealth == 566375 and module.splittime then
			self:Sync("SkeramSplit50Now")
		elseif (health > 1 and health <= 141593) and maxhealth == 566375 and module.splittime then
			self:Sync("SkeramSplit25Now")
		end
	end
end



----------------------------------
-- 		Module Test Function    --
----------------------------------

-- automated test
function module:TestModule()
	module:OnEnable()
	module:OnSetup()
	module:OnEngage()

	module:TestModuleCore()

	-- check event handlers
	module:CheckForBossDeath(string.format(UNITDIESOTHER, module.translatedName))
	module:Event(L["trigger_mcGainOther"])
	module:Event(L["trigger_mcOtherGone"])
	module:Event(L["trigger_deathOther"])
	module:Event(L["trigger_mcGainPlayer"])
	module:Event(L["trigger_mcPlayerGone"])
	module:Event(L["trigger_deathPlayer"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
