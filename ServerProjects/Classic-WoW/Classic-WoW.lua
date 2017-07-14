
assert(BigWigs, "BigWigs not found!")

--[[
	Support for Classic-WoW Project (classic-wow.org)
	
	Servers:
		- Nefarian
		- Open-Beta (Naxxramas)
]]
local project = "Classic-WoW"
BigWigs:RegisterServer(project, "Nefarian")
BigWigs:RegisterServer(project, "Open-Beta (Naxxramas)")

-- Supported Boss Modules
BigWigs:SetServerBossSupport(project, "The Twin Emperors")