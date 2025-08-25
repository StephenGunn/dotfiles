# HTML/Svelte Development Tools in Neovim

## What You Already Have

### 1. **Emmet** (Currently configured)
- Trigger: `,` (comma) in insert mode after typing abbreviation
- Examples:
  ```
  div.container,    → <div class="container"></div>
  ul>li*3,         → <ul><li></li><li></li><li></li></ul>
  div#app>h1+p,    → <div id="app"><h1></h1><p></p></div>
  ```

### 2. **vim-surround** (You have this)
- `cs"'` - Change surrounding " to '
- `cst<div>` - Change surrounding tag to div
- `dst` - Delete surrounding tag
- `ysiw<em>` - Surround word with <em> tags
- `S<div>` in visual mode - Surround selection with div

### 3. **Text Objects for HTML**
- `vat` - Select around tag (including tags)
- `vit` - Select inside tag (content only)
- `dat` - Delete around tag
- `dit` - Delete inside tag
- `cat` - Change around tag
- `cit` - Change inside tag

### 4. **nvim-ts-autotag** (Just added)
- Auto closes HTML/JSX tags
- Auto renames closing tag when you rename opening tag
- Works in Svelte files

### 5. **New Keybindings Added**
- `<leader>ht` - Select outer tag
- `<leader>hi` - Select inner tag  
- `<leader>hd` - Delete outer tag
- `<leader>hc` - Change inner tag
- `<leader>hC` - Change outer tag

### 6. **Indentation Tools** (Just added)
- `<Tab>` / `<S-Tab>` - Indent/unindent in normal and visual mode
- `<leader>=` - Fix indentation in whole file
- `<leader>==` - Fix indentation in paragraph
- `==` - Fix indentation on current line
- `=ap` - Fix indentation in paragraph
- `gg=G` - Fix entire file indentation

### 7. **Fixed Paste with Indent**
- `<leader>p` - Paste after with auto-indent
- `<leader>P` - Paste before with auto-indent

## Common Svelte/HTML Workflows

### Quick Component Creation
1. Type: `div.component,` → `<div class="component"></div>`
2. Type: `script+style,` → Creates script and style tags

### Wrap Selection
1. Select text with `v` mode
2. Press `S<div class="wrapper">` → Wraps in div

### Change Tag Type
1. With cursor on tag: `cst<section>` → Changes to section tag

### Jump Between Tags
1. `%` - Jump between opening and closing tags
2. `[{` and `]}` - Jump to opening/closing braces

## Tips
- Use `.` to repeat last change (great with tag operations)
- Combine with `f` and `t` motions: `cf>` changes until next >
- Use `gn` to select next search match (great for batch edits)