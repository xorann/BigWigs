local bossName = BigWigs.bossmods.naxx.horsemen
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
module.revision = 20018 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300
module.timer.meteor = 13
module.timer.firstMark = 20

------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "SkillEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "SkillEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "MarkEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "MarkEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "MarkEvent")
	
	self:ThrottleSync(3, syncName.shieldwall)
	self:ThrottleSync(8, syncName.mark)
	self:ThrottleSync(5, syncName.void)
	self:ThrottleSync(5, syncName.wrath)
	self:ThrottleSync(5, syncName.meteor)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	
	self.marks = 0
	self.deaths = 0

	module.times = {}
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.mark then
		self:Message(L["msg_engage"], "Attention")
		self:Bar(string.format( L["bar_mark"], self.marks + 1), timer.firstMark, icon.mark) -- 18,5 sec on feenix
		self:DelayedMessage(timer.firstMark - 5, string.format( L["msg_markSoon"], self.marks + 1), "Urgent")
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:MarkEvent(msg)
	if string.find(msg, L["trigger_mark"]) then
		local t = GetTime()
		if not module.times["mark"] or (module.times["mark"] and (module.times["mark"] + 8) < t) then -- why 8?
			self:Sync(syncName.mark .. " " .. tostring(self.marks + 1))
			module.times["mark"] = t
		end
	end
end

function module:SkillEvent(msg)
	local t = GetTime()
	if string.find(msg, L["trigger_meteor"]) then
		if not module.times["meteor"] or (module.times["meteor"] and (module.times["meteor"] + 8) < t) then -- why 8?
			self:Sync(syncName.meteor)
			module.times["meteor"] = t
		end
	elseif string.find(msg, L["trigger_wrath"]) then
		if not module.times["wrath"] or (module.times["wrath"] and (module.times["wrath"] + 8) < t) then -- why 8?
			self:Sync(syncName.wrath)
			module.times["wrath"] = t
		end
	elseif msg == L["trigger_void"] then
		if not module.times["void"] or (module.times["void"] and (module.times["void"] + 8) < t) then -- why 8?
			self:Sync(syncName.void )
			module.times["void"] = t
		end
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	local _,_, mob = string.find(msg, L["trigger_shieldWall"])
	if mob then 
		self:Sync(syncName.shieldwall .. " " .. mob) 
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["trigger_void"] then
		self:Sync(syncName.void )
	end	
end

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, module.thane) or
		msg == string.format(UNITDIESOTHER, module.zeliek) or 
		msg == string.format(UNITDIESOTHER, module.mograine) or
		msg == string.format(UNITDIESOTHER, module.blaumeux) then
		
		self.deaths = self.deaths + 1
		if self.deaths == 4 then
			self:SendBossDeathSync()
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
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(string.format(UNITDIESOTHER, module.thane))
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(L["trigger_void"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_shieldWall"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
