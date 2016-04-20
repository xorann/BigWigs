<b><a href="https://github.com/MOUZU/BigWigs"> Return to the Overview </a></b>

<br \><br \>
# Blackwing Lair

## Razorgore the Untamed
- <b>(100%)</b> First Wave, adjusted Bar and its Warning from 29s to 46s
- <b>(99%)</b> Control Orb, it seems that it will not always trigger the control correctly
- <b>(DG)</b> Mindcontrol, is the timer correct?
- <b>(DG)</b> Polymorph, is the timer correct?
- <b>(DG)</b> Conflagration, seems to be RNG
- <b>(DG)</b> Fireball Volley, seems to be RNG
- <b>(100%)</b> WarnIcon, Fireball Volley cast is announced via Fireball icon
- <b>(DG)</b> War Stomp, timer
- <b>(99%)</b> Egg Counter. The only way I see this getting 100% accurate would be if we could somehow capture on the client controlling razorgore when the cast is being used and I currently have no clue how to get that. At the moment the chance is pretty high that we miss the first 1-3 eggs being destroyed since the position where razorgore spawns and the position the raid is is too far away so that it would be visible in the combat log. maybe hook CastPetAction(id). added a trigger, removed a trigger which could lead to counting above 30.
- <b>(100%)</b> added trigger for Phase 2

## Vaelastrasz the Corrupt
- <b>(100%)</b> Combat Trigger, adjusted timers from 36/26/10 to 38/28/12 AND adjusted enUS locales to trigger combat
- <b>(100%)</b> Burning Adrenaline, seems to be correct
- <b>(100%)</b> WarnIcon, Burning Adrenaline icon appears when it's on you

## Broodlord Lashlayer
- <b>(100%)</b> Blast Wave DURATION, increased the timer for the first one from 12 to 19.5s. The delay between Blast waves ranges between 20 and 40s from my research, the timer is for the Debuff duration.
- <b>(100%)</b> WarnIcon, Mortal Strike icon appears if your target has Mortal Strike active OR if it's up on you

## Firemaw
- <b>(100%)</b> Flame Buffet
- <b>(100%)</b> Wing Buffet, adjusted first timer from 18 to 30s
- <b>(100%)</b> Shadow Flame, added 'Next' timer with 14s
 
## Ebonroc
- <b>(100%)</b> Shadow of Ebonroc, added first timer with 8s
- <b>(100%)</b> Shadow Flame, added 'Next' timer with 14s
- <b>(100%)</b> Wing Buffet, adjusted first timer from 18 to 29s
- <b>(100%)</b> WarnIcon, Shadow of Ebonroc icon appears when it's on you (should be working, is untested though)

## Flamegor
- <b>(100%)</b> Wing Buffet, adjusted first timer from 18 to 28s
- <b>(100%)</b> Shadow Flame, added 'Next' timer with 14s
- <b>(100%)</b> Frenzy, added 'Next' timer with 10s, added a second trigger since it seemed that BigWigs didn't catch it 100%
- <b>(100%)</b> WarnIcon, Tranq Icon will appear for Hunters when Frenzy is up

## Chromaggus
- <b>(100%)</b> First & Second Breath, adjusted from 60 and 30 to 58.5s and 28.5s. The timer for the following breaths shall only start upon completing cast now. Added a cache in case the raid wipes, it will now display the discovered breaths on the next try
- <b>(100%)</b> Frenzy, added 'Next' timer with 15s
- <b>(100%)</b> Vulnerability, added bar to display how long a vulnerability lasts (45s) and it will also display the current vulnerability once discovered(added a 5s delay after switch to be sure it triggers the correct one)
- <b>(100%)</b> WarnIcon, Tranq Icon will appear for Hunters when Frenzy is up

## Nefarian
- <b>FYI</b>: Nefarian's Skills all share more or less the same cooldown, when the cooldown runs out the spells will queue themselves. eg all timers run out on time X, Fear was the first to run out so Fear will get casted first - Classcall ran out while Fear was casted so it gets delayed and will instantly pop when fear is finished - when shadow flame did run out as well it will do the same after class call. But since the cooldowns are not 100% the same the rotation of this queue is changing during fight. Maybe one should note down when which queue comes to look for a pattern here, I'm sure there is one.
- <b>(100%)</b> Nefarian Landing, added a locale and a seperate Timer 'Landing NOW!' which has 13s and on the 14th second Nefarian is already on position and the tank should be too
- <b>(99%)</b> Class call, lowered the timer from 30s to 27s
- <b>(99%)</b> Fear, increased from 23.5 to 25s. Changed the title of the casting fear from 'Possible Fear' to 'Fear NOW!'
- <b>(99%)</b> Shadow Flame, added a timer for the ones following the first one with 19s (2s casttime included)
- <b>(TODO)</b> revisit NefCount Plugin (the count is so fucked up you shouldn't even use it)
- <b>(100%)</b> WarnIcon, Fear icon appears when Nef starts casting Fear
- <b>(TO RETHINK)</b> WarnIcons for specific classcalls? Priest eg?


<br \><br \>
##### Prefix legend
- <b>(100%)</b>  = it's working flawless
- <b>(99%)</b>   = it's working as good as it can be (from my research)
- <b>(QA)</b>    = <b>Q</b>uality <b>A</b>ssurance (need to test its modified state)
- <b>(DG)</b>    = <b>D</b>ata <b>G</b>athering (need to gather more data regarding this matter)
