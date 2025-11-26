#!/bin/bash

# ============================================================================
# HOMEBREW PACKAGE INSTALLATION
# ============================================================================
# This script installs all required Homebrew packages for the terminal setup
# ============================================================================

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# ============================================================================
# CLI TOOLS
# ============================================================================

print_info "Installing CLI tools..."

# Core tools for the cracked terminal setup
PACKAGES=(
    fzf           # Fuzzy finder - interactive filtering
    ripgrep       # Fast grep alternative (rg)
    bat           # Better cat with syntax highlighting
    eza           # Modern ls replacement
    zoxide        # Smarter cd command
    starship      # Cross-shell prompt
    tmux          # Terminal multiplexer
)

# Optional but recommended tools
OPTIONAL_PACKAGES=(
    fd            # Fast find alternative
    jq            # JSON processor
    htop          # Better top
    tldr          # Simplified man pages
    tree          # Directory tree viewer
    wget          # File downloader
    gh            # GitHub CLI
    lazygit       # Terminal UI for git
)

# Install core packages
for package in "${PACKAGES[@]}"; do
    if brew list "$package" &>/dev/null; then
        print_success "$package already installed"
    else
        print_info "Installing $package..."
        brew install "$package"
        print_success "$package installed"
    fi
done

# Ask about optional packages
echo ""
read -p "Install optional packages (fd, jq, htop, tldr, tree, wget, gh, lazygit)? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    for package in "${OPTIONAL_PACKAGES[@]}"; do
        if brew list "$package" &>/dev/null; then
            print_success "$package already installed"
        else
            print_info "Installing $package..."
            brew install "$package"
            print_success "$package installed"
        fi
    done
fi

# ============================================================================
# FONTS
# ============================================================================

print_info "Installing fonts..."

# Nerd Fonts (required for icons in terminal)
FONTS=(
    font-jetbrains-mono-nerd-font    # Primary recommended font
    # font-fira-code-nerd-font       # Alternative
    # font-hack-nerd-font            # Alternative
    # font-meslo-lg-nerd-font        # Alternative (used by Powerlevel10k)
)

for font in "${FONTS[@]}"; do
    if brew list --cask "$font" &>/dev/null; then
        print_success "$font already installed"
    else
        print_info "Installing $font..."
        brew install --cask "$font"
        print_success "$font installed"
    fi
done

# ============================================================================
# FZF SETUP
# ============================================================================

print_info "Configuring fzf..."

# Install fzf key bindings and fuzzy completion
# --key-bindings: Enable CTRL-T, CTRL-R, ALT-C
# --completion: Enable fuzzy completion
# --no-update-rc: Don't modify shell config (we handle this in .zshrc)
# --no-bash --no-fish: Only install for zsh
if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
    $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
    print_success "fzf key bindings and completion configured"
else
    print_warning "fzf install script not found"
fi

# ============================================================================
# OPTIONAL: CASK APPLICATIONS
# ============================================================================

# Map cask names to their .app bundle names in /Applications
# This allows idempotent installation even if app was installed manually
get_app_name() {
    case "$1" in
        iterm2) echo "iTerm.app" ;;
        visual-studio-code) echo "Visual Studio Code.app" ;;
        *) echo "" ;;
    esac
}

# Check if app is already installed (via Homebrew OR manually)
is_app_installed() {
    local cask="$1"
    local app_name=$(get_app_name "$cask")
    
    # First check if Homebrew knows about it
    if brew list --cask "$cask" &>/dev/null; then
        return 0
    fi
    
    # Then check if the app exists in /Applications (manual install)
    if [ -n "$app_name" ] && [ -d "/Applications/$app_name" ]; then
        return 0
    fi
    
    return 1
}

echo ""
read -p "Install recommended terminal apps (iTerm2, Visual Studio Code)? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    CASKS=(
        iterm2           # Better terminal emulator
        visual-studio-code  # Code editor
    )
    
    for cask in "${CASKS[@]}"; do
        if is_app_installed "$cask"; then
            print_success "$cask already installed"
        else
            print_info "Installing $cask..."
            brew install --cask "$cask"
            print_success "$cask installed"
        fi
    done
fi

# ============================================================================
# CLEANUP
# ============================================================================

print_info "Cleaning up..."
brew cleanup
print_success "Homebrew cleanup complete"

echo ""
print_success "All packages installed successfully!"
