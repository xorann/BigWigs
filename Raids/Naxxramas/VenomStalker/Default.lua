--[[
    Created by Vnm-Kronos - https://github.com/Vnm-Kronos
    modified by Dorann
--]]

local bossName = BigWigs.bossmods.naxx.venomstalker
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
module.revision = 20015 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300

local venomstalker = AceLibrary("Babble-Boss-2.2")["Venom Stalker"]
local necrostalker = AceLibrary("Babble-Boss-2.2")["Necro Stalker"]

------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:CombatlogFilter(L["trigger_charge"], self.ChargeEvent)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	
	module.deathCount = 0
	module.chargeNumber = 1
	module.lastCharge = nil
	module.poisonsOnSelf = 0
end

-- called after boss is engaged
function module:OnEngage()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:ChargeEvent(msg)
	local _,_, name, verb = string.find(msg, L["trigger_charge"])
	if verb == L["misc_are"] or verb == L["misc_is"] then
		self:Sync(syncName.charge)
	end
end

--[[function module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
	if string.find(msg, L["trigger_chargeGone"]) then
		poisonsOnSelf = poisonsOnSelf - 1
		if poisonsOnSelf == 0 then
			self:RemoveWarningSign(icon.charge)
		end
	end
end]]
		
function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, venomstalker) or
		msg == string.format(UNITDIESOTHER, necrostalker) then
		
		self:Sync(syncName.death, msg)
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
	module:ChargeEvent(string.format(L["trigger_charge"], L["misc_You"], L["misc_are"]))
	module:ChargeEvent(string.format(L["trigger_charge"], "Someone", L["misc_is"]))
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(string.format(UNITDIESOTHER, venomstalker))
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(string.format(UNITDIESOTHER, necrostalker))
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual(long)
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
