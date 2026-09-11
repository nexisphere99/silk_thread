---

# PART 2: TWINE SUGARCUBE IMPLEMENTATION

---

## File Structure

```
silk-thread/
├── index.html                    # Main Twine SugarCube HTML file
├── src/
│   ├── passages/
│   │   ├── R1/                   # Release 1 passages
│   │   │   ├── R1_Opening.tw
│   │   │   ├── R1_Office.tw
│   │   │   ├── R1_Evening.tw
│   │   │   └── R1_Choice.tw
│   │   ├── R2/                   # Release 2 passages
│   │   │   ├── R2_Opening.tw
│   │   │   ├── R2_Kitchenette.tw
│   │   │   ├── R2_Henderson_Meeting.tw
│   │   │   ├── R2_Greg_Office.tw
│   │   │   ├── R2_Elevator_Silence.tw
│   │   │   ├── R2_Afternoon_Fog.tw
│   │   │   ├── R2_Dinner_Silence.tw
│   │   │   ├── R2_Whiskey_Alone.tw
│   │   │   ├── R2_Late_Night_Email.tw
│   │   │   ├── R2_Choice_Lena.tw
│   │   │   ├── R2_End_Reflection.tw
│   │   │   ├── R2_Dream_Sequence.tw
│   │   │   ├── R2_Harper_Side.tw
│   │   │   ├── R2_Martin_Side.tw
│   │   │   └── R2_Phone_Check.tw
│   │   └── common/
│   │       ├── StoryInit.tw
│   │       ├── StatDisplay.tw
│   │       └── Sidebar.tw
│   ├── styles/
│   │   ├── main.css              # Core visual theme
│   │   ├── passages.css          # Passage-specific styling
│   │   ├── stats.css             # Stat bar styling
│   │   ├── choices.css           # Choice button styling
│   │   └── animations.css        # Transition effects
│   ├── scripts/
│   │   ├── stats.js              # Stat management system
│   │   ├── inventory.js          # Item/wardrobe system
│   │   ├── relationships.js      # NPC relationship tracker
│   │   ├── exploration.js        # Open-world location system
│   │   └── saves.js              # Save/load enhancements
│   └── images/
│       ├── backgrounds/
│       │   ├── apartment_morning.webp
│       │   ├── meridian_lobby.webp
│       │   ├── office_floor39.webp
│       │   ├── conference_room.webp
│       │   ├── elevator.webp
│       │   ├── apartment_night.webp
│       │   └── apartment_dark.webp
│       ├── characters/
│       │   ├── daniel_suit.webp
│       │   ├── lena_sleep.webp
│       │   ├── harper_office.webp
│       │   ├── martin_crane.webp
│       │   ├── greg_tanaka.webp
│       │   └── margaret_walsh.webp
│       └── ui/
│           ├── stat_bar_bg.webp
│           ├── choice_frame.webp
│           └── logo.webp
└── README.md
```

---

## Agent Prompt for Twine SugarCube Implementation

```
You are a Twine SugarCube 2.x game developer. Build an interactive visual novel 
game called "Silk Thread" from the provided narrative script. Follow these 
specifications precisely:

## ENGINE & FORMAT
- Twine 2 with SugarCube 2.37+ story format
- Single compiled HTML file for distribution
- All CSS/JS embedded within the HTML

## STORY INITIALIZATION (StoryInit passage)

Create a StoryInit special passage that sets all game variables:

<<set $feminization = 0>>
<<set $submission = 0>>
<<set $arousalRewiring = 0>>
<<set $marriageBond = 70>>
<<set $ntrAwareness = 0>>
<<set $victoriaTrust = 0>>
<<set $officeSuspicion = 0>>
<<set $selfIdentity = 100>>
<<set $currentRelease = 1>>
<<set $playerName = "Daniel">>

/* Relationship trackers */
<<set $harper = {affection: 0, suspicion: 0, trust: 0}>>
<<set $martin = {respect: 50, suspicion: 0}>>
<<set $lena = {love: 60, distance: 30, adrianInterest: 0}>>
<<set $victoria = {control: 0, trust: 0, affection: 0}>>
<<set $adrian = {awareness: 0, presence: 0}>>

/* Choice history tracking */
<<set $choices = {}>>
<<set $choices.R1_bedChoice = "">>
<<set $choices.R2_lenaConfide = "">>
<<set $choices.R2_exploredHarperDesk = false>>
<<set $choices.R2_visitedMartin = false>>
<<set $choices.R2_checkedPhone = false>>

/* Exploration flags */
<<set $locations = {
  apartment: {unlocked: true, visited: true},
  meridian_lobby: {unlocked: true, visited: true},
  floor39: {unlocked: true, visited: true},
  floor41: {unlocked: false, visited: false},
  floor42: {unlocked: false, visited: false},
  kitchenette: {unlocked: true, visited: false},
  conference_room: {unlocked: true, visited: false},
  elevator: {unlocked: true, visited: false},
  martinOffice: {unlocked: false, visited: false},
  harperDesk: {unlocked: true, visited: false}
}>>

/* Inventory/wardrobe */
<<set $inventory = []>>
<<set $wardrobe = {
  wearing: ["boxers", "dress_shirt_blue", "charcoal_slacks", "polished_shoes", "tie_navy"],
  owned: []
}>>

/* Time system */
<<set $timeOfDay = "morning">>
<<set $day = "tuesday">>
<<set $week = 1>>


## OPEN WORLD EXPLORATION SYSTEM

Create a location hub system. Between key story beats, the player can 
navigate to different locations. Each location may have:
- An NPC interaction (if the NPC is present at that time)
- Environmental observations
- Optional item discovery
- Time-of-day gating

Use this macro pattern for location hubs:

:: R2_Office_Hub
<<set $timeOfDay = "afternoon">>

The office continues around you. People work. Phones ring. 
The Henderson disaster is yours alone.

Where do you go?

<<if !$choices.R2_exploredHarperDesk>>
[[Visit Harper's desk|R2_Harper_Side][$choices.R2_exploredHarperDesk = true]]
<</if>>

<<if !$choices.R2_visitedMartin>>
[[Take the elevator to Floor 41|R2_Martin_Side][$choices.R2_visitedMartin = true; $locations.floor41.visited = true; $locations.martinOffice.visited = true]]
<</if>>

[[Go back to your desk and wait out the day|R2_Afternoon_Fog]]

<<if $timeOfDay == "afternoon">>
[[Head home early|R2_Dinner_Silence][$timeOfDay = "evening"]]
<</if>>


## PASSAGE STRUCTURE

Each story passage follows this template:

:: PassageName [tag1 tag2]
<<set $timeOfDay = "value">>

/* Background image */
<div class="scene-bg" data-bg="image_name">

/* Story text - use timed reveals for pacing */
<<timed 0s>>
Story paragraph one.
<<next 0s>>

Story paragraph two.
<<next 0s>>

More text.
<</timed>>

/* Navigation */
<<if condition>>
[[Choice text|NextPassage][stat changes]]
<</if>>

</div>


## STAT DISPLAY WIDGET

Create a StoryCaption passage for the sidebar:

:: StoryCaption
<div class="stat-panel">
  <div class="stat-header">SILK THREAD</div>
  <div class="stat-subheader">Release <<print $currentRelease>></div>
  
  <div class="stat-group">
    <div class="stat-label">Feminization</div>
    <div class="stat-bar"><div class="stat-fill fem" style="width:<<print $feminization>>%"></div></div>
    <span class="stat-val"><<print $feminization>>%</span>
  </div>
  
  <div class="stat-group">
    <div class="stat-label">Submission</div>
    <div class="stat-bar"><div class="stat-fill sub" style="width:<<print $submission>>%"></div></div>
    <span class="stat-val"><<print $submission>>%</span>
  </div>
  
  <div class="stat-group">
    <div class="stat-label">Marriage Bond</div>
    <div class="stat-bar"><div class="stat-fill mar" style="width:<<print $marriageBond>>%"></div></div>
    <span class="stat-val"><<print $marriageBond>>%</span>
  </div>

  <div class="stat-group">
    <div class="stat-label">NTR Awareness</div>
    <div class="stat-bar"><div class="stat-fill ntr" style="width:<<print $ntrAwareness>>%"></div></div>
    <span class="stat-val"><<print $ntrAwareness>>%</span>
  </div>

  <div class="stat-group">
    <div class="stat-label">Identity</div>
    <div class="stat-bar"><div class="stat-fill id" style="width:<<print $selfIdentity>>%"></div></div>
    <span class="stat-val"><<print $selfIdentity>>% Daniel</span>
  </div>
</div>

<div class="location-info">
  <<print $timeOfDay.toUpperCase()>> | <<print $day.toUpperCase()>>
</div>


## CSS THEME

Style the game with a dark, corporate noir aesthetic:

:root {
  --bg-primary: #0a0a0f;
  --bg-secondary: #12121a;
  --bg-passage: #0f0f17;
  --text-primary: #c8c8d4;
  --text-secondary: #8888a0;
  --text-accent: #b8a88a;
  --link-color: #9a8a6e;
  --link-hover: #d4c4a0;
  --stat-fem: #c77dba;
  --stat-sub: #7d8ec7;
  --stat-mar: #c7a87d;
  --stat-ntr: #c77d7d;
  --stat-id: #7dc79a;
  --border-subtle: #1f1f2e;
  --font-body: 'Cormorant Garamond', Georgia, serif;
  --font-ui: 'Inter', 'Helvetica Neue', sans-serif;
}

/* Import fonts */
@import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Inter:wght@300;400;500&display=swap');

body {
  background: var(--bg-primary);
  color: var(--text-primary);
  font-family: var(--font-body);
  font-size: 17px;
  line-height: 1.75;
}

#story {
  max-width: 720px;
  margin: 0 auto;
  padding: 2rem 1.5rem;
}

.passage {
  background: var(--bg-passage);
  border: 1px solid var(--border-subtle);
  padding: 2.5rem;
  margin-bottom: 1rem;
  animation: fadeIn 0.8s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
}

/* Choice buttons */
.passage a[class*="link"] {
  display: block;
  padding: 1rem 1.5rem;
  margin: 0.5rem 0;
  background: var(--bg-secondary);
  border: 1px solid var(--border-subtle);
  color: var(--link-color);
  text-decoration: none;
  font-family: var(--font-ui);
  font-size: 14px;
  font-weight: 400;
  letter-spacing: 0.02em;
  transition: all 0.3s ease;
}

.passage a[class*="link"]:hover {
  border-color: var(--link-hover);
  color: var(--link-hover);
  background: rgba(154, 138, 110, 0.05);
}

/* Stat bars */
.stat-bar {
  background: var(--bg-primary);
  height: 4px;
  border-radius: 2px;
  overflow: hidden;
  margin: 4px 0;
}

.stat-fill {
  height: 100%;
  transition: width 0.6s ease;
}

.stat-fill.fem { background: var(--stat-fem); }
.stat-fill.sub { background: var(--stat-sub); }
.stat-fill.mar { background: var(--stat-mar); }
.stat-fill.ntr { background: var(--stat-ntr); }
.stat-fill.id { background: var(--stat-id); }

.stat-label {
  font-family: var(--font-ui);
  font-size: 10px;
  font-weight: 500;
  letter-spacing: 0.08em;
  color: var(--text-secondary);
  text-transform: uppercase;
}

.stat-val {
  font-family: var(--font-ui);
  font-size: 11px;
  color: var(--text-secondary);
  float: right;
}

/* Sidebar */
#ui-bar {
  background: var(--bg-secondary);
  border-right: 1px solid var(--border-subtle);
}

.stat-panel {
  padding: 1rem;
}

.stat-header {
  font-family: var(--font-body);
  font-size: 18px;
  font-weight: 600;
  color: var(--text-accent);
  letter-spacing: 0.12em;
  margin-bottom: 0.25rem;
}

.stat-subheader {
  font-family: var(--font-ui);
  font-size: 10px;
  color: var(--text-secondary);
  letter-spacing: 0.06em;
  margin-bottom: 1.5rem;
  text-transform: uppercase;
}

.stat-group {
  margin-bottom: 0.75rem;
}

/* Italic inner thoughts */
em {
  color: var(--text-accent);
  font-style: italic;
}

/* Scene transition overlay */
.scene-transition {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: black;
  z-index: 9999;
  animation: sceneFade 1.2s ease forwards;
}

@keyframes sceneFade {
  0% { opacity: 1; }
  100% { opacity: 0; pointer-events: none; }
}

/* NPC dialogue styling */
.npc-dialogue {
  border-left: 2px solid var(--text-accent);
  padding-left: 1rem;
  margin: 1rem 0;
  color: var(--text-primary);
}

.npc-name {
  font-family: var(--font-ui);
  font-size: 11px;
  font-weight: 500;
  letter-spacing: 0.06em;
  color: var(--text-accent);
  text-transform: uppercase;
  margin-bottom: 0.25rem;
}

/* Stat change notification */
.stat-change {
  font-family: var(--font-ui);
  font-size: 11px;
  color: var(--text-secondary);
  padding: 0.5rem 1rem;
  border: 1px solid var(--border-subtle);
  margin: 1rem 0;
  background: rgba(184, 168, 138, 0.03);
}

.stat-change .positive { color: var(--stat-id); }
.stat-change .negative { color: var(--stat-ntr); }

/* Mobile responsive */
@media (max-width: 768px) {
  #story { padding: 1rem; }
  .passage { padding: 1.5rem; }
  body { font-size: 16px; }
}


## PASSAGE CODE EXAMPLE (R2_Choice_Lena)

:: R2_Choice_Lena [R2 choice]
<<set $timeOfDay = "night">>

The bedroom door is open. Lena stands there in her sleep shirt. The 
oversized one from that 5K charity run three years ago. She looks at me the 
way you look at furniture you've been meaning to rearrange.

"You sure you're okay?"

<<link "Tell her about Henderson">>
  <<set $choices.R2_lenaConfide = "told">>
  <<set $marriageBond += 3>>
  <<set $submission += 2>>
  <<goto "R2_Choice_A_Tell">>
<</link>>

<<link "Keep it to yourself">>
  <<set $choices.R2_lenaConfide = "kept">>
  <<set $marriageBond -= 3>>
  <<goto "R2_Choice_B_Keep">>
<</link>>


## EXPLORATION HUB EXAMPLE

:: R2_Apartment_Night_Hub [R2 hub apartment]
<<set $timeOfDay = "late_night">>

The apartment is dark. Lena's breathing reaches you through the 
half-open bedroom door. Your phone sits on the coffee table. 
The whiskey bottle catches the kitchen light.

<<link "Pour another whiskey and sit with your thoughts">>
  <<goto "R2_Whiskey_Alone">>
<</link>>

<<if !$choices.R2_checkedPhone>>
<<link "Look at Lena's phone on the nightstand">>
  <<set $choices.R2_checkedPhone = true>>
  <<goto "R2_Phone_Check">>
<</link>>
<</if>>

<<link "Go to bed and try to sleep">>
  <<goto "R2_Late_Night_Email">>
<</link>>

<<if $choices.R2_checkedPhone>>
<<link "Close your eyes and drift into uneasy sleep">>
  <<goto "R2_Dream_Sequence">>
<</link>>
<</if>>


## STAT CHANGE NOTIFICATION WIDGET

Create a widget passage:

:: StatNotify [widget nobr]
<<widget "statNotify">>
<div class="stat-change">
  <<if _args[1] > 0>>
    <span class="positive"><<print _args[0]>> +<<print _args[1]>></span>
  <<else>>
    <span class="negative"><<print _args[0]>> <<print _args[1]>></span>
  <</if>>
</div>
<</widget>>

Usage in passages:
<<statNotify "Marriage Bond" 3>>
<<statNotify "Submission" 2>>


## KEY IMPLEMENTATION NOTES

1. ALL passage text must be in first person, Daniel's POV
2. Never use em dashes in any passage text
3. No rhetorical questions followed by self-answers
4. Inner thoughts use <<= "..." >> in italics
5. NPC dialogue uses .npc-dialogue div wrapper
6. Each Release ends on an action beat, never a question
7. Background images set via data attributes on scene divs
8. Save system uses SugarCube's built-in saves with custom UI
9. Passage transitions use <<addclass>> for fade effects
10. Stats auto-display in sidebar, updated per passage change

## SAVE SYSTEM ENHANCEMENT

Config.saves.maxSlotSaves = 8;
Config.saves.maxAutoSaves = 1;
Config.saves.isAllowed = function() {
  return !tags().includes("nosave");
};

## RELEASE GATE SYSTEM

At the end of each release, gate the next release:

:: R2_Complete [R2 release-end]
<<set $currentRelease = 2>>

<div class="release-complete">
  <div class="release-title">RELEASE 2 COMPLETE</div>
  <div class="release-subtitle">THE MISTAKE</div>
  
  <div class="end-stats">
    Feminization: <<print $feminization>>% | 
    Submission: <<print $submission>>% | 
    Marriage Bond: <<print $marriageBond>>% |
    Identity: <<print $selfIdentity>>% Daniel
  </div>
  
  <<if $choices.R2_exploredHarperDesk>>
    <div class="discovery">Harper's sticky note discovered.</div>
  <</if>>
  
  <<if $choices.R2_visitedMartin>>
    <div class="discovery">Martin Crane's counsel received.</div>
  <</if>>

  <<link "Continue to Release 3: The Deal">>
    <<goto "R3_Opening">>
  <</link>>
</div>
```