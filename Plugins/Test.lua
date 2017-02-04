
------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsTest")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["test"] = true,
	["Test"] = true,
	["Test Bar"] = true,
	["Test Bar 2"] = true,
	["Test Bar 3"] = true,
	["Test Bar 4"] = true,
	["Testing"] = true,
	["OMG Bear!"] = true,
	["*RAWR*"] = true,
	["Victory!"] = true,
	["Options for testing."] = true,
	["local"] = true,
	["Local test"] = true,
	["Perform a local test of BigWigs."] = true,
	["sync"] = true,
	["Sync test"] = true,
	["Perform a sync test of BigWigs."] = true,
	["Testing Sync"] = true,
} end)

L:RegisterTranslations("deDE", function() return {
	-- ["test"] = true,
	--["Test"] = "Test",
	["Test Bar"] = "Test Balken",
	["Test Bar 2"] = "Test Balken 2",
	["Test Bar 3"] = "Test Balken 3",
	["Test Bar 4"] = "Test Balken 4",
	["Testing"] = "Teste",
	["OMG Bear!"] = "OMG Bär!",
	["*RAWR*"] = "RAWR",
	["Victory!"] = "Sieg!",
	["Options for testing."] = "Optionen für den Test von BigWigs.",
	["local"] = "Lokal",
	["Local test"] = "Lokaler Test",
	["Perform a local test of BigWigs."] = "Lokalen Test durchführen.",
	--["sync"] = "sync",
	["Sync test"] = "Synchronisations-Test",
	["Perform a sync test of BigWigs."] = "Sychronisations-Test durchführen.",
	["Testing Sync"] = "Synchronisation testen",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsTest = BigWigs:NewModule(L["Test"])
BigWigsTest.revision = 20003

BigWigsTest.consoleCmd = L["test"]
BigWigsTest.consoleOptions = {
	type = "group",
	name = L["Test"],
	desc = L["Options for testing."],
	args   = {
		[L["local"]] = {
			type = "execute",
			name = L["Local test"],
			desc = L["Perform a local test of BigWigs."],
			func = function() BigWigsTest:TriggerEvent("BigWigs_Test") end,
		},
		[L["sync"]] = {
			type = "execute",
			name = L["Sync test"],
			desc = L["Perform a sync test of BigWigs."],
			func = function() BigWigsTest:TriggerEvent("BigWigs_SyncTest") end,
			disabled = function() return ( not IsRaidLeader() and not IsRaidOfficer() ) end,
		},
	}
}

function BigWigsTest:OnEnable()
	self:RegisterEvent("BigWigs_Test")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "TestSync", 5)
	self:RegisterEvent("BigWigs_SyncTest")
end


function BigWigsTest:BigWigs_SyncTest()
	self:TriggerEvent("BigWigs_SendSync", "TestSync")
end


function BigWigsTest:BigWigs_RecvSync(sync, rest, nick)
	if sync == "TestSync" then
		self:Message(L["Testing Sync"], "Positive")
		self:Bar(L["Testing Sync"], 10, "Spell_Frost_FrostShock", true, "Green", "Blue", "Yellow", "Red")
    elseif sync == "TestNumber" and rest then
        --SendChat(rest)
        rest = tonumber(rest)
        if type(rest) == "number" then
            --SendChat(rest * 2) 
        end
	end
end


function BigWigsTest:BigWigs_Test()
    self:Message(L["Testing"], "Attention", true, "Long")
	self:Bar(L["Test Bar 4"], 3, "Spell_Nature_ResistNature", true, "black")
    self:Bar(L["Test Bar 3"], 5, "Spell_Nature_ResistNature", true, "red")
    self:Bar(L["Test Bar 2"], 16, "Inv_Hammer_Unique_Sulfuras")
	self:Bar(L["Test Bar"], 20, "Spell_Nature_ResistNature")
    self:WarningSign("Inv_Hammer_Unique_Sulfuras", 10)
    
	self:DelayedMessage(5, L["OMG Bear!"], "Important", true, "Alert")
	self:DelayedMessage(10, L["*RAWR*"], "Urgent", true, "Alarm")
	self:DelayedMessage(20, L["Victory!"], "Bosskill", true, "Victory")
    
    self:Sync("TestNumber 5")
    
    BigWigs:Proximity()
    
    local function deactivate()
        BigWigs:RemoveProximity()
    end
    
    self:ScheduleEvent("BigWigsTestOver", deactivate, 20, self)
    
    --self:Sync("BossEngaged "..self:ToString())
    
	
    
    --self:TriggerEvent("BigWigs_StartCounterBar", self, "CounterBar Test", 10, "Spell_Shadow_Charm")
    --self:TriggerEvent("BigWigs_StartCounterBar", self, "CounterBar Test2", 30, "Spell_Shadow_Charm", true, "red")
end

--function BigWigsTest:TestCounter()
--    self:TriggerEvent("BigWigs_SetCounterBar", self, "CounterBar Test", 5, true)
--end
