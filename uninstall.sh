#!/bin/bash

# ============================================================================
# DOTFILES UNINSTALLATION SCRIPT
# ============================================================================
# This script removes the dotfiles setup and optionally uninstalls packages
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

print_header() {
    echo -e "\n${BLUE}===========================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}===========================================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Remove symlink and restore backup if exists
remove_symlink() {
    local target="$1"
    local source="$2"
    
    if [ -L "$target" ]; then
        local current_link=$(readlink "$target")
        if [ "$current_link" = "$source" ]; then
            rm "$target"
            print_success "Removed symlink: $target"
            
            # Check for backup and offer to restore
            local latest_backup=$(ls -t "${target}.backup."* 2>/dev/null | head -1)
            if [ -n "$latest_backup" ]; then
                read -p "  Restore backup $latest_backup? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    mv "$latest_backup" "$target"
                    print_success "Restored backup to $target"
                fi
            fi
        else
            print_warning "Symlink $target points elsewhere, skipping"
        fi
    elif [ -e "$target" ]; then
        print_warning "$target is not a symlink, skipping"
    else
        print_info "$target does not exist, skipping"
    fi
}

# ============================================================================
# CONFIRMATION
# ============================================================================

print_header "Dotfiles Uninstallation"

echo -e "${YELLOW}This script will:${NC}"
echo "  1. Remove symlinks to dotfiles"
echo "  2. Optionally restore backup files"
echo "  3. Optionally remove installed packages"
echo ""
read -p "Are you sure you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

# ============================================================================
# REMOVE SYMLINKS
# ============================================================================

print_header "Removing Symlinks"

# .zshrc
remove_symlink "$HOME/.zshrc" "$DOTFILES_DIR/zsh/.zshrc"

# starship.toml
remove_symlink "$HOME/.config/starship.toml" "$DOTFILES_DIR/starship/starship.toml"

# .tmux.conf
remove_symlink "$HOME/.tmux.conf" "$DOTFILES_DIR/tmux/.tmux.conf"

# .gitconfig
remove_symlink "$HOME/.gitconfig" "$DOTFILES_DIR/git/.gitconfig"

# ============================================================================
# REMOVE ZSH PLUGINS (optional)
# ============================================================================

print_header "Zsh Plugins"

read -p "Remove zsh plugins (zsh-autosuggestions, zsh-syntax-highlighting, fzf-tab)? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        rm -rf "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        print_success "Removed zsh-autosuggestions"
    fi
    
    if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        rm -rf "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        print_success "Removed zsh-syntax-highlighting"
    fi
    
    if [ -d "$ZSH_CUSTOM/plugins/fzf-tab" ]; then
        rm -rf "$ZSH_CUSTOM/plugins/fzf-tab"
        print_success "Removed fzf-tab"
    fi
else
    print_info "Keeping zsh plugins"
fi

# ============================================================================
# REMOVE OH MY ZSH (optional)
# ============================================================================

print_header "Oh My Zsh"

read -p "Remove Oh My Zsh? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -d "$HOME/.oh-my-zsh" ]; then
        rm -rf "$HOME/.oh-my-zsh"
        print_success "Removed Oh My Zsh"
    else
        print_info "Oh My Zsh not found"
    fi
else
    print_info "Keeping Oh My Zsh"
fi

# ============================================================================
# REMOVE HOMEBREW PACKAGES (optional)
# ============================================================================

print_header "Homebrew Packages"

read -p "Remove installed Homebrew packages (fzf, ripgrep, bat, eza, zoxide, starship, tmux)? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    PACKAGES=(
        fzf
        ripgrep
        bat
        eza
        zoxide
        starship
        tmux
    )
    
    for package in "${PACKAGES[@]}"; do
        if brew list "$package" &>/dev/null; then
            brew uninstall "$package"
            print_success "Uninstalled $package"
        else
            print_info "$package not installed"
        fi
    done
    
    # Remove Nerd Font
    read -p "Remove JetBrains Mono Nerd Font? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
            brew uninstall --cask font-jetbrains-mono-nerd-font
            print_success "Uninstalled JetBrains Mono Nerd Font"
        else
            print_info "JetBrains Mono Nerd Font not installed"
        fi
    fi
else
    print_info "Keeping Homebrew packages"
fi

# ============================================================================
# CLEANUP FZF
# ============================================================================

if [ -f "$HOME/.fzf.zsh" ]; then
    read -p "Remove fzf configuration (~/.fzf.zsh)? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f "$HOME/.fzf.zsh"
        rm -f "$HOME/.fzf.bash"
        print_success "Removed fzf configuration files"
    fi
fi

# ============================================================================
# DONE
# ============================================================================

print_header "Uninstallation Complete"

echo -e "${GREEN}Dotfiles have been uninstalled.${NC}\n"
echo "Note: You may need to:"
echo "  1. Restart your terminal"
echo "  2. Set up a new shell configuration"
echo "  3. Change your default shell if needed: chsh -s /bin/bash"
echo ""
echo "The dotfiles repository at $DOTFILES_DIR has NOT been deleted."
echo "Delete it manually if you no longer need it."
