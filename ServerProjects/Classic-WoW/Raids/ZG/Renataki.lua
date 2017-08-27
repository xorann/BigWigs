local bossName = BigWigs.bossmods.zg.renataki
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

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("UNIT_HEALTH")
	
	self:ThrottleSync(5, syncName.unvanish)
	self:ThrottleSync(5, syncName.enrage)
	self:ThrottleSync(10, syncName.enrageSoon)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.enrageannounced = nil
	module.vanished = nil
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.vanish then
		self:DelayedMessage(timer.vanishSoon, L["msg_vanishSoon"], "Urgent")
	end
	self:ScheduleRepeatingEvent("renatakivanishcheck", self.VanishCheck, 2, self)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["trigger_enrage"] then
		self:Sync(syncName.enrage)
	end
end

function module:UNIT_HEALTH(arg1)
	if UnitName(arg1) == boss then
		local health = UnitHealth(arg1)
		if health > 25 and health <= 30 and not module.enrageannounced then
			self:Sync(syncName.enrageSoon)
			module.enrageannounced = true
		elseif health > 30 and module.enrageannounced then
			module.enrageannounced = nil
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
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_enrage"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
