local bossName = BigWigs.bossmods.naxx.noth
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

module:RegisterYellEngage(L["trigger_engage1"])
module:RegisterYellEngage(L["trigger_engage2"])
module:RegisterYellEngage(L["trigger_engage3"])

-- called after module is enabled
function module:OnEnable()
    self:CombatlogFilter(L["trigger_curse"], self.CurseEvent, true)
    self:CombatlogFilter(L["trigger_blink"], self.BlinkEvent, true)
	
	self:CombatlogFilter(L["trigger_teleportToBalcony"], self.TeleportEvent, true)
	self:CombatlogFilter(L["trigger_teleportToRoom"], self.TeleportEvent, true)
	
	--self:CombatlogFilter("Noth the Plaguebringer teleports", self.TeleportEvent, true)
	--self:CombatlogFilter("to the balcony above", self.TeleportEvent, true)
	--self:CombatlogFilter("into the battle", self.TeleportEvent, true)
	
	--self:CombatlogFilter("Noth the Plaguebringer raises more skeletons!", self.WaveEvent, true)
	--self:CombatlogFilter("raises more skeletons", self.WaveEvent, true)
	
	--self:CombatlogFilter(L["trigger_teleportToRoom"], self.TeleportEvent, true)
	
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE", "TeleportEvent")
	
	self:ThrottleSync(5, syncName.blink)
	self:ThrottleSync(5, syncName.curse)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	timer.blinkAfterTeleport = timer.firstBlink -- sets timer for first blink after first balcony
    timer.curseAfterTeleport = timer.firstCurse
	timer.toRoom = timer.firstToRoom
	timer.toBalcony = timer.firstToBalcony
	timer.wave2 = timer.wave2_1
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.teleport then
		self:Message(L["msg_engage"], "Important")
		self:Bar(L["bar_teleport"], timer.toBalcony, icon.toBalcony)
		--self:DelayedMessage(timer.toBalcony - 30, L["msg_teleport30"], "Urgent")
		--self:DelayedMessage(timer.toBalcony - 10, L["msg_teleport10"], "Urgent")
	end
	if self.db.profile.blink then
		self:Bar(L["bar_blink"], timer.blinkAfterTeleport, icon.blink)
		--self:DelayedMessage(timer.blinkAfterTeleport - 10, L["msg_blink10"], "Attention")
		--self:DelayedMessage(timer.blinkAfterTeleport - 5, L["msg_blink5"], "Attention")
		self:DelayedSound(timer.regularBlink - 5, "Five") 
		self:DelayedSound(timer.regularBlink - 3, "Three") 
		self:DelayedSound(timer.regularBlink - 2, "Two") 
		self:DelayedSound(timer.regularBlink - 1, "One") 
	end
    if self.db.profile.curse then
        self:Bar(L["bar_curse"], timer.curseAfterTeleport, icon.curse)
    end

	self:ScheduleEvent("bwnothtobalcony", self.TeleportToBalcony, timer.toBalcony, self) -- fallback
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
	self:CancelScheduledEvent("bwnothtobalcony")
	self:CancelScheduledEvent("bwnothtoroom") -- fallback
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CurseEvent(msg, event)
	if string.find(msg, L["trigger_curse"]) then
		self:Sync(syncName.curse)
	end
end

function module:BlinkEvent(msg, event)
	if msg == L["trigger_blink"] then
		self:Sync(syncName.blink)
	end
end

function module:TeleportEvent(msg, event)
	BigWigs:DebugMessage("Teleport " .. msg)
    if string.find(msg, L["trigger_teleportToBalcony"]) then
        self:Sync(syncName.teleportToBalcony)
    elseif string.find(msg, L["trigger_teleportToRoom"]) then
        self:Sync(syncName.teleportToRoom)
    end
end

function module:WaveEvent(msg, event)
	BigWigs:DebugMessage("WaveEvent " .. msg)
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
	module:TeleportEvent(L["trigger_teleportToBalcony"])
	module:TeleportEvent(L["trigger_teleportToRoom"])
	module:BlinkEvent(L["trigger_blink"])
	module:CurseEvent(L["trigger_curse"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	-- /run local m=BigWigs:GetModule("Noth the Plaguebringer");m:TestVisual()
	local function deactivate()
		self:DebugMessage("deactivate")
		self:Disable()
	end

	local function toBalcony()
		BigWigs:Print("to balcony")
		module:TeleportEvent(L["trigger_teleportToBalcony"])
	end
	
	local function toRoom()
		BigWigs:Print("to room")
		module:TeleportEvent(L["trigger_teleportToRoom"])
	end
	
	BigWigs:Print("module Test started")

	-- immitate CheckForEngage
	self:SendEngageSync()

	self:ScheduleEvent(self:ToString() .. "Test_toBalcony1", toBalcony, 5, self)
	self:ScheduleEvent(self:ToString() .. "Test_toRoom1", toRoom, 10, self)
	self:ScheduleEvent(self:ToString() .. "Test_toBalcony2", toBalcony, 15, self)
	self:ScheduleEvent(self:ToString() .. "Test_toRoom2", toRoom, 20, self)
	self:ScheduleEvent(self:ToString() .. "Test_toBalcony3", toBalcony, 25, self)
	self:ScheduleEvent(self:ToString() .. "Test_toRoom3", toRoom, 30, self)
	
	-- deactivate
	self:ScheduleEvent(self:ToString() .. "Test_deactivate", deactivate, 500, self)
end
