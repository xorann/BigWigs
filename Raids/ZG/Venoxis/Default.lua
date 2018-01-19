local bossName = BigWigs.bossmods.zg.venoxis
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
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
    self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	
	self:ThrottleSync(10, syncName.phase2)
	self:ThrottleSync(2, syncName.renew)
	self:ThrottleSync(2, syncName.renewOver)
	self:ThrottleSync(2, syncName.holyfire)
	self:ThrottleSync(2, syncName.holyfireOver)
	self:ThrottleSync(5, syncName.enrage)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.cobra = 0
    
	module.castingholyfire = 0
	module.holyfiretime = 0
	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.phase then
		self:Message(L["msg_phase1"], "Attention")
	end
	--self:TriggerEvent("BigWigs_StartCounterBar", self, "Snakes dead", 4, icon.addDead)
	--self:TriggerEvent("BigWigs_SetCounterBar", self, "Snakes dead", (4 - 0.1))
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	BigWigs:CheckForBossDeath(msg, self)
	
	if string.find(msg, L["trigger_addDeath"]) then
		self:Sync(syncName.addDead .. " " .. tostring(self.cobra + 1))
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if string.find(msg, L["trigger_renew"]) then
		self:Sync(syncName.renew)
	elseif string.find(msg, L["trigger_enrage"]) then
		self:Sync(syncName.enrage)
	end
end

function module:Event(msg)
	local _,_,poisoncloudhitsother,_ = string.find(msg, L["trigger_poisonCloudOtherHit"])
	local _,_,poisoncloudabsorb,_ = string.find(msg, L["trigger_poisonCloudOtherAbsorb"])
	local _,_,poisoncloudresist,_ = string.find(msg, L["trigger_poisonCloudOtherResist"])
	local _,_,poisoncloudimmune,_ = string.find(msg, L["trigger_poisonCloudOtherImmune"])
	if string.find(msg, L["trigger_holyFire"]) then
		self:Sync(syncName.holyfire)
	elseif string.find(msg, L["trigger_attack1"]) or string.find(msg, L["trigger_attack2"]) or string.find(msg, L["trigger_attack3"]) or string.find(msg, L["trigger_attack4"]) then
		if module.castingholyfire == 1 then 
			if (GetTime() - module.holyfiretime) < timer.holyfireCast then
				self:Sync("VenoxisHolyFireStop")
			elseif (GetTime() - module.holyfiretime) >= timer.holyfireCast then
				module.castingholyfire = 0
			end
		end
    elseif msg == L["trigger_poisonCloudYou"] then
        self:WarningSign(icon.cloud, 5)
        self:Message(L["msg_poisonYou"], "Attention", "Alarm")
	elseif string.find(msg, L["trigger_poisonCloud"]) then
		if self.db.profile.announce then
			if string.find(msg, L["trigger_poisonCloudYouHit"]) or msg == L["trigger_poisonCloudYouResist"] or msg == L["trigger_poisonCloudYouAbsorb"] or msg == L["trigger_poisonCloudYouImmune"] then
				self:Message(L["msg_poisonYou"], "Attention", "Alarm")
			elseif poisoncloudhitsother and poisoncloudhitsother~=L["misc_you"] then
				self:TriggerEvent("BigWigs_SendTell", poisoncloudhitsother, L["msg_poisonWhisper"])
			elseif poisoncloudresist then
				self:TriggerEvent("BigWigs_SendTell", poisoncloudresist, L["msg_poisonWhisper"])
			elseif poisoncloudabsorb then
				self:TriggerEvent("BigWigs_SendTell", poisoncloudabsorb, L["msg_poisonWhisper"])
			elseif poisoncloudimmune then
				self:TriggerEvent("BigWigs_SendTell", poisoncloudimmune, L["msg_poisonWhisper"])
			end
		end
	end
end

function module:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["trigger_phase2"]) then
		self:Sync(syncName.phase2)
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if string.find(msg, L["trigger_renewGone"]) then
		self:Sync(syncName.renewOver)
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
    if string.find(msg, L["trigger_poisonCloud"]) then
        self:RemoveWarningSign(icon.cloud)
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
	module:CHAT_MSG_SPELL_AURA_GONE_SELF(L["trigger_poisonCloud"])
	module:CHAT_MSG_SPELL_AURA_GONE_OTHER(L["trigger_renewGone"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_phase2"])
	module:Event(L["trigger_poisonCloudOtherHit"])
	module:Event(L["trigger_poisonCloudOtherAbsorb"])
	module:Event(L["trigger_poisonCloudOtherResist"])
	module:Event(L["trigger_poisonCloudOtherImmune"])
	module:Event(L["trigger_holyFire"])
	module:Event(L["trigger_attack1"])
	module:Event(L["trigger_attack2"])
	module:Event(L["trigger_attack3"])
	module:Event(L["trigger_attack4"])
	module:Event(L["trigger_poisonCloudYou"])
	module:Event(L["trigger_poisonCloud"])
	module:Event(L["trigger_poisonCloudYouHit"])
	module:Event(L["trigger_poisonCloudYouResist"])
	module:Event(L["trigger_poisonCloudYouAbsorb"])
	module:Event(L["trigger_poisonCloudYouImmune"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_renew"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_enrage"])
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(L["trigger_addDeath"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
