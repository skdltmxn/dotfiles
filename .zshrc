# Init zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"

# plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light Aloxaf/fzf-tab

# snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

autoload -Uz compinit && compinit

zinit cdreplay -q

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=nvim

# common
alias so='exec zsh'
alias ls='eza --color=always --long --git --icons=always --no-time --no-user --no-permissions'
alias ll='ls -a'
alias cd='z'
alias cat='bat'
alias c='clear'
alias grep='rg --color=auto'

# directory
alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# brew (linux)
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# if brew is installed, set up aliases
if command -v brew &> /dev/null; then
  alias b='brew'
  alias bu='brew upgrade'
  alias bi='brew install'
fi

# pacman
if command -v pacman &> /dev/null; then
  alias pm='sudo pacman'
  alias pmu='sudo pacman -Syu'
  alias pmi='sudo pacman -S'
  alias pms='sudo pacman -Ss'
  alias pmd='sudo pacman -Rns'
fi

# yay
if command -v yay &> /dev/null; then
  alias yu='yay -Syu'
  alias yi='yay -S'
  alias ys='yay -Ss'
  alias yd='yay -Rns'
fi

# aws
if command -v aws_completer &> /dev/null; then
  complete -C $(which aws_completer) aws
fi

# kubectl
if command -v kubectl &> /dev/null; then
  alias k='kubectl'
fi

alias awslg='aws sso login'
alias tshlg='tsh login --proxy teleport.pubg.io:443 --auth sso'

# git
alias git='LANG=en_US git'
alias gs='git status'
alias gf='git fetch --prune'
alias gp='git push'
alias gr='git rebase'
alias gpl='git pull'
alias gpr='git pull --rebase'
alias gpF='git push -f'
alias gac='git add -A && git commit -S'
alias grst='git reset HEAD~1'
alias gsq='(){ git rebase -i HEAD~$1 }'
alias gsm='git submodule'
alias gsmu='git submodule update --init --recursive'

# pulumi
alias pl='pulumi'
alias pup='pulumi up --suppress-outputs'
alias plc='pulumi config'
alias pst='pulumi stack'
alias pstt='pulumi state'
alias ppv='pulumi preview --suppress-outputs'
alias ppvd='pulumi preview --diff --suppress-outputs'

# pnpm
if command -v pnpm &> /dev/null; then
  alias p='pnpm'
  alias pd='pnpm dev'
  alias pr='pnpm run'
fi

# editor
alias vim='nvim'
alias nv='nvim'

# history
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
HISTDUP=erase
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_TIMEOUT=0

bindkey '^[[A' history-substring-search-up
bindkey '^p' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^n' history-substring-search-down

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_verify

# Styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

# fzf
eval "$(fzf --zsh)"

# Zoxide
eval "$(zoxide init zsh)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Oh My Posh
OH_MY_POSH_HOME="${XDG_DATA_HOME:-${HOME}}/.config/oh-my-posh"
eval "$(oh-my-posh init zsh --config $OH_MY_POSH_HOME/theme.json)"

# Per-project configs
setopt null_glob
for file in $HOME/.config/projects/*.zsh; do
    if [[ -f $file ]]; then
        source "$file"
    fi
done
unsetopt null_glob

export PATH="$HOME/.pulumi/bin:$HOME/go/bin:$HOME/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/go/bin:$PATH"
