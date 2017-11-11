local bossName = BigWigs.bossmods.zg.gurubashiBerserker
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
	self:CombatlogFilter(L["trigger_fearHit"], self.FearEvent)
	self:CombatlogFilter(L["trigger_fearImmune"], self.FearEvent)
	self:CombatlogFilter(L["trigger_fearResist"], self.FearEvent)
	
	self:CombatlogFilter(L["trigger_knockback"], self.KnockbackEvent)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.fear then
		self:Bar(L["bar_fear"], timer.firstFear, icon.fear)
	end
	
	if self.db.profile.knockback then
		self:Bar(L["bar_knockback"], timer.firstKnockack, icon.knockback)
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:FearEvent(event, msg)
	self:Sync(syncName.fear)
end

function module:KnockbackEvent(event, msg)
	self:Sync(syncName.knockback)
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
	module:FearEvent()
	module:KnockbackEvent()
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
