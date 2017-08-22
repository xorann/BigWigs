local bossName = BigWigs.bossmods.aq20.moam
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
    self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	
	self:ThrottleSync(10, syncName.paralyze)
	self:ThrottleSync(10, syncName.unparalyze)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.firstunparalyze = true
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.adds then 
		self:Message(L["msg_engage"], "Important") 
	end
	self:Unparalyze()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_RAID_BOSS_EMOTE(msg)
    if string.find(msg, L["trigger_adds"]) then -- alternative trigger: Moam gains Energize.
		self:Sync(syncName.paralyze)
	elseif string.find(msg, L["trigger_return2"]) then
        self:Sync(syncName.unparalyze)
	end
end
function module:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, L["trigger_adds"]) then -- alternative trigger: Moam gains Energize.
		self:Sync(syncName.paralyze)
	elseif string.find(msg, L["trigger_return2"]) then
        self:Sync(syncName.unparalyze)
    end
end

function module:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if string.find( msg, L["trigger_return1"]) then
		self:Sync(syncName.unparalyze)
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
	module:CHAT_MSG_RAID_BOSS_EMOTE(L["trigger_adds"])
	module:CHAT_MSG_RAID_BOSS_EMOTE(L["trigger_return2"])
	module:CHAT_MSG_MONSTER_EMOTE(L["trigger_adds"])
	module:CHAT_MSG_MONSTER_EMOTE(L["trigger_return2"])
	module:CHAT_MSG_SPELL_AURA_GONE_OTHER(L["trigger_return1"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
