-- tab styles
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- basic vim options
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"
vim.opt.swapfile = false
vim.opt.scrolloff = 8
vim.o.autoindent = true
vim.o.smartindent = true

-- Function to paste with auto-indentation without affecting the default register
local function paste_with_indent()
  -- Temporarily enable paste mode to avoid unwanted auto-indentation during the paste
  vim.cmd("set paste")
  -- Paste from the system clipboard ('+ register) in normal mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('"+p', true, false, true), "n", false)
  -- Disable paste mode after pasting
  vim.cmd("set nopaste")
  -- Reselect the pasted text and indent it
  vim.cmd("normal! `[v`]=")
end

-- Function to paste before the current line with auto-indentation without affecting the default register
local function paste_with_indent_before()
  -- Temporarily enable paste mode to avoid unwanted auto-indentation during the paste
  vim.cmd("set paste")
  -- Paste from the system clipboard ('+ register) before the current line in normal mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('"+P', true, false, true), "n", false)
  -- Disable paste mode after pasting
  vim.cmd("set nopaste")
  -- Reselect the pasted text and indent it
  vim.cmd("normal! `[v`]=")
end

-- Create user commands to call the functions
vim.api.nvim_create_user_command("PasteWithIndent", paste_with_indent, {})
vim.api.nvim_create_user_command("PasteWithIndentBefore", paste_with_indent_before, {})

-- Keybinding to paste with auto-indentation without affecting the default register
vim.api.nvim_set_keymap("n", "<Leader>p", ":PasteWithIndent<CR>", { noremap = true, silent = true })

-- Keybinding to paste before the current line with auto-indentation without affecting the default register
vim.api.nvim_set_keymap("n", "<Leader>P", ":PasteWithIndentBefore<CR>", { noremap = true, silent = true })

-- Define the keymap for replacing the current word under the cursor with what ever is in the first register
vim.api.nvim_set_keymap("n", "<leader>z", [[:%s/<C-R><C-W>/<C-R>0/g<CR>]], { noremap = true, silent = true })

-- Open the quickfix list
vim.api.nvim_set_keymap("n", "<leader>o", ":copen<CR>", { noremap = true, silent = true })

-- Open the next file in the quickfix list in a full window
vim.api.nvim_set_keymap("n", "<leader>j", ":cn<CR>:cclose<CR>:only<CR>", { noremap = true, silent = true })

-- Open the previous file in the quickfix list in a full window
vim.api.nvim_set_keymap("n", "<leader>k", ":cp<CR>:cclose<CR>:only<CR>", { noremap = true, silent = true })

-- shortcut to close current buffer
vim.api.nvim_set_keymap("n", "<leader>w", ":bd<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>W", ":bd!<CR>", { noremap = true, silent = true })

-- shortcut to save --
vim.api.nvim_set_keymap("n", "<leader>s", ":w<CR>", { noremap = true, silent = true })

-- enable sign column
vim.opt.signcolumn = "yes"

-- In the quickfix list, open the selected file in a full window
vim.cmd([[
    augroup quickfix_full_window
        autocmd!
        autocmd FileType qf nnoremap <buffer><silent> <CR> <CR>:cclose<CR>:only<CR>
    augroup END
]])

-- move lines up and down
vim.api.nvim_set_keymap("n", "<S-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-j>", ":m .+1<CR>==", { noremap = true, silent = true })

-- Move selected block of lines up
vim.api.nvim_set_keymap("x", "<S-k>", ":move '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Set a key mapping in normal mode to yank the diagnostic error
vim.api.nvim_set_keymap(
  "n",
  "<leader>E",
  [[:lua YankDiagnosticError()<CR>]],
  { noremap = true, silent = true, desc = "Copy error" }
)

function YankDiagnosticError()
  -- Get the diagnostics for the current cursor position
  local diagnostics = vim.diagnostic.get()

  if #diagnostics == 0 then
    print("No diagnostics found at the cursor position.")
    return
  end

  -- Extract the first diagnostic message
  local diagnostic_message = diagnostics[1].message

  -- Optionally, you could yank it to a specific register like the `+` register (clipboard) with:
  vim.fn.setreg("+", diagnostic_message)

  -- Print a confirmation message
  print("Error has been yanked: " .. diagnostic_message)
end

-- Move selected block of lines down
vim.api.nvim_set_keymap("x", "<S-j>", ":move '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Set up diagnostics
vim.keymap.set({ "n", "v" }, "<leader>F", vim.diagnostic.open_float, {})
vim.keymap.set({ "n", "v" }, "<leader>r", vim.diagnostic.goto_next, {})
vim.keymap.set({ "n", "v" }, "<leader>e", vim.diagnostic.goto_prev, {})

-- add clipboard support
vim.opt.clipboard = "unnamedplus"

-- change the active line number color to something a little brighter
vim.o.cursorline = true
vim.cmd([[highlight CursorLineNr guifg=#5c53bd guibg=NONE]])

-- Quickly close the current buffer
vim.api.nvim_set_keymap("n", "<leader>Q", ":bw<CR>", { silent = true })

-- Delete word without adding to register
vim.api.nvim_set_keymap("n", "<leader>d", '"_d', { silent = true })

-- Delete line without adding to register
vim.api.nvim_set_keymap("n", "<leader>dd", '"_dd', { silent = true })

-- Emmet configuration
vim.cmd([[
  let g:user_emmet_mode='i'
  let g:user_emmet_leader_key=','
]])

-- Rebind Ctrl + PageDown to move the current buffer to a new vertical split and close the original buffer
vim.api.nvim_set_keymap("n", "<C-PageDown>", ":vsplit<CR>", { noremap = true, silent = true })

-- Rebind Ctrl + PageUp to move the current buffer to the left split
vim.api.nvim_set_keymap("n", "<C-PageUp>", ":wincmd h<CR>", { noremap = true, silent = true })

-- delete the selected text and paste, where you don't lose your copied text
vim.keymap.set("n", "<leader>p", '"_dP')

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Jump between buffers
vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>")
vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>")

-- Visualize space character in the indent
vim.cmd("set list")
vim.cmd("set lcs+=space:·")

-- default terminal
vim.g.terminal = "tmux-256color"
-- colors
vim.o.termguicolors = true

-- Set the highlight color for function scopes
vim.api.nvim_set_hl(0, "TSFunction", { fg = "#FFD700", bg = "NONE", bold = true })

-- Set the highlight color for method scopes
vim.api.nvim_set_hl(0, "TSMethod", { fg = "#ADFF2F", bg = "NONE", bold = true })

-- Set the highlight color for parameter scopes
vim.api.nvim_set_hl(0, "TSParameter", { fg = "#1E90FF", bg = "NONE", italic = true })

-- Change the color of the indent character
vim.cmd("highlight IndentChar guifg=#4b5263")

-- Bind Esc to clear search highlights
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })
