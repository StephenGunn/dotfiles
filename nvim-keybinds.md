# Neovim Keybindings Reference

> **Note**: All keybindings are now centralized in `.config/nvim/lua/plugins/which-key.lua`

## Leader Key
- **Leader**: `<Space>`

## Quick Reference Format
- `[mode]` **`key`** → action (source_file:line)
- Modes: `n` (normal), `i` (insert), `v` (visual), `x` (visual block)

## Core Vim Operations

### File & Buffer Management
- `n` **`<leader>s`** → Save file
- `n` **`<leader>w`** → Close buffer (`:bd`)
- `n` **`<leader>W`** → Close all other buffers
- `n` **`<leader>Q`** → Force close buffer (`:bw`)

### Navigation
- `n` **`<S-h>`** → Previous buffer
- `n` **`<S-l>`** → Next buffer
- `n` **`<C-h/j/k/l>`** → Navigate windows
- `n` **`<Esc>`** → Clear search highlights

### Editing
- `n` **`<leader>p`** → Paste from clipboard with indent
- `n` **`<leader>P`** → Paste before with indent
- `n` **`<leader><leader>p`** → Paste over selection (keep register)
- `n` **`<leader>z`** → Replace word under cursor globally
- `n` **`<leader>d`** → Delete without register
- `n` **`<leader>dd`** → Delete line without register

### Line Movement
- `n` **`<S-j>`** → Move line down
- `v/x` **`<S-j>`** → Move selection down
- `v/x` **`<S-k>`** → Move selection up

## LSP & Diagnostics

### Go To
- `n` **`gd`** → Go to definition
- `n` **`gD`** → Go to declaration
- `n` **`gi`** → Go to implementation
- `n` **`gt`** → Go to type definition
- `n` **`gr`** → Find references

### Diagnostics
- `n` **`K`** → Hover documentation
- `n` **`<C-k>`** → Signature help
- `n` **`<leader>e`** → Previous diagnostic
- `n` **`<leader>r`** → Next diagnostic
- `n` **`<leader>F`** → Diagnostic float
- `n` **`<leader>E`** → Copy diagnostic error

### Code Actions
- `n/v` **`<leader>ca`** → Code action
- `n` **`<leader>rn`** → Rename symbol

## TypeScript/Imports (`<leader>i`)
- **`<leader>i<Space>`** → Add import for symbol under cursor
- **`<leader>io`** → Organize imports (sort + remove unused)
- **`<leader>is`** → Sort imports only
- **`<leader>iu`** → Remove unused imports
- **`<leader>ia`** → Add ALL missing imports
- **`<leader>if`** → Fix all auto-fixable issues
- **`<leader>ir`** → Remove all unused statements
- **`<leader>id`** → Go to source definition
- **`<leader>iR`** → Find file references
- **`<leader>iF`** → Rename file & update imports

## Git (`<leader>g`)
- **`<leader>gg`** → LazyGit
- **`<leader>gp`** → Preview hunk
- **`<leader>gb`** → Toggle blame
- **`<leader>gf`** → Live grep (Telescope)

## Telescope & Search
- `n` **`<leader>t`** → Find files
- `n` **`<leader>a`** → Document symbols
- `n` **`<leader>u`** → Undo history
- `n` **`<leader>fr`** → Find references

## File Explorer
- `n` **`<leader>n`** → Toggle file tree
- `n` **`<leader>N`** → Reveal current file in tree

## Quickfix
- `n` **`<leader>o`** → Open quickfix list
- `n` **`<leader>j`** → Next quickfix item
- `n` **`<leader>k`** → Previous quickfix item

## Todo Comments
- `n` **`<leader>J`** → Next todo
- `n` **`<leader>K`** → Previous todo
- `n` **`<leader>T`** → Todo telescope

## Trouble (`<leader>x`)
- **`<leader>xx`** → Toggle diagnostics
- **`<leader>xX`** → Buffer diagnostics
- **`<leader>xL`** → Location list
- **`<leader>xQ`** → Quickfix list

## Code (`<leader>c`)
- **`<leader>cs`** → Symbols (Trouble)
- **`<leader>cl`** → LSP definitions/references
- **`<leader>ca`** → Code action

## Other
- `n` **`<leader>/`** → New comment line
- `n` **`<C-PageDown>`** → Vertical split
- `n` **`<C-PageUp>`** → Go to left split

## Insert Mode
- `i` **`<C-b>`** → Scroll docs backward (completion)
- `i` **`<C-f>`** → Scroll docs forward (completion)
- `i` **`<C-Space>`** → Trigger completion
- `i` **`<C-e>`** → Abort completion
- `i` **`<C-y>`** → Confirm completion

## Treesitter Navigation
- `n` **`)`** → Next function/block start
- `n` **`(`** → Previous function/block start
- `n` **`]`** → Next function/block end
- `n` **`[`** → Previous function/block end

## Plugin-Specific Defaults
Some plugins add their own keybindings:
- **Comment.nvim**: `gc` in visual mode, `gcc` in normal mode
- **vim-surround**: `cs`, `ds`, `ys` operations
- **Leap.nvim**: `s`, `S`, `gs` for motion
- **LuaSnip**: `<Tab>`/`<S-Tab>` for snippet navigation

---

## Viewing Keybindings in Neovim
- Press `<Space>` and wait to see available leader mappings
- Use `:WhichKey` to see all mappings
- Use `:Telescope keymaps` to search all keymaps

## Conflicts Resolved
1. **`<leader>p`** conflict → clipboard paste vs register paste
   - Solution: Register paste moved to `<leader><leader>p`
2. **`<leader>e`** conflict → diagnostic float vs previous diagnostic
   - Solution: Float moved to `<leader>F`, previous kept at `<leader>e`
3. **`<C-k>`** conflict → window navigation vs signature help
   - Solution: Kept signature help (more commonly used in coding)

## File Locations
- **Central keybindings**: `.config/nvim/lua/plugins/which-key.lua`
- **Old locations** (commented out):
  - Core bindings: `vim-options.lua`
  - LSP bindings: `lua/plugins/lsp-config.lua`
  - Plugin bindings: Individual plugin files