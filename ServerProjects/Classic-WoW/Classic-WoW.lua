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
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.onyxia.onyxia)

BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.mc.lucifron)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.mc.magmadar)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.mc.gehennas)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.mc.garr)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.mc.geddon)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.mc.shazzrah)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.mc.sulfuron)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.mc.golemagg)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.mc.majordomo)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.mc.ragnaros)

BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.bwl.razorgore)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.bwl.vaelastrasz)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.bwl.broodlord)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.bwl.firemaw)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.bwl.ebonroc)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.bwl.flamegor)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.bwl.chromaggus)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.bwl.nefarian)

BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.zg.jeklik)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.zg.venoxis)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.zg.marli)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.zg.mandokir)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.zg.grilek)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.zg.hazzarah)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.zg.renataki)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.zg.wushoolay)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.zg.gahzranka)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.zg.thekal)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.zg.arlokk)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.zg.jindo)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.zg.hakkar)

BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq20.kurinnaxx)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq20.rajaxx)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq20.moam)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq20.guardians)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq20.ossirian)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq20.buru)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq20.ayamiss)

BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.skeram)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.bugFamily)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.sartura)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.fankriss)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.viscidus)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.huhuran)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.defenders)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.twins)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.ouro)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.aq40.cthun)

BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.naxx.anubrekhan)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.naxx.faerlina)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.naxx.maexxna)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.naxx.noth)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.naxx.heigan)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.naxx.loatheb)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.naxx.patchwerk)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.naxx.grobbulus)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.naxx.gluth)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.naxx.thaddius)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.naxx.razuvious)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.naxx.gothik)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.naxx.horsemen)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.naxx.sapphiron)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.naxx.kelthuzad)

BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.other.azuregos)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.other.kazzak)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.other.emeriss)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.other.lethon)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.other.taerar)
BigWigs:ServerProjectSupportsBoss(project, BigWigs.bossmods.other.ysondre)
