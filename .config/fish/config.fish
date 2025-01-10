export XDG_SESSION_TYPE=wayland

fish_vi_key_bindings

starship init fish | source

set -U fish_greeting "🌎 🚀 JovianMoon.io  🪐"

source ~/.config/fish/aliases.fish

# Set cursor style based on vi mode
function fish_vi_cursor --on-variable fish_bind_mode
    switch $fish_bind_mode
        case default
            echo -en "\e[2 q" # block cursor
        case insert
            echo -en "\e[6 q" # line cursor
        case visual
            echo -en "\e[2 q" # block cursor
    end
end

# Set Neovim as the default editor
set -Ux EDITOR "nvim"
set -Ux VISUAL "nvim"

set -Ux fish_user_paths $HOME/.cargo/bin $fish_user_paths

eval $(opam env)

# postgresql setup
set -Ux PATH /usr/bin/postgres /usr/bin/psql $PATH

# Created by `pipx` on 2024-10-15 22:41:40
set PATH $PATH /home/stephen/.local/bin


# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# yazi
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# Add ~/.local/bin to the PATH for stream deck
set -U fish_user_paths $HOME/.local/bin $fish_user_paths

# pnpm
set -gx PNPM_HOME "/home/stephen/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

zoxide init fish | source

