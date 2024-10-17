# Dotfiles

Thiw repo is my home base for my dotfiles. I am using Stow to make sure I am version controlling only the files I want.

## Requirements

- Git
- Stow

## Configurations Included

- alacritty
- neovim
- oh-my-zsh
- pnpm
- fish
- kitty
- rofi
- waybar
- wezterm

## Original Inspiration

- https://www.youtube.com/watch?v=y6XCebnB9gs

## Links

- https://www.gnu.org/software/stow

## Things to install

- Check the `scripts/` directory for the install scripts for the programs I use.

## How to stow

- link.sh - This script will symlink all the files in the `dotfiles/` directory to the home directory.

- `stow -t ~ dotfiles/` - This will symlink all the files in the `dotfiles/` directory to the home directory.

- source: https://venthur.de/2021-12-19-managing-dotfiles-with-stow.html

Each program's dotfile is stored in it's own directory. I think each symlink has to be created for each program manually.. I'm not quite sure how the hierarchy of directories works for symlinks.
