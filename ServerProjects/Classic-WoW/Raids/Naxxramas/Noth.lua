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
	
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE", "TeleportEvent")
	
	self:ThrottleSync(5, syncName.blink)
	self:ThrottleSync(5, syncName.curse)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	timer.blinkAfterTeleport = timer.firstBlink -- sets timer for first blink after first balcony
    timer.curseAfterTeleport = timer.firstCurse
	timer.room = timer.firstRoom
	timer.balcony = timer.firstBalcony
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.teleport then
		self:Message(L["msg_engage"], "Important")
		self:Bar(L["bar_teleport"], timer.room, icon.balcony)
		--self:DelayedMessage(timer.room - 30, L["msg_teleport30"], "Urgent")
		--self:DelayedMessage(timer.room - 10, L["msg_teleport10"], "Urgent")
	end
	if self.db.profile.blink then
		self:Bar(L["bar_blink"], timer.blinkAfterTeleport, icon.blink)
		--self:DelayedMessage(timer.blinkAfterTeleport - 10, L["msg_blink10"], "Attention")
		--self:DelayedMessage(timer.blinkAfterTeleport - 5, L["msg_blink5"], "Attention")
	end
    if self.db.profile.curse then
        self:Bar(L["bar_curse"], timer.curseAfterTeleport, icon.curse)
    end

	--self:ScheduleEvent("bwnothtobalcony", self.TeleportToBalcony, timer.room, self)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CurseEvent(event, msg)
	if string.find(msg, L["trigger_curse"]) then
		self:Sync(syncName.curse)
	end
end

function module:BlinkEvent(event, msg)
	if msg == L["trigger_blink"] then
		self:Sync(syncName.blink)
	end
end

function module:TeleportEvent(event, msg)
    if string.find(msg, L["trigger_teleportToBalcony"]) then
        self:Sync(syncName.teleportToBalcony)
    elseif string.find(msg, L["trigger_teleportToRoom"]) then
        self:Sync(syncName.teleportToRoom)
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
	module:TeleportEvent("", L["trigger_teleportToBalcony"])
	module:TeleportEvent("", L["trigger_teleportToRoom"])
	module:BlinkEvent("", L["trigger_blink"])
	module:CurseEvent("", L["trigger_curse"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	-- /run local m=BigWigs:GetModule("Noth");m:TestVisual()
	local function balcony()
		--module:CheckForUnbalance("Instructor Razuvious's Unbalancing Strike hits Death Knight Understudy for 10724.")
		module:TeleportEvent("", L["trigger_teleportToBalcony"])
		BigWigs:Print("balcony")
	end 
	
	local function deactivate()
		self:DebugMessage("deactivate")
		self:Disable()
	end

	BigWigs:Print("module Test started")

	-- immitate CheckForEngage
	self:SendEngageSync()

	-- sweep after 5s
	self:ScheduleEvent(self:ToString() .. "Test_balcony", balcony, 2, self)
	self:ScheduleEvent(self:ToString() .. "Test_deactivate", deactivate, 5, self)
end
