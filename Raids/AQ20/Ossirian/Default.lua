local bossName = BigWigs.bossmods.aq20.ossirian
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
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	
	self:ThrottleSync(3, syncName.weakness)
	self:ThrottleSync(3, syncName.crystal)
	self:ThrottleSync(3, syncName.supreme)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.timeLastWeaken = GetTime()
    self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
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
function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	BigWigs:CheckForBossDeath(msg, self)
	
	-- if the same weakness triggers back to back, the normal combat log entry is missing for the weakness
	-- this event is triggered 2s later
	if string.find(msg, L["trigger_crystal"]) then
		self:Sync(syncName.crystal)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE( msg )
	local _, _, debuffName = string.find(msg, L["trigger_debuff"])
	if debuffName and debuffName ~= L["trigger_expose"] and L:HasReverseTranslation(debuffName) then
		self:Sync(syncName.weakness .. " " .. L:GetReverseTranslation(debuffName))
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if string.find(msg, L["trigger_supreme"]) then
		self:Sync(syncName.supreme)
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
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(L["trigger_crystal"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(L["trigger_debuff"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_supreme"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
