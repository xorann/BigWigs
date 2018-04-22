------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.noth
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"blink", "teleport", "curse", "wave", "bosskill"}


-- locals
module.timer = {
	firstBlink = 25,
	secondBlink = 9,
	thirdBlink = 25,
    regularBlink = 25,
    
	blinkAfterTeleport = 0, -- will be changed during the encounter
	
	firstToRoom = 72, --78 --70
	secondToRoom = 93, --93 --90 
	thirdToRoom = 124, --124 --120,
	toRoom = 0, -- will be changed during the encounter
    
	firstToBalcony = 92,
	secondToBalcony = 113, --112 --110
	thirdToBalcony = 185, --185 --180, -- ??
	toBalcony = 0, -- will be changed during the encounter
    
	firstCurse = 10,
    secondCurse = 10,
    thirdCurse = 29,
    curseAfterTeleport = 0, -- will be changed during the encounter
    curse = 44.5,
    
	wave1 = 12,
	wave2 = 0,
	wave2_1 = 46,
	wave2_2 = 58,
	wave2_3 = 46,
	--wave3 = 80,
}
local timer = module.timer

module.icon = {
	toBalcony = "Spell_Magic_LesserInvisibilty",
	toRoom = "Spell_Magic_LesserInvisibilty",
	blink = "Spell_Arcane_Blink",
	wave = "Spell_ChargePositive",
	curse = "Spell_Shadow_AnimateDead",
}
local icon = module.icon

module.syncName = {
	blink = "NothBlink",
	curse = "NothCurse",
    teleportToBalcony = "NothTeleportToBalcony",
    teleportToRoom = "NothTeleportToRoom",
}
local syncName = module.syncName


module.phase = nil
module.phases = {
	firstRoom = "firstRoom",
	firstBalcony = "firstBalcony",
	secondRoom = "secondRoom",
	secondBalcony = "secondBalcony",
	thirdRoom = "thirdRoom",
	thirdBalcony = "thirdBalcony"
}

------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.curse then
		self:Curse()
	elseif sync == syncName.blink then
		self:Blink()
	elseif sync == syncName.teleportToBalcony then
        self:TeleportToBalcony()
    elseif sync == syncName.teleportToRoom then
        self:TeleportToRoom()
    end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Curse()
	if self.db.profile.curse then
		self:Message(L["msg_curse"], "Important", nil, "Alarm")
		--self:DelayedMessage(timer.curse - 10, L["msg_curse10"], "Urgent")
		self:Bar(L["bar_curse"], timer.curse, icon.curse)
	end
end

function module:Blink()
	if self.db.profile.blink then
		self:Message(L["msg_blinkNow"], "Important", false, "Beware")
		--self:DelayedMessage(timer.regularBlink - 10, L["msg_blink10"], "Attention")
		--self:DelayedMessage(timer.regularBlink - 5, L["msg_blink5"], "Attention")
		self:Bar(L["bar_blink"], timer.regularBlink, icon.blink, true, BigWigsColors.db.profile.significant)
		self:DelayedSound(timer.regularBlink - 5, "Five") 
		self:DelayedSound(timer.regularBlink - 4, "Four") 
		self:DelayedSound(timer.regularBlink - 3, "Three") 
		self:DelayedSound(timer.regularBlink - 2, "Two") 
		self:DelayedSound(timer.regularBlink - 1, "One") 
	end
	
	-- aggro reset?
    self:KTM_Reset()
end

function module:TeleportToBalcony()
	--self:CancelDelayedMessage(L["msg_teleport10"])
	--self:CancelDelayedMessage(L["msg_teleport30"])
	--self:CancelDelayedMessage(L["msg_curse10"])
	
	self:CancelDelayedSound("Five") 
	self:CancelDelayedSound("Four") 
	self:CancelDelayedSound("Three") 
	self:CancelDelayedSound("Two") 
	self:CancelDelayedSound("One") 
	
	self:CancelScheduledEvent("bwnothtobalcony")
	self:RemoveBar(L["bar_teleport"])
	self:RemoveBar(L["bar_blink"])
	self:RemoveBar(L["bar_curse"])

	if self.db.profile.teleport then 
		self:Message(L["msg_teleportNow"], "Important")
		self:Bar(L["bar_back"], timer.toRoom, icon.toRoom)
		--self:DelayedMessage(timer.toRoom - 30, L["msg_back30"], "Urgent")
		--self:DelayedMessage(timer.toRoom - 10, L["msg_back10"], "Urgent")
	end
	if self.db.profile.wave then
		self:Bar(L["bar_wave1"], timer.wave1, icon.wave )
		self:Bar(L["bar_wave2"], timer.wave2, icon.wave )
		--self:Bar(L["bar_wave3"], timer.wave3, icon.wave )
		--self:DelayedMessage(timer.wave2 - 10, L["msg_wave2Soon"], "Urgent")
		--self:DelayedMessage(timer.wave2, L["msg_wave2Now"], "Urgent")
	end
	
	-- setup timers for the next round
	if module.phase == module.phases.firstRoom then
		timer.toBalcony = timer.secondToBalcony
		timer.blinkAfterTeleport = timer.secondBlink
        timer.curseAfterTeleport = timer.secondCurse
		timer.wave2 = timer.wave2_2
		
		module.phase = module.phases.firstBalcony
	elseif module.phase == module.phases.secondRoom then
		timer.toBalcony = timer.thirdToBalcony
		timer.blinkAfterTeleport = timer.thirdBlink -- 2nd teleport to balcony
        timer.curseAfterTeleport = timer.thirdCurse
		
		module.phase = module.phases.secondBalcony
	elseif module.phase == module.phases.thirdRoom then
		-- ???
		module.phase = module.phases.thirdBalcony
	end
	
	self:CancelScheduledEvent("bwnothtoroom")
	self:ScheduleEvent("bwnothtoroom", self.TeleportToRoom, timer.toRoom, self) -- fallback
end

function module:TeleportToRoom()
	if module.phase == module.phases.firstBalcony then
		timer.toRoom = timer.secondToRoom
		
		module.phase = module.phases.secondRoom
	elseif module.phase == module.phases.secondBalcony then
		timer.toRoom = timer.thirdToRoom
		
		module.phase = module.phases.thirdRoom
	end

	self:CancelScheduledEvent("bwnothtoroom")
	self:RemoveBar(L["bar_back"])
	self:RemoveBar(L["bar_wave1"])
	self:RemoveBar(L["bar_wave2"])
	
	if self.db.profile.teleport then
		self:Message(string.format(L["msg_backNow"], timer.toBalcony), "Important")
		self:Bar(L["bar_blink"], timer.blinkAfterTeleport, icon.blink, true, BigWigsColors.db.profile.significant)
		--self:DelayedMessage(timer.blinkAfterTeleport - 10, L["msg_blink10"], "Attention") -- praeda
		--self:DelayedMessage(timer.blinkAfterTeleport - 5, L["msg_blink5"], "Attention") -- praeda
		
		self:Bar(L["bar_teleport"], timer.toBalcony, icon.toBalcony)
		--self:DelayedMessage(timer.toBalcony - 30, L["msg_teleport30"], "Urgent")
		--self:DelayedMessage(timer.toBalcony - 10, L["msg_teleport10"], "Urgent")
	end
    if self.db.profile.curse then
        self:Bar(L["bar_curse"], timer.curseAfterTeleport, icon.curse)
    end
    
	self:CancelScheduledEvent("bwnothtobalcony")
	self:ScheduleEvent("bwnothtobalcony", self.TeleportToBalcony, timer.toBalcony, self) -- fallback
    
    self:KTM_Reset()
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:TeleportToRoom()
	module:TeleportToBalcony()
	module:Blink()
	module:Curse()
	
	module:BigWigs_RecvSync(syncName.curse)
	module:BigWigs_RecvSync(syncName.blink)
	module:BigWigs_RecvSync(syncName.teleportToBalcony)
	module:BigWigs_RecvSync(syncName.teleportToRoom)
end
