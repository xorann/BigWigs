
local bossName = BigWigs.bossmods.aq40.twins
if BigWigs:IsBossSupportedByAnyServerProject(bossName) then
	return
end
-- no implementation found => use default implementation
--BigWigs:Print("default twins")

------------------------------
--      Variables     		--
------------------------------

local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]
local veklor = AceLibrary("Babble-Boss-2.2")["Emperor Vek'lor"]
local veknilash = AceLibrary("Babble-Boss-2.2")["Emperor Vek'nilash"]
local timer = module.timer
local icon = module.icon
local syncName = module.syncName

-- module variables
module.revision = 20013

-- override timers if necessary
--timer.berserk = 300


------------------------------
-- Initialization      --
------------------------------

module:RegisterYellEngage(L["trigger_pull1"])
module:RegisterYellEngage(L["trigger_pull2"])
module:RegisterYellEngage(L["trigger_pull3"])
module:RegisterYellEngage(L["trigger_pull4"])
module:RegisterYellEngage(L["trigger_pull5"])
module:RegisterYellEngage(L["trigger_pull6"])
module:RegisterYellEngage(L["trigger_pull7"])
module:RegisterYellEngage(L["trigger_pull8"])
module:RegisterYellEngage(L["trigger_pull9"])
module:RegisterYellEngage(L["trigger_pull10"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "CheckForBossDeath") -- override module prototype

	self:ThrottleSync(28, syncName.teleport)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
	self:WarnForEnrage()
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
	if string.find(msg, L["trigger_blizzardGain"]) then
		self:BlizzardGain()
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
	if string.find(msg, L["trigger_blizzardGone"]) then
		self:BlizzardGone()
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["trigger_teleport"]) then
		self:Sync(syncName.teleport)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if (string.find(msg, L["trigger_explosion"]) and self.db.profile.bug) then
		self:BugExplosion()
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if string.find(msg, L["trigger_heal1"]) or string.find(msg, L["trigger_heal2"]) then
		self:Sync(syncName.heal)
	end
end

function module:CHAT_MSG_MONSTER_EMOTE(msg)
	if (string.find(msg, L["trigger_enrage"]) and self.db.profile.enrage) then
		self:Message(L["msg_enrage"], "Important")
	end
end


----------------------------------
-- Module Test Function    --
----------------------------------

-- automated test
function module:TestModule()
	module:OnEnable()
	module:OnSetup()
	module:OnEngage()

	module:TestModuleCore()

	-- check event handlers
	module:CheckForBossDeath(string.format(UNITDIESOTHER, veklor))
	module:CheckForBossDeath(string.format(UNITDIESOTHER, veknilash))
	module:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(L["trigger_blizzardGain"])
	module:CHAT_MSG_SPELL_AURA_GONE_SELF(L["trigger_blizzardGone"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_teleport"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_explosion"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(L["trigger_heal1"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(L["trigger_heal2"])
	module:CHAT_MSG_MONSTER_EMOTE(L["trigger_enrage"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	-- /run local m=BigWigs:GetModule("The Twin Emperors");m:Test()
	local function TestTeleport()
		self:Teleport()
	end

	local function TestBlizzard()
		self:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(L["trigger_blizzardGain"])
	end

	local function TestBlizzardGone()
		self:CHAT_MSG_SPELL_AURA_GONE_SELF(L["trigger_blizzardGone"])
	end

	local testTimer = 0
	BigWigs:Print(self:ToString() .. " Test started")

	-- immitate CheckForEngage
	self:SendEngageSync()

	-- teleport after 5s
	testTimer = testTimer + 5
	self:ScheduleEvent(self:ToString() .. "testTeleport", TestTeleport, testTimer, self)
	BigWigs:Print("  testTeleport after " .. testTimer .. "s")

	-- blizzard after 10s
	testTimer = testTimer + 5
	self:ScheduleEvent(self:ToString() .. "testBlizzard", TestBlizzard, testTimer, self)
	BigWigs:Print("  testBlizzard after " .. testTimer .. "s")

	-- blizzard gone after 12s
	testTimer = testTimer + 5
	self:ScheduleEvent(self:ToString() .. "testBlizzardGone", TestBlizzardGone, testTimer, self)
	BigWigs:Print("  testBlizzardGone after " .. testTimer .. "s")

	-- wipe
	testTimer = testTimer + 3
	self:ScheduleEvent(self:ToString() .. "testDisable", self.TestDisable, testTimer, self)
	BigWigs:Print("testDisable in " .. testTimer)
end
