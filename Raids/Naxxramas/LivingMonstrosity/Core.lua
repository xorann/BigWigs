--[[
    Created by Vnm-Kronos - https://github.com/Vnm-Kronos
    modified by Dorann
--]]

------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.livingmonstrosity
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20015 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = { "lightningtotem" }
module.trashMod = true

-- locals
module.timer = {
	lightningTotem = {
		min = 0.5, 
		max = 2
	} -- we want to use intervalbar so ppl don't miss such a fast cast
}
local timer = module.timer

module.icon = {
	lightningTotem = "Spell_Nature_Lightning"
}
local icon = module.icon

module.syncName = {
	lightningTotemCast = "LivingMonstrosityLightningTotemCast",
	lightningTotemSummon = "LivingMonstrosityLightningTotemSummon",
	lightningTotemDeath = "LivingMonstrosityLightningTotemDeath"
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.lightningTotemCast then
		self:LightningTotemCast()
	elseif sync == syncName.lightningTotemSummon then
		self:LightningTotemSummon()
	elseif sync == syncName.lightningTotemDeath then
		self:LightningTotemDeath()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:LightningTotemCast()
	if self.db.profile.lightningtotem then
		self:Message(L["message_lightningtotem"], "Urgent")
		self:Bar(L["bar_lightningtotem"], timer.lightningTotem, icon.lightningTotem)
	end
end

function module:LightningTotemSummon()
	if self.db.profile.lightningtotem then
		self:Message(L["message_lightningtotem"], "Urgent")
		self:WarningSign(icon.lightningTotem, 5)
	end
end

function module:LightningTotemDeath()
	if self.db.profile.lightningtotem then
		self:RemoveWarningSign(icon.lightningTotem)
	end
end

----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:LightningTotemCast()
	module:LightningTotemSummon()
	module:LightningTotemDeath()
	
	module:BigWigs_RecvSync(syncName.lightningTotemCast)
	module:BigWigs_RecvSync(syncName.lightningTotemSummon)
	module:BigWigs_RecvSync(syncName.lightningTotemDeath)
end
