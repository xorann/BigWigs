local bossName = BigWigs.bossmods.other.kazzak
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

-- called after module is enabled
function module:OnEnable()
	module.voidbolttime = 0
	module.castingvoidbolt = false
	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "EventSelf")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "EventSelf")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS", "Melee")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES", "Melee")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS", "Melee")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES", "Melee")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS", "Melee")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES", "Melee")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	
	self:ThrottleSync(2, syncName.markStart)
	self:ThrottleSync(2, syncName.markStop)
	self:ThrottleSync(2, syncName.reflectionStart)
	self:ThrottleSync(2, syncName.reflectionStop)
	self:ThrottleSync(5, syncName.voidboltStart)
	self:ThrottleSync(5, syncName.voidboltStop)
	self:ThrottleSync(5, syncName.supreme)
	self:ThrottleSync(5, syncName.death)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.supreme then
		self:Message(L["msg_engage"], "Important")
		self:DelayedMessage(timer.supreme - 60, L["msg_supreme1min"], "Attention")
		self:DelayedMessage(timer.supreme - 30, L["msg_supreme30"], "Urgent")
		self:DelayedMessage(timer.supreme - 10, L["msg_supreme10"], "Important")
		self:Bar(L["bar_enrage"], timer.supreme, icon.supreme, "Green", "Yellow", "Orange", "Red")
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_COMBAT_FRIENDLY_DEATH(msg)
	BigWigs:CheckForWipe(self)
	local _,_,otherdeath,_ = string.find(msg, L["trigger_deathOther"])
	
	if msg == L["trigger_deathYou"] then
		if self.db.profile.markofkazzak then
			self:RemoveBar(string.format(L["bar_mark"], UnitName("player")))
		end
		
		if self.db.profile.puticon then
			self:RemoveIcon()
		end
		
		if self.db.profile.twistedreflection then
			self:RemoveBar(string.format(L["bar_reflection"], UnitName("player")))
		end
		
		if self.db.profile.corruptsoul then
			self:Message(L["msg_corruptSoulYou"], "Attention")
		end
		
		self:Sync(syncName.randomDeath .. " " .. UnitName("player"))
	elseif otherdeath then
		self:Sync(syncName.randomDeath .. " " .. otherdeath)
	end
end

function module:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.supreme and msg == L["trigger_supreme"] then
		self:Message(L["msg_enrage"], "Important")
	elseif msg == L["trigger_bosskill"] then
		self:SendBossDeathSync()
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["trigger_voidbolt"] then 
		self:Sync(syncName.voidboltStart)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["trigger_enrage"] then 
		self:Sync(syncName.supreme)
	end
end

function module:EventSelf(msg)
	if string.find(msg, L["trigger_markYouGain"]) then
		if self.db.profile.markofkazzak then
			self:Message(L["msg_markYou"], "Attention", true, "Alert")
			self:Bar(string.format(L["bar_mark"], UnitName("player")), timer.mark, icon.mark, true, "white")
		end
		
		if self.db.profile.puticon then
			self:Icon(UnitName("player"))
		end
		
		self:Sync(syncName.markStart .. " " .. UnitName("player"))
	elseif string.find(msg, L["trigger_markYouGone"]) then
		if self.db.profile.markofkazzak then
			self:RemoveBar(string.format(L["bar_mark"], UnitName("player")))
		end
		
		if self.db.profile.puticon then
			self:RemoveIcon()
		end
		
		self:Sync(syncName.markStop .. " " .. UnitName("player"))
	elseif string.find(msg, L["trigger_reflectionYouGain"]) then
		if self.db.profile.twistedreflection then
			self:Message(L["msg_reflectionYou"], "Attention")
			self:Bar(string.format(L["bar_reflection"], UnitName("player")), timer.reflection, icon.reflection, true, "magenta")
		end
		
		self:Sync(syncName.reflectionStart .. " "..UnitName("player"))
	elseif string.find(msg, L["trigger_reflectionYouGone"]) then
		if self.db.profile.twistedreflection then
			self:RemoveBar(string.format(L["bar_reflection"], UnitName("player")))
		end
		
		self:Sync(syncName.reflectionStop .. " " .. UnitName("player"))
	end
end

function module:Event(msg)
	local _,_,markofkazzakother,_ = string.find(msg, L["trigger_markOtherGain"])
	local _,_,markofkazzakotherend,_ = string.find(msg, L["trigger_markOtherGone"])
	local _,_,twistedreflectionother,_ = string.find(msg, L["trigger_reflectionOtherGain"])
	local _,_,twistedreflectionotherend,_ = string.find(msg, L["trigger_reflectionOtherGone"])
	if markofkazzakother then
		self:Sync(syncName.markStart .. " " .. markofkazzakother)
	elseif markofkazzakotherend then
		self:Sync(syncName.markStop .. " " .. markofkazzakotherend)
	elseif twistedreflectionother then
		self:Sync(syncName.reflectionStart .. " " .. twistedreflectionother)
	elseif twistedreflectionotherend then
		self:Sync(syncName.reflectionStop .. " " .. twistedreflectionotherend)
	end
end

function module:Melee(msg)
	if string.find(msg, L["trigger_attack1"]) or string.find(msg, L["trigger_attack2"]) or string.find(msg, L["trigger_attack3"]) or string.find(msg, L["trigger_attack4"]) then
		if module.castingvoidbolt then 
			if (GetTime() - module.voidbolttime) < timer.voidboltCast then
				self:Sync(syncName.voidboltStop)
			elseif (GetTime() - module.voidbolttime) >= timer.voidboltCast then
				module.castingvoidbolt = false
			end
		end
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
	module:Melee(L["trigger_attack1"])
	module:Melee(L["trigger_attack2"])
	module:Melee(L["trigger_attack3"])
	module:Melee(L["trigger_attack4"])
	module:Event(L["trigger_markOtherGain"])
	module:Event(L["trigger_markOtherGone"])
	module:Event(L["trigger_reflectionOtherGain"])
	module:Event(L["trigger_reflectionOtherGone"])
	module:EventSelf(L["trigger_markYouGain"])
	module:EventSelf(L["trigger_markYouGone"])
	module:EventSelf(L["trigger_reflectionYouGain"])
	module:EventSelf(L["trigger_reflectionYouGone"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_enrage"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_voidbolt"])
	module:CHAT_MSG_COMBAT_FRIENDLY_DEATH(L["trigger_deathOther"])
	module:CHAT_MSG_COMBAT_FRIENDLY_DEATH(L["trigger_deathYou"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_supreme"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_bosskill"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
