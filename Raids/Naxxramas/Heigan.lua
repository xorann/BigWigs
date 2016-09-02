
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Heigan the Unclean", "Naxxramas")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Heigan",

	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for Teleports.",

	engage_cmd = "engage",
	engage_name = "Engage Alert",
	engage_desc = "Warn when Heigan is engaged.",

	disease_cmd = "disease",
	disease_name = "Decrepit Fever Alert",
	disease_desc = "Warn for Decrepit Fever",

	-- [[ Triggers ]]--
	starttrigger = "You are mine now!",
	starttrigger2 = "You...are next!",
	starttrigger3 = "I see you!",
	teleport_trigger = "The end is upon you.",
	die_trigger = "%s takes his last breath.",
	dtrigger = "afflicted by Decrepit Fever.",

	-- [[ Warnings ]]--
	engage_message = "Heigan the Unclean engaged! 90 sec to teleport!",

	dwarn = "DISEASE - DISPEL",

	teleport_1min_message = "Teleport in 1 min",
	teleport_30sec_message = "Teleport in 30 sec",
	teleport_10sec_message = "Teleport in 10 sec!",
	on_platform_message = "Teleport! On platform for %d sec!",

	to_floor_30sec_message = "Back in 30 sec",
	to_floor_10sec_message = "Back in 10 sec!",
	on_floor_message = "Back on the floor! 90 sec to next teleport!",

	-- [[ Bars ]]--
	teleport_bar = "Teleport!",
	back_bar = "Back on the floor!",
	dbar = "Decrepit Fever",

	-- [[ Dream Room Mobs ]] --
	["Eye Stalk"] = true,
	["Rotting Maggot"] = true,
} end )


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20003 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = { L["Eye Stalk"], L["Rotting Maggot"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"engage", "teleport", "disease", "bosskill"}


-- locals
local timer = {
	disease = 15,
	toRoom = 45,
	toPlatform = 90,
}
local icon = {
	disease = "Ability_Creature_Disease_03",
	toRoom = "Spell_Magic_LesserInvisibilty",
	toPlatform = "Spell_Arcane_Blink",
}
local syncName = {
	teleport = "HeiganTeleport",
	disease = "HeiganDisease",
}

local berserkannounced = nil


------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["starttrigger"])
module:RegisterYellEngage(L["starttrigger2"])
module:RegisterYellEngage(L["starttrigger3"])

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckForDisease")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckForDisease")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckForDisease")
	
	self:ThrottleSync(10, syncName.teleport)
	self:ThrottleSync(5, syncName.disease)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.started = nil
	timer.toRoom = 45
	timer.toPlatform = 90
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.engage then
		self:Message(L["engage_message"], "Important")
	end
	if self.db.profile.teleport then
		self:Bar(L["teleport_bar"], timer.toPlatform, icon.toPlatform)
		self:DelayedMessage(timer.toPlatform - 60, L["teleport_1min_message"], "Attention")
		self:DelayedMessage(timer.toPlatform - 30, L["teleport_30sec_message"], "Urgent")
		self:DelayedMessage(timer.toPlatform - 10, L["teleport_10sec_message"], "Important")
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Initialization      --
------------------------------

function module:CHAT_MSG_MONSTER_EMOTE( msg )
	if msg == L["die_trigger"] then
		self:SendBossDeathSync()
	end
end

function module:CHAT_MSG_MONSTER_YELL( msg )
	if string.find(msg, L["teleport_trigger"]) then
		self:Sync(syncName.teleport)
	end
end

function module:CheckForDisease( msg )
	if string.find(msg, L["dtrigger"]) then
		if self.db.profile.disease then 
			self:Sync(syncName.disease)
		end
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.disease then
		self:Disease()
	elseif sync == syncName.teleport then
		self:Teleport()
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:Disease()
	self:Message(L["dwarn"], "Important") 
	self:Bar(L["dbar"], timer.disease, icon.disease)
end

function module:Teleport()
	self:ScheduleEvent(self.BackToRoom, timer.toRoom, self)
	
	if self.db.profile.teleport then
		self:Message(string.format(L["on_platform_message"], timer.toRoom), "Attention")
		self:DelayedMessage(timer.toRoom - 30, L["to_floor_30sec_message"], "Urgent")
		self:DelayedMessage(timer.toRoom - 10, L["to_floor_10sec_message"], "Important")
		self:Bar(L["back_bar"], timer.toRoom, icon.toRoom)
	end
end

function module:BackToRoom()
	if self.db.profile.teleport then
		self:Message(L["on_floor_message"], "Attention")
		self:DelayedMessage(timer.toPlatform - 30, L["teleport_30sec_message"], "Urgent")
		self:DelayedMessage(timer.toPlatform - 10, L["teleport_10sec_message"], "Important")
		self:Bar(L["teleport_bar"], timer.toPlatform, icon.toPlatform)
	end
end
