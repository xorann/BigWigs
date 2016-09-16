
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("The Four Horsemen", "Naxxramas")
local thane = AceLibrary("Babble-Boss-2.2")["Thane Korth'azz"]
local mograine = AceLibrary("Babble-Boss-2.2")["Highlord Mograine"]
local zeliek = AceLibrary("Babble-Boss-2.2")["Sir Zeliek"]
local blaumeux = AceLibrary("Babble-Boss-2.2")["Lady Blaumeux"]


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Horsemen",

	mark_cmd = "mark",
	mark_name = "Mark Alerts",
	mark_desc = "Warn for marks",

	shieldwall_cmd  = "shieldwall",
	shieldwall_name = "Shieldwall Alerts",
	shieldwall_desc = "Warn for shieldwall",

	void_cmd = "void",
	void_name = "Void Zone Alerts",
	void_desc = "Warn on Lady Blaumeux casting Void Zone.",

	meteor_cmd = "meteor",
	meteor_name = "Meteor Alerts",
	meteor_desc = "Warn on Thane casting Meteor.",

	wrath_cmd = "wrath",
	wrath_name = "Holy Wrath Alerts",
	wrath_desc = "Warn on Zeliek casting Wrath.",

	markbar = "Mark %d",
	mark_warn = "Mark %d!",
	mark_warn_5 = "Mark %d in 5 sec",
	marktrigger = "is afflicted by Mark of ",

	voidtrigger = "Lady Blaumeux casts Void Zone.",
	voidwarn = "Void Zone Incoming",
	voidbar = "Void Zone",

	meteortrigger = "Thane Korth'azz 's Meteor hits ",
	meteorwarn = "Meteor!",
	meteorbar = "Meteor",

	wrathtrigger = "Sir Zeliek's Holy Wrath hits ",
	wrathwarn = "Holy Wrath!",
	wrathbar = "Holy Wrath",

	startwarn = "The Four Horsemen Engaged! Mark in ~17 sec",

	shieldwallbar = "%s - Shield Wall",
	shieldwalltrigger = "(.*) gains Shield Wall.",
	shieldwall_warn = "%s - Shield Wall for 20 sec",
	shieldwall_warn_over = "%s - Shield Wall GONE!",
} end )


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20003 -- To be overridden by the module!
module.enabletrigger = {thane, mograine, zeliek, blaumeux} -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"mark", "shieldwall", -1, "meteor", "void", "wrath", "bosskill"}


-- locals
local timer = {
	firstMark = 17,
	mark = 12,
	meteor = 12,
	wrath = 12,
	void = 12,
	shieldwall = 20,
}
local icon = {
	mark = "Spell_Shadow_CurseOfAchimonde",
	meteor = "Spell_Fire_Fireball02",
	wrath = "Spell_Holy_Excorcism",
	void = "Spell_Frost_IceStorm",
	shieldwall = "Ability_Warrior_ShieldWall",
}
local syncName = {
	shieldwall = "HorsemenShieldWall",
	mark = "HorsemenMark3",
	void = "HorsemenVoid2",
	wrath = "HorsemenWrath2",
	meteor = "HorsemenMeteor2",
}

local times = nil


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "SkillEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "SkillEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "MarkEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "MarkEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "MarkEvent")
	
	self:ThrottleSync(3, syncName.shieldwall)
	self:ThrottleSync(8, syncName.mark)
	self:ThrottleSync(5, syncName.void)
	self:ThrottleSync(5, syncName.wrath)
	self:ThrottleSync(5, syncName.meteor)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	
	self.marks = 0
	self.deaths = 0

	times = {}
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.mark then
		self:Message(L["startwarn"], "Attention")
		self:Bar(string.format( L["markbar"], self.marks + 1), timer.firstMark, icon.mark) -- 18,5 sec on feenix
		self:DelayedMessage(timer.firstMark - 5, string.format( L["mark_warn_5"], self.marks + 1), "Urgent")
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers	    --
------------------------------

function module:MarkEvent(msg)
	if string.find(msg, L["marktrigger"]) then
		local t = GetTime()
		if not times["mark"] or (times["mark"] and (times["mark"] + 8) < t) then -- why 8?
			self:Sync(syncName.mark .. " " .. tostring(self.marks + 1))
			times["mark"] = t
		end
	end
end

function module:SkillEvent(msg)
	local t = GetTime()
	if string.find(msg, L["meteortrigger"]) then
		if not times["meteor"] or (times["meteor"] and (times["meteor"] + 8) < t) then -- why 8?
			self:Sync(syncName.meteor)
			times["meteor"] = t
		end
	elseif string.find(msg, L["wrathtrigger"]) then
		if not times["wrath"] or (times["wrath"] and (times["wrath"] + 8) < t) then -- why 8?
			self:Sync(syncName.wrath)
			times["wrath"] = t
		end
	elseif msg == L["voidtrigger"] then
		if not times["void"] or (times["void"] and (times["void"] + 8) < t) then -- why 8?
			self:Sync(syncName.void )
			times["void"] = t
		end
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	local _,_, mob = string.find(msg, L["shieldwalltrigger"])
	if mob then 
		self:Sync(syncName.shieldwall .. " " .. mob) 
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["voidtrigger"] then
		self:Sync(syncName.void )
	end	
end

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, thane) or
		msg == string.format(UNITDIESOTHER, zeliek) or 
		msg == string.format(UNITDIESOTHER, mograine) or
		msg == string.format(UNITDIESOTHER, blaumeux) then
		
		self.deaths = self.deaths + 1
		if self.deaths == 4 then
			self:SendBossDeathSync()
		end
	end
end

------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	--Print("sync= "..sync.." rest= "..rest.." nick= "..nick)
	if sync == syncName.mark and rest then
		self:Mark(rest)
	elseif sync == syncName.meteor then
		self:Meteor()
	elseif sync == syncName.wrath then
		self:Wrath()
	elseif sync == syncName.void then
		self:Void()
	elseif sync == syncName.shieldwall and rest then
		self:Shieldwall(rest)
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:Mark(mark)
	mark = tonumber(mark)
	if mark and mark == (self.marks + 1) then
		self.marks = self.marks + 1
		if self.db.profile.mark then
			self:Message(string.format(L["mark_warn"], self.marks), "Important")
			self:Bar(string.format(L["markbar"], self.marks + 1), timer.mark, icon.mark)
			self:DelayedMessage(timer.firstMark - 5, string.format( L["mark_warn_5"], self.marks + 1), "Urgent")
		end
	end
end

function module:Meteor()
	if self.db.profile.meteor then
		self:Message(L["meteorwarn"], "Important")
		self:Bar(L["meteorbar"], timer.meteor, icon.meteor)
	end
end

function module:Wrath()
	if self.db.profile.wrath then
		self:Message(L["wrathwarn"], "Important")
		self:Bar(L["wrathbar"], timer.wrath, icon.wrath)
	end
end

function module:Void()
	if self.db.profile.void then
		self:Message(L["voidwarn"], "Important")
		self:Bar(L["voidbar"], timer.void, icon.void)
	end
end

function module:Shieldwall(mob)
	if mob and self.db.profile.shieldwall then
		self:Message(string.format(L["shieldwall_warn"], mob), "Attention")
		self:Bar(string.format(L["shieldwallbar"], mob), timer.shieldwall, icon.shieldwall)
		self:DelayedMessage(timer.shieldwall, string.format(L["shieldwall_warn_over"], mob), "Positive")
	end
end
