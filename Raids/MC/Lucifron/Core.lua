------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.mc.lucifron
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = { L["misc_addName"] }
module.toggleoptions = {"adds", "curse", "doom", "mc", "bosskill"}

module.defaultDB = {
	adds = false,
}


-- locals
module.timer = {
	curse = 20,
	doom = 15,
	firstDoom = 10,
	mc = 15,
}
local timer = module.timer

module.icon = {
	curse = "Spell_Shadow_BlackPlague",
	doom = "Spell_Shadow_NightOfTheDead",
	mc = "Spell_Shadow_ShadowWordDominate",
}
local icon = module.icon

module.syncName = {
	curse = "LucifronCurseRep1",
	doom = "LucifronDoomRep1",
	shock = "LucifronShock1",
	mc = "LucifronMC_",
	mcEnd = "LucifronMCEnd_",
	add = "LucifronAddDead",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.curse then
		self:Curse()
	elseif sync == syncName.doom then
		self:Doom()
	elseif string.find(sync, syncName.mc) then
		local chosenone = string.sub(sync, 12)
		self:MindControl(chosenone)
	elseif string.find(sync, syncName.mcEnd) then
		local luckyone = string.sub(sync, 15)
		self:MindControlGone(luckyone)
	elseif sync == syncName.add and rest and rest ~= "" then
        rest = tonumber(rest)
		self:AddDeath(rest)
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Curse()
	if self.db.profile.curse then
		self:DelayedMessage(timer.curse - 5, L["msg_curseSoon"], "Attention", nil, nil, true)
		self:Bar(L["bar_curse"], timer.curse, icon.curse)
	end
end

function module:Doom()
	if self.db.profile.doom then
		self:DelayedMessage(timer.doom - 5, L["msg_doomSoon"], "Attention", nil, nil, true)
		self:Bar(L["bar_doom"], timer.doom, icon.doom)
	end
end

function module:MindControl(name)
	if self.db.profile.mc and name then
		if name == UnitName("player") then
			self:Message(L["msg_mindControlYou"], "Attention")
			self:Bar(string.format(L["bar_mindControl"], UnitName("player")), timer.mc, icon.mc, true, BigWigsColors.db.profile.mindControl)
		else
			self:Message(string.format(L["msg_mindControlOther"], name), "Urgent")
			self:Bar(string.format(L["bar_mindControl"], name), timer.mc, icon.mc, true, BigWigsColors.db.profile.mindControl)
		end
	end
end

function module:MindControlGone(name)
	if self.db.profile.mc and name then
		self:RemoveBar(string.format(L["bar_mindControl"], name))
	end
end

function module:AddDeath(number)
	if number and number <= 4 and self.protector < number then
		self.protector = number
		if self.db.profile.adds then
			self:Message(string.format(L["msg_add"], self.protector), "Positive")
		end
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Curse()
	module:Doom()
	module:MindControl(UnitName("player"))
	module:MindControlGone(UnitName("player"))
	module:AddDeath(1)
	
	module:BigWigs_RecvSync(syncName.curse)
	module:BigWigs_RecvSync(syncName.doom)
	module:BigWigs_RecvSync(syncName.mc .. UnitName("player"))
	module:BigWigs_RecvSync(syncName.mcEnd .. UnitName("player"))
	module:BigWigs_RecvSync(syncName.add, 1)
end
