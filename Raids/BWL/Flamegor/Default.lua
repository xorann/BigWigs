local bossName = BigWigs.bossmods.bwl.flamegor
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
module.revision = 20013 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
    self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "Event")
	
	self:ThrottleSync(10, syncName.wingbuffet)
	self:ThrottleSync(10, syncName.shadowflame)
	self:ThrottleSync(5, syncName.frenzy)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.lastFrenzy = 0
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.wingbuffet then
		self:DelayedMessage(timer.firstWingbuffet - 5, L["msg_wingBuffetSoon"], "Attention", nil, nil, true)
		self:Bar(L["bar_wingBuffetFirst"], timer.firstWingbuffet, icon.wingbuffet)
	end
	if self.db.profile.shadowflame then
		self:Bar(L["bar_shadowFlameNext"], timer.firstShadowflame, icon.shadowflame)
	end
	if self.db.profile.frenzy then
		self:Bar(L["bar_frenzyNext"], timer.firstFrenzy, icon.frenzy, true, BigWigsColors.db.profile.frenzyNext) 
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["trigger_wingBuffet"] then
		self:Sync(syncName.wingbuffet)
	elseif msg == L["trigger_shadowFlame"] then
		self:Sync(syncName.shadowflame)
	end
end

function module:Event(msg)
	if msg == L["trigger_frenzyGain1"] or msg == L["trigger_frenzyGain2"] then
		self:Sync(syncName.frenzy)
	elseif msg == L["trigger_frenzyGone"] then
		self:Sync(syncName.frenzyOver)
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
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_wingBuffet"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_shadowFlame"])
	module:Event(L["trigger_frenzyGain1"])
	module:Event(L["trigger_frenzyGain1"])
	module:Event(L["trigger_frenzyGone"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	 -- /run local m=BigWigs:GetModule(BigWigs.bossmods.bwl.flamegor);m:TestVisual()
    local function frenzy()
        self:Event(L["trigger_frenzyGain1"])
    end
    local function frenzyEnd()
        self:Event(L["trigger_frenzyGone"])
    end
    local function deactivate()
        self:DebugMessage("deactivate")
        self:Disable()
    end
    
    BigWigs:Print("module Test started")
    BigWigs:Print("  frenzy after 5s")
    
    
    -- immitate CheckForEngage
    self:SendEngageSync()    
    
    -- sweep after 5s
    self:ScheduleEvent(self:ToString().."Test_frenzy", frenzy, 5, self)
    
    -- sweep after 5s
    self:ScheduleEvent(self:ToString().."Test_frenzyEnd", frenzyEnd, 10, self)
    
    -- reset after 60s
    self:ScheduleEvent(self:ToString().."Test_deactivate", deactivate, 15, self)
end
