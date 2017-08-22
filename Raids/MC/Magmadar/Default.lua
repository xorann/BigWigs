local bossName = BigWigs.bossmods.mc.magmadar
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
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckPanic")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckPanic")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckPanic")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "CheckPanic")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "CheckPanic")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CheckPanic")

	self:ThrottleSync(15, syncName.panic)
	self:ThrottleSync(5, syncName.frenzy)
	self:ThrottleSync(5, syncName.frenzyOver)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
	self:Panic(timer.firstPanicDelay) -- 10s earlier than normal
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CheckPanic(msg)
	if ((string.find(msg, L["trigger_panicHit"])) or (string.find(msg, L["trigger_panicImmune"])) or (string.find(msg, L["trigger_panicResist"]))) then
		self:Sync(syncName.panic)
	end
end

function module:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, L["trigger_frenzy"]) and self.db.profile.frenzy then
		self:Sync(syncName.frenzy)
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if string.find(msg, L["trigger_frenzyGone"]) then
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
	module:CheckPanic(L["trigger_panicHit"])
	module:CheckPanic(L["trigger_panicImmune"])
	module:CheckPanic(L["trigger_panicResist"])
	
	module:CHAT_MSG_MONSTER_EMOTE(L["trigger_frenzy"])
	
	module:CHAT_MSG_SPELL_AURA_GONE_OTHER(L["trigger_frenzyGone"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
