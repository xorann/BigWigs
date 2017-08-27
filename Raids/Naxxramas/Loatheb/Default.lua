local bossName = BigWigs.bossmods.naxx.loatheb
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
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_BREAK_AURA", "CurseEvent")

	-- 2: Doom and SporeSpawn versioned up because of the sync including the
	-- doom/spore count now, so we don't hold back the counter.	
	self:ThrottleSync(10, syncName.doom)
	self:ThrottleSync(5, syncName.spore)
	self:ThrottleSync(5, syncName.curse)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.numSpore = 0 -- how many spores have been spawned
	module.numDoom = 0 -- how many dooms have been casted
	timer.doom = timer.firstDoom
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.doom then
		self:Bar(L["bar_softEnrage"], timer.softEnrage, icon.softEnrage)
		self:DelayedMessage(timer.softEnrage - 60, string.format(L["msg_doomChangeSoon"], 60), "Attention")
		self:DelayedMessage(timer.softEnrage - 30, string.format(L["msg_doomChangeSoon"], 30), "Attention")
		self:DelayedMessage(timer.softEnrage - 10, string.format(L["msg_doomChangeSoon"], 10), "Urgent")
		self:DelayedMessage(timer.softEnrage - 5, string.format(L["msg_doomChangeSoon"], 5), "Important")
		self:DelayedMessage(timer.softEnrage, L["msg_doomChangeNow"], "Important")
		
		-- soft enrage after 5min: Doom every 15s instead of every 30s
		--self:ScheduleEvent("bwloathebdoomtimerreduce", function() module.doomTime = 15 end, 300)
		self:ScheduleEvent("bwloathebdoomtimerreduce", self.SoftEnrage, timer.softEnrage)
		--self:Message(L["msg_engage"], "Red")
		self:Bar(string.format(L["bar_doom"], module.numDoom + 1), timer.doom, icon.doom)
		self:DelayedMessage(timer.doom - 5, string.format(L["msg_doomSoon"], module.numDoom + 1), "Urgent")
		timer.doom = timer.doomLong -- reduce doom timer from 120s to 30s

		self:Bar(L["bar_curse"], timer.firstCurse, icon.curse)
		
		self:Spore()
		self:ScheduleRepeatingEvent("bwloathebspore", self.Spore, timer.spore, self)
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:Event(msg)
	if string.find(msg, L["trigger_doom"]) then
		self:Sync(syncName.doom .. " " .. tostring(module.numDoom + 1))
	end
end

function module:CurseEvent(msg)
	if string.find(msg, L["trigger_curse"]) then
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
	module:Event(L["trigger_doom"])
	module:CurseEvent(L["trigger_curse"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	local function deactivate()
        BigWigs:Print(self:ToString().." Test deactivate")
        self:Disable()
    end
    
    BigWigs:Print(self:ToString().." Test started")
    BigWigs:Print("  Sweep Test after 5s")
    BigWigs:Print("  Sand Storm Test after 10s")
    BigWigs:Print("  Submerge Test after 32s")
    BigWigs:Print("  Emerge Test after 42s")
    
    
    -- immitate CheckForEngage
    self:SendEngageSync()
    
    -- reset after 50s
    self:ScheduleEvent(self:ToString().."Test_deactivate", deactivate, 50, self)
end
