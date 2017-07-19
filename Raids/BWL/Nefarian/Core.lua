------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.bwl.nefarian
local module = BigWigs:GetModule(bossName)
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20013 -- To be overridden by the module!
local victor = AceLibrary("Babble-Boss-2.2")["Lord Victor Nefarius"]
module.enabletrigger = {module.translatedName, victor} -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"mc", "shadowflame", "fear", "classcall", "otherwarn", "bosskill"}

-- locals
module.timer = {
	mobspawn = 6,
	classcall = 30,
	mc = 15,
	shadowflame = 19,
	shadowflameCast = 2,
	fear = 27,
	fearCast = 1.5,
	landing = 15,
	firstClasscall = 24,
	firstFear = 25,
}
local timer = module.timer

module.icon = {
	mobspawn = "Spell_Holy_PrayerOfHealing",
	classcall = "Spell_Shadow_Charm",
	mc = "Spell_Shadow_Charm",
	fear = "Spell_Shadow_Possession",
	shadowflame = "Spell_Fire_Incinerate",
	landing = "INV_Misc_Head_Dragon_Black",
}
local icon = module.icon

module.syncName = {
	shadowflame = "NefarianShadowflame",
	fear = "NefarianFear",
	landing = "NefarianLandingNOW",
	landingSoon = "NefarianLandingSoon",
	addDead = "NefCounter",
	mindControl = "NefarianMindControl",
	zerg = "NefarianZerg"
}
local syncName = module.syncName


module.warnpairs = {
	[L["trigger_shamans"]] = {L["msg_shaman"], true},
	[L["trigger_druid"]] = {L["msg_druid"], true},
	[L["trigger_warlock"]] = {L["msg_warlock"], true},
	[L["trigger_priest"]] = {L["msg_priest"], true},
	[L["trigger_hunter"]] = {L["msg_hunter"], true},
	[L["trigger_warrior"]] = {L["msg_warrior"], true},
	[L["trigger_rogue"]] = {L["msg_rogue"], true},
	[L["trigger_paladin"]] = {L["msg_paladin"], true},
	[L["trigger_mage"]] = {L["msg_mage"], true},
} 
module.nefCounter = nil
module.nefCounterMax = 42 -- how many adds have to be killed to trigger phase 2?
module.phase = nil


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.shadowflame then
		self:Shadowflame()
	elseif sync == syncName.fear then
		self:Fear()
	elseif sync == syncName.landingSoon then
		self:LandingSoon()
    elseif sync == syncName.landing then
		self:Landing()
	elseif sync == syncName.addDead and rest then
		self:NefCounter(rest)
	elseif sync == syncName.mindControl and rest then
		self:MindControl(rest)
	elseif sync == syncName.zerg then
		self:Zerg()
    end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:Shadowflame()
	if self.db.profile.shadowflame then
		self:RemoveBar(L["bar_shadowFlame"]) -- remove timer bar
		self:Bar(L["bar_shadowFlame"], timer.shadowflameCast, icon.shadowflame) -- show cast bar
		self:Message(L["msg_shadowFlame"], "Important", true, "Alarm")
		self:DelayedBar(timer.shadowflameCast, L["bar_shadowFlame"], timer.shadowflame, icon.shadowflame) -- delayed timer bar
	end
end

function module:Fear()
	if self.db.profile.fear then
        self:RemoveBar(L["bar_fear"]) -- remove timer bar
		self:Message(L["msg_fearCast"], "Important", true, "Alert")
		self:Bar(L["msg_fear"], timer.fearCast, icon.fear) -- show cast bar
		self:DelayedBar(timer.fearCast, L["bar_fear"], timer.fear, icon.fear) -- delayed timer bar
        --self:WarningSign(icon.fear, 5)
	end
end

function module:LandingSoon()
	if self.db.profile.otherwarn then
		self:Message(L["msg_landingSoon"], "Important", true, "Long")
	end
end

function module:Landing()
	if not self.phase2 then
        self.phase2 = true
		self:TriggerEvent("BigWigs_StopCounterBar", self, L["misc_drakonidsDead"])
		
        self:Bar(L["msg_landing"], timer.landing, icon.landing)
        self:Message(L["msg_landing"], "Important", nil, "Beware")
		
		-- landing in 15s
		self:DelayedBar(timer.landing, L["bar_classCall"], timer.firstClasscall, icon.classcall)
        self:DelayedBar(timer.landing, L["bar_fear"], timer.firstFear, icon.fear)
        
        -- set ktm
        local function setKTM()
            self:KTM_SetTarget(self:ToString())
            self:KTM_Reset()
        end
        self:ScheduleEvent("bwnefarianktm", setKTM, timer.landing + 1, self)
	end
end

function module:NefCounter(n)
	n = tonumber(n)
	if not self.phase2 and n == (module.nefCounter + 1) and module.nefCounter <= module.nefCounterMax then
		module.nefCounter = module.nefCounter + 1
		--[[if self.db.profile.adds then
			self:Message(string.format(L["add_message"], nefCounter), "Positive")
		end]]
		self:TriggerEvent("BigWigs_SetCounterBar", self, L["misc_drakonidsDead"], (module.nefCounterMax - module.nefCounter))
	end
end

function module:MindControl(name)
	if name and self.db.profile.mc then 
		self:Message(string.format(L["msg_mindControlPlayer"], name), "Important")
		self:Bar(string.format(L["bar_mindControl"], name), timer.mc, icon.mc, "Orange")
	end
end

function module:Zerg()
	if self.db.profile.otherwarn then
		self:Message(L["msg_zerg"])
	end
end

----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Zerg()
	module:MindControl("TestPlayer")
	module:NefCounter(1)
	module:Landing()
	module:Fear()
	module:Shadowflame()

	module:BigWigs_RecvSync(syncName.shadowflame)
	module:BigWigs_RecvSync(syncName.fear)
	module:BigWigs_RecvSync(syncName.landing)
	module:BigWigs_RecvSync(syncName.addDead, 1)
	module:BigWigs_RecvSync(syncName.mindControl, "TestPlayer")
	module:BigWigs_RecvSync(syncName.zerg)
end
