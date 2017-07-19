------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.bwl.ebonroc
local module = BigWigs:GetModule(bossName)
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20013 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"curse", "wingbuffet", "shadowflame", "bosskill"}


-- locals
module.timer = {
	wingbuffet = 30,
	wingbuffetCast = 1,
	curse = 8,
	shadowflame = 16,
	shadowflameCast = 2,
}
local timer = module.timer

module.icon = {
	wingbuffet = "INV_Misc_MonsterScales_14",
	curse = "Spell_Shadow_GatherShadows",
	shadowflame = "Spell_Fire_Incinerate",	
}
local icon = module.icon

module.syncName = {
	wingbuffet = "EbonrocWingBuffet1",
	shadowflame = "EbonrocShadowflame1",
	curse = "EbonrocShadow1",
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
	elseif sync == syncName.curse and rest then
		self:ShadowOfEbonroc(rest)
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:WingBuffet()
	if self.db.profile.wingbuffet then
		self:Message(L["msg_wingBuffet"], "Important")
		self:RemoveBar(L["bar_wingBuffetNext"]) -- remove timer bar
		self:Bar(L["bar_wingBuffetCast"], timer.wingbuffetCast, icon.wingbuffet, true, "black") -- show cast bar
		self:DelayedBar(timer.wingbuffetCast, L["bar_wingBuffetNext"], timer.wingbuffet, icon.wingbuffet) -- delayed timer bar
		self:DelayedMessage(timer.wingbuffet - 5, L["msg_wingBuffetSoon"], "Attention", nil, nil, true)
	end
end

function module:ShadowFlame()
	if self.db.profile.shadowflame then
		self:Message(L["msg_shadowFlame"], "Important", true, "Alarm")
		self:RemoveBar(L["bar_shadowFlameNext"]) -- remove timer bar
		self:Bar(L["bar_shadowFlameCast"], timer.shadowflameCast, icon.shadowflame, true, "red") -- show cast bar
		self:DelayedBar(timer.shadowflameCast, L["bar_shadowFlameNext"], timer.shadowflame, icon.shadowflame) -- delayed timer bar
	end
end

function module:ShadowOfEbonroc(name)
	if name and self.db.profile.curse then
		if name == UnitName("player") then
			self:Message(L["msg_shadowCurseYou"], "Attention")
			self:WarningSign(icon.curse, timer.curse)
		else 
			self:Message(string.format(L["msg_shadowCurseOther"], name), "Attention")
		end
		
		self:Bar(string.format(L["bar_shadowCurse"], name), timer.curse, icon.curse, true, "white")
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
	module:ShadowOfEbonroc(UnitName("player"))
	module:ShadowOfEbonroc("TestPlayer")

	module:BigWigs_RecvSync(syncName.wingbuffet)
	module:BigWigs_RecvSync(syncName.shadowflame)
	module:BigWigs_RecvSync(syncName.curse, "TestPlayer")
end
