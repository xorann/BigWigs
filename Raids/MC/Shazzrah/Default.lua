local bossName = BigWigs.bossmods.mc.shazzrah
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
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_BUFF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS", "Event")
	
	self:ThrottleSync(10, syncName.blink)
    self:ThrottleSync(10, syncName.curse)
    self:ThrottleSync(5, syncName.deaden)
    self:ThrottleSync(5, syncName.deadenOver)
    self:ThrottleSync(0.5, syncName.cs)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.firstblink = true
end

-- called after boss is engaged
function module:OnEngage()        
    if self.db.profile.counterspell then
        self:Bar(L["bar_counterspell"], timer.firstCS, icon.cs)
    end
    self:DelayedSync(timer.firstCS, syncName.cs)
    
    if self.db.profile.blink then
        self:Bar(L["bar_blink"], timer.firstBlink, icon.blink)
    end
    self:DelayedSync(timer.firstBlink, syncName.blink)
    
    if self.db.profile.curse then
        --self:Bar(L["bar_curse"], timer.firstCurse, icon.curse) -- seems to be completly random
    end
    if self.db.profile.deaden then
        self:Bar(L["bar_deaden"], timer.firstDeaden, icon.deaden)
    end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:Event(msg)
	if (string.find(msg, L["trigger_deaden"])) then
		self:Sync(syncName.deaden)
	elseif (string.find(msg, L["trigger_deadenGone"])) then
		self:Sync(syncName.deadenOver)
	elseif (string.find(msg, L["trigger_blink"])) then
		self:Sync(syncName.blink)
	elseif (string.find(msg, L["trigger_counterspellCast"]) or string.find(msg, L["trigger_counterspellResist"])) then
		self:Sync(syncName.cs)
	elseif (string.find(msg, L["trigger_curseHit"]) or string.find(msg, L["trigger_curseResist"])) then
		self:Sync(syncName.curse)
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
	module:Event(L["trigger_deaden"])
	module:Event(L["trigger_deadenGone"])
	module:Event(L["trigger_blink"])
	module:Event(L["trigger_counterspellCast"])
	module:Event(L["trigger_counterspellResist"])
	module:Event(L["trigger_curseHit"])
	module:Event(L["trigger_curseResist"])
		
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
