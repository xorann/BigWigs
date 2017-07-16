local bossName = BigWigs.bossmods.aq40.twins
local serverProjectName = "Classic-WoW"
if not BigWigs:IsServerRegisteredForServerProject(serverProjectName) or not BigWigs:IsBossSupportedByServerProject(bossName, serverProjectName) then
	return
end


--BigWigs:Print("classic-wow twins")

local module = BigWigs:GetModule(bossName)
local L = BigWigs.I18n[bossName]
local timer = module.timer
local icon = module.icon
local syncName = module.syncName

-- module variables
module.revision = 20013

-- timers should be overridden
timer.teleport = 29.8
timer.enrage = 900
timer.blizzard = 10


------------------------------
-- Initialization      --
------------------------------

module:RegisterYellEngage(L["pull_trigger1"])
module:RegisterYellEngage(L["pull_trigger2"])
module:RegisterYellEngage(L["pull_trigger3"])
module:RegisterYellEngage(L["pull_trigger4"])
module:RegisterYellEngage(L["pull_trigger5"])
module:RegisterYellEngage(L["pull_trigger6"])
module:RegisterYellEngage(L["pull_trigger7"])
module:RegisterYellEngage(L["pull_trigger8"])
module:RegisterYellEngage(L["pull_trigger9"])
module:RegisterYellEngage(L["pull_trigger10"])

-- called after module is enabled
function module:OnEnable()
	--self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "CheckForBossDeath") -- addition

	self:ThrottleSync(28, syncName.teleport)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.started = nil
end

-- called after boss is engaged
function module:OnEngage()
	self:BrokenTeleport() -- does not work

	module:WarnForEnrage()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
-- Event Handlers      --
------------------------------
function module:CheckForBossDeath(msg)
	if msg == string.format(UNITDIESOTHER, veklor) or msg == string.format(UNITDIESOTHER, veknilash) then
		self:SendBossDeathSync()
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(msg)
	if string.find(msg, L["blizzard_trigger"]) then
		self:BlizzardGain()
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
	if string.find(msg, L["blizzard_gone_trigger"]) then
		self:BlizzardGone()
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["porttrigger"]) then
		self:Sync(syncName.teleport)
		self:DebugMessage("real port trigger")
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if (string.find(msg, L["explodebugtrigger"]) and self.db.profile.bug) then
		self:BugExplosion()
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if string.find(msg, L["healtrigger1"]) or string.find(msg, L["healtrigger2"]) then
		self:Sync(syncName.heal)
	end
end

function module:CHAT_MSG_MONSTER_EMOTE(msg)
	if (string.find(msg, L["enragetrigger"]) and self.db.profile.enrage) then
		self:Message(L["enragewarn"], "Important")
	end
end

function module:BrokenTeleport()
	self:DelayedSync(timer.teleport, syncName.teleport)
end

----------------------------------
-- Module Test Function    --
----------------------------------
function module:Test()
	-- /run local m=BigWigs:GetModule("The Twin Emperors");m:Test()
	local function testTeleport()
		self:Teleport()
	end

	local function testBlizzard()
		self:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(L["blizzard_trigger"])
	end

	local function testBlizzardGone()
		self:CHAT_MSG_SPELL_AURA_GONE_SELF(L["blizzard_gone_trigger"])
	end

	local function testDisable()
		--module:SendWipeSync()
		BigWigs:TriggerEvent("BigWigs_RebootModule", self:ToString())
		BigWigs:DisableModule(self:ToString())
	end

	local testTimer = 0
	BigWigs:Print(self:ToString() .. " Test started")

	-- immitate CheckForEngage
	self:SendEngageSync()

	-- teleport after 5s
	testTimer = testTimer + 5
	self:ScheduleEvent(self:ToString() .. "testTeleport", testTeleport, testTimer, self)
	BigWigs:Print("  testTeleport after " .. testTimer .. "s")

	-- blizzard after 10s
	testTimer = testTimer + 5
	self:ScheduleEvent(self:ToString() .. "testBlizzard", testBlizzard, testTimer, self)
	BigWigs:Print("  testBlizzard after " .. testTimer .. "s")

	-- blizzard gone after 12s
	testTimer = testTimer + 5
	self:ScheduleEvent(self:ToString() .. "testBlizzardGone", testBlizzardGone, testTimer, self)
	BigWigs:Print("  testBlizzardGone after " .. testTimer .. "s")

	-- wipe
	testTimer = testTimer + 3
	self:ScheduleEvent(self:ToString() .. "testDisable", testDisable, testTimer, self)
	BigWigs:Print("testDisable in " .. testTimer)
end
