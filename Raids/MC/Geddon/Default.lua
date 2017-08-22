local bossName = BigWigs.bossmods.mc.geddon
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
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
	--self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH", "Event")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	
	self:ThrottleSync(5, syncName.bomb)
	self:ThrottleSync(3, syncName.bombStop)
	self:ThrottleSync(4, syncName.service)
	self:ThrottleSync(4, syncName.ignite)
	self:ThrottleSync(29, syncName.inferno)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.firstinferno = true
	self.firstignite = true
end

-- called after boss is engaged
function module:OnEngage()
	self:Inferno()
	self:ManaIgnite()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:Event(msg)
	local _,_, bombother, mcverb = string.find(msg, L["trigger_bombOther"])
	local _,_, bombotherend, mcverb = string.find(msg, L["trigger_bombOtherGone"])
	local _,_, bombotherdeath,mctype = string.find(msg, L["trigger_deathOther"])
	
	if string.find(msg, L["trigger_bombYou"]) then
		self:Sync(syncName.bomb .. " " .. UnitName("player"))
	elseif string.find(msg, L["trigger_bombYouGone"]) then
		self:Sync(syncName.bombStop .. " " .. UnitName("player"))
	elseif string.find(msg, L["trigger_deathYou"]) then
		self:Sync(syncName.bombStop .. " " .. UnitName("player"))
	elseif bombother then
		self:Sync(syncName.bomb .. " " .. bombother)
	elseif bombotherend then
		self:Sync(syncName.bombStop .. " " .. bombotherend)
	elseif string.find(msg, L["trigger_deathOther"]) then		
		self:Sync(syncName.bombStop .. " " .. bombotherdeath)
	elseif (string.find(msg, L["trigger_igniteManaHit"]) or string.find(msg, L["trigger_igniteManaResist"])) then
		self:Sync(syncName.ignite)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if string.find(msg, L["trigger_inferno"]) then
		self:Sync(syncName.inferno)
	end
end

function module:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, L["trigger_service"]) then
		self:Sync(syncName.service)
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
	module:Event(L["trigger_bombOther"])
	module:Event(L["trigger_bombOtherGone"])
	module:Event(L["trigger_deathOther"])
	module:Event(L["trigger_bombYou"])
	module:Event(L["trigger_bombYouGone"])
	module:Event(L["trigger_deathYou"])
	module:Event(L["trigger_deathOther"])
	module:Event(L["trigger_igniteManaHit"])
	module:Event(L["trigger_igniteManaResist"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(L["trigger_inferno"])
	module:CHAT_MSG_MONSTER_EMOTE(L["trigger_service"])
		
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
