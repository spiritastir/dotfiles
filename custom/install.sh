#!/bin/sh

#
# Install Homebrew
#
echo "\nInstalling Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "Homebrew installation complete."

#
# Install Homebrew packages (formulas)
#
echo "\nInstalling Homebrew formulas..."
brew install \
    coreutils \
    diffutils \
    findutils \
    git \
    nvm \
    pnpm \
    starship \
    zimfw
echo "Homebrew formulas installation complete."

#
# Install Homebrew packages (casks)
#
echo "\nInstalling Homebrew casks..."
brew install --cask \
    1password \
    1password-cli \
    alfred \
    betterzip \
    cursor \
    dropbox \
    google-chrome \
    google-drive \
    iterm2 \
    itermai \
    logi-options+ \
    logitech-g-hub \
    logitune \
    nordlocker \
    nordvpn \
    onedrive \
    rectangle-pro \
    slack
    # cheatsheet \
    # ddpm \
    # rectangle \
    # visual-studio-code \

# Deprecated
# brew install --cask \
#   spectacle
echo "Homebrew casks installation complete."

#
# Configure Git credentials
#
echo "\nConfiguring Git credentials..."
if [ -z "$(git config --global user.name)" ]; then
    read -p "Enter your Git username: " GIT_NAME
    if [ -n "$GIT_NAME" ]; then
        git config --global user.name "$GIT_NAME"
    fi
fi

if [ -z "$(git config --global user.email)" ]; then
    read -p "Enter your Git email: " GIT_EMAIL
    if [ -n "$GIT_EMAIL" ]; then
        git config --global user.email "$GIT_EMAIL"
    fi
fi

echo "\nGit configuration:"
echo "  Name: $(git config --global user.name)"
echo "  Email: $(git config --global user.email)"
echo "Git configuration complete."

DOTFILES_DIR="$HOME/.config/zsh"

#
# Backup existing dotfiles
#
echo "\nBacking up existing dotfiles..."
BACKUP_DIR="$DOTFILES_DIR/bak"
mkdir -p "$BACKUP_DIR"

BACKUP_COUNT=0
if [ -f "$HOME/.zprofile" ]; then
    mv "$HOME/.zprofile" "$BACKUP_DIR/.zprofile.bak"
    echo "  Backed up: ~/.zprofile"
    BACKUP_COUNT=$((BACKUP_COUNT + 1))
fi

if [ -f "$HOME/.zsh-history" ]; then
    mv "$HOME/.zsh-history" "$BACKUP_DIR/.zsh-history.bak"
    echo "  Backed up: ~/.zsh-history"
    BACKUP_COUNT=$((BACKUP_COUNT + 1))
fi

if [ -f "$HOME/.zsh-sessions" ]; then
    mv "$HOME/.zsh-sessions" "$BACKUP_DIR/.zsh-sessions.bak"
    echo "  Backed up: ~/.zsh-sessions"
    BACKUP_COUNT=$((BACKUP_COUNT + 1))
fi

if [ $BACKUP_COUNT -eq 0 ]; then
    echo "  No existing dotfiles found to backup."
else
    echo "Backup complete. $BACKUP_COUNT file(s) backed up to $BACKUP_DIR/"
fi

#
# Install custom dotfiles
#
echo "\nInstalling custom dotfiles..."

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Copy all files from custom/.config/zsh to ~/.config/zsh (including dotfiles)
if [ -d "$SCRIPT_DIR/.config/zsh" ]; then
    cp -r "$SCRIPT_DIR/.config/zsh"/. "$DOTFILES_DIR/"
    echo "  Installed zsh configuration files to ~/.config/zsh/"
else
    echo "  Warning: custom/.config/zsh directory not found."
fi

# Copy custom/.zshenv to ~
if [ -f "$SCRIPT_DIR/.zshenv" ]; then
    cp "$SCRIPT_DIR/.zshenv" "$HOME/.zshenv"
    echo "  Installed ~/.zshenv"
else
    echo "  Warning: custom/.zshenv not found."
fi

echo "\nDotfiles installation complete."
echo "Installation finished successfully!"
