<b><a href="https://github.com/MOUZU/BigWigs"> Return to the Overview </a></b>

<br \><br \>
# Molten Core

## Lucifron
- <b>(100%)</b> Lucifron's Curse, changed the regular timer from 20 to 15s
- <b>(100%)</b> Impending Doom
- <b>(100%)</b> Dominate Mind, I don't think it's necessary to implement a timer for the next mc and the normal one works fine
- <b>(QA)</b> Addcounter, new Counting algorithm (only compatible with users of LYQs BigWigs). Users with older versions may receive the sync but can not send.
- <b>(REMOVED)</b> Shadow Shock, wasn't accurate - is maybe not possible to do - and isn't worth it

# Magmadar
- <b>(100%)</b> Panic, changed timer from 7 to 20s for the first one and from 30 to 35 to the regular ones (do I want to add an WarnIcon for that? few seconds prior and until it's gone)
- <b>(100%)</b> Frenzy, added timer for first one with 29s (the others are kinda RNG between 16-21s, so no timer)
- <b>(DG)</b> Lava Bomb, added timer for first one with 12s and regular ones with 11s (REVERTED: If I want to have such I need to find a proper trigger first)
- <b>(100%)</b> WarnIcon, Tranq Icon will appear for Hunters when Frenzy is up

## Gehennas
- <b>(99%)</b> Gehennas' Curse, doubt it will get better. The cast ranges between 23s and 38s from my analysis
- <b>(QA)</b> Addcounter, new Counting algorithm (only compatible with users of LYQs BigWigs). Users with older versions may receive the sync but can not send.
- <b>(REMOVED)</b> Shadow Bolt
- <b>(100%)</b> Rain of Fire, added timer for the first rain. every other rain of fire comes about ~9s. THERE IS NO ACCURATE TRIGGER FOR THE FOLLOWING ONES - REVERTED
- <b>(100%)</b> WarnIcon, Rain of Fire appears when you're standing in Rain of Fire

## Garr
- <b>(100%)</b> Addcount, this counting algorithm seems to already be perfect
- Magma Shackles and Antimagnetic Pulse are RNG and can not be accurately predicted from my research

## Baron Geddon
- removed a lot of code in the Inferno section to begin with.
- <b>(100%)</b> Inferno, increased duration from 8 to 9s. Changed first Inferno from 30 to 15s. Changed timer to appear after the current inferno has faded - the next will follow 16s after
- <b>(100%)</b> Mana Ignite, changed the timer to every 30s
- <b>(100%)</b> Living Bomb, from my research the bomb does not come regularly but it has a cooldown of 7s - removed the 'Next' timer
- <b>(QA)</b> WarnIcon, Living Bomb Icon appears when you're the bomb
- TODO cleanup code

## Shazzrah
- <b>(100%)</b> Shazzrah's Curse, increased the timer for the ones after the first from 20 to 23s
- <b>(100%)</b> Counterspell, lowered the first one from 15 to 14s. others from 17.5 to 16.5s       (NO TRIGGER YET)
- <b>(100%)</b> Blink, changed first from 30.3 to 29s. Changed the name to 'Possible Blink'         (NO TRIGGER YET)
- <b>(100%)</b> Deaden Magic, added timer for the first one after 24s
- <b>(100%)</b> WarnIcon, Deaden Magic icon appears for players who can purge it

## Sulfuron Harbringer
- <b>(QA)</b> Addcounter, new Counting algorithm (only compatible with users of LYQs BigWigs). Users with older versions may receive the sync but can not send.
- <b>(100%)</b> Knockback, increased the timer from 9.5 to 13.5s
- <b>(QA)</b> Flame Spear, added timer every 13s
- <b>(TODO)</b> add big healicons

## Golemagg the Incinerator
- <b>(QA)</b> KTM MasterTarget on Golemagg at pull
- Magma Splash, should I create an alert if the player is reaching x stacks?
- Pyroblast, seems to be every 4s - should I create a timer for that?

## Majordomo Executus
- <b>(QA)</b> Addcounter, new Counting algorithm (only compatible with users of LYQs BigWigs). Users with older versions may receive the sync but can not send.
- <b>(100%)</b> Spell/Damage-reflect Shields, changed timer to every 30s. Timers for the next may only appear after the timer of the current shield is gone.

## Ragnaros
- <b>(100%)</b> Combat start, added timer 64.5s prior to start and added an enUS locale triggering that
- <b>(100%)</b> Knockback, increased the timer from 25s to 28s
- <b>(100%)</b> Hammer of Ragnaros (Caster Knockback), added timer with 25s
- <b>(100%)</b> Submerge/Emerge timer
- <b>(QA)</b> Addcounter, new Counting algorithm (only compatible with users of LYQs BigWigs). Users with older versions may receive the sync but can not send.
- <b>(100%)</b> WarnIcon, Sprint Icon appears 5 seconds prior to Knockback

<br \><br \>
##### Prefix legend
- <b>(100%)</b>  = it's working flawless
- <b>(99%)</b>   = it's working as good as it can be (from my research)
- <b>(QA)</b>    = <b>Q</b>uality <b>A</b>ssurance (need to test its modified state)
- <b>(DG)</b>    = <b>D</b>ata <b>G</b>athering (need to gather more data regarding this matter)
