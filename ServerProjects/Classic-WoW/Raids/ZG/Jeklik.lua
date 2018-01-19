local bossName = BigWigs.bossmods.zg.jeklik
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

module:RegisterYellEngage(L["trigger_engage"])

-- called after module is enabled
function module:OnEnable()
    self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS", "Event")
	
	self:ThrottleSync(10, syncName.fear)
	self:ThrottleSync(10, syncName.fear2)
	self:ThrottleSync(1.5, syncName.mindflay)
	self:ThrottleSync(1.5, syncName.mindflayOver)
	self:ThrottleSync(4, syncName.heal)
	self:ThrottleSync(4, syncName.healOver)
	self:ThrottleSync(5, syncName.bombBats)
	self:ThrottleSync(5, syncName.swarmBats)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
    self.phase          = 0
    self.lastHeal       = 0
    self.castingheal    = 0
end

-- called after boss is engaged
function module:OnEngage()
	self.phase = 1
	
	if self.db.profile.fear then
		self:Bar(L["bar_fear"], timer.firstFear, icon.fear)
	end
	
	if self.db.profile.phase then
		self:Message(L["msg_phaseOne"], "Attention")
	end
	
	self:Bar("First Silence", timer.firstSilence, icon.silence)
	
	-- bats
    if self.db.profile.swarm then
		self:Bar(L["swarm_bartext"], timer.bats, icon.bats);
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:Event(msg)
	local _,_,mindflayother,_ = string.find(msg, L["trigger_mindFlayOtherGain"])
	local _,_,mindflayend,_ = string.find(msg, L["trigger_mindFlayOtherGone"])
	local _,_,liquidfirehitsother,_ = string.find(msg, L["trigger_liquidFireOtherHit"])
	local _,_,liquidfireresist,_ = string.find(msg, L["trigger_liquidFireOtherResist"])
	local _,_,liquidfireabsorb,_ = string.find(msg, L["trigger_liquidFireOtherAbsorb"])
	local _,_,liquidfireimmune,_ = string.find(msg, L["trigger_liquidFireOtherImmune"])
    if string.find(msg, "Your Flames hits you") then
        if self.db.profile.bomb then
            -- Your Flames hits you for %d Fire damage.
            self:WarningSign(icon.fire, 2)
            self:Message(L["msg_fireYou"], "Attention", "Alarm")
        end
	elseif string.find(msg, L["trigger_heal"]) then
		self:Sync(syncName.heal)
	elseif string.find(msg, L["trigger_phaseTwo"]) then
		self:Sync("JeklikPhaseTwo")
	elseif string.find(msg, L["trigger_mindFlayYouGain"]) then
		self:Sync(syncName.mindflay)
	elseif mindflayother and (UnitIsInRaidByName(mindflayother) or UnitIsPetByName(mindflayother)) then
		self:Sync(syncName.mindflay)
	elseif string.find(msg, L["trigger_mindFlayYouGone"]) then 
		self:Sync(syncName.mindflayOver)
	elseif mindflayend and (UnitIsInRaidByName(mindflayend) or UnitIsPetByName(mindflayend)) then 
		self:Sync(syncName.mindflayOver)
	elseif string.find(msg, L["trigger_fearHit"]) or string.find(msg, L["trigger_fearResist"]) or string.find(msg, L["trigger_fearImmune"]) then
		self:Sync(syncName.fear)
	elseif string.find(msg, L["trigger_fearHit2"]) or string.find(msg, L["trigger_fearResist2"]) or string.find(msg, L["trigger_fearImmune2"]) then
		self:Sync(syncName.fear2)
	elseif string.find(msg, L["trigger_attack1"]) or string.find(msg, L["trigger_attack2"]) or string.find(msg, L["trigger_attack3"]) or string.find(msg, L["trigger_attack4"]) then
		if self.castingheal == 1 then 
			if (GetTime()-self.lastHeal) < timer.healCast then
				self:Sync(syncName.healOver)
			elseif (GetTime()-self.lastHeal) >= timer.healCast then
				self.castingheal = 0
			end
		end
	elseif msg == L["trigger_bomb"] then
		self:Sync(syncName.bombBats)
	elseif msg == L["trigger_swarm"] then
		self:Sync(syncName.swarmBats)
	elseif string.find(msg, L["trigger_liquidFire"]) then
		if self.db.profile.announce then
			if string.find(msg, L["trigger_liquidFireYouHit"]) then
                -- do I still need this?
				--self:Message(L["msg_fireYou"], "Attention", "Alarm")
                --self:WarningSign(icon.fire, 2)
			elseif msg == L["trigger_liquidFireYouResist"] or msg == L["trigger_liquidFireYouAbsorb"] or msg == L["trigger_liquidFireYouImmune"] then
				self:Message(L["msg_fireWhisper"], "Attention", "Alarm")
			elseif liquidfirehitsother and liquidfirehitsother~=L["misc_you"] then
				self:TriggerEvent("BigWigs_SendTell", liquidfirehitsother, L["msg_fireWhisper"])
			elseif liquidfireresist then
				self:TriggerEvent("BigWigs_SendTell", liquidfireresist, L["msg_fireWhisper"])
			elseif liquidfireabsorb then
				self:TriggerEvent("BigWigs_SendTell", liquidfireabsorb, L["msg_fireWhisper"])
			elseif liquidfireimmune then
				self:TriggerEvent("BigWigs_SendTell", liquidfireimmune, L["msg_fireWhisper"])
			end
		end
	end
end

function module:UNIT_HEALTH(msg)
    if UnitName(msg) == self.translatedName then
        if UnitHealthMax(msg) == 100 then
            if self.phase < 2 and UnitHealth(msg) < 50 then
                self:Sync(syncName.phase2)
                self:UnregisterEvent("UNIT_HEALTH")
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
	module:Event(L["trigger_mindFlayOtherGain"])
	module:Event(L["trigger_mindFlayOtherGone"])
	module:Event(L["trigger_liquidFireOtherHit"])
	module:Event(L["trigger_liquidFireOtherResist"])
	module:Event(L["trigger_liquidFireOtherAbsorb"])
	module:Event(L["trigger_liquidFireOtherImmune"])
	module:Event(L["trigger_heal"])
	module:Event(L["trigger_phaseTwo"])
	module:Event(L["trigger_mindFlayYouGain"])
	module:Event(L["trigger_mindFlayYouGone"])
	module:Event(L["trigger_fearHit"])
	module:Event(L["trigger_fearResist"])
	module:Event(L["trigger_fearImmune"])
	module:Event(L["trigger_fearHit2"])
	module:Event(L["trigger_fearResist2"])
	module:Event(L["trigger_fearImmune2"])
	module:Event(L["trigger_attack1"])
	module:Event(L["trigger_attack2"])
	module:Event(L["trigger_attack3"])
	module:Event(L["trigger_attack4"])
	module:Event(L["trigger_bomb"])
	module:Event(L["trigger_swarm"])
	module:Event(L["trigger_liquidFire"])
	module:Event(L["trigger_liquidFireYouHit"])
	module:Event(L["trigger_liquidFireYouResist"])
	module:Event(L["trigger_liquidFireYouAbsorb"])
	module:Event(L["trigger_liquidFireYouImmune"])	
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
