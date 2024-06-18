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

## Original Inspiration

- https://www.youtube.com/watch?v=y6XCebnB9gs

## Links

- https://www.gnu.org/software/stow

## Things to install

- Alacritty themes `git clone https://github.com/alacritty/alacritty-theme .config/alacritty/themes`

## How to stow

- source: https://venthur.de/2021-12-19-managing-dotfiles-with-stow.html

Each program's dotfile is stored in it's own directory. I think each symlink has to be created for each program manually.. I'm not quite sure how the hierarchy of directories works for symlinks.

## Neovim Keybinds

| Key Binding | Description                                                                              |
| ----------- | ---------------------------------------------------------------------------------------- |
| n <Space>n  | \* :Neotree toggle right<CR>                                                             |
| n <Space>N  | \* :Neotree reveal right<CR>                                                             |
| n <Space>f  | \* <Lua 168: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:216>                            |
| n <Space>gf | \* <Lua 134: ~/.local/share/nvim/lazy/telescope.nvim/lua/telescope/builtin/init.lua:501> |
| n <Space>t  | \* <Lua 133: ~/.local/share/nvim/lazy/telescope.nvim/lua/telescope/builtin/init.lua:501> |
| v <Space>ca | \* <Lua 91: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:830>                             |
| n <Space>ca | \* <Lua 90: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:830>                             |
| n <Space>rn | \* <Lua 31: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:298>                             |
| n <Space>c  | \* :nohlsearch<CR>                                                                       |
| n <Space>p  | \* "\_dP                                                                                 |
| n <Space>dd | "\_dd                                                                                    |
| n <Space>d  | "\_d                                                                                     |
| n <Space>Q  | :bw<CR>                                                                                  |
| v <Space>e  | \* <Lua 32: /usr/share/nvim/runtime/lua/vim/diagnostic.lua:1145>                         |
| n <Space>e  | \* <Lua 89: /usr/share/nvim/runtime/lua/vim/diagnostic.lua:1694>                         |
| v <Space>r  | \* <Lua 30: /usr/share/nvim/runtime/lua/vim/diagnostic.lua:1222>                         |
| n <Space>r  | \* <Lua 29: /usr/share/nvim/runtime/lua/vim/diagnostic.lua:1222>                         |
| v <Space>F  | \* <Lua 28: /usr/share/nvim/runtime/lua/vim/diagnostic.lua:1694>                         |
| n <Space>F  | \* <Lua 23: /usr/share/nvim/runtime/lua/vim/diagnostic.lua:1694>                         |
| n <Space>z  | \* :%s/<C-R><C-W>/<C-R>0/g<CR>                                                           |
| n &         | \* :&&<CR>                                                                               |
| n H         | \* :BufferLineCyclePrev<CR>                                                              |
| x J         | \* :move '>+1<CR>gv=gv                                                                   |
| n J         | \* :m .+1<CR>==                                                                          |
| x K         | \* :move '<-2<CR>gv=gv                                                                   |
| n L         | \* :BufferLineCycleNext<CR>                                                              |
| x S         | \* <Plug>(nvim-surround-visual)                                                          |
| n \P        | \* :PasteWithIndentBefore<CR>                                                            |
| n \p        | \* :PasteWithIndent<CR>                                                                  |
| x a%        | <Plug>(MatchitVisualTextObject)                                                          |
| n cS        | \* <Plug>(nvim-surround-change-line)                                                     |
| n cs        | \* <Plug>(nvim-surround-change)                                                          |
| n ds        | \* <Plug>(nvim-surround-delete)                                                          |
| x gS        | \* <Plug>(nvim-surround-visual-line)                                                     |
| n gr        | \* <Lua 88: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:418>                             |
| n gi        | \* <Lua 86: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:108>                             |
| n gd        | \* <Lua 84: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:93>                              |
| n gD        | \* <Lua 38: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:86>                              |
| o gc        | \* <Lua 13: vim/\_defaults.lua:0>                                                        |
| n gcc       | \* <Lua 12: vim/\_defaults.lua:0>                                                        |
| x gc        | \* <Lua 11: vim/\_defaults.lua:0>                                                        |
| n gc        | \* <Lua 10: vim/\_defaults.lua:0>                                                        |
| x gx        | \* <Lua 9: vim/\_defaults.lua:0>                                                         |
| n gx        | \* <Lua 8: vim/\_defaults.lua:0>                                                         |
| n ySS       | \* <Plug>(nvim-surround-normal-cur-line)                                                 |
| n yS        | \* <Plug>(nvim-surround                                                                  |
