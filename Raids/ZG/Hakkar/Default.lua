local bossName = BigWigs.bossmods.zg.hakkar
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

module:RegisterYellEngage(L["trigger_engage"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Self")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Self")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Others")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Others")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
	
	
	self:ThrottleSync(5, syncName.bloodSiphon)
	self:ThrottleSync(5, syncName.mindcontrol)
	
	self:ThrottleSync(5, syncName.jeklik)
	self:ThrottleSync(5, syncName.arlokk)
	self:ThrottleSync(5, syncName.arlokkAvoid)
	self:ThrottleSync(5, syncName.venoxis)
	self:ThrottleSync(5, syncName.marli)
	self:ThrottleSync(5, syncName.marliAvoid)
	self:ThrottleSync(5, syncName.thekalStart)
	self:ThrottleSync(5, syncName.thekalStop)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.enrage then
		self:Bar(L["bar_enrage"], timer.enrage, icon.enrage, true, BigWigsColors.db.profile.enrage)
		self:DelayedMessage(timer.enrage - 5 * 60, L["msg_enrage5m"], "Urgent", nil, nil, true)
		self:DelayedMessage(timer.enrage - 60, L["msg_enrage1m"], "Urgent", nil, nil, true)
		self:DelayedMessage(timer.enrage - 30, string.format(L["msg_enrageSeconds"], 30), "Urgent", nil, nil, true)
		self:DelayedMessage(timer.enrage - 10, string.format(L["msg_enrageSeconds"], 10), "Attention", nil, nil, true)
	end
	if self.db.profile.siphon then
		self:Bar(L["bar_siphon"], timer.bloodSiphon, icon.bloodSiphon)
		self:DelayedMessage(timer.bloodSiphon - 30, string.format(L["msg_siphonSoon"], 30), "Urgent")
		self:DelayedWarningSign(timer.bloodSiphon - 30, icon.serpent, 3)
		self:DelayedMessage(timer.bloodSiphon - 10, string.format(L["msg_siphonSoon"], 10), "Attention", nil, nil, true)
	end
	if self.db.profile.mc then
		self:Bar(L["bar_firstMindControl"], timer.firstMindcontrol, icon.mindcontrol, true, BigWigsColors.db.profile.mindControl)
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if msg == L["trigger_aspectOfThekalGone"] then
		self:Sync(syncName.thekalStop)
	end
end

function module:Self(msg)
	if msg == L["trigger_mindControlYou"] then
		self:Sync(syncName.mindcontrol .. " "..UnitName("player"))
    elseif string.find(msg, L["trigger_poisonousBlood"]) then
        self:RemoveWarningSign(icon.serpent)
		
	-- aspects
	elseif msg == L["trigger_aspectOfJeklikYou"] then
		self:Sync(syncName.jeklik)
	elseif msg == L["trigger_aspectOfMarliYou"] then
		self:Sync(syncName.marli .. " "..UnitName("player"))
	elseif msg == L["trigger_aspectOfArlokkYou"] then
		self:Sync(syncName.arlokk .. " "..UnitName("player"))
	elseif string.find(msg, L["trigger_aspectOfVenoxisYou"]) then
		self:Sync(syncName.venoxis)
	elseif msg == L["trigger_aspectOfJeklikYouImmune"] then
		self:Sync(syncName.jeklik)
	elseif msg == L["trigger_aspectOfMarliYouImmune"] then
		self:Sync(syncName.marliAvoid)
	elseif msg == L["trigger_aspectOfArlokkYouImmune"] then
		self:Sync(syncName.arlokkAvoid)
	elseif msg == L["trigger_aspectOfVenoxisYouResist"] then
		self:Sync(syncName.venoxis)
	elseif string.find(msg, L["trigger_aspectOfJeklikGeneralAvoid"]) then
		self:Sync(syncName.jeklik)
	elseif string.find(msg, L["trigger_aspectOfMarliGeneralAvoid"]) then
		self:Sync(syncName.marliAvoid)
	elseif string.find(msg, L["trigger_aspectOfArlokkGeneralAvoid"]) then
		self:Sync(syncName.arlokkAvoid)
	end
end

-- aspects
function module:Others(msg)
	local _, _, aspectofmarliother, _ = string.find(msg, L["trigger_aspectOfMarliOther"])
	local _, _, aspectofmarliotherimmune, _ = string.find(msg, L["trigger_aspectOfMarliOtherImmune"])
	local _, _, aspectofjeklikother, _ = string.find(msg, L["trigger_aspectOfJeklikOther"])
	local _, _, aspectofjeklikotherimmune, _ = string.find(msg, L["trigger_aspectOfJeklikOtherImmune"])
	local _, _, aspectofarlokkother, _ = string.find(msg, L["trigger_aspectOfArlokkOther"])
	local _, _, aspectofarlokkotherimmune, _ = string.find(msg, L["trigger_aspectOfArlokkOtherImmune"])
	if aspectofmarliother then
		self:Sync(syncName.marli .. " "..aspectofmarliother)
	elseif aspectofmarliotherimmune then
		self:Sync(syncName.marliAvoid)
	elseif string.find(msg, L["trigger_aspectOfMarliGeneralAvoid"]) then
		self:Sync(syncName.marliAvoid)
	elseif aspectofjeklikother then
		self:Sync(syncName.jeklik)
	elseif aspectofjeklikotherimmune then
		self:Sync(syncName.jeklik)
	elseif string.find(msg, L["trigger_aspectOfJeklikGeneralAvoid"]) then
		self:Sync(syncName.jeklik)
	elseif aspectofarlokkother then
		self:Sync(syncName.arlokk .. " "..aspectofarlokkother)
	elseif aspectofarlokkotherimmune then
		self:Sync(syncName.arlokkAvoid)
	elseif string.find(msg, L["trigger_aspectOfArlokkGeneralAvoid"]) then
		self:Sync(syncName.arlokkAvoid)
	elseif string.find(msg, L["trigger_aspectOfVenoxisOther"]) then
		self:Sync(syncName.venoxis)
	elseif string.find(msg, L["trigger_aspectOfVenoxisOtherResist"]) then
		self:Sync(syncName.venoxis)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["trigger_siphon"] then
		self:Sync(syncName.bloodSiphon)
		
	-- aspects
	elseif string.find(msg, L["trigger_aspectOfThekal"]) then
		self:Sync(syncName.thekalStart)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE(msg)
	local _, _, mindcontrolother, _ = string.find(msg, L["trigger_mindControlOther"])
	if mindcontrolother then
		self:Sync(syncName.mindcontrol .. " "..mindcontrolother)
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
	module:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE(L["trigger_mindControlOther"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_siphon"])
	module:Others(L["trigger_aspectOfMarliOther"])
	module:Others(L["trigger_aspectOfMarliOtherImmune"])
	module:Others(L["trigger_aspectOfJeklikOther"])
	module:Others(L["trigger_aspectOfJeklikOtherImmune"])
	module:Others(L["trigger_aspectOfArlokkOther"])
	module:Others(L["trigger_aspectOfArlokkOtherImmune"])
	module:Others(L["trigger_aspectOfMarliGeneralAvoid"])
	module:Others(L["trigger_aspectOfJeklikGeneralAvoid"])
	module:Others(L["trigger_aspectOfArlokkGeneralAvoid"])
	module:Others(L["trigger_aspectOfVenoxisOther"])
	module:Others(L["trigger_aspectOfVenoxisOtherResist"])
	module:Self(L["trigger_mindControlYou"])
	module:Self(L["trigger_poisonousBlood"])
	module:Self(L["trigger_aspectOfJeklikYou"])
	module:Self(L["trigger_aspectOfMarliYou"])
	module:Self(L["trigger_aspectOfArlokkYou"])
	module:Self(L["trigger_aspectOfVenoxisYou"])
	module:Self(L["trigger_aspectOfJeklikYouImmune"])
	module:Self(L["trigger_aspectOfMarliYouImmune"])
	module:Self(L["trigger_aspectOfArlokkYouImmune"])
	module:Self(L["trigger_aspectOfVenoxisYouResist"])
	module:Self(L["trigger_aspectOfJeklikGeneralAvoid"])
	module:Self(L["trigger_aspectOfMarliGeneralAvoid"])
	module:Self(L["trigger_aspectOfArlokkGeneralAvoid"])
	module:CHAT_MSG_SPELL_AURA_GONE_OTHER(L["trigger_aspectOfThekalGone"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
