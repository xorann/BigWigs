local bossName = BigWigs.bossmods.other.emeriss
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
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
	module.announceTime = 0
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
		else
			local _,_, EPlayer, EType = string.find(msg, L["trigger_volatileInfection"])
			if (EPlayer and EType) then
				if (EPlayer == L["misc_you"] and EType == L["misc_are"]) then
					if self.db.profile.volatileyou then 
						self:Message(L["msg_volatileInfectionYou"], "Important", true) 
					end
				else
					if self.db.profile.volatileother then
						self:Message(string.format(L["msg_volatileInfectionOther"], EPlayer), "Attention")
						self:Whisper(EPlayer, L["msg_volatileInfectionYou"])
					end
				end
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
		end
	elseif string.find(msg, L["trigger_corruption"]) then
		self:Message(L["msg_corruption"], "Important")
		self:Bar(L["bar_corruption"], timer.corruption, icon.corruption)
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
	module:Event(L["trigger_volatileInfection"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_engage"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_corruption"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
