local bossName = BigWigs.bossmods.naxx.gluth
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
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "FrenzyCheck")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "FrenzyCheck")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "FrenzyCheck")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "EnrageCheck")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "FearCheck")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "FearCheck")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "FearCheck")
	
    self:ThrottleSync(5, syncName.frenzy)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.zomnum = 1
    module.lastFrenzy = 0
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.decimate then
		self:Message(L["msg_engage"], "Attention")
		self:Decimate()
		self:ScheduleRepeatingEvent( "bwgluthdecimate", self.Decimate, timer.decimateInterval, self )
	end
	if self.db.profile.zombies then
		self.zomnum = 1
		self:Bar(string.format(L["bar_zombie"],self.zomnum), timer.zombie, icon.zombie)
		self.zomnum = self.zomnum + 1
		self:Zombies()
	end
	if self.db.profile.enrage then
		self:Bar(L["bar_enrage"], timer.enrage, icon.enrage)
		self:DelayedMessage(timer.enrage - 90, L["msg_enrage90"], "Attention")
		self:DelayedMessage(timer.enrage - 30, L["msg_enrage30"], "Attention")
		self:DelayedMessage(timer.enrage - 10, L["msg_enrage10"], "Urgent")
	end
    if self.db.profile.frenzy then
		self:Bar(L["bar_frenzyNext"], timer.firstFrenzy, icon.frenzy, true, BigWigsColors.db.profile.frenzyNext) 
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:FrenzyCheck(msg)
    if msg == L["trigger_frenzyGain1"] or msg == L["trigger_frenzyGain2"] then
		self:Sync(syncName.frenzy)
	elseif msg == L["trigger_frenzyGone"] then
		self:Sync(syncName.frenzyOver)
	end
end

function module:FearCheck(msg)
	if string.find(msg, L["trigger_fear"]) then
		self:Sync(syncName.fear)
	end
end

function module:EnrageCheck(msg)
	if string.find(msg, L["trigger_berserk"]) then
		self:Sync(syncName.enrage)
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
	module:FrenzyCheck(L["trigger_frenzyGain1"])
	module:FrenzyCheck(L["trigger_frenzyGain2"])
	module:FrenzyCheck(L["trigger_frenzyGone"])
	module:FearCheck(L["trigger_fear"])
	module:EnrageCheck(L["trigger_berserk"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
