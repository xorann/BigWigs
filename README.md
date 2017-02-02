# BigWigs
<i>Diese Beschreibung auf <a href="README.de.md">Deutsch</a> lesen.</i>

BigWigs is a World of Warcraft AddOn to predict certain AI behaviour to improve the players performance.<br \>
This Modification is build for Patch 1.12.1 and its content for use on the <b>Classic-WoW/Nefarian</b> private Server.

## License
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">BigWigs Classic-WoW</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="https://github.com/xorann/BigWigs" property="cc:attributionName" rel="cc:attributionURL">Dorann</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.

The adjustments were originally made by <a href="https://github.com/MOUZU"><b>LYQ</b></a>.<br \>
Adjustments for Classic-WoW made by <b>Dorann</b>.<br \>
<b><a href="https://github.com/xorann/BigWigs">Please refer to this repository for more information.</a></b>

# Download
PLEASE NOTE THIS IS STILL A WORK IN PROGRESS <br>
<b><a href="https://github.com/xorann/BigWigs/releases">Download the latest Release here</a></b>

## How to install
<b>a)</b> If you choose to download the .zip file from the <a href="https://github.com/xorann/BigWigs/releases">latest Release</a> all you have to do is extract the archive in your /World of Warcraft/Interface/AddOns/ directory. (Recommended)<br />
<b>b)</b> If you download the raw code from GitHub (Download ZIP) you'll have to unzip the downloaded archive and rename the folder from 'BigWigs-master' to 'BigWigs' and place it in your /World of Warcraft/Interface/AddOns/ directory. (Not recommended)

## Included AddOns/Plugins
The following Plugins are used for the boss modules.
<ul>
	<li><b>Bars</b> <i>modified by Dorann</i> <br> Shows Bars for important events during a Boss Fight. Added a backport of emphasized bars. Bars that begin at 15s or less or Bars that have less than 10s left move to the emphasized group which can be placed separatly and increases the size of the Bar.</li>
	<li><b>BossBlock</b> <br> Blocks messages from boss mods in the raid chat and raid warning frame.</li>
	<li><b>Messages</b> <br> Shows messages for important events. </li>
	<li><b>Proximity</b> <i>made by Dorann</i> <br> Backport of the Proximity plugin. Shows you which raid members are in close proximity to yourself (C'Thun phase 1). Since there are only range checks for 9.9y, 11.11y and 26y the list should be taken with a grain of salt and should not be absolutly relied upon.</li>
	<li><b>RaidIcon</b> <br> Puts a Raid Icon (Skull by default) over the head of a raid member</li>
	<li><b>Range</b> <br> Allows you to set the range of the combat log to increase the precision of BigWigs. Using the highest possible setting by Default.</li>
	<li><b>Sound</b> <i>modified by Dorann</i> <br> Plays a sound on important events.</li>
	<li><b>Test</b> <br> Allows you to Test BigWigs and move the Plugins (Bars, Messages) around.</li>
	<li><b>Tranq</b> <br> Support for Tranquilizing Shot to see which Hunter used it.</li>
	<li><b>WarningSign</b> <i>made by LYQ, modified by Dorann</i> <br> Displays important SpellIcons in the center of your screen. Eg. if you're standing in Rain of Fire at Gehennas or if you're a Hunter and Magmadar/Flamegor/Chromaggus is Frenzied and you need to Tranq.</li>
</ul>

Several other BigWigs Plugins are included in this repository, so you only need to download and use the 'BigWigs' folder from this repository. If you happen to have any of the listed AddOns seperately I suggest removing or disabling them - in case I adjusted some of those in this repository as well.
<ul>
    <li><b>CustomBar</b> <br> Allows you to create a custom bar with the following command: /bwcb <seconds> <message></li>
	<li><b>Version</b>  <i>modified by Dorann</i> <br> Checks your BigWigs version and warns you if there is a newer version available.</li>
	<li><b>BigWigs_CommonAuras</b> <br \>  Keeps track of certain Buffs and Cooldowns eg. Shield Wall and Challenging Shout</li>
    <li><b>BigWigs_NefCount</b> <i>deactivated atm (NEEDS REWORK)</i> <br \>  improved mechanism for Nefarian phase 1, keeps track of the Adds killed since that triggers phase 2.</li>
    <li><b>BigWigs_ZombieFood</b> <i>modified by LYQ</i> <br> announces if a player is getting dazed</li>
    <li><b>BigWigs_LoathebTactical</b> <br> Spore and Consumable warnings for Loatheb</li>
    <li><b>BigWigs_RespawnTimers</b> <i>(NEEDS REWORK)</i> <br>  Trash respawn timers</li>
	<li><b>BossRecords</b>  <i>made by LYQ</i> <br> This Plugin will keep record of your time used in bossfights and compare it to your fastest.</li>
    <li><b>RaidOfficer</b>  <i>made by LYQ</i> <br> This Plugin will enable for Raid Assistants dragging Players of one Raid-subgroup to another. This was on vanilla previously only enabled for RaidLeaders but the API allows Assistants to do so too.</li>
    <li><b>DousedRunes</b>  <i>made by Dorann</i> <br> Shows you which runes in Molten Core have been doused and which still have to be doused to summon Majordomus. The Frame will be shown after a Rune has been doused and after a boss has been killed (beginning at Magmadar).</li>
</ul>

## Raid Adjustments
If you want to browse through all the changes and their status regarding each encounter in the Raid specific README files. On there you can also see whether changes are untested, working perfectly or working as good as they can be.
<ul>
    <li><a href="Raids/MC/"><b>(MC)</b> Molten Core</a></li>
    <li><a href="Raids/Onyxia/"><b>(ONY)</b> Onyxia</a></li>
    <li><a href="Raids/BWL/"><b>(BWL)</b> Blackwing Lair</a></li>
    <li><a href="Raids/ZG/"><b>(ZG)</b> Zul'Gurub</a></li>
    <li><a href="Raids/AQ20/"><b>(AQ20)</b> Ruins of Ahn'Qiraj</a></li>
    <li><a href="Raids/AQ40/"><b>(AQ40)</b> Temple of Ahn'Qiraj</a></li>
    <li><a href="Raids/Naxxramas/"><b>(NAXX)</b> Naxxramas</a></li>
</ul>


## Core/General Adjustments
- <b>(100%)</b> Reworked the core module and most boss modules to improve the maintainability (see Provided API).
- <b>(100%)</b> Engage Syncs are now working perfectly on every encounter and do allow communication between clients of different language packs.
- <b>(100%)</b> Bosskill Syncs were added for every encounter dynamically and do also support communication of different language packs.
- <b>(100%)</b> BossWipe Syncs were remodelled and added dynamically for every encounter.
- <b>(100%)</b> KTM compatibility - Bossmodules are now able to set the MasterTarget, reset the Threat or Clear the Master Target. RaidOfficers do need to have this version for that.

# Provided API
This is a (incomplete) documentation of the <a href="http://wow.gamepedia.com/BigWigs/API">BigWigs API</a>. This is only important for developers. Also refer to the <a href="modulePrototype overview.txt">modulePrototype overview</a> and the <a href="bossTemplate.lua">bossTemplate</a> for an example implementation.

## Overview
:Sync(sync) <br />
:DelayedSync(delay, sync) <br />
:CancelDelayedSync(sync) <br />
:ThrottleSync(throttle, sync) <br />
 <br />
:Message(text[, priority[, noRaidSay[, sound[, broadcastOnly]]]]) <br />
table :DelayedMessage(delay, text[, priority[, noRaidSay[, sound[, broadcastOnly]]]]) <br />
:CancelDelayedMessage(text) <br />
 <br />
:Bar(text, time, icon[, otherColor, c1[, c2[, c3[, c4[, c5[, c6[, c7[, c8[, c9[, c10]]]]]]]]]]) <br />
:RemoveBar(text) <br />
table :DelayedBar(delay, text, time, icon[, otherColor, c1[, c2[, c3[, c4[, c5[, c6[, c7[, c8[, c9[, c10]]]]]]]]]]) <br />
:CancelDelayedBar(text) <br />
 <br />
:Sound(sound) <br />
table :DelayedSound(delay, sound[, id]) <br />
:CancelDelayedSound(sound[, id]) <br />
 <br />
:Icon(name[, iconnumber]) <br />
:RemoveIcon() <br />
 <br />
:WarningSign(texturePath, duration[, force]) <br />
:RemoveWarningSign(texturePath[, forceHide]) <br />
:DelayedWarningSign(delay, icon, duration[, id]) <br />
:CancelDelayedWarningSign(icon[, id]) <br />
 <br />
:Say(msg) <br />
 <br />
-- KLHThreatMeter <br />
:KTM_Reset() <br />
:KTM_ClearTarget([forceReset]) <br />
:KTM_SetTarget(targetName[, forceReset]) <br />
 <br />
## :Bar(text, length, icon, otherColor, ...)
Starts a timer bar that counts down for the specified length of time.

### Arguments
<ul>
	<li><b>text</b> string<br />The text to show on the bar.</li>
	<li><b>length</b> number<br />The length of the bar in seconds.</li>
	<li><b>icon</b> string<br />What icon to show on the bar.</li>
	<li><b>otherColor</b> boolean<br />Optional, if not specified, the configured colors will be used. If specified, you must provide 1 to 10 colors to use as arguments after otherColor.</li>
	<li><b>...</b> color<br />Optional, if otherColor is specified, you must provide 1 to 10 colors.</li>
</ul>
### Returns
Nothing
		
###	Remarks
"Interface\\\\Icons\\\\" is automatically pre-pended to the icon path. If you have to show a bar with an icon that is not part of the default icons provided by WoW, this is still possible using the self:TriggerEvent("BigWigs_StartBar", ...) syntax.
		
### Example
self:Bar("Adds incoming!", 30, "Spell_Nature_Web")<br />
self:Bar("Testing Colors!", 60, "Spell_Nature_Web", true, "red", "yellow", "green")


## :Icon(name, iconnumber)
Puts the specified raid icon on the specified player, only works if you are promoted in the raid or the raid leader.

### Arguments
<ul>
	<li><b>name</b> string<br />The name of the player you want to put an icon on.</li>
	<li><b>iconnumber</b> number<br />Optional, if not specified, the configured default raid icon will be used. If specified, this raid icon will be used. 1: Yellow Star, 2: Orange Circle, 3: Purple Diamond, 4: Green Triangle, 5: White Moon, 6: Blue Square, 7: Red Cross, 8: Skull</li>
</ul>

### Returns
Nothing.
		
###	Remarks
If you use CheckForBossDeath or CheckForWipe (used by default) the icon is removed automatically. If not, you should clear it yourself.
		
### Example
self:Icon("Dorann") -- puts a skull on Dorann <br />
self:Icon("Dorann", 2) -- puts an orange circle on Dorann

## :Message(text, priority, noRaidSay, sound, broadcastOnly)
Displays a message in the configured message frame (defaults to BigWigs' own message frame) with the color configured for the given priority.

### Arguments
<ul>
	<li><b>text</b> string<br />The message to show.</li>
	<li><b>priority</b> string<br />Optional, one of "Important" (red), "Personal" (red), "Urgent" (orange), "Attention" (yellow), "Positive" (green), "Bosskill" (green) or "Core" (cyan).</li>
	<li><b>noRaidSay</b> boolean<br />Optional, if this is non-nil, the message will not be relayed to raid warning channel, even if that option is enabled.</li>
	<li><b>sound</b> string or boolean<br />Optional, if this is a string, it must be a valid sound name (see :Sound). If 'true' is passed, the default "RaidWarning" sound provided by WoW will be played.</li>
	<li><b>broadcastOnly</b> boolean<br />Optional, if this is provided, the message will only be broadcasted to the raid warning channel (if that option is enabled), and not shown locally.</li>
</ul>
### Returns
Nothing.
		
###	Remarks
You should almost always provide a priority - if not, the message will be white. Remember that you should NOT surround the text with "***". <br />
Also note that priority can be a RGB tuple, like {r=1.0,g=0,b=0}, and also just a color name ("Red", "Purple", "Orange", "Yellow", "Green", "Cyan").
		
### Example
self:Message("Fear in 2sec!", "Important") <br />
self:Message("You have the plague", "Personal", true, "Info")

## :DelayedMessage(delay, ...)
This will schedule a delayed message to be printed after delay seconds.

### Arguments
<ul>
	<li><b>delay</b> number<br />The number of seconds to wait before printing the message.</li>
	<li><b>...</b><br />The rest of the arguments are exactly like the ones for :Message.</li>
</ul>

### Returns
The scheduled event ID, which is useful if you may want to cancel the scheduled message later.
		
### Example
self:DelayedMessage(55, "Something happens in 5sec!", "Important") <br />
<br />
local x = self:DelayedMessage(55, "Something happens in 5sec!", "Important") -- Then, a bit later, the boss enters phase 2, and you no langer want this message to display <br />
self:CancelScheduledEvent(x) <br />
-- or better <br />


## :Sync(sync)
Sends a communication sync to the other BigWigs users in the group.

### Arguments
<ul>
	<li><b>sync</b> string<br />The synchronization token to send to the other people in your group. Note that these tokens are recieved by all the BigWigs modules, so you should make sure you pick something unique.</li>
</ul>
### Returns
Nothing.
		
###	Remarks
The tokens we use are typically prefixed by some portion of the boss name, like "HyakissWeb". When sending a sync, if you want to send more data (this will be provided by the second argument to :BigWigs_RecvSync, detailed later), you have to use string concatenation; "HyakissWeb" .. playerName (which would bekome "HyakissWeb MyToon").
Note that synchronization throttling is done only on the first part, not the additional information you include in the sync.
Of course, sync messages are sent using SendAddonMessage, and as such there are some restrictions inherited. Take a look at Wowpedia for more information.
		
### Example
self:Sync("BossAbility")
self:Sync("BossTargettedAbility " .. player)

# Module Prototype
The following functions and variables are available on each boss module. Also refer to the <a href="modulePrototype overview.txt">modulePrototype overview</a> and the <a href="bossTemplate.lua">bossTemplate</a> for an example implementation.
 <br />
  <br />
------------------------------------- <br />
--      Core: Module Handling      -- <br />
------------------------------------- <br />
 <br />
void BigWigs:ModuleDeclaration(bossName, zoneName) <br />
void BigWigs:RegisterModule(name, module) <br />
void BigWigs:EnableModule(moduleName, nosync) <br />
void BigWigs:SetupModule(moduleName) <br />
void BigWigs:DisableModule(moduleName) <br />
 <br />
-- event handler <br />
void BigWigs:BigWigs_RebootModule(moduleName) <br />
 <br />
--------------------------------------- <br />
--      Functions and Variables      -- <br />
--------------------------------------- <br />
 <br />
-- do not override <br />
BigWigs.modulePrototype.core = BigWigs <br />
BigWigs.modulePrototype.debugFrame = ChatFrame1 <br />
BigWigs.modulePrototype.engaged = false <br />
BigWigs.modulePrototype.bossSync = nil -- untranslated string <br />
BigWigs.modulePrototype.zonename = nil -- AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"] <br />
 <br />
-- override <br />
BigWigs.modulePrototype.revision = 1 -- To be overridden by the module! <br />
BigWigs.modulePrototype.started = false -- not used anymore <br />
BigWigs.modulePrototype.enabletrigger = nil -- boss <br />
BigWigs.modulePrototype.wipemobs = nil -- adds that will be considered in CheckForEngage <br />
BigWigs.modulePrototype.toggleoptions = nil -- {"sweep", "sandblast", "scarab", -1, "emerge", "submerge", -1, "berserk", "bosskill"} <br />
BigWigs.modulePrototype.timers = {} -- table for all timers <br />
BigWigs.modulePrototype.icons = {} -- table for all icons <br />
BigWigs.modulePrototype.proximityCheck = nil -- function(unit) return CheckInteractDistance(unit, 2) end <br />
BigWigs.modulePrototype.proximitySilent = nil -- false <br />
 <br />
 <br />
-- do not override <br />
boolean BigWigs.modulePrototype:IsBossModule() <br />
void BigWigs.modulePrototype:DebugMessage(msg) <br />
void BigWigs.modulePrototype:OnInitialize() <br />
 <br />
-- override (if necessary) <br />
void BigWigs.modulePrototype.OnEnable() <br />
void BigWigs.modulePrototype:OnEngage() <br />
void BigWigs.modulePrototype:OnSetup() <br />
void BigWigs.modulePrototype:OnDisengage() <br />
 <br />
-- do not override <br />
void BigWigs.modulePrototype:Engage() <br />
void BigWigs.modulePrototype:Disengage() <br />
void BigWigs.modulePrototype:Victory() <br />
void BigWigs.modulePrototype:Disable() <br />
 <br />
-- synchronize functions, do not override <br />
string BigWigs.modulePrototype:GetEngageSync() <br />
void BigWigs.modulePrototype:SendEngageSync() <br />
 <br />
string BigWigs.modulePrototype:GetWipeSync() <br />
void BigWigs.modulePrototype:SendWipeSync() <br />
 <br />
string BigWigs.modulePrototype:GetBossDeathSync() <br />
void BigWigs.modulePrototype:SendBossDeathSync() <br />
 <br />
-- event handler, override only if necessary (e.g. c'thun phase transition requires overriding CheckForWipe()) <br />
void BigWigs.modulePrototype:RegisterYellEngage(yell) <br />
 <br />
void BigWigs.modulePrototype:CheckForEngage() <br />
void BigWigs.modulePrototype:CheckForWipe() <br />
void BigWigs.modulePrototype:CheckForBossDeath(msg) <br />
 <br />
-- override <br />
void BigWigs.modulePrototype:BigWigs_RecvSync(sync, rest, nick) <br />
 <br />
-- test function <br />
void BigWigs.modulePrototype:Test() <br />
 <br />
