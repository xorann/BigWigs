local bossName = BigWigs.bossmods.naxx.maexxna
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
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "EnrageEvent")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "SprayEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "SprayEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "SprayEvent")

	self:ThrottleSync(8, syncName.webspray)
	self:ThrottleSync(5, syncName.poison)
	self:ThrottleSync(0, syncName.cocoon)
	-- the MaexxnaCocoon sync is left unthrottled, it's throttled inside the module itself
	-- because the web wrap happens to a lot of players at once.
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.enrageannounced = false
	module.times = {}
end

-- called after boss is engaged
function module:OnEngage()
	self:Webspray()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:SprayEvent(msg)
	-- web spray warning
	if string.find(msg, L["trigger_webSpray"]) then
		self:Sync(syncName.webspray)
	elseif string.find(msg, L["trigger_poison"]) then
		self:Sync(syncName.poison)
	elseif string.find(msg, L["trigger_cocoon"]) then
		local _,_,wplayer,wtype = string.find(msg, L["trigger_cocoon"])
		if wplayer and wtype then
			if wplayer == L["misc_you"] and wtype == L["misc_are"] then
				wplayer = UnitName("player")
			end
			local t = GetTime()
			if (not module.times[wplayer]) or (module.times[wplayer] and (module.times[wplayer] + 10) < t) then
				self:Sync(syncName.cocoon .. " " .. wplayer)
			end
		end
	end
end

function module:UNIT_HEALTH(msg)
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if (health > 30 and health <= 33 and not module.enrageannounced) then
			self:Sync(syncName.enrage)
			module.enrageannounced = true
		elseif (health > 40 and module.enrageannounced) then
			module.enrageannounced = false
		end
	end
end

function module:EnrageEvent(msg)
	if string.find(msg, L["trigger_enrage"]) then
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
	module:EnrageEvent(L["trigger_enrage"])
	module:SprayEvent(L["trigger_webSpray"])
	module:SprayEvent(L["trigger_poison"])
	module:SprayEvent(L["trigger_cocoon"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
