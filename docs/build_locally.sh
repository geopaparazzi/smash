#!/usr/bin/env bash
# Build the SMASH manual locally with Sphinx, into _build/html.
#
# Usage: ./build_locally.sh
# Then open _build/html/index.html directly in a browser (no server needed).
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

VENV_DIR=".venv"

if [ ! -d "$VENV_DIR" ]; then
  echo "Creating virtualenv in $VENV_DIR ..."
  python3 -m venv "$VENV_DIR"
fi

"$VENV_DIR/bin/pip" install -q -r requirements.txt

rm -rf _build
"$VENV_DIR/bin/sphinx-build" -b html . _build/html

INDEX="$(pwd)/_build/html/index.html"
echo ""
echo "Build done. Open this file in a browser:"
echo "  file://$INDEX"

# Best-effort auto-open; harmless if no opener is available (eg. over SSH).
# if command -v xdg-open >/dev/null 2>&1; then
#   xdg-open "$INDEX" >/dev/null 2>&1 &
# elif command -v open >/dev/null 2>&1; then
#   open "$INDEX"
# fi
