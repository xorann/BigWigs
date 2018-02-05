--[[
    Created by Vnm-Kronos - https://github.com/Vnm-Kronos
    modified by Dorann
--]]

------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.venomstalker
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

local venomstalker = AceLibrary("Babble-Boss-2.2")["Venom Stalker"]
local necrostalker = AceLibrary("Babble-Boss-2.2")["Necro Stalker"]

-- module variables
module.revision = 20015 -- To be overridden by the module!
module.enabletrigger = {venomstalker, necrostalker} -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"charge"}
module.trashMod = true

-- locals
module.timer = {
	charge = {
		min = 10, 
		max = 15
	}
}
local timer = module.timer

module.icon = {
	charge = "spell_nature_corrosivebreath",
}
local icon = module.icon

module.syncName = {
	charge = "VenomStalkerCharge",
	death = "VenomStalkerDeath"
}
local syncName = module.syncName

module.deathCount = nil
module.chargeNumber = nil
module.lastCharge = nil
module.poisonsOnSelf = nil

------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.charge then
		self:Charge()
	elseif sync == syncName.death and rest then
		self:Death(rest)
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Charge()
	if self.db.profile.charge then
		if not module.lastCharge then
			module.chargeNumber = 1
		elseif module.lastCharge and module.lastCharge + 0.5 < GetTime() then
			local elapsed = GetTime() - module.lastCharge
			
			if elapsed < timer.charge.min then
				if module.chargeNumber == 1 then
					module.chargeNumber = 2
				else
					module.chargeNumber = 1
				end
			end
		end
		
		self:Bar(string.format(L["bar_charge"], module.chargeNumber), timer.charge, icon.charge)
		module.lastCharge = GetTime()
	end
end

function module:Death(msg)
	module.deathCount = module.deathCount + 1
	if module.deathCount == 2 then
		BigWigs:CheckForBossDeath(msg, self)
	end
end

----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:Charge()
	module:Death("")
	
	module:BigWigs_RecvSync(syncName.charge)
	module:BigWigs_RecvSync(syncName.death, "")
end
