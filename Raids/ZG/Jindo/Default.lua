local bossName = BigWigs.bossmods.zg.jindo
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
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "FadeFrom")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "FadeFrom")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE", "Event")
	
	self:ThrottleSync(5, syncName.curse)
	self:ThrottleSync(4, syncName.hex)
	self:ThrottleSync(4, syncName.hexOver)
end

-- called after module is enabled and after each wipe
function module:OnSetup()	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH") -- override
end

-- called after boss is engaged
function module:OnEngage()
	self:Bar("Next Hex", timer.firstHex, icon.hex)
    --self:Bar("Next Healing Ward", timer.firstHealing, icon.healing)
    --self:Bar("Next Brain Wash", timer.firstBrainwash, icon.brainwash)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	BigWigs:CheckForBossDeath(msg, self) -- don't forget this, we are overriding the default functionality
	
	if msg == L["trigger_brainWashDeath"] then
		self:RemoveBar(L["bar_brainWash"])
	elseif msg == L["trigger_healingDeath"] then
		self:RemoveBar(L["bar_healing"])
	--[[elseif msg == L["trigger_bossDeath"] then
		if self.db.profile.bosskill then self:Message(string.format(AceLibrary("AceLocale-2.2"):new("BigWigs")["%s has been defeated"], self:ToString()), "Bosskill", nil, "Victory") end
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
		self.core:ToggleModuleActive(self, false)]]
	end
end
 
function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
    if self.db.profile.brainwash and string.find(msg, L["trigger_brainWash"]) then
		--self:Message(L["msg_brainWash"], "Attention", true, "Alarm")
		--self:Bar(L["bar_brainWash"], timer.brainwashUptime, icon.brainwash, true, "Black")
        --self:Bar(L["bar_brainWashNext"], timer.brainwash, icon.brainwash)
	elseif self.db.profile.healingward and msg == L["trigger_healing"] then
		--self:Message(L["msg_healing"], "Attention", true, "Alarm")
		--self:Bar(L["bar_healing"], timer.healingUptime, icon.healing, true, "Yellow")
        --self:Bar(L["bar_healingNext"], timer.healing, icon.healing)
	end
end

function module:Event(msg)
	local _, _, curseother_name = string.find(msg, L["trigger_curseOther"])
	local _, _, hexother_name= string.find(msg, L["trigger_hexOther"])
	if curseother_name then
		self:Sync(syncName.curse .. " "..curseother_name)
	elseif hexother_name then
		self:Sync(syncName.hex .. " "..hexother_name)
	elseif msg == L["trigger_curseYou"] then
		self:Sync(syncName.curse .. " "..UnitName("player"))
	elseif msg == L["trigger_hexYou"] then
		self:Sync(syncName.hex .. " "..UnitName("player"))
	--[[elseif self.db.profile.brainwash and string.find(msg, L["trigger_brainWash"]) then
		self:Message(L["msg_brainWash"], "Attention", true, "Alarm")
		self:Bar(L["bar_brainWash"], timer.brainwashUptime, icon.brainwash, true, "Black")]]
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
	if msg == L["trigger_hexYouGone"] then
		self:Sync(syncName.hexOver .. " "..UnitName("player"))
	end
end

function module:FadeFrom(msg)
	local _, _, hexotherend_name = string.find(msg, L["trigger_hexOtherGone"])
	if hexotherend_name then
		self:Sync(syncName.hexOver .. " "..hexotherend_name)
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
	module:FadeFrom(L["trigger_hexOtherGone"])
	module:CHAT_MSG_SPELL_AURA_GONE_SELF(L["trigger_hexYouGone"])
	module:Event(L["trigger_curseOther"])
	module:Event(L["trigger_hexOther"])
	module:Event(L["trigger_curseYou"])
	module:Event(L["trigger_hexYou"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(L["trigger_brainWash"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(L["trigger_healing"])
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(L["trigger_brainWashDeath"])
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(L["trigger_healingDeath"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
