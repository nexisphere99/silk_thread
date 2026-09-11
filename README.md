# Silk Thread   Twine / SugarCube Build

A literary interactive-fiction game built with [Tweego](https://www.motoslave.net/tweego/) and the
SugarCube 2 story format. Release 1 ("The Ordinary Life") is fully implemented.

## Requirements

- [Tweego](https://www.motoslave.net/tweego/) with the `sugarcube-2` story format available.
  This machine has it at `~/tweego`, with formats at `~/tweego/storyformats`.

## Build

```bash
./build.sh
```

This compiles `src/` into `dist/index.html` and points `dist/files` at the project's real
`files/` folder via a relative symlink (`dist/files -> ../files`), so the `files/images/...`
paths used throughout the passages resolve correctly no matter whether you open
`dist/index.html` directly or serve the `dist/` folder. Because it's a symlink, new images
dropped into `files/` show up immediately without re-running the build.

Open `dist/index.html` directly in a browser afterward, everything except the `files/` assets
is a single self-contained HTML file with all CSS/JS embedded. No server required.

`TWEEGO_BIN` / `TWEEGO_PATH` env vars override the tweego binary/format-path locations if
they're not at `~/tweego/tweego` and `~/tweego/storyformats`.

## Project layout

```
src/
  styles/         .tw files, each passage tagged [stylesheet]; numbered 01–06 for load order
  scripts/        .tw files, each passage tagged [script]; macros, npc/phone/stat helpers
  passages/
    system/       StoryInit, StoryData, StoryTitle, Start/Settings/Credits
    shared/       StoryCaption (the stats sidebar)
    release-1/    all Release 1 content, one .tw file per scene block
files/
  images/locations/      10 background/hero images (see silk-thread-r1-image-prompts.md)
  images/characters/     4 character portraits
  images/mood/            6 set-piece images (ceiling crack, shirts, shoes, etc.)
  images/ui/               stats panel texture
```

Drop generated images into `files/images/...` using the exact filenames listed in
`story_files/release_1/silk-thread-r1-image-prompts.md` (each prompt now has its target path
directly above it) and they'll appear automatically   every `<img>` fails gracefully
(`onerror` hides the container) so the game looks intentional with or without art assets.

## Custom macros (defined in `src/scripts/macros.tw`)

- `<<location "Label">>`   small uppercase location header
- `<<scene "Label" "path.png">>`   header + full-width hero image
- `<<portrait "path.png" "Name">>`   right-floated character inset
- `<<moodimage "path.png" "caption">>`   centered set-piece image
- `<<modstat "path" delta>>` / `<<setstat "path" value>>`   adjust `$stats.*` or `$npc.*.*`, clamped 0–100
- `<<npc "who" "stat" delta>>`   bump an `$npc` entry and stamp `lastInteraction`
- `<<ifstat "path" threshold>>...<<else>>...<</ifstat>>`
- `<<advancetime>>`   steps `$time.period` / `$time.day` forward
- `<<addmessage "sender" "text">>` + `<<openphone>>`   phone message system (wired for future releases)

Optional/explore choices use `<span class="sidequest"><<link ...>><</link>></span>` (SugarCube's
`<<link>>` has no native class argument, so the class lives on a wrapping span)   this gets the
dashed "◇ explore" treatment in `choices.tw`.

## What's implemented vs. deferred

Implemented: full Release 1 narrative (all passages from `silk-thread-release-1-story.md`,
including all 3 side quests and the ambient apartment-examine content), stat/NPC/time/phone
systems from the agent spec, a themed SugarCube UI bar, and the end-of-release stats screen.

Deferred (present in the original spec as scaffolding for *future* releases, not needed by R1,
so left out rather than stubbed): `inventory.js`, `save-system.js`, `achievements.js`, and the
`shared/wardrobe.tw` / `mirror.tw` / `map.tw` templates. Add these when Release 2+ content
actually needs them.
