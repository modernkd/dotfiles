# 🚀 Dotfiles - Cracked Terminal Setup

A modern, powerful terminal configuration for macOS featuring Oh My Zsh, Starship prompt, tmux, and a suite of CLI tools that make your terminal experience blazingly fast and beautiful.

![Terminal Preview](https://via.placeholder.com/800x400?text=Your+Cracked+Terminal)

## ✨ What's Included

### Shell Configuration (`.zshrc`)
- **Oh My Zsh** - Framework for managing Zsh configuration
- **Starship** - Fast, customizable, cross-shell prompt
- **Zoxide** - Smarter `cd` command that learns your habits
- **fzf** - Fuzzy finder for files, history, and more
- **fzf-tab** - Replace Zsh's default completion with fzf
- **zsh-autosuggestions** - Fish-like autosuggestions
- **zsh-syntax-highlighting** - Syntax highlighting for commands

### CLI Tools
| Tool | Replaces | Description |
|------|----------|-------------|
| `eza` | `ls` | Modern ls with icons and git integration |
| `bat` | `cat` | Syntax-highlighted cat with line numbers |
| `ripgrep` | `grep` | Blazingly fast recursive search |
| `fzf` | - | Fuzzy finder for everything |
| `zoxide` | `cd` | Smarter directory navigation |

### Prompt (Starship)
- Git branch and status
- Node.js, Python, Rust, Go version display
- Command duration for long-running commands
- Current time
- Error status indicator

### Terminal Multiplexer (tmux)
- Prefix key: `Ctrl+a` (more ergonomic than `Ctrl+b`)
- Mouse support enabled
- Vim-style pane navigation
- Beautiful Catppuccin-inspired status bar
- Easy window/pane splitting with `|` and `-`

### Git Configuration
- Sensible defaults
- Useful aliases (`co`, `br`, `ci`, `st`, `lg`, etc.)
- Pull with rebase by default
- Auto-prune on fetch
- VS Code as default editor and merge tool

## 🚀 Quick Install

**One-liner installation:**

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/code/dotfiles && cd ~/code/dotfiles && chmod +x install.sh && ./install.sh
```

## 📦 Manual Installation

### Prerequisites
- macOS (this setup is designed for macOS)
- Git
- Terminal.app, iTerm2, or any modern terminal

### Step-by-Step

1. **Clone the repository:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/code/dotfiles
   cd ~/code/dotfiles
   ```

2. **Make scripts executable:**
   ```bash
   chmod +x install.sh uninstall.sh scripts/*.sh
   ```

3. **Run the installation script:**
   ```bash
   ./install.sh
   ```

4. **Set your terminal font:**
   - Open your terminal preferences
   - Set font to "JetBrainsMono Nerd Font" (installed by the script)
   - Recommended size: 13-14pt

5. **Configure git with your info:**
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your@email.com"
   ```

6. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

## 📁 Repository Structure

```
dotfiles/
├── README.md              # This file
├── install.sh             # Main installation script
├── uninstall.sh           # Removal script
├── zsh/
│   └── .zshrc             # Zsh configuration
├── starship/
│   └── starship.toml      # Starship prompt config
├── tmux/
│   └── .tmux.conf         # Tmux configuration
├── git/
│   └── .gitconfig         # Git configuration
└── scripts/
    ├── brew.sh            # Homebrew package installation
    └── macos.sh           # macOS system preferences
```

## ⌨️ Key Bindings & Aliases

### Zsh Aliases

#### File Operations
| Alias | Command | Description |
|-------|---------|-------------|
| `ls` | `eza --icons` | List with icons |
| `ll` | `eza -la --git` | Long list with git status |
| `lt` | `eza --tree` | Tree view |
| `cat` | `bat` | Syntax-highlighted output |
| `grep` | `rg` | Fast recursive search |

#### Git
| Alias | Command | Description |
|-------|---------|-------------|
| `gs` | `git status` | Status |
| `ga` | `git add` | Stage files |
| `gc` | `git commit` | Commit |
| `gp` | `git push` | Push |
| `gpl` | `git pull` | Pull |
| `gco` | `git checkout` | Checkout |
| `gcb` | `git checkout -b` | Create branch |
| `gl` | `git log --oneline` | Pretty log |
| `gd` | `git diff` | Diff |
| `gds` | `git diff --staged` | Staged diff |

#### Navigation
| Alias | Command | Description |
|-------|---------|-------------|
| `..` | `cd ..` | Up one directory |
| `...` | `cd ../..` | Up two directories |
| `code` | `cd ~/code` | Go to code directory |
| `docs` | `cd ~/Documents` | Go to Documents |

#### Development
| Alias | Command | Description |
|-------|---------|-------------|
| `nrd` | `npm run dev` | Start dev server |
| `nrb` | `npm run build` | Build project |
| `pnrd` | `pnpm run dev` | pnpm dev server |

### fzf Key Bindings
| Key | Action |
|-----|--------|
| `Ctrl+T` | Fuzzy find files |
| `Ctrl+R` | Fuzzy search history |
| `Alt+C` | Fuzzy cd into directory |

### tmux Key Bindings
| Key | Action |
|-----|--------|
| `Ctrl+a` | Prefix key |
| `Prefix + \|` | Split pane vertically |
| `Prefix + -` | Split pane horizontally |
| `Prefix + h/j/k/l` | Navigate panes (vim-style) |
| `Prefix + m` | Maximize/restore pane |
| `Alt+1-9` | Switch to window 1-9 |
| `Prefix + r` | Reload config |

## 🎨 Customization

### Changing the Theme

The setup uses Catppuccin-inspired colors. To customize:

1. **Starship prompt:** Edit `starship/starship.toml`
2. **fzf colors:** Edit the `FZF_DEFAULT_OPTS` in `zsh/.zshrc`
3. **tmux colors:** Edit the status bar section in `tmux/.tmux.conf`

### Adding Custom Aliases

Add your custom aliases to `zsh/.zshrc` in the appropriate section, then run:
```bash
source ~/.zshrc
```

### Changing the Default Editor

Edit `zsh/.zshrc` and change:
```bash
export EDITOR="code --wait"  # Change to vim, nvim, etc.
```

## 🔄 Updating

To update your dotfiles:

```bash
cd ~/code/dotfiles
git pull
```

Changes are automatically reflected since we use symlinks!

To update installed packages:
```bash
brew update && brew upgrade
```

## 🗑️ Uninstallation

To remove the dotfiles setup:

```bash
cd ~/code/dotfiles
./uninstall.sh
```

The script will:
- Remove symlinks
- Optionally restore backup files
- Optionally remove installed packages
- Optionally remove Oh My Zsh

## 🐛 Troubleshooting

### Icons not showing correctly
- Make sure you've set your terminal font to a Nerd Font
- Recommended: "JetBrainsMono Nerd Font"

### Slow shell startup
- Check which plugins are loading in `.zshrc`
- Run `zsh -xv` to debug startup time

### fzf not working
- Run `$(brew --prefix)/opt/fzf/install` to reinstall key bindings
- Make sure `~/.fzf.zsh` exists and is sourced

### tmux colors look wrong
- Make sure your terminal supports true color
- Add to your terminal profile: `TERM=xterm-256color`

## 📚 Resources

- [Oh My Zsh](https://ohmyz.sh/)
- [Starship](https://starship.rs/)
- [fzf](https://github.com/junegunn/fzf)
- [tmux](https://github.com/tmux/tmux)
- [eza](https://github.com/eza-community/eza)
- [bat](https://github.com/sharkdp/bat)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [zoxide](https://github.com/ajeetdsouza/zoxide)

## 📄 License

MIT License - feel free to use and modify as you like!

---

**Enjoy your cracked terminal! 🎉**
