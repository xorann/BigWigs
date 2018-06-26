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

local BB = BigWigs.BabbleBoss

-- module variables
module.revision = 20018 -- To be overridden by the module!

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
	
	self:RemoveBar(string.format(L["bar_add"], module.numAbominations, "Unstoppable Abomination"))
	self:RemoveBar(string.format(L["bar_add"], module.numWeavers, "Soul Weaver"))
	
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
	if mob == BB["Unstoppable Abomination"] then
		self:Sync(syncName.abomination .. " " .. mob)
	elseif mob == BB["Soul Weaver"] then
		self:Sync(syncName.soulWeaver .. " " .. mob)
	elseif mob == BB["Kel'Thuzad"] then 
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
	module:Event(L["trigger_fissure"])
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
	-- /run local m=BigWigs:GetModule("Kel'Thuzad");m:TestVisual()
	local function abominationDeath()
		module:CHAT_MSG_COMBAT_HOSTILE_DEATH(string.format(L["trigger_addDeath"], BB["Unstoppable Abomination"]))
	end
	
	local function weaverDeath()
		module:CHAT_MSG_COMBAT_HOSTILE_DEATH(string.format(L["trigger_addDeath"], BB["Soul Weaver"]))
	end
	
	local function phase2()
		module:CHAT_MSG_MONSTER_YELL(L["trigger_phase2_1"])
	end
	
	local function frostbolt()
		module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_frostbolt"])
	end

	local function interrupt()
		module:Event(L["trigger_kick1"])
	end

	local function detonate()
		module:Affliction(L["trigger_detonate"])
	end

	local function frostboltVolley()
		module:Affliction(L["trigger_frostboltVolley"])
	end
	
	local function frostblast()
		module:CHAT_MSG_MONSTER_YELL(L["trigger_frostBlast"])
	end
	
	local function fissure()
		module:Event(L["trigger_fissure"])
	end
	
	local function phase3()
		module:CHAT_MSG_MONSTER_YELL(L["trigger_phase3"])
	end
	
	local function guardians()
		module:CHAT_MSG_MONSTER_YELL(L["trigger_guardians"])
	end

	local function deactivate()
		self:DebugMessage("deactivate")
		self:Disable()
		--[[self:DebugMessage("deactivate ")
		if self.phase then
			self:DebugMessage("deactivate module "..self:ToString())
			--BigWigs:ToggleModuleActive(self, false)
			self.core:ToggleModuleActive(self, false)
			self.phase = nil
		end]]
	end

	BigWigs:Print("module Test started")
	BigWigs:Print("  Abomination Death after 3s")
	BigWigs:Print("  Soul Weaver Death Test after 6s")
	BigWigs:Print("  Phase 2 Test after 9s")
	BigWigs:Print("  Frostbolt Test after 12s")
	BigWigs:Print("  Interrupt Test after 13s")
	BigWigs:Print("  Detonate Test after 16s")
	BigWigs:Print("  Frostbolt Volley Test after 19s")
	BigWigs:Print("  Frostblast Test after 22s")
	BigWigs:Print("  Fissure Test after 25s")
	BigWigs:Print("  Phase 3 Test after 28s")
	BigWigs:Print("  Guardians Test after 31s")
	BigWigs:Print("  Deactivate after 40s")

	-- immitate CheckForEngage
	self:SendEngageSync()

	-- abomination death after 3s
	self:ScheduleEvent(self:ToString() .. "Test_abominationDeath", abominationDeath, 3, self)

	-- weaver death after 6s
	self:ScheduleEvent(self:ToString() .. "Test_weaverDeath", weaverDeath, 6, self)

	-- phase2 after 9s
	self:ScheduleEvent(self:ToString() .. "Test_phase2", phase2, 9, self)

	-- frostbolt after 12s
	self:ScheduleEvent(self:ToString() .. "Test_frostbolt", frostbolt, 12, self)

	-- interrupt after 13s
	self:ScheduleEvent(self:ToString() .. "Test_interrupt", interrupt, 13, self)

	-- detonate after 16s
	self:ScheduleEvent(self:ToString() .. "Test_detonate", detonate, 16, self)

	-- frostbolt volley after 19s
	self:ScheduleEvent(self:ToString() .. "Test_frostboltVolley", frostboltVolley, 19, self)
	
	-- frost blast after 22s
	self:ScheduleEvent(self:ToString() .. "Test_frostblast", frostblast, 22, self)
	
	-- fissure after 25s
	self:ScheduleEvent(self:ToString() .. "Test_fissure", fissure, 25, self)
	
	-- phase3 after 28s
	self:ScheduleEvent(self:ToString() .. "Test_phase3", phase3, 28, self)
	
	-- guardians after 31s
	self:ScheduleEvent(self:ToString() .. "Test_guardians", guardians, 31, self)
	
	-- deactivate after 40s
	self:ScheduleEvent(self:ToString() .. "Test_deactivate", deactivate, 40, self)
end
