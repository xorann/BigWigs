
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Noth the Plaguebringer", "Naxxramas")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Noth",

	blink_cmd = "blink",
	blink_name = "Blink Alert",
	blink_desc = "Warn for blink",

	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for teleport",

	curse_cmd = "curse",
	curse_name = "Curse Alert",
	curse_desc = "Warn for curse",

	wave_cmd = "wave",
	wave_name = "Wave Alert",
	wave_desc = "Warn for waves",

	starttrigger1 = "Die, trespasser!",
	starttrigger2 = "Glory to the master!",
	starttrigger3 = "Your life is forfeit!",
	startwarn = "Noth the Plaguebringer engaged! 90 seconds till teleport",

	addtrigger = "Rise, my soldiers! Rise and fight once more!",

	blinktrigger = "Noth the Plaguebringer gains Blink.",
	blinkwarn = "Blink!",
	blinkwarn5 = "Blink in ~5 seconds!",
	blinkwarn10 = "Blink in ~10 seconds!",
	blinkbar = "Blink",

	teleportwarn = "Teleport! He's on the balcony!",
	teleportwarn10 = "Teleport in 10 seconds!",
	teleportwarn30 = "Teleport in 30 seconds!",

	teleportbar = "Teleport!",
	backbar = "Back in room!",

	backwarn = "He's back in the room for %d seconds!",
	backwarn10 = "10 seconds until he's back in the room!",
	backwarn30 = "30 seconds until he's back in the room!",

	cursetrigger = "afflicted by Curse of the Plaguebringer",
	cursewarn = "Curse! next in ~28 seconds",
	curse10secwarn = "Curse in ~10 seconds",

	cursebar = "Next Curse",

	wave1bar = "Wave 1",
	wave2bar = "Wave 2",
	wave3bar = "Wave 3",
	wave2_message = "Wave 2 in 10sec",
	wave2s_message = "Wave 2 Spawning!",
} end )


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20003 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"blink", "teleport", "curse", "wave", "bosskill"}


-- locals
local timer = {
	firstBlink = 25,
	secondBlink = 11,
	thirdBlink = 22,
	blinkAfterTeleport = 0, -- will be changed during the encounter
	regularBlink = 25,
	firstRoom = 90,
	secondRoom = 110,
	thirdRoom = 180,
	room = 0, -- will be changed during the encounter
	firstBalcony = 70,
	secondBalcony = 95,
	thirdBalcony = 120,
	balcony = 0, -- will be changed during the encounter
	curse = 28,
	wave1 = 5,
	wave2 = 41,
	wave3 = 80,
}
local icon = {
	balcony = "Spell_Magic_LesserInvisibilty",
	blink = "Spell_Arcane_Blink",
	wave = "Spell_ChargePositive",
	curse = "Spell_Shadow_AnimateDead",
}
local syncName = {
	blink = "NothBlink",
	curse = "NothCurse",
}

local berserkannounced = nil

------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["starttrigger1"])
module:RegisterYellEngage(L["starttrigger2"])
module:RegisterYellEngage(L["starttrigger3"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "CheckForBlink")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckForCurse")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckForCurse")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckForCurse")
	
	self:ThrottleSync(5, syncName.blink)
	self:ThrottleSync(5, syncName.curse)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	timer.blinkAfterTeleport = timer.firstBlink -- sets timer for first blink after first balcony
	timer.room = timer.firstRoom
	timer.balcony = timer.firstBalcony
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.teleport then
		self:Message(L["startwarn"], "Important")
		self:Bar(L["teleportbar"], timer.room, icon.balcony)
		self:DelayedMessage(timer.room - 30, L["teleportwarn30"], "Urgent")
		self:DelayedMessage(timer.room - 10, L["teleportwarn10"], "Urgent")
	end
	if self.db.profile.blink then
		self:Bar(L["blinkbar"], timer.blinkAfterTeleport, icon.blink)
		self:DelayedMessage(timer.blinkAfterTeleport - 10, L["blinkwarn10"], "Attention")
		self:DelayedMessage(timer.blinkAfterTeleport - 5, L["blinkwarn5"], "Attention")
	end

	self:ScheduleEvent("bwnothtobalcony", self.TeleportToBalcony, timer.room, self)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


--[[
90s  room
25s  blink
50s  blink
70s  balcony
110s room
22s  blink
47s  blink
72s  blink
95s  balcony
180s room
11s  blink
36s  blink
61s  blink
86s  blink
111s blink
120s balcony
??s  room
??s  blink
]]

------------------------------
--      Initialization      --
------------------------------

function module:CheckForCurse(msg)
	if string.find(msg, L["cursetrigger"]) then
		self:Sync(syncName.curse)
	end
end

function module:CheckForBlink(msg)
	if msg == L["blinktrigger"] then
		self:Sync(syncName.blink)
	end
end

function module:TeleportToBalcony()
	if timer.room == timer.firstRoom then
		timer.room = timer.secondRoom
		timer.blinkAfterTeleport = timer.secondBlink
	elseif timer.room == timer.secondRoom then
		timer.room = timer.thirdRoom
		timer.blinkAfterTeleport = timer.thirdBlink -- 2nd teleport to balcony
	end

	self:CancelDelayedMessage(L["teleportwarn10"])
	self:CancelDelayedMessage(L["teleportwarn30"])
	self:CancelDelayedMessage(L["curse10secwarn"])
	
	self:RemoveBar(L["blinkbar"])
	self:RemoveBar(L["cursebar"])

	if self.db.profile.teleport then 
		self:Message(L["teleportwarn"], "Important")
		self:Bar(L["backbar"], timer.balcony, icon.balcony)
		self:DelayedMessage(timer.balcony - 30, L["backwarn30"], "Urgent")
		self:DelayedMessage(timer.balcony - 10, L["backwarn10"], "Urgent")
	end
	if self.db.profile.wave then
		self:Bar(L["wave1bar"], timer.wave1, icon.wave )
		self:Bar(L["wave2bar"], timer.wave2, icon.wave )
		self:Bar(L["wave3bar"], timer.wave3, icon.wave )
		self:DelayedMessage(timer.wave2 - 10, L["wave2_message"], "Urgent")
		self:DelayedMessage(timer.wave2, L["wave2s_message"], "Urgent")
	end
	self:ScheduleEvent("bwnothtoroom", self.TeleportToRoom, timer.balcony, self)
end

function module:TeleportToRoom()
	if timer.balcony == timer.firstBalcony then
		timer.balcony = timer.secondBalcony
	elseif timer.balcony == timer.secondBalcony then
		timer.balcony = timer.thirdBalcony
	end

	if self.db.profile.teleport then
		self:Message(string.format(L["backwarn"], timer.room), "Important")
		self:Bar(L["blinkbar"], timer.blinkAfterTeleport, icon.blink)
		self:DelayedMessage(timer.blinkAfterTeleport - 10, L["blinkwarn10"], "Attention") -- praeda
		self:DelayedMessage(timer.blinkAfterTeleport - 5, L["blinkwarn5"], "Attention") -- praeda
		
		self:Bar(L["teleportbar"], timer.room, icon.balcony)
		self:DelayedMessage(timer.room - 30, L["teleportwarn30"], "Urgent")
		self:DelayedMessage(timer.room - 10, L["teleportwarn10"], "Urgent")
	end
	self:ScheduleEvent("bwnothtobalcony", self.TeleportToBalcony, timer.room, self)
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.curse then
		self:Curse()
	elseif sync == syncName.blink then
		self:Blink()
	end
end

------------------------------
--      Utility	Functions   --
------------------------------

function module:Curse()
	if self.db.profile.curse then
		self:Message(L["cursewarn"], "Important", nil, "Alarm")
		self:DelayedMessage(timer.curse - 10, L["curse10secwarn"], "Urgent")
		self:Bar(L["cursebar"], timer.curse, icon.curse)
	end
end

function module:Blink()
	if self.db.profile.blink then
		self:Message(L["blinkwarn"], "Important")
		self:DelayedMessage(timer.regularBlink - 10, L["blinkwarn10"], "Attention")
		self:DelayedMessage(timer.regularBlink - 5, L["blinkwarn5"], "Attention")
		self:Bar(L["blinkbar"], timer.regularBlink, icon.blink)
	end
	
	-- aggro reset?
end