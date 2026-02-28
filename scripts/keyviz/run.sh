#!/usr/bin/env bash
# Keyviz runner script
# Usage: ./run.sh [--list] [--device /dev/input/eventX]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"

# Create venv if it doesn't exist
if [[ ! -d "$VENV_DIR" ]]; then
    echo "Creating virtual environment..."
    python -m venv "$VENV_DIR"
    source "$VENV_DIR/bin/activate"
    pip install -q -r "$SCRIPT_DIR/requirements.txt"
else
    source "$VENV_DIR/bin/activate"
fi

# Run the app
python "$SCRIPT_DIR/keyviz.py" "$@"
