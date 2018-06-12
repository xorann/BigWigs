local bossName = BigWigs.bossmods.naxx.kelthuzad
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

-- Big evul hack to enable the module when entering Kel'Thuzads chamber.
function module:OnRegister()
	self:RegisterEvent("MINIMAP_ZONE_CHANGED")
end

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES", "Event")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Affliction")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Affliction")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Affliction")
	
	self:ThrottleSync(5, syncName.detonate)
	self:ThrottleSync(5, syncName.frostblast)
	self:ThrottleSync(2, syncName.frostbolt)
	self:ThrottleSync(2, syncName.frostboltOver)
	self:ThrottleSync(2, syncName.fissure)
	self:ThrottleSync(2, syncName.abomination)
	self:ThrottleSync(2, syncName.soulWeaver)
	self:ThrottleSync(5, syncName.phase2)
	self:ThrottleSync(5, syncName.phase3)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	
	self.warnedAboutPhase3Soon = nil
	module.frostbolttime = 0
end

-- called after boss is engaged
function module:OnEngage()
	self:Message(L["msg_engage"], "Attention")
	self:Bar(L["bar_phase1"], timer.phase1, icon.phase1)
	self:DelayedMessage(timer.phase1 - 20, L["msg_phase2Soon"], "Important")
	
	if self.db.profile.addcount then
		module.timePhase1Start = GetTime() 	-- start of p1, used for tracking add counts
		module.numAbominations = 0
		module.numWeavers = 0
		self:Bar(string.format(L["bar_add"], module.numAbominations, "Unstoppable Abomination"), timer.phase1, icon.abomination)
		self:Bar(string.format(L["bar_add"], module.numWeavers, "Soul Weaver"), timer.phase1, icon.soulWeaver)
		
		self:KTM_SetTarget("Unstoppable Abomination")
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
    self:RemoveProximity()
	
	BigWigsFrostBlast:FBClose()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:MINIMAP_ZONE_CHANGED(msg)
	if GetMinimapZoneText() ~= L["misc_zone"] or self.core:IsModuleActive(module.translatedName) then 
        return 
    end
    
	-- Activate the Kel'Thuzad mod!
	self.core:EnableModule(module.translatedName)
end

-- check for phase 3
function module:UNIT_HEALTH(msg)
	if self.db.profile.phase then 
		if UnitName(msg) == self.translatedName then
			local health = UnitHealth(msg)
			if health > 35 and health <= 40 and not self.warnedAboutPhase3Soon then
				self:Message(L["msg_phase3Soon"], "Attention")
				self.warnedAboutPhase3Soon = true
			elseif health > 40 and self.warnedAboutPhase3Soon then
				self.warnedAboutPhase3Soon = nil
			end
		end
	end
end

function module:CHAT_MSG_MONSTER_YELL(msg)
	if ((msg == L["trigger_phase2_1"]) or (msg == L["trigger_phase2_2"]) or (msg == L["trigger_phase2_3"])) then
		self:Sync(syncName.phase2)
	elseif msg == L["trigger_phase3"] then
		self:Sync(syncName.phase3)
	elseif msg == L["trigger_mindControl1"] or msg == L["trigger_mindControl2"] then
		self:Sync(syncName.mindcontrol)
	elseif msg == L["trigger_guardians"] then
		self:Sync(syncName.guardians)
	elseif msg == L["trigger_frostBlast"] then
		self:Sync(syncName.frostblast)
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["trigger_frostbolt"]) then
		self:Sync(syncName.frostbolt)
	end
end

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	BigWigs:CheckForBossDeath(msg, self)

	local _,_, mob = string.find(msg, L["trigger_addDeath"])
	if mob == "Unstoppable Abomination" then
		self:Sync(syncName.abomination .. " " .. mob)
	elseif mob == "Soul Weaver" then
		self:Sync(syncName.soulWeaver .. " " .. mob)
	elseif mob == "Kel'Thuzad" then 
		self:SendBossDeathSync()
	end
end

--[[function module:Volley()
	self:Bar(L["bar_frostboltVolley"], 15, icon.frostboltVolley)
end]]
function module:Affliction(msg)
	if string.find(msg, L["trigger_detonate"]) then
		local _,_, dplayer, dtype = string.find( msg, L["trigger_detonate"])
		if dplayer and dtype then
			if dplayer == L["misc_you"] and dtype == L["misc_are"] then
				dplayer = UnitName("player")
			end
			self:Sync(syncName.detonate .. " ".. dplayer)
		end
	end
	
	if string.find(msg, L["trigger_frostboltVolley"]) then
		local now = GetTime()
		
		-- only warn if there are more than 4 players hit by frostbolt volley within 4s
		if now - module.timeLastFrostboltVolley > 4 then
			module.timeLastFrostboltVolley = now
			module.numFrostboltVolleyHits = 1
		else 
			module.numFrostboltVolleyHits = module.numFrostboltVolleyHits + 1
		end
		
		if module.numFrostboltVolleyHits == 4 then 
			self:Sync(syncName.frostboltVolley)
		end
	end
end

function module:Event(msg)
	-- shadow fissure
	if string.find(msg, L["trigger_fissure"]) then
		self:Sync(syncName.fissure)
	end

	-- frost bolt
	if GetTime() < module.frostbolttime + timer.frostbolt then
		if string.find(msg, L["trigger_attack1"]) or string.find(msg, L["trigger_attack2"]) or string.find(msg, L["trigger_attack3"]) or string.find(msg, L["trigger_attack4"]) then
			self:Sync(syncName.frostboltOver)
		elseif string.find(msg, L["trigger_kick1"]) or string.find(msg, L["trigger_kick2"]) or string.find(msg, L["trigger_kick3"]) -- kicked
			or string.find(msg, L["trigger_pummel1"]) or string.find(msg, L["trigger_pummel2"]) or string.find(msg, L["trigger_pummel3"]) -- pummeled
			or string.find(msg, L["trigger_shieldBash1"]) or string.find(msg, L["trigger_shieldBash2"]) or string.find(msg, L["trigger_shieldBash3"]) -- shield bashed
			or string.find(msg, L["trigger_earthShock1"]) or string.find(msg, L["trigger_earthShock2"]) then -- earth shocked
			
			self:Sync(syncName.frostboltOver)
		end
	else
		module.frostbolttime = 0
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
	module:Event(L["trigger_attack1"])
	module:Event(L["trigger_attack2"])
	module:Event(L["trigger_attack3"])
	module:Event(L["trigger_attack4"])
	module:Event(L["trigger_kick1"])
	module:Event(L["trigger_kick2"])
	module:Event(L["trigger_kick3"])
	module:Event(L["trigger_pummel1"])
	module:Event(L["trigger_pummel2"])
	module:Event(L["trigger_pummel3"])
	module:Event(L["trigger_shieldBash1"])
	module:Event(L["trigger_shieldBash2"])
	module:Event(L["trigger_shieldBash3"])
	module:Event(L["trigger_earthShock1"])
	module:Event(L["trigger_earthShock2"])
	module:Affliction(L["trigger_detonate"])
	module:Affliction(L["trigger_frostboltVolley"])
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(L["trigger_addDeath"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_frostbolt"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_phase2_1"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_phase2_2"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_phase2_3"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_phase3"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_mindControl1"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_mindControl2"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_guardians"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_frostBlast"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
