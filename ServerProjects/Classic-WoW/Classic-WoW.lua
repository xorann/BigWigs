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
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.bwl.razorgore)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.bwl.vaelastrasz)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.bwl.broodlord)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.bwl.firemaw)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.bwl.ebonroc)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.bwl.flamegor)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.bwl.chromaggus)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.bwl.nefarian)

BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.skeram)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.sartura)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.fankriss)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.huhuran)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.twins)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.ouro)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.cthun)
