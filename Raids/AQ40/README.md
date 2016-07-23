<b><a href="https://github.com/MOUZU/BigWigs"> Return to the Overview </a></b>

<br \><br \>
# Temple of Ahn'Qiraj

## The Prophet Skeram

## Vem, Yauj and Kri

## Battleguard Sartura

## Fankriss the Unyielding

## Viscidus

## Princess Huhuran

## The Twin Emperors

## Ouro the Sandworm

## C'Thun
- <b>(100%)</b> Engage
- <b>(100%)</b> P1 Eye Tentacles
- <b>(100%)</b> P1 Dark Glare. Announces Group and plays different sounds wether your group or the group next to you is where dark glare lands (Run away) or not (Beware).
- <b>(QA)</b> P1 Dark Glare duration
- <b>(100%)</b> Transition from Eye of C'Thun to C'Thun
- <b>(QA)</b> P2 First and recurring Giant Claw
- <b>(QA)</b> P2 First and recurring Giant Eye
- <b>(QA)</b> P2 First and recurring Eye Tentacles
- <b>(99%)</b> P2 Weakened phase. There is no clear trigger for this on our server
- <b>(QA)</b> P2 Weakened phase ends. Check for exactly 1 damage on c'thun
- <b>(QA)</b> P2 All timers after weakened phase.
- <b>(DG)</b> Flesh Tentacles

countdown before dark glare start and end
not working: weaken less than 5s before eye tentacles
sometimes giant eye timer during weaken

Giant Claw
    - Spawn trigger: "Giant Claw Tentacle's Ground Rupture"
    - first spawn 25s after eye of c'thun dies
    - spawns every 40s
    - spawns 10, 11 or 14s after weakened phase
    
Giant Eye
    - Spawn trigger: "Giant Eye Tentacle begins to cast Eye Beam."
    - first spawn 56.154/56.391s/56.231/56.242 after eye of c'thun dies
    - spawns every 40.048(40.266/40.067/39.871/39.97/[42.081/]40.067)
    - spawns 40s after weakened phase
    - Eye Beam: "Giant Eye Tentacle begins to cast Eye Beam."

Eye Tentacles
    - spawn trigger (check only after weakened phase): 
        "Eye Tentacle's Mind Flay was resisted"
        "Eye Tentacle's Mind Flay is absorbed"
        "hits Eye Tentacle for"
        "crits Eye Tentacle for"
        "Shadow damage from Eye Tentacle's Mind Flay"
    - first spawn 40.303 (40.438/40.346/40.415/40.013) after eye of c'thun dies (slight delay since there is no clear spawn trigger)
    - spawns every 30s
    - spawns 14.868/19.223s after weakened phase; 75.685/75.28s after last spawn before weakened phase

<br \><br \>
##### Prefix legend
- <b>(100%)</b>  = it's working flawless
- <b>(99%)</b>   = it's working as good as it can be (from my research)
- <b>(QA)</b>    = <b>Q</b>uality <b>A</b>ssurance (need to test its modified state)
- <b>(DG)</b>    = <b>D</b>ata <b>G</b>athering (need to gather more data regarding this matter)
