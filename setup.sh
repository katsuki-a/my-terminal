#!/bin/zsh

# This script sets up the terminal based on the provided markdown file.

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Prerequisite Check ---
echo "Checking for prerequisites..."
if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is not installed. Please install it first from https://brew.sh/"
    exit 1
fi
echo "✓ Homebrew is installed."
if [[ -n "$ZSH_VERSION" ]]; then
    echo "✓ Shell is zsh."
else
    echo "Warning: Shell is not zsh. This script is intended for zsh."
fi

# --- Step 1: Install iTerm2 ---
echo "\n--- Step 1: Installing iTerm2 ---"
if brew list --cask iterm2 &>/dev/null; then
    echo "iTerm2 is already installed. Skipping."
else
    echo "Installing iTerm2..."
    brew install --cask iterm2
    echo "iTerm2 installation complete."
fi

# --- Step 2: Install Iceberg iTerm2 Theme ---
echo "\n--- Step 2: Installing Iceberg iTerm2 Theme ---"
THEME_URL="https://raw.githubusercontent.com/Arc0re/Iceberg-iTerm2/master/Iceberg.itermcolors"
THEME_PATH="$HOME/Downloads/Iceberg.itermcolors"
echo "Downloading Iceberg theme to $THEME_PATH..."
# -f: fail silently on server errors, -s: silent mode, -L: follow redirects, -o: output to file
curl -fsSL -o "$THEME_PATH" "$THEME_URL"
echo "Opening the theme file to add it to iTerm2's presets..."
open "$THEME_PATH"
echo "IMPORTANT: Please apply the 'Iceberg' theme manually in iTerm2's settings:"
echo "iTerm2 -> Preferences (or Settings) -> Profiles -> (Your Profile) -> Colors -> Color Presets... -> Select 'Iceberg'"

# --- Step 3: Install Prezto ---
echo "\n--- Step 3: Installing Prezto ---"
ZPREZTO_DIR="${ZDOTDIR:-$HOME}/.zprezto"
if [ -d "$ZPREZTO_DIR" ]; then
    echo "Prezto directory already exists at $ZPREZTO_DIR. Skipping installation."
else
    echo "Cloning Prezto repository..."
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "$ZPREZTO_DIR"

    echo "Setting up Prezto configuration files..."
    setopt EXTENDED_GLOB
    for rcfile in "$ZPREZTO_DIR"/runcoms/^README.md(.N); do
        TARGET_FILE="${ZDOTDIR:-$HOME}/.${rcfile:t}"
        # If a config file already exists and is not a symlink, back it up.
        if [ -f "$TARGET_FILE" ] && [ ! -L "$TARGET_FILE" ]; then
            mv "$TARGET_FILE" "$TARGET_FILE.pre-prezto-backup"
            echo "Backed up existing $TARGET_FILE to $TARGET_FILE.pre-prezto-backup"
        fi
        ln -s "$rcfile" "$TARGET_FILE"
    done
    echo "Prezto installation complete."
fi

# --- Step 4 & 5: Configure .zpreztorc ---
ZPREZTORC_PATH="${ZDOTDIR:-$HOME}/.zpreztorc"
if [ ! -f "$ZPREZTORC_PATH" ]; then
    echo "Error: ~/.zpreztorc not found. Prezto setup might be incomplete."
    exit 1
}

echo "\n--- Step 4: Setting prompt theme to 'pure' ---"
# Use a temporary file for sed compatibility between GNU and BSD (macOS). This is safer than in-place editing.
if grep -q "zstyle ':prezto:module:prompt' theme 'pure'" "$ZPREZTORC_PATH"; then
    echo "Prompt theme is already set to 'pure'."
else
    sed "s|zstyle ':prezto:module:prompt' theme 'sorin'|zstyle ':prezto:module:prompt' theme 'pure'|" "$ZPREZTORC_PATH" > "$ZPREZTORC_PATH.tmp" && mv "$ZPREZTORC_PATH.tmp" "$ZPREZTORC_PATH"
    echo "Theme set to 'pure'."
fi

echo "\n--- Step 5: Adding 'syntax-highlighting' and 'autosuggestions' modules ---"
# Check if modules are already present to avoid duplicates.
if grep -q "'syntax-highlighting'" "$ZPREZTORC_PATH"; then
    echo "Syntax highlighting and autosuggestions modules already appear to be configured."
else
    # Replace the 'prompt' line with the new modules plus 'prompt'.
    # The regex `^\s*'prompt'` matches 'prompt' at the beginning of a line, ignoring leading whitespace.
    sed "s|^\s*'prompt'|  'syntax-highlighting' \\\n  'autosuggestions' \\\n  'prompt'|" "$ZPREZTORC_PATH" > "$ZPREZTORC_PATH.tmp" && mv "$ZPREZTORC_PATH.tmp" "$ZPREZTORC_PATH"
    echo "Added 'syntax-highlighting' and 'autosuggestions' modules."
fi

echo "\n--- Setup Complete! ---"
echo "Please restart your terminal or run 'source ~/.zshrc' to apply the changes."
