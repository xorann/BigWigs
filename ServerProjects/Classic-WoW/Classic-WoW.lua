
assert(BigWigs, "BigWigs not found!")

--[[
	Support for Classic-WoW Project (classic-wow.org)
	
	Servers:
		- Nefarian
		- Open-Beta (Naxxramas)

	Server name has to be the value you get from GetRealmName()
]]

local project = "Classic-WoW"
BigWigs:RegisterServer(project, "Nefarian")
BigWigs:RegisterServer(project, "Open-Beta (Naxxramas)")

-- Supported Boss Modules
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.skeram)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.twins)
