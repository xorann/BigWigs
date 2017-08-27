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
	
	firstRoom = 88,
	secondRoom = 108,
	thirdRoom = 178,
	room = 0, -- will be changed during the encounter
    
	firstBalcony = 70,
	secondBalcony = 90,
	thirdBalcony = 120, -- ??
	balcony = 0, -- will be changed during the encounter
    
	firstCurse = 10,
    secondCurse = 10,
    thirdCurse = 35,
    curseAfterTeleport = 0, -- will be changed during the encounter
    curse = 44.5,
    
	wave1 = 13,
	wave2 = 44,
	--wave3 = 80,
}
local timer = module.timer

module.icon = {
	balcony = "Spell_Magic_LesserInvisibilty",
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
		self:Message(L["msg_blinkNow"], "Important")
		--self:DelayedMessage(timer.regularBlink - 10, L["msg_blink10"], "Attention")
		--self:DelayedMessage(timer.regularBlink - 5, L["msg_blink5"], "Attention")
		self:Bar(L["bar_blink"], timer.regularBlink, icon.blink)
	end
	
	-- aggro reset?
    self:KTM_Reset()
end

function module:TeleportToBalcony()
	if timer.room == timer.firstRoom then
		timer.room = timer.secondRoom
		timer.blinkAfterTeleport = timer.secondBlink
        timer.curseAfterTeleport = timer.secondCurse
	elseif timer.room == timer.secondRoom then
		timer.room = timer.thirdRoom
		timer.blinkAfterTeleport = timer.thirdBlink -- 2nd teleport to balcony
        timer.curseAfterTeleport = timer.thirdCurse
	end

	--self:CancelDelayedMessage(L["msg_teleport10"])
	--self:CancelDelayedMessage(L["msg_teleport30"])
	--self:CancelDelayedMessage(L["msg_curse10"])
	
	self:RemoveBar(L["bar_blink"])
	self:RemoveBar(L["bar_curse"])

	if self.db.profile.teleport then 
		self:Message(L["msg_teleportNow"], "Important")
		self:Bar(L["bar_back"], timer.balcony, icon.balcony)
		--self:DelayedMessage(timer.balcony - 30, L["msg_back30"], "Urgent")
		--self:DelayedMessage(timer.balcony - 10, L["msg_back10"], "Urgent")
	end
	if self.db.profile.wave then
		self:Bar(L["bar_wave1"], timer.wave1, icon.wave )
		self:Bar(L["bar_wave2"], timer.wave2, icon.wave )
		--self:Bar(L["bar_wave3"], timer.wave3, icon.wave )
		--self:DelayedMessage(timer.wave2 - 10, L["msg_wave2Soon"], "Urgent")
		--self:DelayedMessage(timer.wave2, L["msg_wave2Now"], "Urgent")
	end
	--self:ScheduleEvent("bwnothtoroom", self.TeleportToRoom, timer.balcony, self)
end

function module:TeleportToRoom()
	if timer.balcony == timer.firstBalcony then
		timer.balcony = timer.secondBalcony
	elseif timer.balcony == timer.secondBalcony then
		timer.balcony = timer.thirdBalcony
	end

	if self.db.profile.teleport then
		self:Message(string.format(L["msg_backNow"], timer.room), "Important")
		self:Bar(L["bar_blink"], timer.blinkAfterTeleport, icon.blink)
		--self:DelayedMessage(timer.blinkAfterTeleport - 10, L["msg_blink10"], "Attention") -- praeda
		--self:DelayedMessage(timer.blinkAfterTeleport - 5, L["msg_blink5"], "Attention") -- praeda
		
		self:Bar(L["bar_teleport"], timer.room, icon.balcony)
		--self:DelayedMessage(timer.room - 30, L["msg_teleport30"], "Urgent")
		--self:DelayedMessage(timer.room - 10, L["msg_teleport10"], "Urgent")
	end
    if self.db.profile.curse then
        self:Bar(L["bar_curse"], timer.curseAfterTeleport, icon.curse)
    end
    
	--self:ScheduleEvent("bwnothtobalcony", self.TeleportToBalcony, timer.room, self)
    
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
