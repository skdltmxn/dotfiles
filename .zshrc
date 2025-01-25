if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions fzf-tab)

source $ZSH/oh-my-zsh.sh

# Enable zsh-completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

# Enable zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export LANG=en_US.UTF-8
export EDITOR=nvim

autoload -Uz compinit && compinit

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

if command -v aws_completer &> /dev/null; then
  complete -C $(which aws_completer) aws
fi

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
