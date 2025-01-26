if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Init zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"

zinit ice depth=1; zinit light romkatv/powerlevel10k

# plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
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

export LANG=en_US.UTF-8
export EDITOR=nvim

# common
alias so='source ~/.zshrc'
alias ls='eza --color=always --long --git --icons=always --no-time --no-user --no-permissions'
alias ll='la -a'
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

# brew (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
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

alias awslg='aws sso login'

# git
alias git='LANG=en_US git'
alias gs='git status'
alias gf='git fetch --prune'
alias gp='git push'
alias gr='git rebase'
alias gpr='git pull --rebase'
alias gpF='git push -f'
alias gac='git add -A && git commit -S'
alias grst='git reset HEAD~1'
alias gsq='(){ git rebase -i HEAD~$1 }'
alias gsm='git submodule'
alias gsmu='git submodule update --init --recursive'

# pulumi
alias p='pulumi'
alias pu='pulumi up --suppress-outputs'
alias pc='pulumi config'
alias pst='pulumi stack'
alias pstt='pulumi state'
alias ppv='pulumi preview --suppress-outputs'
alias ppvd='pulumi preview --diff --suppress-outputs'

# editor
alias vim='nvim'
alias nv='nvim'

# history
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
HISTDUP=erase

bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

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

# fzf
eval "$(fzf --zsh)"

# Zoxide
eval "$(zoxide init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
