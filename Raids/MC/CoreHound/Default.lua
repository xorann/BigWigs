local bossName = BigWigs.bossmods.mc.coreHound
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

local t = nil

------------------------------
-- Initialization      		--
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Ability")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Ability")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Ability")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Ability")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Ability")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Ability")
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.bars then
		self:Bar(L["bar_unknown"], timer.firstAbility, icon.ability)
	end
	
	t = GetTime()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
	
end


------------------------------
-- Event Handlers      		--
------------------------------
function module:Ability(msg)
	for ability, translatedAbility in pairs(module.abilityTable) do
		local hit = string.format(L["trigger_hit"], translatedAbility)
		local immune = string.format(L["trigger_immune"], translatedAbility)
		local resist = string.format(L["trigger_resist"], translatedAbility)
		
		if ((string.find(msg, hit)) or (string.find(msg, immune)) or (string.find(msg, resist))) then
			self:Sync(syncName.ability .. " " .. ability)
			
			if (GetTime() - t) > 1 then
				self.core:DebugMessage(ability .. " interval: " .. GetTime() - t)
				t = GetTime()
			end
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
	module:Ability(string.format(L["trigger_hit"], L["misc_dread"]))
	module:Ability(string.format(L["trigger_immune"], L["misc_dispair"]))
	module:Ability(string.format(L["trigger_resist"], L["misc_stomp"]))

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
