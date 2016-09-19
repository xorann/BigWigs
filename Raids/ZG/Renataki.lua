
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Renataki", "Zul'Gurub")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Renataki",

	enrage_trigger = "Renataki gains Enrage\.",
	enragesoon_message = "Enrage soon! Get ready!",
	enrage_message = "Enraged!",
	vanishsoon_message = "Vanish soon!",
	vanish_message = "Boss has vanished!",
	unvanish_message = "Boss is revealed!",
	vanish_bar = "Vanish",

	vanish_cmd = "vanish",
	vanish_name = "Vanish announce",
	vanish_desc = "Shows warnings for boss' Vanish.",
	
	enraged_cmd = "enraged",
	enraged_name = "Announce boss Enrage",
	enraged_desc = "Lets you know when boss hits harder.",
} end )

L:RegisterTranslations("deDE", function() return {
	cmd = "Renataki",

	enrage_trigger = "Renataki bekommt \'Wutanfall\'\.",
	enragesoon_message = "Raserei bald! Mach dich bereit!",
	enrage_message = "Boss ist in Raserei!",
	vanishsoon_message = "Verschwinden bald!",
	vanish_message = "Boss ist verschwunden!",
	unvanish_message = "Boss wird aufgedeckt!",
	vanish_bar = "Verschwinden",

	vanish_cmd = "vanish",
	vanish_name = "Verschwinden anzeigen",
	vanish_desc = "Verk\195\188ndet Boss' Verschwinden.",
	
	enraged_cmd = "enraged",
	enraged_name = "Verk\195\188ndet Boss' Raserei",
	enraged_desc = "L\195\164sst dich wissen, wenn Boss h\195\164rter zuschl\195\164gt.",
} end )


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20004 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.toggleoptions = {"vanish", "enraged", "bosskill"}

-- locals
local timer = {
	vanishSoon = 22,
	unvanish = 30,
}
local icon = {
	vanish = "Ability_Stealth",
}
local syncName = {
	unvanish = "RenatakiUnvanish",
	enrage = "RenatakiEnrage",
	enrageSoon = "RenatakiEnrageSoon",
}


------------------------------
--      Initialization      --
------------------------------

--module:RegisterYellEngage(L["start_trigger"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("UNIT_HEALTH")
	
	self:ThrottleSync(5, syncName.unvanish)
	self:ThrottleSync(5, syncName.enrage)
	self:ThrottleSync(10, syncName.enrageSoon)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	enrageannounced = nil
	vanished = nil
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.vanish then
		self:DelayedMessage(timer.vanishSoon, L["vanishsoon_message"], "Urgent")
	end
	self:ScheduleRepeatingEvent("renatakivanishcheck", self.VanishCheck, 2, self)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers	    --
------------------------------

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["enrage_trigger"] then
		self:Sync(syncName.enrage)
	end
end

function module:UNIT_HEALTH(arg1)
	if UnitName(arg1) == boss then
		local health = UnitHealth(arg1)
		if health > 25 and health <= 30 and not enrageannounced then
			self:Sync(syncName.enrageSoon)
			enrageannounced = true
		elseif health > 30 and enrageannounced then
			enrageannounced = nil
		end
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.enrageSoon and self.db.profile.enraged then
		self:Message(L["enragesoon_message"], "Urgent")
	elseif sync == syncName.enrage and self.db.profile.enraged then
		self:Message(L["enrage_message"], "Attention")
	elseif sync == syncName.unvanish then
		vanished = nil
		if self.db.profile.vanish then
			self:RemoveBar(L["vanish_bar"])
			self:Message(L["unvanish_message"], "Attention")
			self:DelayedMessage(timer.vanishSoon, L["vanishsoon_message"], "Urgent")
		end
		self:ScheduleRepeatingEvent("renatakivanishcheck", self.VanishCheck, 2, self)
	end
end


------------------------------
--      Utility	Functions   --
------------------------------

function module:IsVanished()
	vanished = true
	self:CancelScheduledEvent("renatakivanishcheck")
	if self.db.profile.vanish then
		self:Message(L["vanish_message"], "Attention")
		self:Bar(L["vanish_bar"], timer.unvanish, icon.vanish)
	end
	self:ScheduleRepeatingEvent("renatakiunvanishcheck", self.UnvanishCheck, 2, self)
	self:ScheduleEvent(syncName.unvanish, self.Unvanish, timer.unvanish, self)
end

function module:UnvanishCheck()
	if UnitExists("target") and UnitName("target") == "Renataki" and UnitExists("targettarget") then
		if vanished then
			vanished = nil
			self:Unvanish()
			return
		end
	end
	local num = GetNumRaidMembers()
	for i = 1, num do
		local raidUnit = string.format("raid%starget", i)
		if UnitExists(raidUnit) and UnitName(raidUnit) == "Renataki" and UnitExists(raidUnit.."target") then
			if vanished then
				vanished = nil
				self:Unvanish()
				return
			end
		end
	end
end

function module:VanishCheck()
	local num = GetNumRaidMembers()
	for i = 1, num do
		local raidUnit = string.format("raid%starget", i)
		if UnitExists(raidUnit) and UnitClassification(raidUnit) == "worldboss" and UnitName(raidUnit) == self.translatedName and UnitExists(raidUnit.."target") then
			if vanished then
				vanished = nil
			end
			return
		end
	end
	self:IsVanished()
end

function module:Unvanish()
	self:CancelScheduledEvent("renatakiunvanishcheck")
	self:CancelScheduledEvent("renatakiunvanish")
	self:Sync(syncName.unvanish)
end
