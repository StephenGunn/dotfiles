# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZVM_VI_HIGHLIGHT_FOREGROUND="#A6E3A1"
ZVM_VI_HIGHLIGHT_BACKGROUND="#45475A"
ZVM_VI_HIGHLIGHT_EXTRASTYLE="bold,underline"
ZVM_VI_EDITOR="nvim"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Plugin setup
plugins=(git zsh-vi-mode)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# User configuration
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

alias vim=nvim
alias server="ssh stephen@192.168.86.32"
alias dotfiles="cd ~/dotfiles"
alias cr="cd ~/cr"
alias p="cd ~/Projects"

# Load Powerlevel10k theme
source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# NPM setup
PATH="~/.npm-global/bin:$PATH"

# Load asdf version manager
. /opt/asdf-vm/asdf.sh
PATH="~/.npm-global/bin:$PATH"

# Bun completions
[ -s "/home/stephen/.bun/_bun" ] && source "/home/stephen/.bun/_bun"

# Bun setup
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export COLORTERM=truecolor

# PNPM setup
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME/bin:$PATH"

# Optimize VI mode
bindkey -v  # Enable VI mode

# Disable menu completion to prevent sluggishness
unsetopt MENU_COMPLETE

# Disable auto-completion listing to prevent lag
unsetopt AUTO_LIST

# Reduce completion menu cycles
zstyle ':completion:*' menu select

# Load zsh-autocomplete plugin
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Autocompletion settings
# Disable immediate suggestions
zstyle ':autocomplete:*' insert-unambiguous no

# Set delay for showing completions
zstyle ':autocomplete:*' max-delay 0

# Show suggestions on Tab press
bindkey '^I' self-insert
bindkey '^[[Z' expand-or-complete  # Shift-Tab for completion

# Disable unnecessary key bindings
bindkey -r '^[[A'  # Disable up arrow key binding in vi mode if not needed
bindkey -r '^[[B'  # Disable down arrow key binding in vi mode if not needed

# Load syntax highlighting at the end for performance
source /home/stephen/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
