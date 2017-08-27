local bossName = BigWigs.bossmods.zg.mandokir
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

module:RegisterYellEngage(L["trigger_engage"])

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
	
	self:ThrottleSync(5, syncName.whirlwind)
	self:ThrottleSync(5, syncName.whirlwindOver)
	self:ThrottleSync(5, syncName.enrage)
	self:ThrottleSync(5, syncName.enrageOver)
	self:ThrottleSync(5, syncName.gazeCast)
	self:ThrottleSync(5, syncName.gazeAfflicted)
	self:ThrottleSync(5, syncName.gazeOver)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
	self:Bar("Charge", timer.firstCharge, icon.charge) 
    -- todo check combat log regarding CHARGE to trigger the ones following the first
    self:Bar("Next Whirlwind", timer.firstWhirlwind, icon.whirlwind)
    self:Bar(L["Possible Gaze"], timer.firstGaze, icon.gaze)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_MONSTER_YELL(msg)
	local gazetime
	local _,_,watchedplayer,_ = string.find(msg, L["trigger_watch"])
	if watchedplayer then
		if self.db.profile.announce then
			if watchedplayer == UnitName("player") then
				self:Message(L["msg_watchYou"], "Personal", true, "Alarm")
			else
				self:Message(string.format(L["msg_watchOther"], watchedplayer), "Attention")
				self:TriggerEvent("BigWigs_SendTell", watchedplayer, L["msg_watchWhisper"])
			end
		end
		if self.db.profile.puticon then
			self:Icon(watchedplayer, -1, 7)
		end
		if watchedplayer == UnitName("player") and self.db.profile.gaze then
			self:WarningSign(icon.gaze, 7)
		end
	end
end

function module:Event(msg)
	local _,_,gazedplayer,_ = string.find(msg, L["trigger_gazeOtherGain"])
	local _,_,gazedplayerend,_ = string.find(msg, L["trigger_gazeOtherGone"])
	--local _,_,gazeddeathend,_ = string.find(msg, L["trigger_deathOther"])
	if msg == L["trigger_whirlwindGain"] then
		self:Sync(syncName.whirlwind)
	elseif msg == L["trigger_whirlwindGone"] then
		self:Sync(syncName.whirlwindOver)
	elseif msg == L["trigger_enrageGain"] then
		self:Sync(syncName.enrage)
	elseif msg == L["trigger_enrageFade"] then
		self:Sync(syncName.enrageOver)
	elseif msg == L["trigger_gazeCast"] then
		self:Sync(syncName.gazeCast)
	elseif msg == L["trigger_gazeYouGain"] then
		gazetime = GetTime()
		self:Sync(syncName.gazeAfflicted .. " " .. UnitName("player"))
	elseif gazedplayer then
		gazetime = GetTime()
		self:Sync(syncName.gazeAfflicted .. " " .. gazedplayer)
	elseif msg == L["trigger_gazeYouGone"] then
		self:Sync(syncName.gazeOver .. " " .. UnitName("player"))
	elseif gazedplayerend and gazedplayerend ~= L["misc_you"] then
		self:Sync(syncName.gazeOver .. " " .. gazedplayerend)
	--elseif msg == L["trigger_deathYou"] then
	--	self:Sync("MandokirGazeEnd "..UnitName("player"))
	--elseif gazeddeathend then
	--	self:Sync("MandokirGazeEnd "..gazeddeathend)
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
	module:Event(L["trigger_gazeOtherGain"])
	module:Event(L["trigger_gazeOtherGone"])
	module:Event(L["trigger_whirlwindGain"])
	module:Event(L["trigger_whirlwindGone"])
	module:Event(L["trigger_enrageGain"])
	module:Event(L["trigger_enrageFade"])
	module:Event(L["trigger_gazeCast"])
	module:Event(L["trigger_gazeYouGain"])
	module:Event(L["trigger_gazeYouGone"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
