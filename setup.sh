#!/bin/zsh

#==============================================================================
# iTerm2 + zsh + Prezto Setup Script
#
# This script automates the setup of a modern terminal environment on macOS.
# It is designed to be idempotent and can be safely run multiple times.
#
# What it does:
# 1. Checks for prerequisites (Homebrew, Git, etc.).
# 2. Installs iTerm2.
# 3. Installs the Iceberg color theme for iTerm2.
# 4. Installs the Prezto Zsh framework.
# 5. Configures Prezto with the 'Pure' prompt and useful modules.
#==============================================================================

# --- Configuration ---
# Exit immediately if a command exits with a non-zero status.
set -e
# Treat unset variables as an error.
set -u
# Pipes return the exit status of the last command to exit with a non-zero status.
set -o pipefail

# --- Variables and Constants ---
readonly ZPREZTO_DIR="${ZDOTDIR:-$HOME}/.zprezto"
readonly ZPREZTORC_PATH="${ZDOTDIR:-$HOME}/.zpreztorc"
readonly ICEBERG_THEME_URL="https://raw.githubusercontent.com/Arc0re/Iceberg-iTerm2/master/Iceberg.itermcolors"
readonly ICEBERG_THEME_PATH="$HOME/Downloads/Iceberg.itermcolors"

# --- Helper Functions for Logging ---
# Use colors for better readability
readonly C_RESET='\033[0m'
readonly C_RED='\033[0;31m'
readonly C_GREEN='\033[0;32m'
readonly C_YELLOW='\033[0;33m'
readonly C_CYAN='\033[0;36m'

info() {
  echo "${C_CYAN}==>${C_RESET} $1"
}

success() {
  echo "${C_GREEN}✓${C_RESET} $1"
}

warn() {
  echo "${C_YELLOW}Warning:${C_RESET} $1"
}

error() {
  echo "${C_RED}Error:${C_RESET} $1" >&2
  exit 1
}

# --- Main Functions ---

# Check for all required dependencies before starting
check_prerequisites() {
  info "Checking prerequisites..."

  if [[ "$(uname)" != "Darwin" ]]; then
    error "This script is intended for macOS only."
  fi

  if ! command -v brew &>/dev/null; then
    error "Homebrew is not installed. Please install it from https://brew.sh/ja/"
  fi

  if ! command -v git &>/dev/null; then
    error "Git is not installed. Please install it (e.g., via Homebrew: brew install git)."
  fi

  if [[ -z "$ZSH_VERSION" ]]; then
    warn "Current shell is not Zsh. This script configures Zsh."
  fi

  success "All prerequisites are met."
}

# Install iTerm2 using Homebrew
install_iterm2() {
  info "Checking iTerm2 installation..."
  if brew list --cask iterm2 &>/dev/null; then
    success "iTerm2 is already installed."
  else
    info "Installing iTerm2..."
    brew install --cask iterm2
    success "iTerm2 has been installed."
  fi
}

# Download and prompt user to apply the Iceberg color theme
install_iceberg_theme() {
  info "Setting up Iceberg iTerm2 theme..."
  info "Downloading Iceberg theme to $ICEBERG_THEME_PATH..."
  
  if curl -fsSL -o "$ICEBERG_THEME_PATH" "$ICEBERG_THEME_URL"; then
    success "Theme downloaded."
    open "$ICEBERG_THEME_PATH"
    info "A file has been opened to register the color theme."
    warn "Manual action required: Apply the 'Iceberg' theme in iTerm2 settings:"
    echo "  iTerm2 -> Preferences -> Profiles -> Colors -> Color Presets... -> Select 'Iceberg'"
  else
    error "Failed to download Iceberg theme."
  fi
}

# Clone Prezto repo and create symlinks for its configuration files
install_prezto() {
  info "Checking Prezto installation..."
  if [[ -d "$ZPREZTO_DIR" ]]; then
    success "Prezto is already installed at $ZPREZTO_DIR."
  else
    info "Installing Prezto..."
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "$ZPREZTO_DIR"

    info "Creating Prezto configuration file symlinks..."
    setopt EXTENDED_GLOB
    for rcfile in "$ZPREZTO_DIR"/runcoms/^README.md(.N); do
      local target_file="${ZDOTDIR:-$HOME}/.${rcfile:t}"
      if [[ -f "$target_file" && ! -L "$target_file" ]]; then
        mv "$target_file" "${target_file}.pre-prezto-backup"
        info "Backed up existing $target_file to ${target_file}.pre-prezto-backup"
      fi
      ln -s "$rcfile" "$target_file"
    done
    success "Prezto has been installed."
  fi
}

# Modify .zpreztorc to set the theme and add modules
configure_prezto() {
  info "Configuring Prezto settings in $ZPREZTORC_PATH..."

  if [[ ! -f "$ZPREZTORC_PATH" ]]; then
    error "$ZPREZTORC_PATH not found. Prezto installation may have failed."
  fi

  # Set prompt theme to 'pure'
  info "Setting prompt theme to 'pure'..."
  if grep -q "zstyle ':prezto:module:prompt' theme 'pure'" "$ZPREZTORC_PATH"; then
    success "Prompt theme is already set to 'pure'."
  else
    sed -i.bak "s|zstyle ':prezto:module:prompt' theme 'sorin'|zstyle ':prezto:module:prompt' theme 'pure'|" "$ZPREZTORC_PATH"
    rm "${ZPREZTORC_PATH}.bak"
    success "Prompt theme has been set to 'pure'."
  fi

  # Add syntax-highlighting and autosuggestions modules
  info "Enabling syntax-highlighting and autosuggestions modules..."
  if grep -q "pmodule.*syntax-highlighting" "$ZPREZTORC_PATH"; then
    success "Syntax highlighting and autosuggestions modules are already enabled."
  else
    local temp_file=$(mktemp)
    # Use awk to insert modules after the pmodule list definition line
    awk '
      /zstyle ':prezto:load' pmodule/ {
        print;
        print "  'syntax-highlighting' \\n";
        print "  'autosuggestions' \\n";
        next
      }
      { print }
    ' "$ZPREZTORC_PATH" > "$temp_file" && mv "$temp_file" "$ZPREZTORC_PATH"
    success "Enabled syntax-highlighting and autosuggestions modules."
  fi
}

# --- Main Execution ---
main() {
  check_prerequisites
  install_iterm2
  install_iceberg_theme
  install_prezto
  configure_prezto

  echo
  info "--------------------------------------------------"
  success "Setup complete!"
  info "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
  info "--------------------------------------------------"
}

# Run the main function
main