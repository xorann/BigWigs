local bossName = BigWigs.bossmods.bwl.ebonroc
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
module.revision = 20013 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	
	self:ThrottleSync(10, syncName.wingbuffet)
	self:ThrottleSync(5, syncName.shadowflame)
	self:ThrottleSync(5, syncName.curse)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.wingbuffet then
		self:Bar(L["bar_wingBuffetFirst"], timer.wingbuffet, icon.wingbuffet)
		self:DelayedMessage(timer.wingbuffet - 5, L["msg_wingBuffetSoon"], "Attention", nil, nil, true)
	end
	if self.db.profile.curse then
		self:Bar(L["bar_shadowCurseFirst"], timer.curse, icon.curse, true, "white")
	end
	if self.db.profile.shadowflame then
		self:Bar(L["bar_shadowFlameNext"], timer.shadowflameCast, icon.shadowflame)
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["trigger_shadowFlame"] then
		self:Sync(syncName.shadowflame)
	elseif msg == L["trigger_wingBuffet"] then
		self:Sync(syncName.wingbuffet)
	end
end

function module:Event(msg)
	local _,_,shadowcurseother,_ = string.find(msg, L["trigger_shadowCurseOther"])
	
	if string.find(msg, L["trigger_shadowCurseYou"]) then
		self:Sync(syncName.curse .. " " .. UnitName("player"))
	elseif shadowcurseother then
		self:Sync(syncName.curse .. " " .. shadowcurseother)
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
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_shadowFlame"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_wingBuffet"])
	module:Event(L["trigger_shadowCurseOther"])
	module:Event(L["trigger_shadowCurseYou"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
