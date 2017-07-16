local bossName = BigWigs.bossmods.aq40.skeram
local serverProjectName = "Classic-WoW"
if not BigWigs:IsServerRegisteredForServerProject(serverProjectName) or not BigWigs:IsBossSupportedByServerProject(bossName, serverProjectName) then
	return
end

--BigWigs:Print("classic-wow skeram")


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

	self:ThrottleSync(1, syncName.mc)
	self:ThrottleSync(1, syncName.mcOver)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
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


----------------------------------
-- 		Module Test Function    --
----------------------------------

-- automated test
function module:TestModule()
	module:OnEnable()
	module:OnSetup()
	module:OnEngage()

	module:TestModuleCore()

	-- check trigger functions
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
