local bossName = BigWigs.bossmods.zg.Marli
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

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
	
	self:ThrottleSync(5, syncName.drain)
	self:ThrottleSync(5, syncName.drainOver)
	self:ThrottleSync(5, syncName.trollPhase)
	self:ThrottleSync(5, syncName.spiderPhase)
	self:ThrottleSync(5, syncName.spiders)
	self:ThrottleSync(11, syncName.volley)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
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
function module:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["trigger_spiders"]) then
		self:Sync(syncName.spiders)
	elseif string.find(msg, L["trigger_phaseTroll"]) then
		self:Sync(syncName.trollPhase)
	elseif string.find(msg, L["trigger_spiderTroll1"]) or string.find(msg, L["trigger_spiderTroll2"]) then
		self:Sync(syncName.spiderPhase)
	end
end

function module:Event(msg)
	local _,_,drainlifeotherstart,_ = string.find(msg, L["trigger_drainLifeOtherGain"])
	local _,_,drainlifeotherend,_ = string.find(msg, L["trigger_drainLifeOtherGone"])
	if string.find(msg, L["trigger_poisonHit1"]) or string.find(msg, L["trigger_poisonHit2"]) or msg == L["trigger_poisonResist"] or msg == L["trigger_poisonImmune"] then
		self:Sync(syncName.volley)
	elseif string.find(msg, L["trigger_drainLife"]) then
		if msg == L["trigger_drainLifeYouGain"] then
			self:Sync(syncName.drain)
		elseif msg == L["trigger_drainLifeYouGone"] then
			self:Sync(syncName.drainOver)
		elseif drainlifeotherstart and (UnitIsInRaidByName(drainlifeotherstart) or UnitIsPetByName(drainlifeotherstart)) then
			self:Sync(syncName.drain)
		elseif drainlifeotherend and drainlifeotherend ~= L["misc_you"] and (UnitIsInRaidByName(drainlifeotherstart) or UnitIsPetByName(drainlifeotherstart)) then
			self:Sync(syncName.drainOver)
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
	module:CHAT_MSG_MONSTER_YELL(L["trigger_spiders"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_phaseTroll"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_spiderTroll1"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_spiderTroll2"])
	module:Event(L["trigger_drainLifeOtherGain"])
	module:Event(L["trigger_drainLifeOtherGone"])
	module:Event(L["trigger_poisonHit1"])
	module:Event(L["trigger_poisonHit2"])
	module:Event(L["trigger_poisonResist"])
	module:Event(L["trigger_poisonImmune"])
	module:Event(L["trigger_drainLife"])
	module:Event(L["trigger_drainLifeYouGain"])
	module:Event(L["trigger_drainLifeYouGone"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
