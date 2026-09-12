# Silk Thread — Developer Log

Internal build log across all six releases. Numbers are per-release (not cumulative): passages and prose word counts are counted directly from that release's own `.tw` files; image counts are newly-introduced images referenced for the first time in that release (reused assets from earlier releases aren't recounted).

---

## Release 1 — The Ordinary Life

**Passages:** 34 &nbsp;|&nbsp; **Images added:** 18 &nbsp;|&nbsp; **Prose:** ~6,168 words

- Full engine build from scratch: SugarCube theme/CSS, StoryInit variable schema (`$stats`, `$npc`, `$wardrobe`, `$phone`, `$choices`, `$flags`, `$time`), and the first custom macro set (`<<location>>`, `<<modstat>>`, `<<npc>>`, `<<advancetime>>`, `<<ifstat>>`).
- Establishes Daniel's baseline married life at Meridian Consulting: Lena, Harper Quinn, Martin Crane, Greg Tanaka.
- Morning routine → commute → office day, with two sidequests (Harper's coffee, Martin's hallway mentorship) and a phone-glimpse sidequest that plants Adrian Wolfe's Instagram follow request as a Chekhov's gun for Release 6.
- Bedroom sex scene with the first 3-way branching choice (try to go down / suggest something different / accept the routine), each with its own `marriageBond` hit.
- Sunday ritual closing and the first stats recap screen.
- Mid-release polish: fixed sidebar/title overlap, added speaker-labeled dialogue (`<<say>>`/`<<sayself>>`), fixed a stat-bar-always-100%-filled bug, fixed a critical bare-`<<goto>>` bug that silently skipped passage content, added the sidebar objective indicator and character portrait, swapped the "ceiling crack" motif for "chip in the nightstand paint," removed em-dashes project-wide.

---

## Release 2 — The Mistake

**Passages:** 24 &nbsp;|&nbsp; **Images added:** 17 &nbsp;|&nbsp; **Prose:** ~6,538 words

- Daniel's professional life cracks: the Henderson account collapses, Greg Tanaka's office confrontation, Martin and Harper's differing reactions.
- Introduces `$choices.r2.lenaChoice` — a marital-repair-attempt branch at dinner.
- Sidequests: Harper's sticky note, an extended Harper conversation, an extended Martin hallway beat, a late-night phone check, staying up late.
- Whiskey-alone-at-night beat, a dream sequence, and a late-night email that seeds the Victoria Cross introduction for Release 3.
- Infra: extension-mismatch cleanup (doc said `.webp`, actual files were `.png` — the first occurrence of a pattern that recurred every release after).

---

## Release 3 — The Deal

**Passages:** 22 &nbsp;|&nbsp; **Images added:** 19 &nbsp;|&nbsp; **Prose:** ~6,464 words

- Victoria Cross introduced: the 7 AM summons to Floor 42, the career-autopsy conversation, the offer.
- The drawer scene — first physical contact with the La Perla panties — with a 3-way choice (`shame` / `curiosity` / `negotiate`) setting `$choices.r3.dealChoice` and seeding `feminization` for the first time.
- Sidequests: lunch with Harper, an extended Martin elevator encounter.
- Ends with the panties waiting in the nightstand for "tomorrow."
- Infra: fixed a Harper portrait filename mismatch, split a reused corridor image out from the elevator scene so it got its own hero shot, re-caught and fixed a reintroduced bare-`<<goto>>` bug.

---

## Release 4 — Silk Against Skin

**Passages:** 20 &nbsp;|&nbsp; **Images added:** 17 &nbsp;|&nbsp; **Prose:** ~6,198 words

- Daniel wears the panties to work for the first full day: standup, lunch with Crane, the conference-room presentation where Victoria watches him perform.
- Harper and Martin both register something's different, advancing their suspicion threads without confirming anything.
- After-hours summons to Victoria's office with the first denied-permission dynamic and a 3-way choice (`ask` / `demand` / `silent`) setting `$choices.r4.afterHoursChoice`.
- Two sidequests: the washroom-stall locker moment (written at full explicitness per direct instruction) and an evening phone-check that plants the first seed of NTR awareness.
- Infra: fixed the sidebar release-subtitle bug (stuck on "Release 1" past R2), built the `$buildRelease` vs `$currentRelease` split so the sidebar shows which build a player is running rather than which chapter they've reached.

---

## Release 5 — Matching Set

**Passages:** 24 &nbsp;|&nbsp; **Images added:** 14 &nbsp;|&nbsp; **Prose:** ~7,992 words

- The bra arrives — first full matching set worn for a complete workday.
- A full day of near-misses: the Dave Parkman backslap, Harper's forearm pausing on the strap during a work session, lunch with Martin.
- After-hours foot-worship scene with the first denied orgasm, and a 3-way choice (`ask` / `thanks` / `stop`) setting `$choices.r5.afterHoursChoice`.
- Four sidequests: Lena's pre-dawn departure (flashback), the elevator with Martin, coffee with Harper, Greg Tanaka's summons.
- Infra: fixed the hero `.scene-image` CSS that was cropping every non-16:9 image to a fixed box — now shows full images at natural height.

---

## Release 6 — Lena Meets Adrian

**Passages:** 18 &nbsp;|&nbsp; **Images added:** 14 &nbsp;|&nbsp; **Prose:** ~6,192 words

- Adrian Wolfe appears in person for the first time, at Meridian's quarterly mixer — the entrance, the handshake, and the forty-minute conversation with Lena that Daniel watches from across the room.
- Victoria's running commentary ("Adrian has that effect on people") ties the NTR thread directly to her ongoing control of Daniel.
- Three optional sidequests at the mixer: Harper the observer, Martin's standard, Victoria's check-in.
- Home sex scene fueled by Lena's secondhand arousal from the party, followed by the midnight second-text choice (`read` / `ask` / `pretend`) setting `$choices.r6.choiceResolution` and driving the first substantial `ntrAwareness` swing.
- Infra: fixed a real crash — `$choices`/`$flags` schema growth meant an old save (or a same-tab session surviving a version update) restored without newer keys, throwing "Cannot set properties of undefined" the moment a later release's passage tried to set them. Fixed with a `Save.onLoad` + `:storyready` migration pass, patched onto every branch with more than one release's worth of schema growth.

---

## Cross-cutting engine work

Not tied to a single release, applied wherever relevant across the branch set (`release_1`–`release_6`, `main`):

- **Image verification workflow** — disk-listing vs. code-referenced-path diffing — caught a real bug on every single release (unused assets, extension mismatches, wrong folders, double extensions).
- **Bare-`<<goto>>` sweep** — a Python regex scan for `^\s*<<goto` lines, since a bare goto after prose silently drops that passage's own text for the player. Run before every release ships.
- **Save-schema migration** (`Silk.fillDefaults`/`Silk.migrateMoments` in `macros.tw`) — keeps old saves and same-tab sessions from crashing when a newer release adds `$choices`/`$flags` keys.
- **`$buildRelease`** — sidebar always names the build being played, independent of `$currentRelease` (which still drives in-story chapter-based visual changes like the portrait swap).
- **Patreon link** — unified to `patreon.com/c/sithrstudio` on the true-latest ending of every branch.

## Branch model

- `release_1` … `release_6`: `release_1` is R1-only (filtered); every other `release_N` branch is cumulative (R1 through RN). Each is what's actually published to a given Patreon tier/version.
- `main`: full ongoing development, always at the latest content, never pushed to origin.
