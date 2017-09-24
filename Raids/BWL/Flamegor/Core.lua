------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.bwl.flamegor
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20013 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"wingbuffet", "shadowflame", "frenzy", "bosskill"}


-- locals
module.timer = {
	firstWingbuffet = 33.5,
	wingbuffet = 30,
	wingbuffetCast = 1,
	firstShadowflame = 15,
	shadowflame = 16,
	shadowflameCast = 2,
	firstFrenzy = 10,
	frenzy = 10,
}
local timer = module.timer

module.icon = {
	wingbuffet = "INV_Misc_MonsterScales_14",
	shadowflame = "Spell_Fire_Incinerate",
	frenzy = "Ability_Druid_ChallangingRoar",
	tranquil = "Spell_Nature_Drowsy",
}
local icon = module.icon

module.syncName = {
	wingbuffet = "FlamegorWingBuffetX",
	shadowflame = "FlamegorShadowflameX",
	frenzy = "FlamegorFrenzyStart",
	frenzyOver = "FlamegorFrenzyEnd",
}
local syncName = module.syncName

module.lastFrenzy = 0
local _, playerClass = UnitClass("player")
module.playerClass = playerClass


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.wingbuffet then
		self:WingBuffet()
	elseif sync == syncName.shadowflame then
		self:ShadowFlame()
	elseif sync == syncName.frenzy then
		self:Frenzy()
	elseif sync == syncName.frenzyOver then
		self:FrenzyGone()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:WingBuffet()
	if self.db.profile.wingbuffet then
        self:Message(L["msg_wingBuffet"], "Important")
		self:RemoveBar(L["bar_wingBuffetNext"]) -- remove timer bar
        self:DelayedMessage(timer.wingbuffet - 5, L["msg_wingBuffetSoon"], "Attention", nil, nil, true)
		self:Bar(L["bar_wingBuffetCast"], timer.wingbuffetCast, icon.wingbuffet) -- show cast bar
		self:DelayedBar(timer.wingbuffetCast, L["bar_wingBuffetNext"], timer.wingbuffet, icon.wingbuffet) -- delayed timer bar
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

function module:Frenzy()
	if self.db.profile.frenzy then
		self:Message(L["msg_frenzy"], "Important", nil, true, "Alert")
		self:Bar(L["bar_frenzy"], timer.frenzy, icon.frenzy, true, "Yellow")
        if module.playerClass == "HUNTER" then
            self:WarningSign(icon.tranquil, timer.frenzy, true)
        end
        module.lastFrenzy = GetTime()
	end
end

function module:FrenzyGone()
	if self.db.profile.frenzy then
        self:RemoveBar(L["bar_frenzy"])
        self:RemoveWarningSign(icon.tranquil, true)
        if module.lastFrenzy ~= 0 then
            local NextTime = (module.lastFrenzy + timer.frenzy) - GetTime()
            self:Bar(L["bar_frenzyNext"], NextTime, icon.frenzy, true, "white")
        end
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
	module:Frenzy()
	module:FrenzyGone()

	module:BigWigs_RecvSync(syncName.wingbuffet)
	module:BigWigs_RecvSync(syncName.shadowflame)
	module:BigWigs_RecvSync(syncName.frenzy)
	module:BigWigs_RecvSync(syncName.frenzyOver)
end
