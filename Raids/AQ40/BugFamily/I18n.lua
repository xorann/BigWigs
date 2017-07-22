------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.aq40.bugFamily
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "BugFamily",

	-- commands
	panic_cmd = "panic",
	panic_name = "Fear",
	panic_desc = "Warn for Princess Yauj's Panic.",

	toxicvolley_cmd = "toxicvolley",
	toxicvolley_name = "Toxic Volley",
	toxicvolley_desc = "Warn for Lord Kri's Toxic Volley.",

	heal_cmd = "heal",
	heal_name = "Great Heal",
	heal_desc = "Announce Princess Yauj's heals.",

	announce_cmd = "announce",
	announce_name = "Poison Cloud",
	announce_desc = "Whispers players that stand in the Poison Cloud.\n\n(Requires assistant or higher)",

	deathspecials_cmd = "deathspecials",
	deathspecials_name = "Death Specials",
	deathspecials_desc = "Lets people know which boss has been killed and what special abilities they do.",

	enrage_cmd = "enrage",
	enrage_name = "Enrage",
	enrage_desc = "Enrage timers.",

	-- triggers
	trigger_heal = "Princess Yauj begins to cast Great Heal\.",
	trigger_attack1 = "Princess Yauj attacks",
	trigger_attack2 = "Princess Yauj misses",
	trigger_attack3 = "Princess Yauj hits",
	trigger_attack4 = "Princess Yauj crits",
	trigger_toxicVolleyHit = "Toxic Volley hits",
	trigger_toxicVolleyAfflicted = "afflicted by Toxic Volley\.",
	trigger_toxicVolleyResist = "Toxic Volley was resisted",
	trigger_toxicVolleyImmune = "Toxic Volley fail(.+) immune",
	trigger_panic = "is afflicted by Fear%.",
	trigger_panicResist = "Princess Yauj 's Fear was resisted",
	trigger_panicImmune = "Princess Yauj 's Fear fail(.+) immune",
	trigger_toxicVaporsYou = "You are afflicted by Toxic Vapors\.",
	trigger_toxicVaporsOther = "(.+) is afflicted by Toxic Vapors\.",
	trigger_enrage = "%s goes into a berserker rage!",

	-- messages
	msg_heal = "Casting heal!",
	msg_panic = "Fear in 3 Seconds!",
	msg_toxicVolley = "Toxic Volley in 3 Seconds!",
	msg_toxicVapors = "Move away from the Poison Cloud!",
	msg_enrage5m = "Enrage in 5 minutes!",
	msg_enrage3m = "Enrage in 3 minutes!",
	msg_enrage90 = "Enrage in 90 seconds!",
	msg_enrage90 = "Enrage in 60 seconds!",
	msg_enrage30 = "Enrage in 30 seconds!",
	msg_enrage10 = "Enrage in 10 seconds!",
	msg_kriDead = "Lord Kri is dead! Poison Cloud spawned!",
	msg_yaujDead = "Princess Yauj is dead! Kill the spawns!",
	msg_vemDead = "Vem is dead!",
	msg_vemDeadKriEnrage = "Vem is dead! Lord Kri is enraged!",
	msg_vemDeadYaujEnrage = "Vem is dead! Princess Yauj is enraged!",
	msg_vemDeadBothEnrage = "Vem is dead! Lord Kri & Princess Yauj are enraged!",
	msg_enrage = "Enraged!",

	-- bars
	bar_heal = "Great Heal",
	bar_panic = "Panic",
	bar_panicFirst = "Possible Panic",
	bar_toxicVolley = "Toxic Volley",
	bar_enrage = "Enrage",

	-- misc

} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	panic_cmd = "panic",
	panic_name = "Furcht",
	panic_desc = "Warnung f\195\188r Prinzessin Yaujs Furcht.",

	toxicvolley_cmd = "toxicvolley",
	toxicvolley_name = "Toxische Salve",
	toxicvolley_desc = "Warnung f\195\188r Lord Kris Toxische Salve.",

	heal_cmd = "heal",
	heal_name = "Gro\195\159e Heilung",
	heal_desc = "Verk\195\188ndet Prinzessin Yaujs Heilungen.",

	announce_cmd = "announce",
	announce_name = "Giftwolke",
	announce_desc = "Fl\195\188stert Spielern, dass sie in der Giftwolke stehen.\n\n(Ben\195\182tigt Schlachtzugleiter oder Assistent)",

	deathspecials_cmd = "deathspecials",
	deathspecials_name = "Spezielle Todeseffekte",
	deathspecials_desc = "Informiert Spieler, welcher Boss bereits get\195\182tet wurde und welche Spezialf\195\164higkeiten sie haben.",

	enrage_cmd = "enrage",
	enrage_name = "Raserei",
	enrage_desc = "Zeit, bis der Boss in Raserei verf\195\164llt.",

	-- triggers
	trigger_heal = "Prinzessin Yauj beginnt Großes Heilen zu wirken.",
	trigger_attack1 = "Prinzessin Yauj greift an",
	trigger_attack2 = "Prinzessin Yauj verfehlt",
	trigger_attack3 = "Prinzessin Yauj trifft",
	trigger_attack4 = "Prinzessin Yauj trifft (.+) kritisch",
	trigger_toxicVolleyHit = "Toxische Salve trifft",
	trigger_toxicVolleyAfflicted = "von Toxische Salve betroffen",
	trigger_toxicVolleyResist = "Toxische Salve(.+) widerstanden",
	trigger_toxicVolleyImmune = "Toxische Salve(.+) Ein Fehlschlag(.+) immun",
	trigger_panic = "von Furcht betroffen",
	trigger_panicResist = "Furcht(.+) widerstanden",
	trigger_panicImmune = "Furcht(.+) immun",
	trigger_toxicVaporsYou = "Ihr seid von Toxische Dämpfe betroffen.",
	trigger_toxicVaporsOther = "(.+) ist von Toxische Dämpfe betroffen.",
	trigger_enrage = "%s goes into a berserker rage!",

	-- messages
	msg_heal = "Wirkt Heilung!",
	msg_panic = "Furcht in 3 Sekunden!",
	msg_toxicVolley = "Toxische Salve in 3 Sekunden!",
	msg_toxicVapors = "Beweg dich aus der Giftwolke raus!",
	msg_enrage5m = "Raserei in 5 Minuten!",
	msg_enrage3m = "Raserei in 3 Minuten!",
	msg_enrage90 = "Raserei in 90 Sekunden!",
	msg_enrage90 = "Raserei in 60 Sekunden!",
	msg_enrage30 = "Raserei in 30 Sekunden!",
	msg_enrage10 = "Raserei in 10 Sekunden!",
	msg_kriDead = "Lord Kri ist tot! Giftwolke hat sich gebildet!",
	msg_yaujDead = "Prinzessin Yauj ist tot! T\195\182te die kleinen K\195\164fer!",
	msg_vemDead = "Vem ist tot!",
	msg_vemDeadKriEnrage = "Vem ist tot! Lord Kri verf\195\164llt in Raserei!",
	msg_vemDeadYaujEnrage = "Vem ist tot! Prinzessin Yauj verf\195\164llt in Raserei!",
	msg_vemDeadBothEnrage = "Vem ist tot! Lord Kri & Prinzessin Yauj verfallen in Raserei!",
	msg_enrage = "Raserei!",

	-- bars
	bar_heal = "Gro\195\159e Heilung",
	bar_panic = "Furcht",
	bar_panicFirst = "Mögliche Furcht",
	bar_toxicVolley = "Toxische Salve",
	bar_enrage = "Raserei",

	-- misc

} end )

