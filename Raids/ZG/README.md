<b><a href="https://github.com/MOUZU/BigWigs"> Return to the Overview </a></b>

<br \><br \>
# Zul'Gurub

## High Priestess Jeklik
- <b>(99%)</b> Heal (Phase 2), added 'Next' timer with 20s
- <b>(100%)</b> fixed Engage Sync
- <b>(100%)</b> fixed Phase 2 Notifier
- <b>(DG)</b> Fear, seems not to be timed - maybe just a cooldown
- <b>(DG)</b> MindFlay, seems not to be timed - just a cooldown
- <b>(QA)</b> WarnIcon, if you're standing in the fire in Phase 2. changed fire triggers
- <b>(QA)</b> Silence, added timer for first Silence after 12s in Phase 1
- <b>(QA)</b> Fire Bombs, added a timer on phase Switch. Those Bombs start 10s in Phase 2

## High Priest Venoxis
- <b>(QA)</b> Addcounter, new Counting algorithm (only compatible with users of LYQs BigWigs). Users with older versions may receive the sync but can not send.
- <b>(100%)</b> KTM Reset, on Phase 2
- <b>(100%)</b> WarnIcon, appears when you're standing in the cloud in P2

## High Priestess Mar'li

## Bloodlord Mandokir
- <b>(QA)</b> added locale to trigger combat start
- <b>(100%)</b> added 'Vilebranch Speaker' to enabletrigger, as previously Mandokir's mod only got enabled on pull and therefore avoided my combat trigger.
- <b>(100%)</b> added 'Next Whirlwind' bar with 20s
- <b>(QA)</b> added 'Charge' bar with the first one 15. Need trigger for the ones following that, the following should get +30s
- <b>(100%)</b> added 'Next Gaze' bar with 11s (should be 19s counting from 'Incoming Gaze')
- <b>(100%)</b> added missing locale for 'Incoming Gaze'
- <b>(QA)</b> added WarnIcon if the player is afflicted by Threatening Gaze.

## High Priest Thekal
- <b>(100%)</b> added locale to trigger phase 2
- <b>(100%)</b> Knockback Phase 2, first one after 5s and the next one after 20s.
- <b>(100%)</b> Bloodlust, Phase 2: first one after 29s
- <b>(100%)</b> New Adds, added Timer on Phase 2 engage.
- <b>(99%)</b> added a mechanism to the core to reactivate thekal mod after phase 1 ended, added a timer for the next phase

## High Priestess Arlokk
- <b>(QA)</b> added locale to trigger combat
- <b>(QA)</b> added 'Hakkari Shadow Hunter' to enable mod to fix the combattrigger
- <b>(100%)</b> added 'Next Vanish' bar with 35s (should be accurate)
- <b>(99%)</b> fixed trigger for Vanish, so 'Vanish' bar should display but it can't be 100% accurate. Changed its title to 'Estimated Return'

## Jin'do the Hexxer
- <b>(100%)</b> Hex duration, from my research there is no way to predict the next hex accurately. added timer for first hex after 8s
- <b>(DG)</b> Brain Wash Totem, the trigger doesn't work when it's destroyed. should come every ~21s
- <b>(DG)</b> Healing Totem, the trigger on spawn doesn't work, idk about the one when it's destroyed. should come every 20s. added timer for the first one
- <b>(DG)</b> Teleport, I don't have any data on this one
- <b>(100%)</b> added locale to trigger combat

## Gahz'ranka

## Hakkar the Soulflayer
- <b>(100%)</b> Mind Control, fixed Next timer to only appear after the current was finished and changed the value to 11s.
- <b>(100%)</b> Blood Siphon, first timer got its timer adjusted by -1s
- <b>(100%)</b> WarnIcon, WindSerpent icon appears when you've hit the 30s mark to the next Blood Siphon. The icon shall disappear either when you've gained the blood from the Pet or the Blood Siphon starts.

## Edge of Madness

<br \><br \>
##### Prefix legend
- <b>(100%)</b>  = it's working flawless
- <b>(99%)</b>   = it's working as good as it can be (from my research)
- <b>(QA)</b>    = <b>Q</b>uality <b>A</b>ssurance (need to test its modified state)
- <b>(DG)</b>    = <b>D</b>ata <b>G</b>athering (need to gather more data regarding this matter)
