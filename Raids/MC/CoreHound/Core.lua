------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.mc.coreHound
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014
module.enabletrigger = module.translatedName
module.toggleoptions = {"bars" --[[, "bosskill"]]}


-- locals
module.timer = {
	firstAbility = 10,
	ability = 14,
}
local timer = module.timer

module.icon = {
	ability = "Spell_Shadow_UnholyFrenzy"
}
local icon = module.icon

module.syncName = {
	ability = "CoreHoundDebuff",
}
local syncName = module.syncName

module.abilityTable = {
	["Ancient Dread"] = L["misc_dread"],
	["Ancient Despair"] = L["misc_dispair"],
	["Ground Stomp"] = L["misc_stomp"],
	["Cauterizing Flames"] = L["misc_flames"],
	["Withering Heat"] = L["misc_heat"],
	["Ancient Hysteria"] = L["misc_hysteria"]
}


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.ability and rest then
		if self.db.profile.bars then		
			local ability = module.abilityTable[rest]
			if ability then
				self:RemoveBar(L["bar_unknown"])
				self:Bar(ability, timer.ability, icon.ability)
			end
		end
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:BigWigs_RecvSync(syncName.ability, "Ancient Dread")
	module:BigWigs_RecvSync(syncName.ability, "Ancient Despair")
	module:BigWigs_RecvSync(syncName.ability, "Ground Stomp")
	module:BigWigs_RecvSync(syncName.ability, "Cauterizing Flames")
	module:BigWigs_RecvSync(syncName.ability, "Withering Heat")
	module:BigWigs_RecvSync(syncName.ability, "Ancient Hysteria")
end
