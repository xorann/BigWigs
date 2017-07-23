local bossName = BigWigs.bossmods.bwl.broodlord
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
module.revision = 20013 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300

------------------------------
-- Initialization      		--
------------------------------

module:RegisterYellEngage(L["trigger_engage"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	--self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.lastBlastWave = 0
	self.lastMS = 0
	self.MS = ""
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.bw then
		self:Bar(L["bar_blastWave"], timer.blastWave, icon.blastWave, true, "Red")
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
-- Event Handlers      		--
------------------------------
function module:Event(msg)
	local _, _, name, detect = string.find(msg, L["trigger_mortalStrike"])
	if name and detect and self.db.profile.ms then
		self.MS = name
		self.lastMS = GetTime()

		if detect == L["misc_are"] then
			self:MortalStrike(UnitName("player"))
		else
			self:MortalStrike(name)
		end
	elseif string.find(msg, L["trigger_blastWave"]) then
		if GetTime() - self.lastBlastWave > 5 then
			self:BlastWave()
			--self:ScheduleEvent("BigWigs_Message", 24, L["msg_blastWave"], "Urgent", true, "Alert")
		end
		self.lastBlastWave = GetTime()
	end
end

--[[function module:CHAT_MSG_COMBAT_FRIENDLY_DEATH(msg)
	if not self.db.profile.bw then return end
	local _, _, deathother = string.find(msg, L["trigger_deathOther"])
	if msg == L["trigger_deathYou"] then
		self:RemoveBar(string.format(L["bar_mortalStrike"], UnitName("player")))
	elseif deathother then
		self:RemoveBar(string.format(L["bar_mortalStrike"], deathother))
	end
end]]

function module:PLAYER_TARGET_CHANGED()
	if (self.lastMS + 5) > GetTime() and UnitName("target") == self.MS then
		if self.db.profile.ms then
			self:WarningSign(icon.mortalStrike, (self.lastMS + 5) - GetTime())
		end
	else
		self:RemoveWarningSign(icon.mortalStrike)
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
	module:Event(L["trigger_mortalStrike"])
	module:Event(L["trigger_blastWave"])
	module:PLAYER_TARGET_CHANGED()

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
