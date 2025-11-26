# ============================================================================
# CRACKED TERMINAL SETUP - .zshrc
# ============================================================================
# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# ============================================================================
# OH MY ZSH CONFIGURATION
# ============================================================================

# Theme - disabled in favor of Starship prompt
ZSH_THEME=""

# Plugins
# Note: fzf-tab must be loaded BEFORE zsh-autosuggestions and zsh-syntax-highlighting
# Note: zsh-syntax-highlighting must be LAST
plugins=(
    git
    colored-man-pages
    extract
    web-search
    fzf-tab
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Editor
export EDITOR="code --wait"
export VISUAL="code --wait"

# Language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Node.js
export NODE_OPTIONS="--max-old-space-size=8192"

# History configuration
export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE=~/.zsh_history

# ============================================================================
# TOOL INITIALIZATIONS
# ============================================================================

# Starship prompt - must be after Oh My Zsh
eval "$(starship init zsh)"

# Zoxide - smarter cd (replaces z plugin functionality)
eval "$(zoxide init zsh --cmd cd)"

# fzf - fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf configuration
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!node_modules/*" --glob "!.next/*" --glob "!dist/*"'
export FZF_DEFAULT_OPTS='
  --height 60%
  --layout=reverse
  --border rounded
  --preview-window=right:60%:wrap
  --bind=ctrl-d:preview-page-down
  --bind=ctrl-u:preview-page-up
  --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796
  --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6
  --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796
'

# fzf with preview for Ctrl+T (file search)
export FZF_CTRL_T_OPTS="
  --preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || cat {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"

# fzf for Ctrl+R (history search)
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command to clipboard'
"

# fzf for Alt+C (cd into directory)
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --color=always --icons {} | head -200'
"

# ============================================================================
# ALIASES - FILE OPERATIONS
# ============================================================================

# eza - modern ls replacement
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias la='eza -a --icons --group-directories-first'
alias l='eza -l --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons --group-directories-first'
alias lta='eza --tree --level=3 --icons --group-directories-first -a'
alias ltg='eza --tree --level=2 --icons --group-directories-first --git-ignore'

# bat - syntax-highlighted cat
alias cat='bat --paging=never'
alias catp='bat --plain'  # No line numbers, no git
alias catl='bat'          # With pager (less-like)

# ripgrep - fast grep
alias grep='rg'
alias rgi='rg -i'         # Case insensitive
alias rgf='rg --files-with-matches'  # Only show filenames
alias rgh='rg --hidden'   # Include hidden files

# ============================================================================
# ALIASES - GIT (preserved from original)
# ============================================================================

alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -20'
alias gla='git log --oneline --graph --decorate --all'
alias gb='git branch'
alias gba='git branch -a'
alias gst='git stash'
alias gstp='git stash pop'
alias gf='git fetch --all --prune'
alias grb='git rebase'
alias grbi='git rebase -i'
alias gcp='git cherry-pick'
alias grs='git reset'
alias grsh='git reset --hard'

# ============================================================================
# ALIASES - NAVIGATION
# ============================================================================

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# Quick access directories (customize as needed)
alias c='cd ~/code'           # Use 'c' to go to code directory
alias proj='cd ~/code'        # Alternative alias for projects
alias docs='cd ~/Documents'
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'

# ============================================================================
# ALIASES - SYSTEM
# ============================================================================

alias reload='source ~/.zshrc && echo "✓ zshrc reloaded"'
alias zshconfig='$EDITOR ~/.zshrc'
alias starconfig='$EDITOR ~/.config/starship.toml'
alias tmuxconfig='$EDITOR ~/.tmux.conf'

# Disk usage
alias df='df -h'
alias du='du -h'
alias dud='du -d 1 -h'
alias duf='du -sh *'

# Process management
alias psg='ps aux | rg'
alias top='top -o cpu'

# Network
alias ip='curl -s ifconfig.me && echo'
alias localip='ipconfig getifaddr en0'
alias ports='lsof -i -P -n | grep LISTEN'

# Clipboard
alias pbp='pbpaste'
alias pbc='pbcopy'

# ============================================================================
# ALIASES - DEVELOPMENT
# ============================================================================

# Node/npm
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nr='npm run'
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'
alias nrl='npm run lint'

# pnpm
alias pn='pnpm'
alias pni='pnpm install'
alias pna='pnpm add'
alias pnad='pnpm add -D'
alias pnr='pnpm run'
alias pnrd='pnpm run dev'
alias pnrb='pnpm run build'

# Python
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# Docker
alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimg='docker images'
alias dprune='docker system prune -af'

# ============================================================================
# ALIASES - TMUX
# ============================================================================

alias t='tmux'
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'
alias tka='tmux kill-server'

# ============================================================================
# FUNCTIONS (preserved and enhanced)
# ============================================================================

# Kill processes on a specific port (preserved from original)
killdev() {
    if [ -z "$1" ]; then
        echo "Usage: killdev <port>"
        return 1
    fi
    lsof -ti:$1 | xargs kill -9 2>/dev/null && echo "✓ Killed processes on port $1" || echo "No process found on port $1"
}

# Start development server (preserved from original - customize as needed)
startdev() {
    echo "Starting development server..."
    npm run dev
}

# Convert markdown to PDF (preserved from original)
md2pdf() {
    if [ -z "$1" ]; then
        echo "Usage: md2pdf <input.md> [output.pdf]"
        return 1
    fi
    local input="$1"
    local output="${2:-${input%.md}.pdf}"
    pandoc "$input" -o "$output" && echo "✓ Created $output"
}

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# fzf-powered git branch checkout
fco() {
    local branches branch
    branches=$(git branch --all | grep -v HEAD) &&
    branch=$(echo "$branches" | fzf --height 40% --reverse) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fzf-powered git log browser
flog() {
    git log --oneline --graph --color=always |
    fzf --ansi --no-sort --reverse --tiebreak=index \
        --preview 'git show --color=always $(echo {} | grep -o "[a-f0-9]\{7\}" | head -1)' \
        --bind 'enter:execute(git show --color=always $(echo {} | grep -o "[a-f0-9]\{7\}" | head -1) | less -R)'
}

# fzf-powered file opener
fo() {
    local file
    file=$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {}') &&
    $EDITOR "$file"
}

# fzf-powered directory navigation
fd() {
    local dir
    dir=$(find ${1:-.} -type d 2>/dev/null | fzf --preview 'eza --tree --level=1 --icons {}') &&
    cd "$dir"
}

# Quick HTTP server
serve() {
    local port="${1:-8000}"
    echo "Starting HTTP server on http://localhost:$port"
    python3 -m http.server "$port"
}

# Weather in terminal
weather() {
    curl -s "wttr.in/${1:-Stockholm}?format=3"
}

# Cheat sheet
cheat() {
    curl -s "cheat.sh/$1"
}

# ============================================================================
# FZF-TAB CONFIGURATION
# ============================================================================

# Disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false

# Set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'

# Set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'

# Preview file content with bat
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 $realpath 2>/dev/null || eza -la --icons $realpath 2>/dev/null || echo $realpath'

# Switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# Use tmux popup for fzf-tab (if in tmux)
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# ============================================================================
# ZSH OPTIONS
# ============================================================================

# History
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file
setopt SHARE_HISTORY             # Share history between all sessions

# Directory
setopt AUTO_CD                   # Auto cd when typing directory name
setopt AUTO_PUSHD                # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS         # Do not store duplicates in the stack
setopt PUSHD_SILENT              # Do not print the directory stack after pushd or popd

# Completion
setopt COMPLETE_IN_WORD          # Complete from both ends of a word
setopt ALWAYS_TO_END             # Move cursor to the end of a completed word
setopt AUTO_MENU                 # Show completion menu on a successive tab press
setopt AUTO_LIST                 # Automatically list choices on ambiguous completion
setopt AUTO_PARAM_SLASH          # If completed parameter is a directory, add a trailing slash

# ============================================================================
# AUTOSUGGESTIONS CONFIGURATION
# ============================================================================

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6e738d"

# ============================================================================
# PATH ADDITIONS (if needed)
# ============================================================================

# Add local bin
export PATH="$HOME/.local/bin:$PATH"

# Add Homebrew sbin
export PATH="/opt/homebrew/sbin:$PATH"

# ============================================================================
# FINAL MESSAGE
# ============================================================================

# Uncomment to show a welcome message
# echo "🚀 Terminal ready | $(date '+%H:%M') | $(weather)"
