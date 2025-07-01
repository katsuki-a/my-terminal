# iTerm2 + zsh + Prezto Environment Setup

This repository provides a script to automate the setup of a modern and efficient terminal environment on macOS.

## Features

- **iTerm2**: A feature-rich replacement for the standard macOS terminal.
- **zsh**: A powerful shell, the default in modern macOS versions.
- **Prezto**: A configuration framework for zsh that makes it faster and easier to use.
- **Pure**: A clean, beautiful, and minimal prompt for zsh.
- **Syntax Highlighting**: Highlights commands in the shell, making them easier to read and debug.
- **Autosuggestions**: Suggests commands as you type based on your history.
- **Automated & Idempotent Script**: The setup script is safe to run multiple times, automatically checking for existing installations and configurations.

## Prerequisites

Before running the setup script, please ensure you have the following installed:

- **macOS**: The script is designed specifically for macOS.
- **Homebrew**: The missing package manager for macOS. If not installed, get it from [https://brew.sh](https://brew.sh).
- **Git**: A version control system. Can be installed via `brew install git`.
- **zsh**: Should be your default shell (default on macOS Catalina and later).

## Automatic Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/my-terminal.git
    cd my-terminal
    ```

2.  **Make the script executable:**
    ```bash
    chmod +x setup.sh
    ```

3.  **Run the script:**
    ```bash
    ./setup.sh
    ```

4.  **Follow the on-screen instructions.** The script will inform you of its progress. A manual step is required to apply the iTerm2 color theme.

5.  **Restart your terminal** or run `source ~/.zshrc` to apply all changes.

## What the Script Automates

The `setup.sh` script performs the following steps:

1.  **Prerequisite Check**: Verifies that Homebrew, Git, and zsh are available.
2.  **Install iTerm2**: Installs iTerm2 via Homebrew if it's not already present.
3.  **Install Iceberg Theme**:
    - Downloads the [Iceberg for iTerm2](https://github.com/Arc0re/Iceberg-iTerm2) theme.
    - Opens the theme file, which registers it in iTerm2.
    - **You must manually apply the theme**: `iTerm2 -> Preferences -> Profiles -> Colors -> Color Presets... -> Select 'Iceberg'`.
4.  **Install Prezto**:
    - Clones the [Prezto repository](https://github.com/sorin-ionescu/prezto).
    - Backs up any existing `~/.zsh*` configuration files.
    - Creates symlinks for the necessary Prezto configuration files.
5.  **Configure Prezto**:
    - Modifies the `~/.zpreztorc` file to:
      - Set the prompt theme to `pure`.
      - Enable the `syntax-highlighting` and `autosuggestions` modules for a better interactive experience.