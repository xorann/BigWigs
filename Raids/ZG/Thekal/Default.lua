local bossName = BigWigs.bossmods.zg.thekal
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

module:RegisterYellEngage(L["trigger_phase2"]) -- the phase2 trigger is used on engage on nefarian ...

-- called after module is enabled
function module:OnEnable()	
    --self:RegisterEvent("CHAT_MSG_MONSTER_YELL") -- phase transition
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Fades")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Fades")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Fades")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:ThrottleSync(10, syncName.phase2)
	self:ThrottleSync(5, syncName.heal)
	self:ThrottleSync(3, syncName.frenzy)
	self:ThrottleSync(3, syncName.frenzyOver)
	self:ThrottleSync(3, syncName.bloodlust)
	self:ThrottleSync(3, syncName.bloodlustOver)
	self:ThrottleSync(3, syncName.silence)
	self:ThrottleSync(3, syncName.silenceOver)
	self:ThrottleSync(5, syncName.mortalcleave)
	self:ThrottleSync(5, syncName.disarm)
	self:ThrottleSync(5, syncName.enrage)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.zathdead = nil
	module.lorkhandead = nil
	module.thekaldead = nil
end

-- called after boss is engaged
function module:OnEngage()
	self.phase = 1
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
-- override: only check for boss death in phase 2
function module:CheckForBossDeath(msg)
    --self:DebugMessage("thekal death; phase: " .. self.phase .. " msg: " .. msg)
	if self.phase == 2 then
		BigWigs:CheckForBossDeath(msg, self)
    elseif msg == string.format(UNITDIESOTHER, self:ToString()) or msg == string.format(L["You have slain %s!"], self.translatedName) then
        self:Sync(syncName.phase2)
    end
end
--[[function module:CHAT_MSG_MONSTER_YELL(msg) -- yell missing on nefarian, workaround in CheckForBossDeath function; 2016-09-25: phase2 trigger used as engage trigger ..
    if string.find(msg, L["trigger_phase2"]) then
        self:Sync(syncName.phase2)
    end
end]]

function module:Event(msg)
	local _,_,silenceother_triggerword = string.find(msg, L["trigger_silenceOther"])
	local _,_,disarmother_triggerword = string.find(msg, L["trigger_disarmOther"])
	local _,_,mortalcleaveother_triggerword = string.find(msg, L["trigger_mortalCleaveOther"])
	if msg == L["trigger_tigers"] then
		self:Message(L["msg_tigers"], "Important")
	elseif msg == L["trigger_heal"] then
		self:Sync(syncName.heal)
	elseif msg == L["trigger_silenceYou"] then
		self:Sync(syncName.silence .. " "..UnitName("player"))
	elseif silenceother_triggerword then
		self:Sync(syncName.silence .. " "..silenceother_triggerword)
	elseif msg == L["trigger_disarmYou"] then
		self:Sync(syncName.disarm .. " "..UnitName("player"))
	elseif disarmother_triggerword then
		self:Sync(syncName.disarm .. " "..disarmother_triggerword)
	elseif msg == L["trigger_mortalCleaveYou"] then
		self:Sync(syncName.mortalcleave .. " "..UnitName("player"))
	elseif mortalcleaveother_triggerword then
		self:Sync(syncName.mortalcleave .. " "..mortalcleaveother_triggerword)
	elseif msg == L["trigger_resurrectionThekal"] then
		if module.zathdead and module.lorkhandead then
			self:ScheduleEvent(self.CheckZealots, 2, self)
		else
			module.thekaldead = nil
		end
	elseif msg == L["trigger_resurrectionZath"] then
		module.zathdead = nil
	elseif msg == L["trigger_resurrectionLorkhan"] then
		module.lorkhandead = nil
	end
end

function module:CheckZealots()
	if module.zathdead and module.lorkhandead then
		self:Sync(syncName.phase2)
	else
		module.thekaldead = nil
	end
end

function module:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, L["trigger_death"]) then
		if arg2 == L["trigger_zath"] then
			module.zathdead = true
			if self.db.profile.bloodlust then
				self:RemoveBar(string.format(L["bar_bloodlust"], L["trigger_zath"]))
			end
		elseif arg2 == L["trigger_lorkhan"] then
			module.lorkhandead = true
			if self.db.profile.heal then
				self:RemoveBar(L["bar_heal"])
			end
			if self.db.profile.bloodlust then
				self:RemoveBar(string.format(L["bar_bloodlust"], L["trigger_lorkhan"]))
			end
		elseif arg2 == L["trigger_thekal"] then
			module.thekaldead = true
		end
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["trigger_forcepunch"] then
		self:Bar(L["bar_forcePunch"], timer.forcePunch, icon.forcePunch)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	local _,_,bloodlustgainword = string.find(msg, L["trigger_bloodlustGain"])
	if msg == L["trigger_frenzyGain"] then
		self:Sync(syncName.frenzy)
	elseif msg == L["trigger_enrage"] then
		self:Sync(syncName.enrage)
	elseif bloodlustgainword then
		self:Sync(syncName.bloodlust .. " " .. bloodlustgainword)
	end
end

function module:Fades(msg)
	local _,_,silenceotherend_triggerword = string.find(msg, L["trigger_silenceOtherGone"])
	local _,_,bloodlustendword = string.find(msg, L["trigger_bloodlustGone"])
	if bloodlustendword then
		self:Sync(syncName.bloodlustOver .. " "..bloodlustendword)
	elseif msg == L["trigger_silenceYouGone"] then
		self:Sync(syncName.silenceOver .. " "..UnitName("player"))
	elseif silenceotherend_triggerword then
		self:Sync(syncName.silenceOver .. " "..silenceotherend_triggerword)
	elseif msg == L["trigger_frenzyGone"] then
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
	module:Fades(L["trigger_silenceOtherGone"])
	module:Fades(L["trigger_bloodlustGone"])
	module:Fades(L["trigger_silenceYouGone"])
	module:Fades(L["trigger_frenzyGone"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_bloodlustGain"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_frenzyGain"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_enrage"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_forcepunch"])
	module:CHAT_MSG_MONSTER_EMOTE(L["trigger_death"])
	module:CheckZealots()
	module:Event(L["trigger_silenceOther"])
	module:Event(L["trigger_disarmOther"])
	module:Event(L["trigger_mortalCleaveOther"])
	module:Event(L["trigger_tigers"])
	module:Event(L["trigger_heal"])
	module:Event(L["trigger_silenceYou"])
	module:Event(L["trigger_disarmYou"])
	module:Event(L["trigger_mortalCleaveYou"])
	module:Event(L["trigger_resurrectionThekal"])
	module:Event(L["trigger_resurrectionZath"])
	module:Event(L["trigger_resurrectionLorkhan"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
    -- /run local m=BigWigs:GetModule("High Priest Thekal");m:Test()
    
	local function testPhaseSwitch()
		module:CheckForBossDeath(string.format(UNITDIESOTHER, self:ToString()))
    end
    local function testRemoveBars()
        BigWigs:Print("testRemoveBars")
        self:Sync(syncName.frenzyOver) 
        self:Sync(syncName.bloodlustOver) 
        self:Sync(syncName.silenceOver) 
    end
	local function testDisable()
		--module:SendWipeSync()
		BigWigs:TriggerEvent("BigWigs_RebootModule", self:ToString())
		BigWigs:DisableModule(module:ToString())
	end
    
    -- short test
    local testTimer = 0
    self:SendEngageSync()

    -- phase switch
    testTimer = testTimer + 3
    self:ScheduleEvent(self:ToString() .. "testPhaseSwitch", testPhaseSwitch, testTimer, self)
    BigWigs:Print("testPhaseSwitch in " .. testTimer)
    
    self:Sync(syncName.heal)
    self:Sync(syncName.frenzy)
    self:Sync(syncName.bloodlust)
    self:Sync(syncName.silence)
    self:Sync(syncName.mortalcleave)
    self:Sync(syncName.disarm)
    self:Sync(syncName.enrage)
    self:PhaseSwitch()

    testTimer = testTimer + 3
    self:ScheduleEvent(self:ToString() .. "testRemoveBars", testRemoveBars, testTimer, self)
    BigWigs:Print("testRemoveBars in " .. testTimer)
    
    -- disable
    testTimer = testTimer + 10
    self:ScheduleEvent(self:ToString() .. "testDisable", testDisable, testTimer, self)
    BigWigs:Print("testDisable in " .. testTimer)
end
