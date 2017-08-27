------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.heigan
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = { L["Eye Stalk"], L["Rotting Maggot"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"engage", "teleport", "disease", "erruption", "bosskill"}


-- locals
module.timer = {
    firstDisease = 8,
	disease = 21,
	toFloor = 45,
	toPlatform = 90,
    firstErruption = 10,
    firstDanceErruption = 5,
    erruption = 0, -- will be changed during the encounter
    erruptionSlow = 10,
    erruptionFast = 3.2,
    dancing = 10,
}
local timer = module.timer

module.icon = {
	disease = "Ability_Creature_Disease_03",
	toFloor = "Spell_Magic_LesserInvisibilty",
	toPlatform = "Spell_Arcane_Blink",
    erruption = "spell_fire_selfdestruct",
    dancing = "INV_Gizmo_RocketBoot_01",
}
local icon = module.icon

module.syncName = {
	toPlatform = "HeiganToPlatform",
    toFloor = "HeiganToFloor",
	disease = "HeiganDisease",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.disease then
		self:Disease()
	elseif sync == syncName.toPlatform then
		self:ToPlatform()
    elseif sync == syncName.toFloor then
        self:ToFloor()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Disease()
    if self.db.profile.disease then
        self:Message(L["msg_decrepitFever"], "Important") 
    
        -- don't show bar before teleport
        local registered, time, elapsed = self:BarStatus(L["bar_toPlatform"])
        if time and elapsed then
            local remaining = time - elapsed
            if timer.disease < remaining then
                self:Bar(L["bar_decrepitFever"], timer.disease, icon.disease)
            end
        end
    end
end

function module:ToPlatform()	
	if self.db.profile.teleport then
		self:Message(string.format(L["msg_onPlatform"], timer.toFloor), "Attention")
		self:Bar(L["bar_toFloor"], timer.toFloor, icon.toFloor)
	end
    if self.db.profile.erruption then
        self:CancelScheduledEvent("HeiganErruption")
        
        timer.erruption = timer.erruptionFast
        self:Bar(L["bar_erruption"], timer.firstDanceErruption, icon.erruption) 
        self:ScheduleEvent("HeiganErruption", self.Erruption, timer.firstDanceErruption, self)
    end
end

function module:ToFloor()
	if self.db.profile.teleport then
		self:Message(L["msg_onFloor"], "Attention")
		self:Bar(L["bar_toPlatform"], timer.toPlatform, icon.toPlatform)
	end
    if self.db.profile.disease then
        self:Bar(L["bar_decrepitFever"], timer.firstDisease, icon.disease)
    end
    if self.db.profile.erruption then
        self:CancelScheduledEvent("HeiganErruption")
        
        timer.erruption = timer.erruptionSlow
        self:Bar(L["bar_erruption"], timer.erruption, icon.erruption) 
        self:ScheduleEvent("HeiganErruption", self.Erruption, timer.erruption, self)
    end
end


------------------------------
-- Utility	Functions   	--
------------------------------
function module:Erruption()
    if self.db.profile.erruption then
        -- don't show bar before teleport
        local registered, time, elapsed = self:BarStatus(L["bar_toPlatform"])
        if registered and timer and elapsed then
            local remaining = time - elapsed
            if timer.erruption + 1 < remaining then
                self:Bar(L["bar_erruption"], timer.erruption, icon.erruption)
                self:ScheduleEvent("HeiganErruption", self.Erruption, timer.erruption, self)
            else
                self:Sound("Beware")
                self:Bar(L["bar_dancingShoes"], timer.dancing, icon.dancing)
            end
        else
            self:Bar(L["bar_erruption"], timer.erruption, icon.erruption)
            self:ScheduleEvent("HeiganErruption", self.Erruption, timer.erruption, self)
        end
        
    end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:ToFloor()
	module:ToPlatform()
	module:Disease()
	
	module:BigWigs_RecvSync(syncName.disease)
	module:BigWigs_RecvSync(syncName.toPlatform)
	module:BigWigs_RecvSync(syncName.toFloor)
end
