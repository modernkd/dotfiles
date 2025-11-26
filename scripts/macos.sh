#!/bin/bash

# ============================================================================
# MACOS SETTINGS
# ============================================================================
# This script configures macOS settings for a better developer experience
# Run with: ./macos.sh
# Some changes require a logout/restart to take effect
# ============================================================================

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_info "Configuring macOS settings..."

# Close any open System Preferences panes to prevent them from overriding settings
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ============================================================================
# GENERAL UI/UX
# ============================================================================

print_info "Configuring General UI/UX..."

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "
print_success "Disabled boot sound"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
print_success "Expanded save panel by default"

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
print_success "Expanded print panel by default"

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
print_success "Save to disk by default"

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
print_success "Disabled automatic capitalization"

# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
print_success "Disabled smart dashes"

# Disable automatic period substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
print_success "Disabled automatic period substitution"

# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
print_success "Disabled smart quotes"

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
print_success "Disabled auto-correct"

# ============================================================================
# KEYBOARD
# ============================================================================

print_info "Configuring Keyboard..."

# Enable full keyboard access for all controls (Tab in dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
print_success "Enabled full keyboard access"

# Set a fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
print_success "Set fast keyboard repeat rate"

# ============================================================================
# TRACKPAD
# ============================================================================

print_info "Configuring Trackpad..."

# Enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
print_success "Enabled tap to click"

# ============================================================================
# FINDER
# ============================================================================

print_info "Configuring Finder..."

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true
print_success "Show hidden files"

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
print_success "Show all filename extensions"

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true
print_success "Show status bar"

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true
print_success "Show path bar"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true
print_success "Keep folders on top"

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
print_success "Search current folder by default"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
print_success "Disabled extension change warning"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
print_success "Disabled .DS_Store on network/USB volumes"

# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
print_success "Set list view as default"

# Show the ~/Library folder
chflags nohidden ~/Library
print_success "Show ~/Library folder"

# Show the /Volumes folder
sudo chflags nohidden /Volumes
print_success "Show /Volumes folder"

# ============================================================================
# DOCK
# ============================================================================

print_info "Configuring Dock..."

# Set the icon size of Dock items
defaults write com.apple.dock tilesize -int 48
print_success "Set Dock icon size to 48"

# Minimize windows into their application's icon
defaults write com.apple.dock minimize-to-application -bool true
print_success "Minimize to application icon"

# Show indicator lights for open applications
defaults write com.apple.dock show-process-indicators -bool true
print_success "Show indicator lights"

# Don't animate opening applications
defaults write com.apple.dock launchanim -bool false
print_success "Disabled opening animation"

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1
print_success "Sped up Mission Control"

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false
print_success "Disabled auto-rearrange Spaces"

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true
print_success "Enabled Dock auto-hide"

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
print_success "Removed Dock auto-hide delay"

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true
print_success "Translucent hidden app icons"

# ============================================================================
# SCREENSHOTS
# ============================================================================

print_info "Configuring Screenshots..."

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"
print_success "Save screenshots to Desktop"

# Save screenshots in PNG format
defaults write com.apple.screencapture type -string "png"
print_success "Save screenshots as PNG"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true
print_success "Disabled screenshot shadow"

# ============================================================================
# TERMINAL
# ============================================================================

print_info "Configuring Terminal..."

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4
print_success "Set Terminal to UTF-8"

# Enable Secure Keyboard Entry in Terminal.app
defaults write com.apple.terminal SecureKeyboardEntry -bool true
print_success "Enabled Secure Keyboard Entry"

# ============================================================================
# ACTIVITY MONITOR
# ============================================================================

print_info "Configuring Activity Monitor..."

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
print_success "Show main window on launch"

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0
print_success "Show all processes"

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0
print_success "Sort by CPU usage"

# ============================================================================
# RESTART AFFECTED APPLICATIONS
# ============================================================================

print_info "Restarting affected applications..."

for app in "Activity Monitor" "Dock" "Finder" "SystemUIServer" "Terminal"; do
    killall "${app}" &> /dev/null || true
done

print_success "Done! Some changes require a logout/restart to take effect."
