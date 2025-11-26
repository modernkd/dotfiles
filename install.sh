#!/bin/bash

# ============================================================================
# DOTFILES INSTALLATION SCRIPT
# ============================================================================
# This script sets up a cracked terminal environment on macOS
# It is idempotent - safe to run multiple times
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

# Backup existing file if it exists and is not a symlink
backup_file() {
    local file="$1"
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$file" "$backup"
        print_warning "Backed up existing $file to $backup"
    fi
}

# Create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Remove existing symlink if it points somewhere else
    if [ -L "$target" ]; then
        local current_link=$(readlink "$target")
        if [ "$current_link" = "$source" ]; then
            print_success "Symlink already exists: $target -> $source"
            return
        else
            rm "$target"
            print_info "Removed old symlink: $target -> $current_link"
        fi
    fi
    
    # Backup existing file
    backup_file "$target"
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"
    
    # Create symlink
    ln -s "$source" "$target"
    print_success "Created symlink: $target -> $source"
}

# ============================================================================
# SYSTEM CHECK
# ============================================================================

print_header "Checking System Requirements"

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only"
    exit 1
fi
print_success "Running on macOS"

# Check for Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
    print_info "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Please wait for Xcode Command Line Tools to install, then run this script again."
    exit 0
fi
print_success "Xcode Command Line Tools installed"

# ============================================================================
# HOMEBREW
# ============================================================================

print_header "Setting Up Homebrew"

if ! command -v brew &>/dev/null; then
    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for this session
    eval "$(/opt/homebrew/bin/brew shellenv)"
    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"
fi

# Update Homebrew
print_info "Updating Homebrew..."
brew update
print_success "Homebrew updated"

# ============================================================================
# INSTALL PACKAGES
# ============================================================================

print_header "Installing Packages via Homebrew"

# Run the brew installation script
if [ -f "$DOTFILES_DIR/scripts/brew.sh" ]; then
    source "$DOTFILES_DIR/scripts/brew.sh"
else
    print_warning "brew.sh not found, installing packages directly..."
    
    # Core CLI tools
    PACKAGES=(
        fzf           # Fuzzy finder
        ripgrep       # Fast grep
        bat           # Better cat
        eza           # Better ls
        zoxide        # Smarter cd
        starship      # Prompt
        tmux          # Terminal multiplexer
    )
    
    for package in "${PACKAGES[@]}"; do
        if brew list "$package" &>/dev/null; then
            print_success "$package already installed"
        else
            print_info "Installing $package..."
            brew install "$package"
            print_success "$package installed"
        fi
    done
    
    # Install Nerd Font
    if brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
        print_success "JetBrains Mono Nerd Font already installed"
    else
        print_info "Installing JetBrains Mono Nerd Font..."
        brew install --cask font-jetbrains-mono-nerd-font
        print_success "JetBrains Mono Nerd Font installed"
    fi
fi

# ============================================================================
# FZF SETUP
# ============================================================================

print_header "Setting Up fzf"

if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
    # Install fzf key bindings and completion (idempotent)
    $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
    print_success "fzf key bindings and completion configured"
else
    print_warning "fzf install script not found"
fi

# ============================================================================
# OH MY ZSH
# ============================================================================

print_header "Setting Up Oh My Zsh"

if [ -d "$HOME/.oh-my-zsh" ]; then
    print_success "Oh My Zsh already installed"
else
    print_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed"
fi

# ============================================================================
# ZSH PLUGINS
# ============================================================================

print_header "Installing Zsh Plugins"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions
if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    print_success "zsh-autosuggestions already installed"
else
    print_info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    print_success "zsh-autosuggestions installed"
fi

# zsh-syntax-highlighting
if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    print_success "zsh-syntax-highlighting already installed"
else
    print_info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    print_success "zsh-syntax-highlighting installed"
fi

# fzf-tab
if [ -d "$ZSH_CUSTOM/plugins/fzf-tab" ]; then
    print_success "fzf-tab already installed"
else
    print_info "Installing fzf-tab..."
    git clone https://github.com/Aloxaf/fzf-tab "$ZSH_CUSTOM/plugins/fzf-tab"
    print_success "fzf-tab installed"
fi

# ============================================================================
# CREATE SYMLINKS
# ============================================================================

print_header "Creating Symlinks"

# .zshrc
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# starship.toml
mkdir -p "$HOME/.config"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

# .tmux.conf
create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# .gitconfig (only if it doesn't exist - user should customize)
if [ ! -e "$HOME/.gitconfig" ]; then
    create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
else
    print_warning ".gitconfig already exists - not overwriting (customize manually if needed)"
fi

# ============================================================================
# MACOS SETTINGS (optional)
# ============================================================================

if [ -f "$DOTFILES_DIR/scripts/macos.sh" ]; then
    read -p "Do you want to apply macOS settings? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_header "Applying macOS Settings"
        source "$DOTFILES_DIR/scripts/macos.sh"
    fi
fi

# ============================================================================
# FINAL STEPS
# ============================================================================

print_header "Installation Complete! 🚀"

echo -e "${GREEN}Your cracked terminal setup is ready!${NC}\n"
echo "Next steps:"
echo "  1. Set your terminal font to 'JetBrainsMono Nerd Font'"
echo "  2. Restart your terminal or run: source ~/.zshrc"
echo "  3. Update git config with your name and email:"
echo "     git config --global user.name \"Your Name\""
echo "     git config --global user.email \"your@email.com\""
echo ""
echo "Enjoy your new terminal! 🎉"
