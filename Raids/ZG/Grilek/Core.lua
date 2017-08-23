------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.zg.grilek
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"avatar", "melee", "announce", "puticon", "bosskill"}


-- locals
module.timer = {
	melee = 10,
	avatar = 15,
}
local timer = module.timer

module.icon = {
	avatar = "Ability_Creature_Cursed_05",
}
local icon = module.icon

module.syncName = {
	meleeIni = "GrilekMeleeIni",
	melee = "GrilekMelee",
	avatar = "GrilekAvatar",
	avatarOver = "GrilekAvatarStop",
}
local syncName = module.syncName

module.firstwarn = nil
module.nameoftarget = nil
module.lasttarget = "randomshitthatwonthappen"


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.meleeIni then
		if self.db.profile.melee then
			self:DelayedMessage(timer.melee, L["msg_avatarSoon"], "Attention", true, "Alarm")
		end
	elseif sync == syncName.melee then
		if self.db.profile.melee then
			self:DelayedMessage(timer.melee, L["msg_avatarSoon"], "Attention", true, "Alarm")
		end
	elseif sync == syncName.avatar then
		self:Avatar()
		if self.db.profile.avatar then
			self:Bar(L["bar_avatar"], timer.avatar, icon.avatar)
			self:Message(L["msg_avatarNow"], "Urgent")
		end
	elseif sync == syncName.avatarOver then
		self:CancelScheduledEvent("grilektargetchangedcheck")
		module.nameoftarget = nil
		if self.db.profile.avatar then
			self:RemoveBar(L["bar_avatar"])
		end
		if self.db.profile.puticon then
			self:RemoveIcon(module.lasttarget)
		end
		module.lasttarget = "randomshitthatwonthappen"
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:BigWigs_RecvSync(syncName.meleeIni)
	module:BigWigs_RecvSync(syncName.melee)
	module:BigWigs_RecvSync(syncName.avatar)
	module:BigWigs_RecvSync(syncName.avatarOver)
end
