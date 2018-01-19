------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.horsemen
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

module.thane = AceLibrary("Babble-Boss-2.2")["Thane Korth'azz"]
module.mograine = AceLibrary("Babble-Boss-2.2")["Highlord Mograine"]
module.zeliek = AceLibrary("Babble-Boss-2.2")["Sir Zeliek"]
module.blaumeux = AceLibrary("Babble-Boss-2.2")["Lady Blaumeux"]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = {module.thane, module.mograine, module.zeliek, module.blaumeux} -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"mark", "shieldwall", -1, "meteor", "void", "wrath", "bosskill"}


-- locals
module.timer = {
	firstMark = 17,
	mark = 12,
	meteor = 12,
	wrath = 12,
	void = 12,
	shieldwall = 20,
}
local timer = module.timer

module.icon = {
	mark = "Spell_Shadow_CurseOfAchimonde",
	meteor = "Spell_Fire_Fireball02",
	wrath = "Spell_Holy_Excorcism",
	void = "Spell_Frost_IceStorm",
	shieldwall = "Ability_Warrior_ShieldWall",
}
local icon = module.icon

module.syncName = {
	shieldwall = "HorsemenShieldWall",
	mark = "HorsemenMark3",
	void = "HorsemenVoid2",
	wrath = "HorsemenWrath2",
	meteor = "HorsemenMeteor2",
}
local syncName = module.syncName


module.times = nil
module.marks = nil
module.deaths = nil


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
-- Sync Handlers	    	--
------------------------------
function module:Mark(mark)
	mark = tonumber(mark)
	if mark and mark == (self.marks + 1) then
		self.marks = self.marks + 1
		if self.db.profile.mark then
			self:Message(string.format(L["msg_markNow"], self.marks), "Important")
			self:Bar(string.format(L["bar_mark"], self.marks + 1), timer.mark, icon.mark)
			self:DelayedMessage(timer.firstMark - 5, string.format( L["msg_markSoon"], self.marks + 1), "Urgent")
		end
	end
end

function module:Meteor()
	if self.db.profile.meteor then
		self:Message(L["msg_meteor"], "Important")
		self:Bar(L["bar_meteor"], timer.meteor, icon.meteor)
	end
end

function module:Wrath()
	if self.db.profile.wrath then
		self:Message(L["msg_wrath"], "Important")
		self:Bar(L["bar_wrath"], timer.wrath, icon.wrath)
	end
end

function module:Void()
	if self.db.profile.void then
		self:Message(L["msg_voidZone"], "Important")
		self:Bar(L["bar_void"], timer.void, icon.void)
	end
end

function module:Shieldwall(mob)
	if mob and self.db.profile.shieldwall then
		self:Message(string.format(L["msg_shieldWallGain"], mob), "Attention")
		self:Bar(string.format(L["bar_shieldWall"], mob), timer.shieldwall, icon.shieldwall)
		self:DelayedMessage(timer.shieldwall, string.format(L["msg_shieldWallGone"], mob), "Positive")
	end
end


------------------------------
-- Utility	Functions   	--
------------------------------


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:Shieldwall("test")
	module:Void()
	module:Wrath()
	module:Meteor()
	module:Mark(1)
	
	module:BigWigs_RecvSync(syncName.mark, 1)
	module:BigWigs_RecvSync(syncName.meteor)
	module:BigWigs_RecvSync(syncName.wrath)
	module:BigWigs_RecvSync(syncName.void)
	module:BigWigs_RecvSync(syncName.shieldwall, "test")
end
