------------------------------
-- Localization      		--
------------------------------

local bossName = BigWigs.bossmods.zg.grilek
local L = BigWigs.i18n[bossName]

L:RegisterTranslations("enUS", function() return {
	cmd = "Grilek",

	-- commands
	avatar_cmd = "avatar",
	avatar_name = "Avatar alert",
	avatar_desc = "Announce when the boss has Avatar (enrage phase).",
	
	melee_cmd = "melee",
	melee_name = "Warnings for melee",
	melee_desc = "Warn before Avatar is cast, so melee classes can get away from the boss in time.",

	announce_cmd = "announce",
	announce_name = "Whisper players",
	announce_desc = "Lets players know that they are being targetted by Gri'lek so they run away.",

	puticon_cmd = "puticon",
	puticon_name = "Place icon",
	puticon_desc = "Place a raid icon on the targetted player.\n\n(Requires assistant or higher)",
	
	-- triggers
	trigger_avatarGain = "Gri\'lek gains Avatar\.",
	trigger_avatarGone = "Avatar fades from Gri\'lek\.",
	
	-- messages
	msg_avatarSoon = "Avatar soon! Melee get out!",
	msg_avatarNow = "Avatar! Run away from the boss!",
	msg_avatarYou = "Gri'lek is coming for you! Run away!",
	msg_avatarWhisper = "Gri'lek is coming for you! Run away!",
	msg_avatarOther = "Gri'lek is going for %s!",
	
	-- bars
	bar_avatar = "Avatar",
	
	-- misc	

} end )

L:RegisterTranslations("deDE", function() return {
	cmd = "Grilek",

	-- commands
	avatar_cmd = "avatar",
	avatar_name = "Alarm für Avatar",
	avatar_desc = "Ankündigen wenn der Boss Avatar ist (Raserei Phase).",
	
	melee_cmd = "melee",
	melee_name = "Warnunken für die Nahkämpfer",
	melee_desc = "Warnt bevor Avatar gewirkt wird, sodass die Nahkämpfer Zeit haben sich vom Boss zu entfernen.",

	announce_cmd = "announce",
	announce_name = "Benachrichtigt Spieler",
	announce_desc = "Informiert Spieler, dass Gri\'lek sie verfolgt, sodass sie rechtzeitig weglaufen können.",

	puticon_cmd = "puticon",
	puticon_name = "Setzt Schlachtzugssymbole",
	puticon_desc = "Setzt ein Schlachtzugssymbol auf den verfolgten Spieler.\n\n(Benötigt Schlachtzugleiter oder Assistent)",
	
	-- triggers
	trigger_avatarGain = "Gri\'lek bekommt \'Avatar\'\.",
	trigger_avatarGone = "Avatar schwindet von Gri\'lek\.",
	
	-- messages
	msg_avatarSoon = "Avatar bald! Nahkämpfer raus!",
	msg_avatarNow = "Avatar! Geh weg vom Boss!",
	msg_avatarYou = "Gri'lek kommt auf dich zu! Lauf weg!",
	msg_avatarWhisper = "Gri'lek kommt auf dich zu! Lauf weg!",
	msg_avatarOther = "Gri'lek verfolgt %s!",
	
	-- bars
	bar_avatar = "Avatar",
	
	-- misc	

} end )
