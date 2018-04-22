local bossName = BigWigs.bossmods.naxx.noth
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

module:RegisterYellEngage(L["trigger_engage1"])
module:RegisterYellEngage(L["trigger_engage2"])
module:RegisterYellEngage(L["trigger_engage3"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "CheckForBlink")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckForCurse")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckForCurse")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckForCurse")
    
    self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE", "Teleport")
	
	self:ThrottleSync(5, syncName.blink)
	self:ThrottleSync(5, syncName.curse)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	timer.blinkAfterTeleport = timer.firstBlink -- sets timer for first blink after first balcony
    timer.curseAfterTeleport = timer.firstCurse
	timer.toRoom = timer.firstToRoom
	timer.toBalcony = timer.firstToBalcony
	
	module.phase = module.phases.firstRoom
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
		self:DelayedSound(timer.regularBlink - 4, "Four") 
		self:DelayedSound(timer.regularBlink - 3, "Three") 
		self:DelayedSound(timer.regularBlink - 2, "Two") 
		self:DelayedSound(timer.regularBlink - 1, "One") 
	end
    if self.db.profile.curse then
        self:Bar(L["bar_curse"], timer.curseAfterTeleport, icon.curse)
    end

	self:ScheduleEvent("bwnothtobalcony", self.TeleportToBalcony, timer.toBalcony, self)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
	self:CancelScheduledEvent("bwnothtobalcony")
	self:CancelScheduledEvent("bwnothtoroom") -- fallback
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CheckForCurse(msg)
	if string.find(msg, L["trigger_curse"]) then
		self:Sync(syncName.curse)
	end
end

function module:CheckForBlink(msg)
	if msg == L["trigger_blink"] then
		self:Sync(syncName.blink)
	end
end

function module:Teleport(msg)
    if msg == L["trigger_teleportToBalcony"] then
        self:Sync(syncName.teleportToBalcony)
    elseif msg == L["trigger_teleportToRoom"] then
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
	module:Teleport(L["trigger_teleportToBalcony"])
	module:Teleport(L["trigger_teleportToRoom"])
	module:CheckForBlink(L["trigger_blink"])
	module:CheckForCurse(L["trigger_curse"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
