------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.bwl.firemaw
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20013 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"wingbuffet", "shadowflame", "flamebuffet", "bosskill"}


-- locals
module.timer = {
	firstWingbuffet = 25,
	wingbuffet = 30,
	wingbuffetCast = 1,
	shadowflame = 16,
	shadowflameCast = 2,
	flameBuffet = 5,
}
local timer = module.timer

module.icon = {
	wingbuffet = "INV_Misc_MonsterScales_14",
	shadowflame = "Spell_Fire_Incinerate",
	flameBuffet = "Spell_Fire_Fireball",
}
local icon = module.icon

module.syncName = {
	wingbuffet = "FiremawWingBuffetX",
	shadowflame = "FiremawShadowflameX",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.wingbuffet then
        self:WingBuffet()
	elseif sync == syncName.shadowflame then
		self:ShadowFlame()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:WingBuffet() 
	if 	self.db.profile.wingbuffet then
		self:Message(L["msg_wingBuffet"], "Important")
		self:RemoveBar(L["bar_wingBuffetNext"]) -- remove timer bar
		self:Bar(L["bar_wingBuffetCast"], timer.wingbuffetCast, icon.wingbuffet, true, "Black") -- show cast bar
		self:DelayedBar(timer.wingbuffetCast, L["bar_wingBuffetNext"], timer.wingbuffet, icon.wingbuffet) -- delayed timer bar
        self:DelayedMessage(timer.wingbuffet - 5, L["msg_wingBuffetSoon"], "Attention", nil, nil, true)
	end
end

function module:ShadowFlame()
	if self.db.profile.shadowflame then
        self:Message(L["msg_shadowFlame"], "Important", true, "Alarm")
		self:RemoveBar(L["bar_shadowFlameNext"]) -- remove timer bar
		self:Bar(L["bar_shadowFlameCast"], timer.shadowflameCast, icon.shadowflame) -- show cast bar
        self:DelayedBar(timer.shadowflameCast, L["bar_shadowFlameNext"], timer.shadowflame, icon.shadowflame) -- delayed timer bar
	end
end


------------------------------
-- Utility			    	--
------------------------------

function module:FlameBuffet()
	if self.db.profile.flamebuffet then
		self:Bar(L["bar_flameBuffet"], timer.flameBuffet, icon.flameBuffet, true, "White")
	end
end

----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:WingBuffet()
	module:ShadowFlame()

	module:BigWigs_RecvSync(syncName.wingbuffet)
	module:BigWigs_RecvSync(syncName.shadowflame)
end
