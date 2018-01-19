
assert(BigWigs, "BigWigs not found!")

--[[
	Support for OtherProject Project (OtherProject.tld)
	
	Servers:
		- OtherProjectServer1
		- OtherProjectServer2

	Server name has to be the value you get from GetRealmName()
]]

local project = "OtherProject"
BigWigs:RegisterServer(project, "Nefarian2")
BigWigs:RegisterServer(project, "OtherProjectServer2")

-- Supported Boss Modules
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.twins)
