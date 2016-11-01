
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Thaddius", "Naxxramas")
local feugen = AceLibrary("Babble-Boss-2.2")["Feugen"]
local stalagg = AceLibrary("Babble-Boss-2.2")["Stalagg"]

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Thaddius",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	phase_cmd = "phase",
	phase_name = "Phase Alerts",
	phase_desc = "Warn for Phase transitions",

	polarity_cmd = "polarity",
	polarity_name = "Polarity Shift Alert",
	polarity_desc = "Warn for polarity shifts",

	power_cmd = "power",
	power_name = "Power Surge Alert",
	power_desc = "Warn for Stalagg's power surge",

	adddeath_cmd = "adddeath",
	adddeath_name = "Add Death Alert",
	adddeath_desc = "Alerts when an add dies.",

	charge_cmd = "charge",
	charge_name = "Charge Alert",
	charge_desc = "Warn about Positive/Negative charge for yourself only.",

	throw_cmd = "throw",
	throw_name = "Throw Alerts",
	throw_desc = "Warn about tank platform swaps.",

	enragetrigger = "%s goes into a berserker rage!",
	starttrigger = "Stalagg crush you!",
	starttrigger1 = "Feed you to master!",
	trigger_phase2_1 = "EAT YOUR BONES",
	trigger_phase2_2 = "BREAK YOU!",
	trigger_phase2_3 = "KILL!",

	adddeath = "No... more... Feugen...",
	adddeath2 = "Master save me...",

	teslaoverload = "%s overloads!",

	pstrigger = "Now YOU feel pain!",
	trigger_polarity_cast = "Thaddius begins to cast Polarity Shift",
	chargetrigger = "You are afflicted by (%w+) Charge.",
	positivetype = "Spell_ChargePositive",
	negativetype = "Spell_ChargeNegative",
	stalaggtrigger = "Stalagg gains Power Surge.",

	you = "You",
	are = "are",

	enragewarn = "Enrage!",
	startwarn = "Thaddius Phase 1",
	startwarn2 = "Thaddius Phase 2, Enrage in 5 minutes!",
	addsdownwarn = "Thaddius incoming in 10-20sec!",
	pswarn1 = "Thaddius begins to cast Polarity Shift! - CHECK DEBUFF!",
	pswarn2 = "30 seconds to Polarity Shift!",
	pswarn3 = "3 seconds to Polarity Shift!",
	poswarn = "You changed to a Positive Charge!",
	negwarn = "You changed to a Negative Charge!",
	nochange = "Your debuff did not change!",
	polaritytickbar = "Polarity tick",
	enragebartext = "Enrage",
	warn_enrage_3m = "Enrage in 3 minutes",
	warn_enrage_90 = "Enrage in 90 seconds",
	warn_enrage_60 = "Enrage in 60 seconds",
	warn_enrage_30 = "Enrage in 30 seconds",
	warn_enrage_10 = "Enrage in 10 seconds",
	stalaggwarn = "Power Surge on Stalagg!",
	powersurgebar = "Power Surge",

	bar1text = "Polarity Shift",

	throwbar = "Throw",
	throwwarn = "Throw in ~5 seconds!",
} end )

---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20003 -- To be overridden by the module!
module.enabletrigger = {module.translatedName, feugen, stalagg} -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"enrage", "charge", "polarity", -1, "power", "throw", "phase", "bosskill"}


-- locals
local timer = {
	throw = 21,
	powerSurge = 10,
	enrage = 300,
	polarityTick = 6,
	polarityShift = 30,
}
local icon = {
	throw = "Ability_Druid_Maul",
	powerSurge = "Spell_Shadow_UnholyFrenzy",
	enrage = "Spell_Shadow_UnholyFrenzy",
	polarityShift = "Spell_Nature_Lightning",
}
local syncName = {
	powerSurge = "StalaggPower",
	phase2 = "ThaddiusPhaseTwo",
	adddied = "ThaddiusAddDeath",
	polarity = "ThaddiusPolarity",
	enrage = "ThaddiusEnrage",
}


------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["starttrigger"])
module:RegisterYellEngage(L["starttrigger1"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "CheckStalagg")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "PolarityCast")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "PolarityCast")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "CheckForEnrage")
	
	self:ThrottleSync(10, syncName.polarity)
	self:ThrottleSync(4, syncName.powerSurge)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.started = nil
	self.enrageStarted = nil
	self.addsdead = 0
	self.teslawarn = nil
	self.stage1warn = nil
	self.previousCharge = ""
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.phase and not self.stage1warn then
		self:Message(L["startwarn"], "Important")
	end
	self.stage1warn = true
	self:Throw()
	self:ScheduleRepeatingEvent("bwthaddiusthrow", self.Throw, timer.throw, self)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers	    --
------------------------------

function module:CheckStalagg(msg)
	if msg == L["stalaggtrigger"] then
		self:Sync(syncName.powerSurge)
	end
end

function module:CHAT_MSG_MONSTER_YELL( msg )
	if string.find(msg, L["pstrigger"]) then
		self:Sync(syncName.polarity)	
	elseif msg == L["adddeath"] or msg == L["adddeath2"] then
		self:Sync(syncName.adddied)
	elseif string.find(msg, L["trigger_phase2_1"]) or string.find(msg, L["trigger_phase2_2"]) or string.find(msg, L["trigger_phase2_3"]) then
		self:Sync(syncName.phase2)
	end
end

function module:CheckForEnrage(msg)
	if msg == L["enragetrigger"] then
		self:Sync(syncName.enrage)
	end
end

function module:PolarityCast(msg)
	if self.db.profile.polarity and string.find(msg, L["trigger_polarity_cast"]) then
		self:Message(L["pswarn1"], "Important")
	end
end

function module:PLAYER_AURAS_CHANGED(msg)
	local chargetype = nil
	local iIterator = 1
	while UnitDebuff("player", iIterator) do
		local texture, applications = UnitDebuff("player", iIterator)
		if texture == L["positivetype"] or texture == L["negativetype"] then
			-- If we have a debuff with this texture that has more
			-- than one application, it means we still have the
			-- counter debuff, and thus nothing has changed yet.
			-- (we got a PW:S or Renew or whatever after he casted
			--  PS, but before we got the new debuff)
			if applications > 1 then 
				return 
			end
			chargetype = texture
			-- Note that we do not break out of the while loop when
			-- we found a debuff, since we still have to check for
			-- debuffs with more than 1 application.
		end
		iIterator = iIterator + 1
	end
	if not chargetype then return end

	self:UnregisterEvent("PLAYER_AURAS_CHANGED")

	self:NewPolarity(chargetype)
end

function module:NewPolarity(chargetype)
    if self.db.profile.charge then
		if self.previousCharge and self.previousCharge == chargetype then
			self:Message(L["nochange"], "Urgent", true, "Long")
		elseif chargetype == L["positivetype"] then
			self:Message(L["poswarn"], "Positive", true, "RunAway")
			self:WarningSign(chargetype, 5)
		elseif chargetype == L["negativetype"] then
			self:Message(L["negwarn"], "Important", true, "RunAway")
			self:WarningSign(chargetype, 5)
		end
		self:Bar(L["polaritytickbar"], timer.polarityTick, chargetype, "Important")
	end
	self.previousCharge = chargetype
end

------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.powerSurge then
		self:PowerSurge()
	elseif sync == syncName.adddied then
		self:AddDied()
	elseif sync == syncName.phase2 then
		self:Phase2()
	elseif sync == syncName.polarity then
		self:PolarityShift()
	elseif sync == syncName.enrage then
		self:Enrage()
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:PowerSurge()
	if self.db.profile.power then
		self:Message(L["stalaggwarn"], "Important")
		self:Bar(L["powersurgebar"], timer.powerSurge, icon.powerSurge)
	end
end

function module:AddDied()
	self.addsdead = self.addsdead + 1
	if self.addsdead == 2 then
		if self.db.profile.phase then 
			self:Message(L["addsdownwarn"], "Attention") 
		end
		self:CancelScheduledEvent("bwthaddiusthrow")
		self:CancelDelayedMessage(L["throwwarn"])
	end
end

function module:Phase2()
    self:RemoveBar(L["throwbar"])
    self:CancelDelayedMessage(L["throwwarn"])
    self:CancelScheduledEvent("bwthaddiusthrow")
    
	if self.db.profile.phase then 
		self:Message(L["startwarn2"], "Important") 
	end
	if self.db.profile.enrage then
		self:Bar(L["enragebartext"], timer.enrage, icon.enrage)
		self:DelayedMessage(timer.enrage - 3 * 60, L["warn_enrage_3m"], "Attention")
		self:DelayedMessage(timer.enrage - 90, L["warn_enrage_90"], "Attention")
		self:DelayedMessage(timer.enrage - 60, L["warn_enrage_60"], "Urgent")
		self:DelayedMessage(timer.enrage - 30, L["warn_enrage_30"], "Important")
		self:DelayedMessage(timer.enrage - 10, L["warn_enrage_10"], "Important")
	end
end

function module:PolarityShift()
	if self.db.profile.polarity then
		self:RegisterEvent("PLAYER_AURAS_CHANGED")
		self:DelayedMessage(timer.polarityShift - 3, L["pswarn3"], "Important", nil, "Beware")
		self:Bar(L["bar1text"], timer.polarityShift, icon.polarityShift)
	end
end

function module:Enrage()
	if self.db.profile.enrage then 
		self:Message(L["enragewarn"], "Important") 
	end
	
	self:RemoveBar(L["enragebartext"])
	
	self:CancelDelayedMessage(L["warn_enrage_3m"])
	self:CancelDelayedMessage(L["warn_enrage_90"])
	self:CancelDelayedMessage(L["warn_enrage_60"])
	self:CancelDelayedMessage(L["warn_enrage_30"])
	self:CancelDelayedMessage(L["warn_enrage_10"])
end

------------------------------
--      Utility	Functions   --
------------------------------

function module:Throw()
	if self.db.profile.throw then
		self:Bar(L["throwbar"], timer.throw, icon.throw)
		self:DelayedMessage(timer.throw - 5, L["throwwarn"], "Urgent")
	end
end


------------------------------
--      Test                --
------------------------------

function module:Test(long)
    -- /run local m=BigWigs:GetModule("Thaddius");m:Test()
    
	local function testPhase2()
		module:CHAT_MSG_MONSTER_YELL(L["trigger_phase2_1"])
        BigWigs:Print("  testPhase2")
    end
	local function testPolarityShiftPositive()
		module:NewPolarity(L["positivetype"])
	end
    local function testPolarityShiftNegative()
		module:NewPolarity(L["negativetype"])
	end
	local function testDisable()
		--module:SendWipeSync()
		BigWigs:TriggerEvent("BigWigs_RebootModule", self:ToString())
		BigWigs:DisableModule(module:ToString())
        BigWigs:Print("  testDisable")
	end
    
    if long then
        local testTimer = 0
        self:SendEngageSync()

        -- phase2
        testTimer = testTimer + 10
        self:ScheduleEvent(self:ToString() .. "testPhase2", testPhase2, testTimer, self)
        BigWigs:Print(" testPhase2 in " .. testTimer)

        -- polarity shift 1
        testTimer = testTimer + 5
        self:ScheduleEvent(self:ToString() .. "testPolarityShiftPositive", testPolarityShiftPositive, testTimer, self)
        BigWigs:Print(" testPolarityShiftPositive1 in " .. testTimer)

        -- polarity shift 2
        testTimer = testTimer + 30
        self:ScheduleEvent(self:ToString() .. "testPolarityShiftPositive2", testPolarityShiftPositive, testTimer, self)
        BigWigs:Print(" testPolarityShiftPositive2 in " .. testTimer)

        -- polarity shift 3
        testTimer = testTimer + 30
        self:ScheduleEvent(self:ToString() .. "testPolarityShiftNegative", testPolarityShiftNegative, testTimer, self)
        BigWigs:Print(" testPolarityShiftNegative in " .. testTimer)

        -- disable
        testTimer = testTimer + 5
        self:ScheduleEvent(self:ToString() .. "testDisable", testDisable, testTimer, self)
        BigWigs:Print(" testDisable in " .. testTimer)
    else
        local testTimer = 0
        self:SendEngageSync()

        -- phase2
        testTimer = testTimer + 5
        self:ScheduleEvent(self:ToString() .. "testPhase2", testPhase2, testTimer, self)
        BigWigs:Print(" testPhase2 in " .. testTimer)

        -- polarity shift 1
        testTimer = testTimer + 5
        self:ScheduleEvent(self:ToString() .. "testPolarityShiftPositive", testPolarityShiftPositive, testTimer, self)
        BigWigs:Print(" testPolarityShiftPositive1 in " .. testTimer)

        -- polarity shift 2
        testTimer = testTimer + 5
        self:ScheduleEvent(self:ToString() .. "testPolarityShiftPositive2", testPolarityShiftPositive, testTimer, self)
        BigWigs:Print(" testPolarityShiftPositive2 in " .. testTimer)

        -- polarity shift 3
        testTimer = testTimer + 5
        self:ScheduleEvent(self:ToString() .. "testPolarityShiftNegative", testPolarityShiftNegative, testTimer, self)
        BigWigs:Print(" testPolarityShiftNegative in " .. testTimer)

        -- disable
        testTimer = testTimer + 5
        self:ScheduleEvent(self:ToString() .. "testDisable", testDisable, testTimer, self)
        BigWigs:Print(" testDisable in " .. testTimer)
    end
end
