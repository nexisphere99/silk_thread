# SILK THREAD   Twine SugarCube Agent Prompt & File Structure

## Project File Structure

```
silk-thread/
├── index.html                    # Main Twine HTML shell
├── src/
│   ├── styles/
│   │   ├── main.css             # Core typography, layout, colors
│   │   ├── ui-overrides.css     # SugarCube UI bar customization
│   │   ├── passages.css         # Passage-specific styling
│   │   ├── choices.css          # Choice button styling
│   │   ├── stats.css            # Stats panel styling
│   │   ├── phone.css            # Phone/text message UI styling
│   │   └── transitions.css     # Fade/slide passage transitions
│   ├── scripts/
│   │   ├── init.js              # Game initialization, variable setup
│   │   ├── stats.js             # Stat system (get/set/display)
│   │   ├── inventory.js         # Wardrobe/item tracking
│   │   ├── phone.js             # Phone message system
│   │   ├── npc-tracker.js       # NPC relationship state
│   │   ├── save-system.js       # Custom save/load logic
│   │   ├── achievements.js      # Milestone tracking
│   │   └── macros.js            # Custom SugarCube macros
│   ├── passages/
│       ├── release-1/
│       │   ├── r1-opening.tw       # Alarm, morning routine
│       │   ├── r1-apartment.tw     # Morning apartment scenes
│       │   ├── r1-commute.tw       # Drive to work
│       │   ├── r1-office.tw        # Office arrival, Harper, Martin
│       │   ├── r1-afternoon.tw     # Afternoon grind, meetings
│       │   ├── r1-dinner.tw        # Evening at home, dinner
│       │   ├── r1-bedroom.tw       # Sex scene, choices
│       │   ├── r1-aftermath.tw     # Post-sex, whiskey, ceiling
│       │   ├── r1-week.tw          # Rest of week montage
│       │   ├── r1-sunday.tw        # Sunday ritual, closing
│       │   └── r1-sidequests.tw    # Harper coffee, Martin, phone
│       ├── release-2/
│       │   └── (future releases)
│       ├── shared/
│       │   ├── phone-ui.tw         # Reusable phone overlay
│       │   ├── stats-panel.tw      # Stats display sidebar
│       │   ├── mirror.tw           # Mirror moment template
│       │   ├── wardrobe.tw         # Wardrobe selection UI
│       │   └── map.tw              # Location map (open world nav)
│       └── system/
│           ├── start.tw            # Title screen
│           ├── settings.tw         # Player settings
│           ├── credits.tw          # Credits
│           └── debug.tw            # Debug/stat viewer
│── files/
│       ├── images/
│       │   ├── locations/          # Background images
│       │   ├── characters/         # Character portraits
│       │   ├── items/              # Item/wardrobe images
│       │   └── ui/                 # UI elements, icons
│       ├── audio/
│       │   ├── ambient/            # Background loops
│       │   └── sfx/                # Sound effects
│       └── fonts/
│           └── (custom fonts)
└── README.md
```

---

## AGENT PROMPT   Twine SugarCube Implementation

Use this prompt with a code agent (Claude Code, Cursor, etc.) to build the game:

---

### SYSTEM CONTEXT

You are building an adult interactive fiction game called "Silk Thread" in Twine SugarCube 2.x format. The game is a first-person narrative experience with open-world exploration, stat tracking, NPC relationships, branching choices, and explicit content. The tone is literary contemporary fiction, not pulp or parody.

### TECHNICAL REQUIREMENTS

**Engine:** Twine 2 with SugarCube 2.37+ story format
**Output:** Single compiled HTML file with embedded CSS/JS, OR modular .tw files for Tweego CLI compilation
**Target:** Desktop browser (1920x1080 primary), mobile responsive (375px minimum)

### CORE ARCHITECTURE

#### 1. Variable Initialization (StoryInit passage)

```javascript
// StoryInit special passage
<<set $player = {
    name: "Daniel",
    alterName: "Danielle",
    currentIdentity: "Daniel"
}>>

// Core Stats
<<set $stats = {
    feminization: 0,
    submission: 0,
    arousalRewiring: 0,
    marriageBond: 70,
    ntrAwareness: 0,
    victoriaTrust: 0,
    officeSuspicion: 0,
    selfIdentity: 100  // 100 = fully Daniel, 0 = fully Danielle
}>>

// Release tracking
<<set $currentRelease = 1>>
<<set $releaseProgress = 0>>

// NPC Relationships
<<set $npc = {
    lena: { affection: 50, suspicion: 0, adrianInterest: 0, lastInteraction: "" },
    victoria: { trust: 0, control: 0, arousal: 0, lastInteraction: "" },
    adrian: { awareness: 0, lenaProgress: 0, danielleAwareness: 0 },
    harper: { trust: 10, suspicion: 0, attraction: 0, lastInteraction: "" },
    martin: { respect: 40, suspicion: 0, lastInteraction: "" },
    celeste: { introduced: false, trust: 0 }
}>>

// Inventory / Wardrobe
<<set $wardrobe = {
    owned: ["boxer-briefs", "dress-shirts", "suits", "leather-shoes"],
    wearing: ["boxer-briefs", "dress-shirt-blue", "charcoal-suit", "leather-shoes"],
    hidden: []
}>>

// Phone system
<<set $phone = {
    messages: [],
    unread: 0
}>>

// Choice history (for branching)
<<set $choices = {
    r1: { bedChoice: "", sideQuests: [] }
}>>

// Time system
<<set $time = {
    day: "monday",
    period: "morning",  // morning, afternoon, evening, night
    week: 1
}>>

// Flags
<<set $flags = {
    harperCoffee: false,
    martinElevator: false,
    lenaPhoneGlimpse: false,
    triedGoDown: false,
    suggestedNew: false,
    acceptedRoutine: false
}>>
```

#### 2. Custom Macros (macros.js)

```javascript
// Stat modification with clamping
Macro.add('modstat', {
    handler: function() {
        var stat = this.args[0];
        var value = this.args[1];
        if (State.variables.stats.hasOwnProperty(stat)) {
            State.variables.stats[stat] = Math.max(0, Math.min(100, 
                State.variables.stats[stat] + value));
        }
    }
});

// Add phone message
Macro.add('addmessage', {
    handler: function() {
        var sender = this.args[0];
        var text = this.args[1];
        var time = this.args[2] || State.variables.time.period;
        State.variables.phone.messages.push({
            sender: sender,
            text: text,
            time: time,
            day: State.variables.time.day,
            read: false
        });
        State.variables.phone.unread++;
    }
});

// Time advancement
Macro.add('advancetime', {
    handler: function() {
        var periods = ["morning", "afternoon", "evening", "night"];
        var days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"];
        var currentPeriodIndex = periods.indexOf(State.variables.time.period);
        if (currentPeriodIndex < periods.length - 1) {
            State.variables.time.period = periods[currentPeriodIndex + 1];
        } else {
            State.variables.time.period = "morning";
            var currentDayIndex = days.indexOf(State.variables.time.day);
            State.variables.time.day = days[(currentDayIndex + 1) % 7];
            if (State.variables.time.day === "monday") {
                State.variables.time.week++;
            }
        }
    }
});

// Conditional text based on stat thresholds
Macro.add('ifstat', {
    tags: ['else'],
    handler: function() {
        var stat = this.args[0];
        var threshold = this.args[1];
        var value = State.variables.stats[stat];
        if (value >= threshold) {
            new Wikifier(this.output, this.payload[0].contents);
        } else if (this.payload.length > 1) {
            new Wikifier(this.output, this.payload[1].contents);
        }
    }
});

// Location-aware passage display
Macro.add('location', {
    handler: function() {
        var loc = this.args[0];
        $(this.output).wiki('<div class="location-header">' + loc + '</div>');
    }
});
```

#### 3. Open World Navigation System

The game uses a hub-based open world. Each time period (morning/afternoon/evening/night) presents available locations. Some locations trigger story-critical passages; others are explorable side content.

```
// Template for hub passage
:: R1_Hub_Morning [hub]
<<location "Daniel's Apartment">>
<<set $time.period = "morning">>

<div class="hub-options">
    <<link "Kitchen" "R1_Kitchen">><<set $time.period = "morning">><</link>>
    <<link "Bedroom" "R1_Bedroom_Morning">><<set $time.period = "morning">><</link>>
    <<link "Leave for Work" "R1_Commute">><<advancetime>><</link>>
</div>

// Office hub
:: R1_Hub_Office [hub]
<<location "Meridian Consulting - Floor 39">>

<div class="hub-options">
    <<link "Your Desk" "R1_Desk">><</link>>
    <<link "Break Room" "R1_BreakRoom">><</link>>
    <<if !$flags.martinElevator>>
        <<link "Elevator Bank" "R1_Martin_Encounter">><</link>>
    <</if>>
    <<link "Conference Room" "R1_Meeting">><</link>>
    <<if $time.period === "afternoon">>
        <<link "Head Home" "R1_Commute_Home">><<advancetime>><</link>>
    <</if>>
</div>
```

#### 4. Stats Display Sidebar

```
:: StoryCaption
<div class="stats-sidebar">
    <div class="stat-group">
        <div class="stat-label">Identity</div>
        <div class="stat-bar">
            <div class="stat-fill identity" style="width: <<= $stats.selfIdentity>>%"></div>
        </div>
        <div class="stat-value"><<= $stats.selfIdentity>>% Daniel</div>
    </div>
    
    <div class="stat-group">
        <div class="stat-label">Marriage</div>
        <div class="stat-bar">
            <div class="stat-fill marriage" style="width: <<= $stats.marriageBond>>%"></div>
        </div>
    </div>
    
    <<if $stats.submission > 0>>
    <div class="stat-group">
        <div class="stat-label">Submission</div>
        <div class="stat-bar">
            <div class="stat-fill submission" style="width: <<= $stats.submission>>%"></div>
        </div>
    </div>
    <</if>>
    
    <<if $phone.unread > 0>>
    <div class="phone-notif" data-passage="PhoneUI">
        📱 <<= $phone.unread>> unread
    </div>
    <</if>>
</div>
```

#### 5. CSS Theme (main.css core)

```css
:root {
    --bg-primary: #0a0a0e;
    --bg-secondary: #131318;
    --bg-card: #1a1a22;
    --text-primary: #d4d0c8;
    --text-secondary: #8a8680;
    --text-dim: #5a5650;
    --accent-gold: #c4a35a;
    --accent-rose: #8b3a4a;
    --accent-ice: #4a6a8b;
    --link-color: #c4a35a;
    --link-hover: #e0c070;
    --choice-bg: #1a1a22;
    --choice-border: #2a2a32;
    --choice-hover: #252530;
    --font-body: 'Libre Baskerville', Georgia, serif;
    --font-ui: 'Inter', 'Helvetica Neue', sans-serif;
    --transition-speed: 0.3s;
}

html, body {
    background: var(--bg-primary);
    color: var(--text-primary);
    font-family: var(--font-body);
    font-size: 17px;
    line-height: 1.75;
    max-width: 100%;
    overflow-x: hidden;
}

#story {
    max-width: 680px;
    margin: 0 auto;
    padding: 2rem 1.5rem;
}

.passage {
    animation: fadeIn 0.6s ease;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(8px); }
    to { opacity: 1; transform: translateY(0); }
}

/* Choice buttons */
.choice-container {
    margin: 2rem 0;
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
}

.choice-container a,
.choice-btn {
    display: block;
    padding: 1rem 1.25rem;
    background: var(--choice-bg);
    border: 1px solid var(--choice-border);
    color: var(--text-primary);
    text-decoration: none;
    font-family: var(--font-body);
    font-size: 0.95rem;
    line-height: 1.5;
    cursor: pointer;
    transition: all var(--transition-speed);
}

.choice-container a:hover,
.choice-btn:hover {
    background: var(--choice-hover);
    border-color: var(--accent-gold);
    color: var(--accent-gold);
}

/* Location header */
.location-header {
    font-family: var(--font-ui);
    font-size: 0.7rem;
    letter-spacing: 0.15em;
    text-transform: uppercase;
    color: var(--text-dim);
    margin-bottom: 1.5rem;
    padding-bottom: 0.5rem;
    border-bottom: 1px solid #1a1a22;
}

/* Stats sidebar */
.stats-sidebar {
    padding: 1rem;
}

.stat-group {
    margin-bottom: 0.75rem;
}

.stat-label {
    font-family: var(--font-ui);
    font-size: 0.65rem;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    color: var(--text-dim);
    margin-bottom: 0.25rem;
}

.stat-bar {
    height: 4px;
    background: #1a1a22;
    border-radius: 2px;
    overflow: hidden;
}

.stat-fill {
    height: 100%;
    transition: width 0.5s ease;
}

.stat-fill.identity { background: var(--accent-ice); }
.stat-fill.marriage { background: var(--accent-rose); }
.stat-fill.submission { background: var(--accent-gold); }

/* Phone UI overlay */
.phone-overlay {
    position: fixed;
    top: 0; right: 0; bottom: 0; left: 0;
    background: rgba(0,0,0,0.85);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
}

.phone-device {
    width: 320px;
    max-height: 80vh;
    background: #111;
    border-radius: 24px;
    padding: 2rem 1rem;
    overflow-y: auto;
}

.message-bubble {
    padding: 0.6rem 0.9rem;
    margin: 0.4rem 0;
    border-radius: 12px;
    font-family: var(--font-ui);
    font-size: 0.85rem;
    max-width: 80%;
}

.message-bubble.incoming {
    background: #2a2a35;
    color: var(--text-primary);
    margin-right: auto;
}

.message-bubble.outgoing {
    background: var(--accent-ice);
    color: #fff;
    margin-left: auto;
}

/* SugarCube UI overrides */
#ui-bar { background: var(--bg-secondary); border-right: 1px solid #1a1a22; }
#ui-bar-toggle { color: var(--text-dim); }
#ui-bar a { color: var(--text-secondary); }
#menu-core li a:hover { color: var(--accent-gold); }

/* Responsive */
@media (max-width: 768px) {
    #story { padding: 1rem; }
    html { font-size: 15px; }
    .phone-device { width: 90vw; }
}
```

#### 6. Sample Passage Implementation (Release 1 Opening)

```
:: Start [system]
<<set $currentRelease = 1>>
<<goto "R1_Opening">>

:: R1_Opening [r1 story]
<<location "Daniel & Lena's Apartment - Bedroom">>
<<set $time = { day: "monday", period: "morning", week: 1 }>>

The alarm goes off at 5:45 AM. Fifteen minutes early, the way it always does, the way I set it three years ago when I decided that being early was the same thing as being in control. It isn't. But the alarm doesn't know that and neither do I, most mornings.

I lie there for eleven seconds. I know it's eleven because I count them. Some men pray. Some men reach for their wives. I count to eleven and then I swing my legs off the mattress and plant my feet on the hardwood and that's it, that's the beginning, every single weekday for the last four years.

Lena's hair is fanned across her pillow like something from a shampoo commercial, auburn catching the thin line of streetlight that leaks through the blinds. She used to get up with me. We'd make coffee together, bump hips at the kitchen counter, her in my old college t-shirt, me in boxers, and the apartment would smell like dark roast and sleep-warm skin. That was year one. Maybe early year two.

Now she sleeps until I leave.

I kiss her forehead. She doesn't stir.

<div class="choice-container">
    <<link "Get up. Start the ritual." "R1_MorningRoutine">><</link>>
    <<link "Lie here a moment longer." "R1_LingerBed">><</link>>
</div>

:: R1_LingerBed [r1 story]
<<location "Bedroom">>

I stay. Ten more seconds. The sheets smell like her shampoo, something with coconut, and the pillow holds the shape of her head and for a moment the bed feels like what it used to feel like. A shared space. A warm country with a population of two.

Then the moment passes. Moments always pass. I swing my legs off the mattress.

<<goto "R1_MorningRoutine">>

:: R1_MorningRoutine [r1 story]
<<location "Bathroom">>

The shower takes exactly seven minutes. I've timed it. Water at 102 degrees because I read somewhere that's the optimal temperature for circulation without damaging your skin, and I filed that fact away the same way I file everything: neatly, permanently, uselessly.

Shaving. Jawline first, then cheeks, then upper lip, then the neck in careful downward strokes. My father taught me to shave when I was fourteen. His hand over mine on the razor, guiding the angle. "A man's face is his handshake with the world, Danny." He said things like that. Declarations that sounded carved from granite but meant nothing when you held them up to light.

I pick the shirt I selected last night. Light blue, Egyptian cotton, pressed on Sunday along with four others while football played in the background. I don't care about football. I care about the appearance of caring about football, which is its own exhausting sport.

Tie. Windsor knot. Shoes by the door, polished to a mirror sheen.

I grab my briefcase. Keys. Phone. Wallet. The same four objects in the same four pockets every morning.

<<goto "R1_Hub_Morning">>

:: R1_Hub_Morning [r1 hub]
<<location "Daniel's Apartment">>

The apartment is quiet. Lena is still sleeping. The kitchen counter is clean, the coffee maker untouched.

<div class="hub-options">
    <<link "Make coffee alone" "R1_Kitchen_Solo">><</link>>
    <<if !$flags.lenaPhoneGlimpse>>
        <<link "Glance at the living room" "R1_LivingRoom_Morning">><</link>>
    <</if>>
    <<link "Head out the door" "R1_Commute">><</link>>
</div>

:: R1_Kitchen_Solo [r1 story]
<<location "Kitchen">>

I make coffee. The machine gurgles and hisses and produces something that tastes like it was brewed by someone going through the motions, which is accurate. I drink it standing at the counter, looking at the spot where Lena used to stand, hip cocked against the drawer, stealing sips from my mug because she was too lazy to pour her own.

The spot is empty. The coffee is adequate.

<<goto "R1_Hub_Morning">>

:: R1_Commute [r1 story]
<<advancetime>>
<<location "Downtown - In Transit">>

The drive takes twenty-eight minutes today. I listen to a podcast about market disruption that I'll reference in a meeting to sound current and then immediately forget. The host has the kind of voice that suggests he's never lost sleep over anything, and I envy that, the luxury of certainty.

Downtown materializes through the windshield. Glass towers, steel bones. Meridian Consulting occupies floors 38 through 42. I work on 39. Interior-facing. No skyline view.

The parking garage is four levels underground. I park in the same spot. Not assigned. Just habit. That sentence is probably the most honest thing I'll think all morning.

<<goto "R1_Hub_Office">>

:: R1_Hub_Office [r1 hub]
<<location "Meridian Consulting - Floor 39">>

The lobby smells like fresh flowers and that particular strain of ambition that coats the inside of buildings where people wear lanyards. My office is exactly what you'd expect. Not corner. Not window-facing.

<div class="hub-options">
    <<link "Sit at your desk, start emails" "R1_Desk_Morning">><</link>>
    <<if !$flags.harperCoffee>>
        <<link "Break room for coffee" "R1_SQ_HarperCoffee">><</link>>
    <</if>>
    <<if !$flags.martinElevator>>
        <<link "Catch Martin Crane in the hall" "R1_SQ_MartinHall">><</link>>
    <</if>>
</div>

:: R1_Desk_Morning [r1 story]
<<location "Your Office - Floor 39">>

I boot up my laptop. Thirty-seven emails overnight, twelve flagged, three from Greg Tanaka with the passive-aggressive urgency of a man who sends emails at midnight and expects responses by 6 AM.

Scan, reply, file. Scan, reply, file. The rhythm of it is almost soothing, the way treading water is almost swimming.

"You misspelled 'deliverables' on slide nine."

I look up. Harper Quinn is standing at the edge of my desk with a revised deck in her hand. Twenty-six. Sharp enough to cut glass. Dark hair pulled back, minimal makeup, the posture of someone who decided early that competence was the only currency worth earning.

"Did I?"

"D-E-L-I-V-E-R-A-B-L-E-S. You had an 'A' where the second 'E' goes. It's fine. I caught it."

She drops the deck on my desk. "Did you read Crane's latest memo? 'Synergistic value alignment across stakeholder touchpoints.' I counted fourteen buzzwords in three paragraphs."

I laugh. Actually laugh. The sound surprises me. It's been buried under so many layers of professional composure that hearing it feels like finding a twenty-dollar bill in an old jacket.

She grins, quick and conspiratorial, and then she's gone.

<<goto "R1_Afternoon">>

:: R1_SQ_HarperCoffee [r1 sidequest]
<<set $flags.harperCoffee = true>>
<<location "Break Room - Floor 39">>

The break room on 39 is a liminal space. Half kitchen, half purgatory. A Keurig machine that makes sounds like a dying animal. A motivational poster someone hung ironically three years ago that everyone's forgotten was ironic.

Harper is at the counter, pouring hot water over a pour-over setup she brought from home.

"You bring your own coffee equipment to the office?"

"The Keurig is an affront to human dignity." She adjusts the pour. "Also, I like ritual. The weighing, the temperature, the timing. It's meditative."

"That sounds like something Martin Crane would say about golf."

"Except coffee doesn't require ugly pants and a massive carbon footprint." She looks at me. Direct. "You're wound tight today."

"I'm always wound tight."

"Yeah, but today it's showing. Your jaw's been clenched since you sat down this morning."

I consciously relax my jaw. She smiles.

"Better. Want some?"

She pours. The coffee is better than anything the building has ever produced. We stand there sipping from ceramic mugs she brought from home, and for about ninety seconds, the office is almost bearable.

"You're going to be fine Thursday," she says, without context, because she doesn't need it.

<<modstat "npc.harper.trust" 5>>
<<goto "R1_Hub_Office">>

:: R1_SQ_MartinHall [r1 sidequest]
<<set $flags.martinElevator = true>>
<<location "Hallway - Floor 39">>

Martin Crane intercepts me near the elevator bank. Fifty-five, six-foot-one, built like a man who played football in college and never entirely stopped believing the world owed him for it. Handshake like he's testing whether your bones are load-bearing.

"Ashford. Henderson account ready for Thursday?"

"Yes, sir. Three-scenario breakdown, full competitive analysis, updated projections."

"Good." He claps my shoulder. The impact is somewhere between affection and establishing dominance. "You've been solid on this one. Keep it tight."

He walks away. Big strides. The hallway parts for him without him noticing because he's never had to notice.

I stand there for a moment. My shoulder warm where his hand was. Martin represents something I'm supposed to want. The commanding voice, the corner office, the certainty.

I should admire him. I do, technically, in the way you admire a monument you walk past every day.

<<modstat "officeSuspicion" 0>>
<<goto "R1_Hub_Office">>

:: R1_Afternoon [r1 story]
<<set $time.period = "afternoon">>
<<location "Meridian Consulting - Floor 39">>

The afternoon is a sludge of meetings and spreadsheets and a lunch I eat at my desk. Turkey on wheat, apple, water. The same lunch four days a week because decisions are a finite resource.

At 2 PM I sit in on a strategy review where Greg Tanaka talks for forty minutes about "leveraging adjacencies" and I nod at the appropriate intervals.

Harper catches my eye during the phrase "circle back on the bandwidth question" and does something subtle with her left eyebrow that makes me cough-laugh into my coffee. Greg glances at me. I fake a cough.

By 5 PM the building is thinning out.

<<link "Head home" "R1_Commute_Home">><<advancetime>><</link>>

:: R1_Commute_Home [r1 story]
<<set $time.period = "evening">>
<<location "In Transit">>

The drive home is twenty minutes. Light traffic. I stop at the grocery store for no particular reason and leave without buying anything.

<<goto "R1_Hub_Evening">>

:: R1_Hub_Evening [r1 hub]
<<location "Daniel's Apartment - Evening">>

Lena is in the kitchen. The apartment smells like garlic and olive oil, which means she reheated the pasta from two nights ago.

<div class="hub-options">
    <<link "Join her in the kitchen" "R1_Dinner">><</link>>
    <<link "Change clothes first" "R1_Bedroom_Change">><</link>>
</div>

:: R1_Dinner [r1 story]
<<location "Kitchen / Living Room">>

"Hey." She's at the counter, scrolling her phone, wineglass half-empty. She's in leggings and an oversized sweater that slips off one shoulder.

"Hey. Smells good."

"It's the same thing from Tuesday."

"Still smells good."

She half-smiles. Doesn't look up from her phone.

We eat at the kitchen table with the TV on in the living room, volume low. I talk about work. The Henderson account. Greg's meeting. She nods at the right moments. Her fork moving from plate to mouth in a rhythm that mirrors the conversation: steady, practiced, automatic.

"How was your day?"

"Fine. Yoga was good. Sarah's pregnant."

"Sarah from your studio?"

"Mmhm."

The conversation dies the way our conversations always die. Not with conflict but with the mutual, silent agreement that we've both said enough to qualify as communication without actually communicating anything.

<<goto "R1_Evening_Couch">>

:: R1_Evening_Couch [r1 story]
<<location "Living Room">>

We sit on the couch. Her legs are tucked under her. I have my laptop open, pretending to review tomorrow's prep.

The silence between us has texture. It used to be comfortable. Now it's the other kind.

"I'm going to bed," she says at 9:15.

She leans over and kisses my cheek. Brief, dry. The kiss of a woman fulfilling a contract.

"I'll be in soon."

She pads down the hallway. I hear the bathroom door close. Water running. Then the bedroom door.

<<if !$flags.lenaPhoneGlimpse>>
    <<link "Notice her phone on the coffee table" "R1_SQ_PhoneGlimpse">><</link>>
<</if>>
<<link "Follow her to bed" "R1_Bedroom_Night">><</link>>

:: R1_SQ_PhoneGlimpse [r1 sidequest]
<<set $flags.lenaPhoneGlimpse = true>>
<<location "Living Room">>

Her phone is on the coffee table. The screen lights up with a notification. Instagram. A follow request from someone named "adrianwolfe" with a profile photo of a jawline and a sunset.

I don't know who that is. I don't think about it.

When she comes back briefly for water, she picks up her phone, swipes, pauses for a moment, and then her thumb taps "Accept."

She doesn't mention it. I don't ask.

<<goto "R1_Bedroom_Night">>

:: R1_Bedroom_Night [r1 story]
<<set $time.period = "night">>
<<location "Bedroom">>

The bedroom is dark except for the glow of Lena's phone. She's lying on her side, scrolling. Her face in that blue light looks younger, softer.

I undress in the dark. Fold my shirt. Hang my slacks. Place my shoes side by side.

I slide into bed. The sheets are cool on my side. Her side radiates heat. The distance between us is maybe eighteen inches but I have to build up to crossing it the way someone builds up to jumping off a diving board.

I put my hand on her thigh. Over the blanket. Tentative.

She puts her phone down.

The sigh. She doesn't know she does it. This small exhalation through her nose. It isn't desire. It isn't refusal. It's something in between.

<<goto "R1_SexScene">>

:: R1_SexScene [r1 story intimate]
<<location "Bedroom">>

The lights are off. They're always off.

I move on top of her. She parts her legs. Not wide. Just enough. Her hands settle on my shoulders with the weight of something already familiar, already catalogued.

I'm inside her. She's warm and the mechanics are fine, they've always been fine. I move. She responds. The sounds are quiet, polite. A small "mm" on my third thrust. A shift of her hips on the fifth.

Four minutes. I finish. The orgasm is functional. A release valve, not a crescendo. I exhale against her neck and she pats my shoulder blade the way you pat a dog that just brought back a ball.

I roll off.

She reaches for her phone. The screen blooms to life.

I stare at the ceiling. The hairline crack running from the light fixture to the northwest corner. I've been tracking it for two years.

//*I used to make her scream.*//

<div class="choice-container">
    <<link "Try to go down on her" "R1_Choice_A">>
        <<set $choices.r1.bedChoice = "godown">>
    <</link>>
    <<link "Suggest something different" "R1_Choice_B">>
        <<set $choices.r1.bedChoice = "suggest">>
    <</link>>
    <<link "Say nothing. Accept the routine." "R1_Choice_C">>
        <<set $choices.r1.bedChoice = "accept">>
    <</link>>
</div>

:: R1_Choice_A [r1 story]
<<modstat "marriageBond" -2>>
<<set $flags.triedGoDown = true>>

I touch her hip. "Hey. Let me..."

I start to move down, pulling the blanket. She puts her hand on my shoulder. Gentle, but firm.

"I'm tired, babe."

The word "babe" is a closed door with a welcome mat in front of it.

I stop. Move back up.

"Okay."

"Long day," she adds.

"Yeah."

She rolls to her side, facing away. I lie on my back and feel the rejection like a small, cold stone in my stomach. Not painful. Worn smooth. I've swallowed this stone before.

<<goto "R1_PostSex">>

:: R1_Choice_B [r1 story]
<<modstat "marriageBond" -3>>
<<set $flags.suggestedNew = true>>

"We could try something different."

She turns her head on the pillow. In the dark I can't read her expression but I can feel it. That slight tension.

"Different how?"

I don't have a good answer. I don't even know what I mean. But the words don't organize themselves fast enough, and into the gap, her discomfort flows like water.

"Daniel, I'm really tired."

"No, I know. Forget it."

She adjusts her pillow. The conversation curls up and dies between us.

<<goto "R1_PostSex">>

:: R1_Choice_C [r1 story]
<<set $flags.acceptedRoutine = true>>

I don't say anything. She picks up her phone. The blue light returns.

This is what marriage becomes. This is what everyone says and what nobody questions. This is normal. This is fine.

<<goto "R1_PostSex">>

:: R1_PostSex [r1 story]
<<location "Kitchen - Late Night">>

The night settles. I get up. Pad to the kitchen. Pour a finger of whiskey.

I stand at the window. The city is out there, lit up. And I'm in here, in my nice apartment, with my nice wife, with my nice career, drinking nice whiskey. The word "nice" is a prison sentence served in a room with no bars.

My phone is on the counter. No new emails. No messages. No one reaching for me in the digital dark.

I finish the whiskey. Go back to bed. Close my eyes.

Tomorrow will be the same.

I count to eleven.

<<goto "R1_WeekMontage">>

:: R1_WeekMontage [r1 story]
<<location "Multiple - Week One">>
<<set $time.day = "thursday">>

Tuesday through Thursday pass in a smear of meetings and decks and lunches I don't taste. The Henderson meeting goes well Thursday. Not brilliantly. Not catastrophically. The client nods. Greg nods.

Thursday evening. Lena is on the couch in yoga pants. Laptop open.

"Pizza or Thai?"

"Thai. Get the pad see ew."

"Same as always?"

She glances up. Holds my gaze for a half-second longer than usual.

"Same as always," she says.

I order the Thai. We eat on the couch. Her feet in my lap. I rub her arches while she works. This is us at our best: functional, cooperative. Two people sharing a couch and a pad see ew and the comfortable lie that this is enough.

<<goto "R1_Sunday">>

:: R1_Sunday [r1 story]
<<set $time.day = "sunday">>
<<location "Daniel's Apartment - Sunday">>

Sunday. The ritual.

I lay out five shirts on the bed, still warm from the iron. Each one pressed along the seams, collar stiffened. I hang them in the closet, organized by color. Monday through Friday. No decisions required.

The shoes come next. Polish, brush, buff. I've been doing this since I was sixteen.

Football is on the TV. I don't look at it.

Lena comes home at 2:15 from brunch. Flushed from mimosas. Happy in the way she gets around other people, a particular brightness that dims slightly when she walks through our door.

I notice it. I always notice it. I never say anything.

The evening arrives without announcement. We eat leftovers. We watch a show. We go to bed.

I do not reach for her. She does not reach for me.

The crack in the ceiling is the same length it was last week.

I count to eleven.

I sleep.

<<goto "R1_Closing">>

:: R1_Closing [r1 story]
<<location "Bedroom - Late Night">>

This is my life.

These are my shirts. This is my tie. These are my shoes.

This is my wife, who is beautiful and kind and slowly becoming a stranger I share a mortgage with.

This is my office, mid-level, interior-facing, no view.

This is my routine. My armor.

Everything is fine.

Everything is exactly, precisely fine.

The alarm is set for 5:45 AM. Fifteen minutes early. Because Daniel Ashford is a man who builds buffers into everything, and one day, maybe, that buffer will be the thing that saves him.

Or maybe it'll be the thing that keeps him from ever needing to be saved at all.

<div class="release-end">
    <div class="release-title">End of Release 1: The Ordinary Life</div>
    <<link "Continue to Release 2" "R2_Opening">><</link>>
    <<link "View Stats" "R1_StatsScreen">><</link>>
</div>

:: R1_StatsScreen [r1 system]
<div class="stats-full">
<h3>Release 1 Complete</h3>

|Stat|Value|
|Identity|<<= $stats.selfIdentity>>% Daniel|
|Marriage Bond|<<= $stats.marriageBond>>%|
|Feminization|<<= $stats.feminization>>%|
|Submission|<<= $stats.submission>>%|

<h3>Choices Made</h3>
<<if $choices.r1.bedChoice === "godown">>You tried to go down on Lena. She declined.
<<elseif $choices.r1.bedChoice === "suggest">>You suggested something different. She wasn't interested.
<<else>>You accepted the routine.
<</if>>

<h3>Side Quests</h3>
<<if $flags.harperCoffee>>✓ Harper's Pour-Over<<else>>○ Harper's Pour-Over (missed)<</if>>
<<if $flags.martinElevator>>✓ Martin's Hallway<<else>>○ Martin's Hallway (missed)<</if>>
<<if $flags.lenaPhoneGlimpse>>✓ The Follow Request<<else>>○ The Follow Request (missed)<</if>>

<<link "Continue to Release 2" "R2_Opening">><</link>>
</div>
```

#### 7. Compilation with Tweego

```bash
# Install Tweego
# Download from: https://www.motoslave.net/tweego/

# Compile all .tw files into single HTML
tweego src/passages/ -o dist/silk-thread.html -f sugarcube-2

# With CSS and JS includes
tweego src/passages/ \
    --head="<link rel='stylesheet' href='styles/main.css'>" \
    -o dist/silk-thread.html \
    -f sugarcube-2

# Watch mode for development
tweego src/passages/ -o dist/silk-thread.html -f sugarcube-2 --watch
```

#### 8. Build Notes

- All passages tagged with `[r1]` for release filtering
- Hub passages tagged `[hub]` for open-world navigation
- Side quests tagged `[sidequest]` and gated by flags
- Intimate scenes tagged `[intimate]` for content filtering
- The `<<modstat>>` macro handles all stat changes with 0-100 clamping
- Phone messages accumulate across releases via `$phone.messages` array
- NPC relationship objects persist and carry forward
- Save system uses SugarCube's built-in `Save` API with custom slot naming
- The open-world hub system gates content by `$time.period` so players explore freely within narrative time blocks
