------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.mc.shazzrah
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
-- module.wipemobs = { L["misc_addName"] }
module.toggleoptions = {"curse", "deaden", "blink", "counterspell", "bosskill"}



-- locals
module.timer = {
	cs = 19,
    firstCS = 10,
    curse =  22, 
    firstCurse = 10,
    blink = 45,
    firstBlink = 30,
    deaden = 24,
    firstDeaden = 15,
}
local timer = module.timer

module.icon = {
    cs = "Spell_Frost_IceShock",
    curse = "Spell_Shadow_AntiShadow",
    blink = "Spell_Arcane_Blink",
    deaden = "Spell_Holy_SealOfSalvation",
}
local icon = module.icon

module.syncName = {
	cs = "ShazzrahCounterspell2",
    curse = "ShazzrahCurse2",
    blink = "ShazzrahBlink1",
    deaden = "ShazzrahDeadenMagicOn",
    deadenOver = "ShazzrahDeadenMagicOff",
}
local syncName = module.syncName

local _, playerClass = UnitClass("player")
module.playerClass = playerClass
module.firstblink = true


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.blink then
        self:Blink()
	elseif sync == syncName.deaden  then
        self:DeadenMagic()
	elseif sync == syncName.deadenOver then
		self:DeadenMagicOver()
	elseif sync == syncName.curse then
		self:Curse()
	elseif sync == syncName.cs then
		self:Counterspell()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Counterspell()
    if self.db.profile.counterspell then
        self:Bar(L["bar_counterspell"], timer.cs, icon.cs)
    end
    self:DelayedSync(timer.cs, syncName.cs)
end

function module:Curse()
    self:Message(L["msg_curse"], "Attention", "Alarm")
    --self:Bar(L["bar_curse"], timer.curse, icon.curse) -- seems to be completly random
end

function module:Blink()
	module.firstblink = false
    self:KTM_Reset()
    
    if self.db.profile.blink then
        self:Message(L["msg_blinkNow"], "Important")
        self:Bar(L["bar_blink"], timer.blink, icon.blink)
        
        self:DelayedMessage(timer.blink - 5, L["msg_blinkSoon"], "Attention", "Alarm", nil, nil, true)
    end
    
    self:DelayedSync(timer.blink, syncName.blink)
end

function module:DeadenMagic()
    if self.db.profile.deaden then
        self:RemoveBar(L["bar_deaden"])
        self:Message(L["msg_deaden"], "Important")
        self:Bar(L["bar_deaden"], timer.deaden, icon.deaden)
        if module.playerClass == "SHAMAN" or module.playerClass == "PRIEST" then
            self:WarningSign(icon.deaden, timer.deaden)
        end
    end
end

function module:DeadenMagicOver()
    if self.db.profile.deaden then
        self:RemoveBar(L["bar_deaden"])
        if module.playerClass == "SHAMAN" or module.playerClass == "PRIEST" then
            self:RemoveWarningSign(icon.deaden)
        end
    end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:DeadenMagic()
	module:DeadenMagicOver()
	module:Blink()
	module:Curse()
	module:Counterspell()	
	
	module:BigWigs_RecvSync(syncName.blink)
	module:BigWigs_RecvSync(syncName.deaden)
	module:BigWigs_RecvSync(syncName.deadenOver)
	module:BigWigs_RecvSync(syncName.curse)
	module:BigWigs_RecvSync(syncName.cs)
end
