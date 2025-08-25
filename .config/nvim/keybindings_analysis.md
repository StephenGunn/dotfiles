# Neovim Keybindings Analysis

## Summary of All Keybindings

### Leader Key
- **Leader key**: `<Space>` (defined in vim-options.lua:8)

### Core Vim Navigation & Editing

#### init.lua (Lines 87-122)
- `n` **`)`** - Next block/function start (using treesitter)
- `n` **`(`** - Previous block/function start (using treesitter)
- `n` **`]`** - Next block/function end (using treesitter)
- `n` **`[`** - Previous block/function end (using treesitter)

#### vim-options.lua
##### Paste Operations (Lines 46-49)
- `n` **`<Leader>p`** - Paste with auto-indentation from system clipboard
- `n` **`<Leader>P`** - Paste before with auto-indentation from system clipboard
- `n` **`<leader>p`** - Delete and paste without losing register (line 157) **CONFLICT!**

##### Search & Replace (Lines 52-53)
- `n` **`<leader>z`** - Replace all occurrences of word under cursor with register 0

##### Quickfix Navigation (Lines 55-64)
- `n` **`<leader>o`** - Open quickfix list
- `n` **`<leader>j`** - Next quickfix item in full window
- `n` **`<leader>k`** - Previous quickfix item in full window

##### Buffer Management (Lines 67-71, 136-137)
- `n` **`<leader>w`** - Close current buffer (`:bd`)
- `n` **`<leader>W`** - Close all buffers except current
- `n` **`<leader>Q`** - Force close current buffer (`:bw`)
- `n` **`<leader>s`** - Save file

##### Diagnostics & LSP (Lines 61, 94-99, 124-127, 190-191, 227-235)
- `n` **`gt`** - Go to type definition
- `n` **`<leader>E`** - Copy diagnostic error to clipboard
- `n/v` **`<leader>F`** - Open diagnostic float **CONFLICT!**
- `n/v` **`<leader>r`** - Next diagnostic **CONFLICT!**
- `n/v` **`<leader>e`** - Previous diagnostic **CONFLICT!**
- `n` **`<leader>i`** - Auto add import

##### Line Movement (Lines 87-91, 121)
- `n` **`<S-k>`** - Move line up **CONFLICT with K hover!**
- `n` **`<S-j>`** - Move line down
- `x` **`<S-k>`** - Move selected block up
- `x` **`<S-j>`** - Move selected block down

##### Delete Operations (Lines 139-143)
- `n` **`<leader>d`** - Delete without register
- `n` **`<leader>dd`** - Delete line without register

##### Window Navigation (Lines 151-154, 160-164)
- `n` **`<C-PageDown>`** - Create vertical split
- `n` **`<C-PageUp>`** - Move to left split
- `n` **`<c-k>`** - Window up
- `n` **`<c-j>`** - Window down
- `n` **`<c-h>`** - Window left
- `n` **`<c-l>`** - Window right

##### Buffer Navigation (Lines 166-167)
- `n` **`<S-l>`** - Next buffer (BufferLine) **CONFLICT!**
- `n` **`<S-h>`** - Previous buffer (BufferLine)

##### Other (Line 191)
- `n` **`<Esc>`** - Clear search highlights

### LSP Keybindings (lsp-config.lua Lines 184-193)
- `n` **`gD`** - Go to declaration
- `n` **`gd`** - Go to definition
- `n` **`K`** - Hover documentation **CONFLICT with <S-k>!**
- `n` **`gi`** - Go to implementation
- `n` **`<C-k>`** - Signature help **CONFLICT with window navigation!**
- `n` **`gr`** - Find references
- `n` **`<leader>e`** - Open diagnostic float **DUPLICATE!**
- `n` **`<leader>rn`** - Rename symbol
- `n/v` **`<leader>ca`** - Code action

### Plugin-Specific Keybindings

#### Telescope (telescope.lua Lines 8-24)
- `n` **`<leader>t`** - Find files
- `n` **`<leader>gf`** - Live grep
- `n` **`<leader>fr`** - Find references
- `n` **`<leader>a`** - Search document symbols

#### Neo-tree (neo-tree.lua Lines 10-11)
- `n` **`<leader>N`** - Reveal file in tree
- `n` **`<leader>n`** - Toggle file tree

#### Git Signs (git.lua Lines 20-21)
- `n` **`<leader>gp`** - Preview git hunk
- `n` **`<leader>gb`** - Toggle line blame

#### Todo Comments (todo.lua Lines 16-26)
- `n` **`<leader>J`** - Next todo comment
- `n` **`<leader>K`** - Previous todo comment
- `n` **`<leader>T`** - Open todos in Telescope

#### Trouble (trouble.lua Lines 5-36)
- `n` **`<leader>xx`** - Toggle diagnostics
- `n` **`<leader>xX`** - Toggle buffer diagnostics
- `n` **`<leader>cs`** - Toggle symbols
- `n` **`<leader>cl`** - Toggle LSP definitions/references
- `n` **`<leader>xL`** - Toggle location list
- `n` **`<leader>xQ`** - Toggle quickfix list

#### Comments (comments.lua Line 34)
- `n` **`<leader>/`** - Insert comment line and enter insert mode

#### LuaSnip (luasnip.lua Lines 22-62)
- `i/s` **`<Tab>`** - Expand or jump forward in snippet
- `i/s` **`<S-Tab>`** - Jump backward in snippet
- `i` **`<C-n>`** - Next choice in snippet **CONFLICT with completion!**
- `i` **`<C-p>`** - Previous choice in snippet

#### Completions (completions.lua Lines 63-69)
- `i` **`<C-b>`** - Scroll docs backward
- `i` **`<C-f>`** - Scroll docs forward
- `i` **`<C-Space>`** - Trigger completion
- `i` **`<C-e>`** - Abort completion
- `i` **`<C-y>`** - Confirm completion

#### Telescope Undo (telescope-undo.lua Line 11)
- `n` **`<leader>u`** - Open undo history

#### Leap Motion (leap.lua)
- Creates default mappings (likely `s`, `S`, `gs` in various modes)

### Raw Keybinds (from raw_keybinds.txt)
Additional keybindings found that might be set by plugins or defaults:
- Various vim-surround mappings (`cs`, `ds`, `ys`, etc.)
- vim-visual-multi mappings (`<C-n>`, `<C-Up>`, `<C-Down>`, etc.)
- Comment.nvim mappings (`gc`, `gcc` in various modes)
- Alpha dashboard mappings (single letter commands in dashboard)

## Identified Conflicts

### Critical Conflicts:
1. **`<leader>p`** - Defined twice:
   - Line 46: Paste with indent (using custom command)
   - Line 157: Delete and paste without register loss
   
2. **`<leader>e`** - Defined twice:
   - vim-options.lua:126: Previous diagnostic
   - lsp-config.lua:190: Open diagnostic float

3. **`<leader>r`** - Potential conflict:
   - vim-options.lua:125: Next diagnostic
   - telescope.lua might use for oldfiles

4. **`K` vs `<S-k>`** conflict:
   - `K`: LSP hover (standard)
   - `<S-k>`: Move line up (custom)

5. **`<C-k>` - Triple conflict:**
   - Window navigation up
   - LSP signature help
   - Used in various contexts

6. **`<C-n>` conflict:**
   - LuaSnip next choice
   - vim-visual-multi find under cursor

7. **`<S-l>` and `<S-h>`** - Potential conflict:
   - BufferLine navigation
   - Could conflict with standard vim behavior

8. **`<leader>F`** - Case sensitivity issue:
   - `<leader>F`: Diagnostic float
   - `<leader>f`: Format (LSP)

## Recommendations

1. **Fix `<leader>p` conflict** - Use different key for one of the paste operations
2. **Fix `<leader>e` conflict** - Use different key for diagnostics
3. **Consider using `<leader>h` for hover instead of overriding `K`**
4. **Use `<leader>k` for signature help instead of `<C-k>`**
5. **Review the `<S-j>` and `<S-k>` line movement** - These override useful vim defaults
6. **Consider namespacing keybindings** better (e.g., all git under `<leader>g`, all LSP under `<leader>l`)

## File Organization
- Core keybindings: `vim-options.lua` and `init.lua`
- LSP keybindings: `lsp-config.lua`
- Plugin-specific: Individual plugin files
- Raw keybinds reference: `raw_keybinds.txt` (appears to be output from `:map`)