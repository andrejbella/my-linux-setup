if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZINIT_HOME="${XDG_CACHE_HOME:-${HOME}/.local/share}/zinit/zinit.git"
ZINIT_PLUGINS="${XDG_CACHE_HOME:-${HOME}/.local/share}/zinit/plugins"
FZF_HOME="${HOME}/.fzf}"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Add Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light asdf-vm/asdf

source "$ZINIT_PLUGINS"/Aloxaf---fzf-tab/fzf-tab.plugin.zsh
source "$ZINIT_PLUGINS"/asdf-vm---asdf/asdf.sh
source "$ZINIT_PLUGINS"/asdf-vm---asdf/internal/completions/asdf.zsh


# Use arrow keys to cycle through autosuggestions history
bindkey "^[[1;5A" history-beginning-search-backward
bindkey "^[[1;5B" history-beginning-search-forward


HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

unsetopt beep

# Completions case insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:*' fzf-preview 'ls --color $realpath'

alias cd="z"
alias l="eza"
alias ls="eza"
alias lt="eza --tree --level"
alias ll="ls -la"
alias hs="history | grep -i"
alias mi=micro

alias k=kubectl
alias t=talosctl
alias k9=k9s

alias gs="git status"
alias gc="git commit"
alias ga="git add"
alias gp="git push"


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
. <(flux completion zsh)

# Load completions
autoload -U compinit; compinit

export TALOSCONFIG=~/.config/configs/talosconfig
export KUBECONFIG=~/.config/configs/kubeconfig
export SOPS_AGE_KEY_FILE=~/keys/age/keys.txt

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
