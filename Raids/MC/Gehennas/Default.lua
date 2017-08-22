local bossName = BigWigs.bossmods.mc.gehennas
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
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",        "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE",            "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_FRIENDLYPLAYER_DAMAGE",  "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE",              "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE",     "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",               "Event")
    self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	
	self:ThrottleSync(10, syncName.curse)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.flamewaker = 0
	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.curse then
		self:DelayedMessage(timer.firstCurse - 5, L["msg_curseSoon"], "Urgent", nil, nil, true)
		self:Bar(L["bar_curse"], timer.firstCurse, icon.curse)
	end
	--self:Bar(L["bar_rain"], timer.firstRain, icon.rain)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:Event(msg)
    if string.find(msg, L["trigger_rainRun"]) then
        if self.db.profile.rain then
            -- I found no better way to trigger this, it will autohide after 2s which is the time between Rain of Fire ticks
            self:WarningSign(icon.rain, timer.rainTick)
            self:DebugMessage("warning sign tick")
        end
    elseif ((string.find(msg, L["trigger_curseHit"])) or (string.find(msg, L["trigger_curseResist"]))) then
		self:Sync(syncName.curse)
	elseif (string.find(msg, L["trigger_rain"])) then
        -- this will not trigger, but I will leave it in case they fix this combatlog event/message
        if self.db.profile.rain then
            self:Message(L["msg_fire"], "Attention", true, "Alarm")
            self:WarningSign(icon.rain, timer.rainDuration)
            self:DebugMessage("warning sign normal")
            --self:DelayedBar(timer.rainDuration, L["bar_rain"], timer.nextRain - timer.rainDuration, icon.rain) -- variance too high
        end
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
    if string.find(msg, L["Rain of Fire"]) then
        -- this will not trigger, but I will leave it in case they fix this combatlog event/message
        self:RemoveWarningSign(icon.rain)
        self:DebugMessage("remove warning sign")
    end
end

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	BigWigs:CheckForBossDeath(msg, self)
	
	if string.find(msg, L["trigger_addDeath"]) then
		self:Sync(syncName.add .. " " .. tostring(module.flamewaker + 1))
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
	module:Event(L["trigger_rainRun"])
	module:Event(L["trigger_curseHit"])
	module:Event(L["trigger_curseResist"])
	module:Event(L["trigger_rain"])
	module:CHAT_MSG_SPELL_AURA_GONE_SELF(L["Rain of Fire"])
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(L["trigger_addDeath"])
		
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
