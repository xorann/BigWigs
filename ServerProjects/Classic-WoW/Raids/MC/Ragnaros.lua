local bossName = BigWigs.bossmods.mc.ragnaros
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

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	
	self:ThrottleSync(5, syncName.knockback)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	
	module.firstKnockback = true
	module.sonsdead = 0
end

-- called after boss is engaged
function module:OnEngage()
	self:Emerge()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	BigWigs:CheckForBossDeath(msg, self)

	if string.find(msg, L["misc_addName"]) then
		self:Sync(syncName.sons .. " " .. tostring(module.sonsdead + 1))
	end
end

function module:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["trigger_knockback"]) then
		self:Sync(syncName.knockback)
	elseif string.find(msg, L["trigger_submerge"]) then
		self:Sync(syncName.submerge)
	elseif string.find(msg, L["trigger_engage"]) then
		self:SendEngageSync()
    elseif string.find(msg, L["trigger_engageSoon"]) then
        self:Sync(syncName.engageSoon)
    elseif string.find(msg, L["trigger_hammer"]) then
        self:Sync(syncName.hammer)
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
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(L["misc_addName"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_knockback"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_submerge"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_engage"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_engageSoon"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_hammer"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
