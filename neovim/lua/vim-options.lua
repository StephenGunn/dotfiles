-- tab styles
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- auto indent
vim.cmd("set autoindent")
vim.cmd("set smartindent")

-- basic vim options
vim.g.mapleader  = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"

-- add clipboard support
vim.opt.clipboard = "unnamedplus"


-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

-- Jump between buffers
vim.keymap.set('n', '<S-l>', ':BufferLineCycleNext<CR>')
vim.keymap.set('n', '<S-h>', ':BufferLineCyclePrev<CR>')

-- Visualize space character in the indent
vim.cmd("set list")
vim.cmd("set lcs+=space:·")

-- default terminal
vim.g.terminal = "tmux-256color"
-- colors
vim.o.termguicolors = true

-- Set the highlight color for function scopes
vim.api.nvim_set_hl(0, 'TSFunction', { fg = '#FFD700', bg = 'NONE', bold = true })

-- Set the highlight color for method scopes
vim.api.nvim_set_hl(0, 'TSMethod', { fg = '#ADFF2F', bg = 'NONE', bold = true })

-- Set the highlight color for parameter scopes
vim.api.nvim_set_hl(0, 'TSParameter', { fg = '#1E90FF', bg = 'NONE', italic = true })


-- Change the color of the indent character
vim.cmd("highlight IndentChar guifg=#4b5263")


-- Move lines up and down
vim.keymap.set('n', '<S-j>', ':m .+1<CR>==')
vim.keymap.set('n', '<S-k>', ':m .-1<CR>==')

-- Clear search highlights
vim.keymap.set('n', '<leader>c', ':nohlsearch<CR>')




