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
alias pi="ssh stephen@192.168.86.27"
alias dotfiles="cd ~/dotfiles"
alias cr="cd ~/cr"
alias p="cd ~/Projects"

# Load Powerlevel10k theme
source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# NPM setup
export PATH="$HOME/.npm-global/bin:$PATH"

# Load asdf version manager
. /opt/asdf-vm/asdf.sh

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Bun setup
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


export COLORTERM=truecolor

# Optimize VI mode
bindkey -v  # Enable VI mode

# Completion settings

# Enable menu completion - pressing Tab will show suggestions you can navigate
zstyle ':completion:*' menu select=2

# Disable automatic listing to prevent lag
unsetopt AUTO_LIST

# Reduce completion menu cycles
zstyle ':completion:*' menu select

# Show list on ambiguous completion (when there are multiple matches)
setopt AUTO_MENU

# Make sure menu is shown after the second Tab press
bindkey '^I' expand-or-complete

# Disable unnecessary key bindings
bindkey -r '^[[A'  # Disable up arrow key binding in vi mode if not needed
bindkey -r '^[[B'  # Disable down arrow key binding in vi mode if not needed

# Load syntax highlighting at the end for performance
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Flyctl setup
export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# Add LuaRocks paths
export LUA_PATH="$(luarocks path --lr-path)"
export LUA_CPATH="$(luarocks path --lr-cpath)"

# yazi
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# pnpm
export PNPM_HOME="/home/stephen/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
