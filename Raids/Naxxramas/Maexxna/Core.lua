------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.maexxna
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"spray", "poison", "cocoon", "enrage", "bosskill"}


-- locals
module.timer = {
	poison = 20,
	cocoon = 20,
	spider = 30,
	webspray = 40,
}
local timer = module.timer

module.icon = {
	charge = "Spell_Frost_FrostShock",
	teleport = "Spell_Arcane_Blink",
	cocoon = "Spell_Nature_Web",
	spider = "INV_Misc_MonsterSpiderCarapace_01",
	webspray = "Ability_Ensnare",
	poison = "Ability_Creature_Poison_03",
}
local icon = module.icon

module.syncName = {
	webspray = "MaexxnaWebspray",
	poison = "MaexxnaPoison",
	cocoon = "MaexxnaCocoon",
	enrageSoon = "MaexxnaEnrageSoon",
	enrage = "MaexxnaEnrage",
}
local syncName = module.syncName


module.times = nil
module.enrageannounced = nil
module.firstWebspray = nil


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest)
	if sync == syncName.webspray then
		self:Webspray()
	elseif sync == syncName.poison then
		self:Poison()
	elseif sync == syncName.cocoon and rest then
		self:Cocoon(rest)
	elseif sync == syncName.enrageSoon then
		self:EnrageSoon()
	elseif sync == syncName.enrage then
		self:Enrage()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Webspray()
	if self.db.profile.spray then
		if not module.firstWebspray then
			module.firstWebspray = true
			self:Message(L["msg_webSpray"], "Important")
		end
		self:Bar(L["bar_cocoon"], timer.cocoon, icon.cocoon)
		self:Bar(L["bar_spider"], timer.spider, icon.spider)
		self:Bar(L["bar_webSpray"], timer.webspray, icon.webspray)
	end
end

function module:Poison()
	if self.db.profile.poison then 
		self:Message(L["msg_poison"], "Important")
		self:Bar(L["bar_poison"], timer.poison, icon.poison)
	end
end

function module:Cocoon(player)
	local t = GetTime()
	if (not module.times[player]) or (module.times[player] and (module.times[player] + 10) < t) then
		if self.db.profile.cocoon then 
			self:Message(string.format(L["msg_cocoon"], player), "Urgent") 
		end
		module.times[player] = t
	end
end

function module:EnrageSoon()
	if self.db.profile.enrage then 
		self:Message(L["msg_enrageSoon"], "Important") 
	end
end

function module:Enrage()
	if self.db.profile.enrage then 
		self:Message(L["msg_enrage"], "Important", nil, "Beware") 
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:Enrage()
	module:EnrageSoon()
	module:Cocoon("test")
	module:Poison()
	module:Webspray()
	
	module:BigWigs_RecvSync(syncName.webspray)
	module:BigWigs_RecvSync(syncName.poison)
	module:BigWigs_RecvSync(syncName.cocoon, 1)
	module:BigWigs_RecvSync(syncName.enrageSoon)
	module:BigWigs_RecvSync(syncName.enrage)
end
