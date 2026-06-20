# dotfiles

Personal config for zsh, tmux, Neovim, and terminal emulators, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Install

```bash
# Homebrew (skip if already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Required tools
brew install stow neovim tmux starship fzf zoxide fnm eza bat ripgrep fd lazygit go python golangci-lint
brew install --cask font-meslo-lg-nerd-font font-d2coding         # Nerd Font for icons
xcode-select --install                                            # C compiler + make (Treesitter parsers)
fnm install --lts                                                 # Node runtime for LSP servers & Copilot
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm # tmux plugin manager

# Symlink the dotfiles
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
stow .
```

On Linux, use Homebrew or your distro's package manager — package names are usually identical.

## Required tools

Everything in the install command is referenced unconditionally by the configs:

- **Shell:** `starship` (prompt), `fzf` (fuzzy finder + completion), `zoxide` (`cd`), `fnm` (Node), `eza` (`ls`), `bat` (`cat`), `ripgrep` (`grep`). `zinit` and its plugins self-install on first shell launch.
- **tmux:** `tmux` + `tpm`; the plugins are fetched by tpm and the clipboard uses macOS `pbcopy`.
- **Neovim** (≥ 0.11): `neovim`, a C compiler + `make`, and the `node` / `go` / `python` runtimes the language servers need. `ripgrep` + `fd` power Telescope, `lazygit` is the Git UI, `golangci-lint` is the Go linter.

LSP servers and formatters/linters install themselves via [Mason](https://github.com/mason-org/mason.nvim) on first launch (`ts_ls`, `lua_ls`, `svelte`, `gopls`, `stylua`, `isort`, `black`, `eslint_d`, `pylint`) — you only need the runtimes above.

## Post-install

1. Open a new shell so zsh bootstraps `zinit`.
2. In `tmux`, press `prefix + I` (prefix is `Ctrl-s`) to install tmux plugins.
3. Launch `nvim` — `lazy.nvim` and Mason install everything automatically (`:Lazy sync` / `:Mason` to verify).
4. Run `:Copilot setup` to authenticate GitHub Copilot (subscription required).

## Optional tools

Activated only if present (guarded by `command -v` in `.zshrc`): `kubectl`, `aws`, `terraform`, `pulumi`, `pnpm`, `bun`, `tsh`, and `tig` (for the `prefix + T` popup). Arch Linux adds `pacman` / `yay` aliases.

## Includes

- zsh (`.zshrc`)
- tmux (`.tmux.conf`, `.config/tmux/`)
- neovim (`.config/nvim`)
- alacritty (`.config/alacritty`)
- ghostty (`.config/ghostty`)
- starship (`.config/starship.toml`)
