
-- trigger for spore spawn missing

----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Loatheb", "Naxxramas")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Loatheb",

	doom_cmd = "doom",
	doom_name = "Inevitable Doom Alert",
	doom_desc = "Warn for Inevitable Doom",

	curse_cmd = "curse",
	curse_name = "Remove Curse Alert",
	curse_desc = "Warn when curses are removed from Loatheb",

	doombar = "Inevitable Doom %d",
	doomwarn = "Inevitable Doom %d! %d sec to next!",
	doomwarn5sec = "Inevitable Doom %d in 5 sec!",
	doomtrigger = "afflicted by Inevitable Doom.",

	cursewarn = "Curses removed! RENEW CURSES",
	cursebar = "Remove Curse",
	cursetrigger = "Loatheb's Chains of Ice is removed.",

	doomtimerbar = "Doom every 15sec",
	doomtimerwarn = "Doom timerchange in %s seconds!",
	doomtimerwarnnow = "Inevitable Doom now happens every 15sec!",

	cursetimerbar = "Remove Curse Timer",
	cursetimerwarn = "Curses removed, next in %s seconds!",

	startwarn = "Loatheb engaged, 2 min to Inevitable Doom!",

	you = "You",
	are = "are",
} end )


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20003 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"doom", "curse", "bosskill"}


-- locals
local timer = {
	softEnrage = 300,
	firstDoom = 120,
	doomLong = 30,
	doomShort = 15,
	doom = 0, -- this variable will be changed during the encounter
	spore = 12,
	curse = 30,
}
local icon = {
	softEnrage = "Spell_Shadow_UnholyFrenzy",
	doom = "Spell_Shadow_NightOfTheDead",
	spore = "Ability_TheBlackArrow",
	curse = "Spell_Holy_RemoveCurse",
}
local syncName = {
	doom = "LoathebDoom2",
	spore = "LoathebSporeSpawn2",
	curse = "LoathebRemoveCurse",
}

local numSpore = 0 -- how many spores have been spawned
local numDoom = 0 -- how many dooms have been casted


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_BREAK_AURA", "Curse")

	-- 2: Doom and SporeSpawn versioned up because of the sync including the
	-- doom/spore count now, so we don't hold back the counter.	
	self:ThrottleSync(10, syncName.doom)
	self:ThrottleSync(5, syncName.spore)
	self:ThrottleSync(5, syncName.curse)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	numSpore = 0 -- how many spores have been spawned
	numDoom = 0 -- how many dooms have been casted
	timer.doom = timer.firstDoom
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.doom then
		self:Bar(L["doomtimerbar"], timer.softEnrage, icon.softEnrage)
		self:DelayedMessage(timer.softEnrage - 60, string.format(L["doomtimerwarn"], 60), "Attention")
		self:DelayedMessage(timer.softEnrage - 30, string.format(L["doomtimerwarn"], 30), "Attention")
		self:DelayedMessage(timer.softEnrage - 10, string.format(L["doomtimerwarn"], 10), "Urgent")
		self:DelayedMessage(timer.softEnrage - 5, string.format(L["doomtimerwarn"], 5), "Important")
		self:DelayedMessage(timer.softEnrage, L["doomtimerwarnnow"], "Important")
		
		-- soft enrage after 5min: Doom every 15s instead of every 30s
		--self:ScheduleEvent("bwloathebdoomtimerreduce", function() module.doomTime = 15 end, 300)
		self:ScheduleEvent("bwloathebdoomtimerreduce", self.SoftEnrage, timer.softEnrage)
		self:Message(L["startwarn"], "Red")
		self:Bar(string.format(L["doombar"], numDoom + 1), timer.doom, icon.doom)
		self:DelayedMessage(timer.doom - 5, string.format(L["doomwarn5sec"], numDoom + 1), "Urgent")
		timer.doom = timer.doomLong -- reduce doom timer from 120s to 30s
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Initialization      --
------------------------------

function module:Event( msg )
	if string.find(msg, L["doomtrigger"]) then
		self:Sync(syncName.doom .. " " .. tostring(numDoom + 1))
	end
end

function module:Curse( msg )
	if string.find(msg, L["cursetrigger"]) then
		self:Sync(syncName.curse)
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.doom and rest then
		self:Doom(rest)
	elseif sync == syncName.spore and rest then
		self:Spore(rest)
	elseif sync == syncName.curse then
		self:Curse()
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:Doom(syncNumDoom)
	syncNumDoom = tonumber(syncNumDoom)
	if syncNumDoom then
		if syncNumDoom == (numDoom + 1) then
			numDoom = numDoom + 1
			if self.db.profile.doom then
				self:Message(string.format(L["doomwarn"], numDoom, timer.doom), "Important")
			end
			if self.db.profile.doom then
				self:Bar(string.format(L["doombar"], numDoom + 1), timer.doom, icon.doom)
				self:DelayedMessage(timer.doom - 5, string.format(L["doomwarn5sec"], numDoom + 1), "Urgent")
			end
		end
	end
end

function module:Spore(syncNumSpore)
	syncNumSpore = tonumber(syncNumSpore)
	if not syncNumSpore then
		if syncNumSpore == (numSpore + 1) then
			numSpore = numSpore
			if self.db.profile.spore then
				self:Message(string.format(L["sporewarn"], numSpore), "Important")
			end			
			if self.db.profile.spore then
				self:Bar(string.format(L["sporebar"], numSpore + 1), timer.spore, icon.spore)
			end
		end
	end
end

function module:Curse()
	if self.db.profile.curse then
		self:Message(L["cursewarn"], "Important")
		self:Bar(L["cursebar"], timer.curse, icon.curse)
	end
end


------------------------------
--      Utility	Functions   --
------------------------------

function module:SoftEnrage()
	timer.doom = timer.doomShort -- reduce doom timer from 30s to 15s
end
