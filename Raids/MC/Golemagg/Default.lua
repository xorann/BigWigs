local bossName = BigWigs.bossmods.mc.golemagg
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
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("UNIT_HEALTH")
	
	self:ThrottleSync(10, syncName.earthquake)
	self:ThrottleSync(10, syncName.enrage)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.earthquakeon = nil
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
function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if string.find(msg, L["trigger_enrage"]) then
		self:Sync(syncName.enrage)
	end
end

function module:UNIT_HEALTH(arg1)
	if UnitName(arg1) == boss then
		local health = UnitHealth(arg1)
		if health > 15 and health <= 20 and not module.earthquakeon then
			self:Sync(syncName.earthquake)
			module.earthquakeon = true
		elseif health > 20 and earthquakeon then
			module.earthquakeon = nil
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
	module:UNIT_HEALTH("player")
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
