------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.mc.sulfuron
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = { L["misc_addName"] }
module.toggleoptions = {"heal", "adds", "knockback", "bosskill"}

module.defaultDB = {
	adds = false,
}


-- locals
module.timer = {
	knockback = 13.5,
    firstKnockback = 5.8,
    heal = 2,
    flame_spear = 13,
}
local timer = module.timer

module.icon = {
	knockback = "Spell_Fire_Fireball",
    heal = "Spell_Shadow_ChillTouch",
    flame_spear = "Spell_Fire_FlameBlades",
}
local icon = module.icon

module.syncName = {
	knockback = "SulfuronKnockback",
    heal = "SulfuronAddHeal",
    flame_spear = "SulfuronSpear",
    add_dead = "SulfuronAddDead",
}
local syncName = module.syncName

module.deadpriests = 0


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)    
    if sync == syncName.add_dead and rest and rest ~= "" then
        rest = tonumber(rest)
        self:AddDeath(rest)
	elseif sync == syncName.heal then
		self:Heal()
	elseif sync == syncName.knockback then
		self:Knockback()
    elseif sync == syncName.flame_spear then
        self:FlameSpear()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:AddDeath(number)
	if number and number <= 4 and module.deadpriests < number then
		module.deadpriests = number
		if self.db.profile.adds then
			self:Message(string.format(L["msg_adds"], module.deadpriests), "Positive")
			--self:TriggerEvent("BigWigs_SetCounterBar", self, "Priests dead", (4 - deadpriests))
		end
	end
end

function module:Heal()
	if self.db.profile.heal then		
		self:Message(L["msg_heal"], "Attention", true, "Alarm")
		self:Bar(L["bar_heal"], timer.heal, icon.heal, true, BigWigsColors.db.profile.interrupt)
	end
end

function module:Knockback()
	if self.db.profile.knockback then
		self:Bar(L["bar_knockback"], timer.knockback, icon.knockback)
		self:DelayedMessage(timer.knockback - 3, L["msg_knockbackSoon"], "Urgent")
	end
end

function module:FlameSpear()
	self:Bar(L["bar_flameSpear"], timer.flame_spear, icon.flame_spear)
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:AddDeath(1)
	module:Heal()
	module:Knockback()
	module:FlameSpear()
	
	module:BigWigs_RecvSync(syncName.add_dead, 1)
	module:BigWigs_RecvSync(syncName.heal)
	module:BigWigs_RecvSync(syncName.knockback)
	module:BigWigs_RecvSync(syncName.flame_spear)
end
