#!/usr/bin/env bash
# Builds the Silk Thread Twine/SugarCube game into dist/index.html.
#
# dist/ is a self-contained, servable output folder: index.html plus a
# files/ symlink back to the project's real asset folder, so image/audio
# paths like "files/images/locations/x.png" resolve whether you open
# dist/index.html directly or serve the dist/ folder.
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

TWEEGO_BIN="${TWEEGO_BIN:-$HOME/tweego/tweego}"
TWEEGO_PATH="${TWEEGO_PATH:-$HOME/tweego/storyformats}"

if [ ! -x "$TWEEGO_BIN" ]; then
    echo "error: tweego binary not found at $TWEEGO_BIN (set TWEEGO_BIN to override)" >&2
    exit 1
fi

mkdir -p dist

echo "Compiling src/ -> dist/index.html ..."
TWEEGO_PATH="$TWEEGO_PATH" "$TWEEGO_BIN" src/ -o dist/index.html -f sugarcube-2 -l

# Point dist/files at the real files/ folder (relative symlink) so newly
# added images/audio show up immediately without re-running this script.
if [ -L dist/files ]; then
    rm dist/files
elif [ -e dist/files ]; then
    echo "error: dist/files exists and is not a symlink, remove it manually and re-run" >&2
    exit 1
fi
ln -s ../files dist/files

echo "Done. Open dist/index.html in a browser."
