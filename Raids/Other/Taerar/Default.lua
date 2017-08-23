local bossName = BigWigs.bossmods.other.taerar
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
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.announceTime = 0
end

-- called after boss is engaged
function module:OnEngage()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:Event(msg)
	-- only announce every 3 seconds
	if module.announceTime + 3 < GetTime() then
		module.announceTime = GetTime()
		
		if string.find(msg, L["trigger_noxiousBreath"]) then
			if self.db.profile.noxious then 
				self:Message(L["msg_noxiousBreathNow"], "Important")
				self:DelayedMessage(timer.noxiousBreath - 5, L["msg_noxiousBreathSoon"], "Important", true, "Alert")
				self:Bar(L["bar_noxiousBreath"], timer.noxiousBreath, icon.noxiousBreath)
			end
		end
	end
end

function module:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["trigger_engage"] then
		if self.db.profile.noxious then
			self:Message(L["msg_engage"], "Important")
			self:DelayedMessage(timer.firstNoxiousBreath - 5, L["msg_noxiousBreathSoon"], "Important", true, "Alert")
			self:Bar(L["bar_noxiousBreath"], timer.firstNoxiousBreath, icon.noxiousBreath)
		elseif self.db.profile.fear then
			self:DelayedMessage(timer.firstFear - 5, L["msg_fearSoon"], "Important", true, "Alert")
			self:Bar(L["bar_fear"], timer.firstFear, icon.fear)
		end
	elseif string.find(msg, L["trigger_banish"]) then
		 self:Message(L["msg_banish"], "Important")
		 self:Bar(L["bar_banish"], timer.banish, icon.banish)
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["trigger_fear"] and self.db.profile.fear then
		self:Message(L["msg_fearNow"], "Important", "Alert")
		self:DelayedMessage(timer.fear, L["msg_fearSoon"], "Important", true, "Alert")
		self:Bar(L["bar_fear"], timer.fear, icon.fear)
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
	module:Event(L["trigger_noxiousBreath"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_engage"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_banish"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_fear"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
