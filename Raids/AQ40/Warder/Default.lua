local bossName = BigWigs.bossmods.aq40.warder
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

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")

	if not module.warnings then
		module.warnings = {
			["dust"] = {L["msg_dust"], L["msg_rootsFear"]},
			["roots"] = {L["msg_Roots"], L["msg_silenceDust2"]},
			["fear"] = {L["msg_fear"], L["msg_silenceDust"]},
			["silence"] = {L["msg_silence"], L["msg_rootsFear2"]},
		}
	end

	self:ThrottleSync(10, syncName.fear)
	self:ThrottleSync(10, syncName.silence)
	self:ThrottleSync(10, syncName.roots)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
	self.ability1 = nil
	self.ability2 = nil

	self:Bar("First Ability", timer.firstAbility, icon.unknown)
	self:Bar("Second Ability", timer.secondAbility, icon.unknown)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
-- Event Handlers      		--
------------------------------
function module:Event(msg)
	if string.find(msg, L["trigger_fear"]) then
		self:Sync(syncName.fear)
	elseif string.find(msg, L["trigger_silence"]) then
		self:Sync(syncName.silence)
	elseif string.find(msg, L["trigger_roots"]) then
		self:Sync(syncName.roots)
	elseif string.find(msg, L["trigger_dust"]) then
		self:Sync(syncName.dust)
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
	module:Event(L["trigger_fear"])
	module:Event(L["trigger_silence"])
	module:Event(L["trigger_roots"])
	module:Event(L["trigger_dust"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
