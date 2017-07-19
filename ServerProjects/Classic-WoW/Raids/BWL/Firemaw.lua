local bossName = BigWigs.bossmods.bwl.firemaw
local serverProjectName = "Classic-WoW"
if not BigWigs:IsServerRegisteredForServerProject(serverProjectName) or not BigWigs:IsBossSupportedByServerProject(bossName, serverProjectName) then
	return
end


--BigWigs:Print("classic-wow " .. bossName)

------------------------------
-- Variables     			--
------------------------------

local module = BigWigs:GetModule(bossName)
local L = BigWigs.i18n[bossName]
local timer = module.timer
local icon = module.icon
local syncName = module.syncName

-- module variables
module.revision = 20013 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	
	self:ThrottleSync(10, syncName.wingbuffet)
	self:ThrottleSync(10, syncName.shadowflame)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.wingbuffet then
		self:DelayedMessage(timer.firstWingbuffet - 5, L["msg_wingBuffetSoon"], "Attention", nil, nil, true)
		self:Bar(L["bar_wingBuffetFirst"], timer.firstWingbuffet, icon.wingbuffet)
	end
	if self.db.profile.shadowflame then
		self:Bar(L["bar_shadowFlameNext"], timer.shadowflame, icon.shadowflame)
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end

------------------------------
--      Event Handlers      --
------------------------------

function module:Event(msg)
	if msg == L["trigger_wingBuffet"] then
		self:Sync(syncName.wingbuffet)
	elseif msg == L["trigger_shadowFlame"] then 
		self:Sync(syncName.shadowflame)
	-- flamebuffet triggers too often on nefarian and therefor this warning doesn't make any sense
	--[[elseif string.find(msg, L["trigger_flameBuffetAfflicted"]) 
			or string.find(msg, L["trigger_flameBuffetResisted"]) 
			or string.find(msg, L["trigger_flameBuffetImmune"]) 
			or string.find(msg, L["trigger_flameBuffetAbsorbYou"]) 
			or string.find(msg, L["trigger_flameBuffetAbsorbOther"]) then
			
		self:FlameBuffet()]]
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
	module:Event(L["trigger_wingBuffet"])
	module:Event(L["trigger_shadowFlame"])
	module:Event(L["trigger_flameBuffetAfflicted"])
	module:Event(L["trigger_flameBuffetResisted"])
	module:Event(L["trigger_flameBuffetImmune"])
	module:Event(L["trigger_flameBuffetAbsorbYou"])
	module:Event(L["trigger_flameBuffetAbsorbOther"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
