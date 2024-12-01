export XDG_SESSION_TYPE=wayland

fish_vi_key_bindings

starship init fish | source

set -U fish_greeting "🌎 🚀 JovianMoon.io  🪐"

source ~/.config/fish/aliases.fish

# This function shows the vi mode dynamically in the right prompt
function fish_right_prompt
    switch $fish_bind_mode
        case insert
            echo -n (set_color green)" INSERT "(set_color normal)
        case default
            echo -n (set_color red)" NORMAL "(set_color normal)
        case visual
            echo -n (set_color yellow)" VISUAL "(set_color normal)
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

# pnpm
set -gx PNPM_HOME "/home/stephen/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

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
