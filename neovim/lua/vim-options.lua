-- tab styles
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- auto indent
vim.cmd("set autoindent")
vim.cmd("set smartindent")

-- basic vim options
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"

-- scrolloff
vim.opt.scrolloff = 6

-- Set up diagnostics
vim.keymap.set({ "n", "v" }, "<leader>F", vim.diagnostic.open_float, {})
vim.keymap.set({ "n", "v" }, "<leader>r", vim.diagnostic.goto_next, {})
vim.keymap.set({ "n", "v" }, "<leader>e", vim.diagnostic.goto_prev, {})

-- add clipboard support
vim.opt.clipboard = "unnamedplus"

-- change the active line number color to something a little brighter
vim.o.cursorline = true
vim.cmd([[highlight CursorLineNr guifg=#5c53bd guibg=NONE]])

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

-- Move lines up and down
vim.keymap.set("n", "<S-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<S-k>", ":m .-1<CR>==")

-- Clear search highlights
vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>")
