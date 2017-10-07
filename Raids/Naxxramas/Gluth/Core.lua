------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.gluth
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"frenzy", "fear", "decimate", "enrage", "bosskill", "zombies"}


-- locals
module.timer = {
	decimateInterval = 104,
	zombie = 10,
	enrage = 324,
	fear = 20,
	frenzy = 10,
	firstFrenzy = 10,
}
local timer = module.timer

module.icon = {
	zombie = "Ability_Seal",
	enrage = "Spell_Shadow_UnholyFrenzy",
	fear = "Spell_Shadow_PsychicScream",
	decimate = "INV_Shield_01",
	tranquil = "Spell_Nature_Drowsy",
	frenzy = "Ability_Druid_ChallangingRoar",
}
local icon = module.icon

module.syncName = {
    frenzy = "GluthFrenzyStart",
    frenzyOver = "GluthFrenzyEnd",
	enrage = "GluthEnrage",
	fear = "GluthFear",
}
local syncName = module.syncName


module.lastFrenzy = nil
local _, playerClass = UnitClass("player")
module.playerClass = playerClass
module.zomnum = nil


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.frenzy then
		self:Frenzy()
	elseif sync == syncName.frenzyOver then
		self:FrenzyGone()
	elseif sync == syncName.fear then
		self:Fear()
	elseif sync == syncName.enrage then
		self:Enrage()
    end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Frenzy()
	if self.db.profile.frenzy then
		self:Message(L["msg_frenzy"], "Important", nil, true, "Alert")
		self:Bar(L["bar_frenzy"], timer.frenzy, icon.frenzy, true, BigWigsColors.db.profile.frenzy)
        
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
            self:Bar(L["bar_frenzyNext"], NextTime, icon.frenzy, true, BigWigsColors.db.profile.frenzyNext)
        end
	end
end

function module:Fear()
	if self.db.profile.fear then
		self:Message(L["msg_fearNow"], "Important")
		self:Bar(L["bar_fear"], timer.fear, icon.fear, true, "Orange")
		self:DelayedMessage(timer.fear - 5, L["msg_fearSoon"], "Urgent")
	end
end

function module:Enrage()
	if self.db.profile.enrage then 
		self:Message(L["msg_enrage"], "Important") 
	end
	--[[self:CancelScheduledEvent("bwgluthdecimate")
	self:CancelScheduledEvent("bwgluthdecimatewarn")
	self:CancelScheduledEvent("bwgluthfrenzy_warn")
	self:CancelScheduledEvent("bwgluthfear_warn_5")
	self:CancelScheduledEvent("bwgluthfear_warn")]]
end


------------------------------
-- Utility	Functions   	--
------------------------------
function module:Decimate()
	if self.db.profile.decimate then
		self:Bar(L["bar_decimate"], timer.decimateInterval, icon.decimate)
		self:DelayedMessage(timer.decimateInterval - 5, L["msg_decimateSoon"], "Urgent")
	end
	
	if self.db.profile.zombies then
		self.zomnum = 1
		self:Bar(string.format(L["bar_zombie"],self.zomnum), timer.zombie, icon.zombie)
		self.zomnum = self.zomnum + 1
		self:ScheduleRepeatingEvent("bwgluthzbrepop", self.Zombies, timer.zombie, self)
	end
end

function module:Zombies()	
	self:Bar(string.format(L["bar_zombie"],self.zomnum), timer.zombie, icon.zombie)	

	if self.zomnum <= 10 then
		self.zomnum = self.zomnum + 1
	elseif self.zomnum > 10 then		
		self:CancelScheduledEvent("bwgluthzbrepop")	
		self:RemoveBar(string.format(L["bar_zombie"], self.zomnum ))
		self.zomnum = 1
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:Enrage()
	module:Fear()
	module:FrenzyGone()
	module:Frenzy()
	
	module:BigWigs_RecvSync(syncName.frenzy)
	module:BigWigs_RecvSync(syncName.frenzyOver)
	module:BigWigs_RecvSync(syncName.fear)
	module:BigWigs_RecvSync(syncName.enrage)
end
