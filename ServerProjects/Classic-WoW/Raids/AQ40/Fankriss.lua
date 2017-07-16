local bossName = BigWigs.bossmods.aq40.fankriss
local serverProjectName = "Classic-WoW"
if not BigWigs:IsServerRegisteredForServerProject(serverProjectName) or not BigWigs:IsBossSupportedByServerProject(bossName, serverProjectName) then
	return
end

BigWigs:Print("classic-wow " .. bossName)


------------------------------
-- Variables     			--
------------------------------

local module = BigWigs:GetModule(bossName)
local L = BigWigs.i18n[bossName]
local timer = module.timer
local icon = module.icon
local syncName = module.syncName

-- module variables
module.revision = 20013 -- To be overridden by the module!

-- timers should be overridden
timer.worm = 20


------------------------------
-- Initialization      		--
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")

	self:ThrottleSync(.1, syncName.worm)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.worms = 0
end

-- called after boss is engaged
function module:OnEngage()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
-- Event Handlers      		--
------------------------------
function module:Event(msg)
	if string.find(msg, L["trigger_entanglePlayer"]) or string.find(msg, L["trigger_entangleOther"]) then
		self:Sync(syncName.entangle)
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["trigger_worm"] then
		self:Sync(syncName.worm .. " " .. tostring(module.worms + 1))

		-- maybe someday it will be fixed on nefarian
		BigWigs:Print("Worm spawn trigger has been fixed on the server. Please report this on https://github.com/xorann/BigWigs/issues")
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
	module:Event(L["trigger_entanglePlayer"])
	module:Event(L["trigger_entangleOther"])
	--module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(L["trigger_worm"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
