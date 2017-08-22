local bossName = BigWigs.bossmods.mc.lucifron
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
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
	--self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH", "Event")

	self:ThrottleSync(0.5, syncName.mc .. "(.*)")
	self:ThrottleSync(0.5, syncName.mcEnd .. "(.*)")
	self:ThrottleSync(5, syncName.curse)
	self:ThrottleSync(5, syncName.doom)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.protector = 0
	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.curse then
		self:DelayedMessage(timer.curse - 5, L["msg_curseSoon"], "Attention", nil, nil, true)
		self:Bar(L["bar_curse"], timer.curse, icon.curse)
	end
	if self.db.profile.doom then
		self:DelayedMessage(timer.firstDoom - 5, L["msg_doomSoon"], "Attention", nil, nil, true)
		self:Bar(L["bar_doom"], timer.firstDoom, icon.doom)
	end
end

-- called after boss is disengaged (wipe/retreat or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:Event(msg)
	local _,_,mindcontrolother,_ = string.find(msg, L["trigger_mindControlOther"])
	local _,_,mindcontrolotherend,_ = string.find(msg, L["trigger_mindControlOtherGone"])
	--local _,_,mindcontrolotherdeath,_ = string.find(msg, L["trigger_deathOther"])
	if ((string.find(msg, L["trigger_curseHit"])) or (string.find(msg, L["trigger_curseResist"]))) then
		self:Sync(syncName.curse)
	elseif ((string.find(msg, L["trigger_doomHit"])) or (string.find(msg, L["trigger_doomResist"]))) then
		self:Sync(syncName.doom)
	elseif string.find(msg, L["trigger_mindControlYou"]) then
		self:Sync(syncName.mc .. UnitName("player"))
	elseif string.find(msg, L["trigger_mindControlYouGone"]) then
		self:Sync(syncName.mcEnd .. UnitName("player"))
	elseif string.find(msg, L["trigger_deathYou"]) then
		self:Sync(syncName.mcEnd .. UnitName("player"))
	elseif mindcontrolother then
		self:Sync(syncName.mc .. mindcontrolother)
	elseif mindcontrolotherend then
		self:Sync(syncName.mcEnd .. mindcontrolotherend)
	--elseif mindcontrolotherdeath then
	--	self:Sync(syncName.mcEnd .. mindcontrolotherdeath)
	end
end

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	BigWigs:CheckForBossDeath(msg, self)
	
	if string.find(msg, L["trigger_deathAdd"]) then
		self:Sync(syncName.add .. " " .. tostring(self.protector + 1))
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
	module:Event(L["trigger_mindControlOther"])
	module:Event(L["trigger_mindControlOtherGone"])
	module:Event(L["trigger_curseHit"])
	module:Event(L["trigger_curseResist"])
	module:Event(L["trigger_doomHit"])
	module:Event(L["trigger_doomResist"])
	module:Event(L["trigger_mindControlYou"])
	module:Event(L["trigger_doomResist"])
	module:Event(L["trigger_mindControlYou"])
	module:Event(L["trigger_mindControlYouGone"])
	module:Event(L["trigger_deathYou"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
