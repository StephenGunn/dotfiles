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

## Keybinds

| Key Binding | Description                                                                                |
| ----------- | ------------------------------------------------------------------------------------------ |
| n c         | \*@:e $MYVIMRC <CR>                                                                        |
| n e         | \*@:ene \| startinsert <CR>                                                                |
| n f         | \*@:cd $HOME/dotfiles \| Telescope find_files<CR>                                          |
| n g         | \*@:Telescope live_grep<CR>                                                                |
| n l         | \*@:Lazy<CR>                                                                               |
| n m         | \*@:Mason<CR>                                                                              |
| n q         | \*@:qa<CR>                                                                                 |
| n r         | \*@:Telescope oldfiles<CR>                                                                 |
| n u         | \*@<Cmd>lua require('lazy').sync()<CR>                                                     |
| n <M-CR>    | \*@<Lua 313: ~/.local/share/nvim/lazy/alpha-nvim/lua/alpha.lua:718>                        |
| n <Space>n  | \* :Neotree toggle right<CR>                                                               |
| n <Space>N  | \* :Neotree reveal right<CR>                                                               |
| n <Space>f  | \* <Lua 168: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:216>                              |
| n <Space>gf | \* <Lua 134: ~/.local/share/nvim/lazy/telescope.nvim/lua/telescope/builtin/init.lua:501>   |
| n <Space>t  | \* <Lua 133: ~/.local/share/nvim/lazy/telescope.nvim/lua/telescope/builtin/init.lua:501>   |
| v <Space>ca | \* <Lua 91: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:830>                               |
| n <Space>ca | \* <Lua 90: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:830>                               |
| n <Space>rn | \* <Lua 31: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:298>                               |
| n <Space>c  | \* :nohlsearch<CR>                                                                         |
| n <Space>p  | \* "\_dP                                                                                   |
| n <Space>dd | "\_dd                                                                                      |
| n <Space>d  | "\_d                                                                                       |
| n <Space>Q  | :bw<CR>                                                                                    |
| v <Space>e  | \* <Lua 32: /usr/share/nvim/runtime/lua/vim/diagnostic.lua:1145>                           |
| n <Space>e  | \* <Lua 89: /usr/share/nvim/runtime/lua/vim/diagnostic.lua:1694>                           |
| v <Space>r  | \* <Lua 30: /usr/share/nvim/runtime/lua/vim/diagnostic.lua:1222>                           |
| n <Space>r  | \* <Lua 29: /usr/share/nvim/runtime/lua/vim/diagnostic.lua:1222>                           |
| v <Space>F  | \* <Lua 28: /usr/share/nvim/runtime/lua/vim/diagnostic.lua:1694>                           |
| n <Space>F  | \* <Lua 23: /usr/share/nvim/runtime/lua/vim/diagnostic.lua:1694>                           |
| n <Space>z  | \* :%s/<C-R><C-W>/<C-R>0/g<CR>                                                             |
| x #         | \* <Lua 7: vim/\_defaults.lua:0>                                                           |
|             | :help v\_#-default                                                                         |
| o %         | <Plug>(MatchitOperationForward)                                                            |
| x %         | <Plug>(MatchitVisualForward)                                                               |
| n %         | <Plug>(MatchitNormalForward)                                                               |
| n &         | \* :&&<CR>                                                                                 |
|             | :help &-default                                                                            |
| x \*        | \* <Lua 3: vim/\_defaults.lua:0>                                                           |
|             | :help v_star-default                                                                       |
| x @         | \* mode() == 'V' ? ':normal! @'.getcharstr().'<CR>' : '@'                                  |
|             | :help v\_@-default                                                                         |
| n H         | \* :BufferLineCyclePrev<CR>                                                                |
| x J         | \* :move '>+1<CR>gv=gv                                                                     |
| n J         | \* :m .+1<CR>==                                                                            |
| x K         | \* :move '<-2<CR>gv=gv                                                                     |
| n K         | \* <Lua 85: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:33>                                |
| n L         | \* :BufferLineCycleNext<CR>                                                                |
| x Q         | \* mode() == 'V' ? ':normal! @<C-R>=reg_recorded()<CR><CR>' : 'Q'                          |
|             | :help v_Q-default                                                                          |
| x S         | \* <Plug>(nvim-surround-visual)                                                            |
|             | Add a surrounding pair around a visual selection                                           |
| n Y         | \* y$                                                                                      |
|             | :help Y-default                                                                            |
| o [%        | <Plug>(MatchitOperationMultiBackward)                                                      |
| x [%        | <Plug>(MatchitVisualMultiBackward)                                                         |
| n [%        | <Plug>(MatchitNormalMultiBackward)                                                         |
| n [d        | \* <Lua 15: vim/\_defaults.lua:0>                                                          |
|             | Jump to the previous diagnostic                                                            |
| x \\c       | <Plug>(VM-Visual-Cursors)                                                                  |
| n \\gS      | <Plug>(VM-Reselect-Last)                                                                   |
| n \\/       | <Plug>(VM-Start-Regex-Search)                                                              |
| n \\\       | <Plug>(VM-Add-Cursor-At-Pos)                                                               |
| x \\a       | <Plug>(VM-Visual-Add)                                                                      |
| x \\f       | <Plug>(VM-Visual-Find)                                                                     |
| x \\/       | <Plug>(VM-Visual-Regex)                                                                    |
| x \\A       | <Plug>(VM-Visual-All)                                                                      |
| n \\A       | <Plug>(VM-Select-All)                                                                      |
| n \P        | \* :PasteWithIndentBefore<CR>                                                              |
| n \p        | \* :PasteWithIndent<CR>                                                                    |
| o ]%        | <Plug>(MatchitOperationMultiForward)                                                       |
| x ]%        | <Plug>(MatchitVisualMultiForward)                                                          |
| n ]%        | <Plug>(MatchitNormalMultiForward)                                                          |
| n ]d        | \* <Lua 14: vim/\_defaults.lua:0>                                                          |
|             | Jump to the next diagnostic                                                                |
| x a%        | <Plug>(MatchitVisualTextObject)                                                            |
| n cS        | \* <Plug>(nvim-surround-change-line)                                                       |
|             | Change a surrounding pair, putting replacements on new lines                               |
| n cs        | \* <Plug>(nvim-surround-change)                                                            |
|             | Change a surrounding pair                                                                  |
| n ds        | \* <Plug>(nvim-surround-delete)                                                            |
|             | Delete a surrounding pair                                                                  |
| x gS        | \* <Plug>(nvim-surround-visual-line)                                                       |
|             | Add a surrounding pair around a visual selection, on new lines                             |
| o g%        | <Plug>(MatchitOperationBackward)                                                           |
| x g%        | <Plug>(MatchitVisualBackward)                                                              |
| n g%        | <Plug>(MatchitNormalBackward)                                                              |
| n gr        | \* <Lua 88: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:418>                               |
| n gi        | \* <Lua 86: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:108>                               |
| n gd        | \* <Lua 84: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:93>                                |
| n gD        | \* <Lua 38: /usr/share/nvim/runtime/lua/vim/lsp/buf.lua:86>                                |
| o gc        | \* <Lua 13: vim/\_defaults.lua:0>                                                          |
|             | Comment textobject                                                                         |
| n gcc       | \* <Lua 12: vim/\_defaults.lua:0>                                                          |
|             | Toggle comment line                                                                        |
| x gc        | \* <Lua 11: vim/\_defaults.lua:0>                                                          |
|             | Toggle comment                                                                             |
| n gc        | \* <Lua 10: vim/\_defaults.lua:0>                                                          |
|             | Toggle comment                                                                             |
| x gx        | \* <Lua 9: vim/\_defaults.lua:0>                                                           |
|             | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) |
| n gx        | \* <Lua 8: vim/\_defaults.lua:0>                                                           |
|             | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) |
| n ySS       | \* <Plug>(nvim-surround-normal-cur-line)                                                   |
|             | Add a surrounding pair around the current line, on new lines (normal mode)                 |
| n yS        | \* <Plug>(nvim-surround                                                                    |
