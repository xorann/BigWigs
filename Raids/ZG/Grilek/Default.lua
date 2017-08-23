local bossName = BigWigs.bossmods.zg.grilek
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

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
	
	self:ThrottleSync(8, syncName.meleeIni)
	self:ThrottleSync(8, syncName.melee)
	self:ThrottleSync(10, syncName.avatar)
	self:ThrottleSync(10, syncName.avatarOver)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.firstwarn = true
	module.nameoftarget = nil
	module.lasttarget = "randomshitthatwonthappen"
end

-- called after boss is engaged
function module:OnEngage()
	if module.firstwarn then
		self:Sync(syncName.meleeIni)
		module.firstwarn = false
	end	
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:Event(msg)
	if msg == L["trigger_avatarGain"] then
		self:Sync(syncName.avatar)
	elseif msg == L["trigger_avatarGone"] then
		self:Sync(syncName.avatarOver)
		self:Sync(syncName.melee)
	end
end


------------------------------
--      Utility	Functions   --
------------------------------
function module:TargetChangedCheck()
	local num = GetNumRaidMembers()
	for i = 1, num do
		local raidUnit = string.format("raid%starget", i)
		if UnitExists(raidUnit) and UnitName(raidUnit) == "Gri'lek" and UnitExists(raidUnit.."target") then
			module.nameoftarget = UnitName(raidUnit.."target")
			if not module.lasttarget then
				module.lasttarget = module.nameoftarget
			end
		end
	end
	if module.nameoftarget and module.nameoftarget ~= module.lasttarget then
		if self.db.profile.puticon then
			self:Icon(module.nameoftarget, -1, -1)
		end
		if self.db.profile.announce then
			if module.nameoftarget == UnitName("player") then
				self:Message(L["msg_avatarYou"], "Attention", "Alarm")
			else
				self:Message(string.format(L["msg_avatarOther"], module.nameoftarget), "Personal")
				self:TriggerEvent("BigWigs_SendTell", module.nameoftarget, L["msg_avatarWhisper"])
			end
		end
		module.lasttarget = module.nameoftarget
	end
end

function module:Avatar()
	self:ScheduleRepeatingEvent("grilektargetchangedcheck", self.TargetChangedCheck, 0.5, self)
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
	module:Event(L["trigger_avatarGain"])
	module:Event(L["trigger_avatarGone"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
