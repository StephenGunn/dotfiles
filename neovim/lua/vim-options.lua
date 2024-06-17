-- tab styles
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

-- Enable auto-indentation
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

-- basic vim options
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"
vim.opt.swapfile = false
-- scrolloff
vim.opt.scrolloff = 6

-- replace all instances --
-- Define the keymap for replacing the current word under the cursor
vim.api.nvim_set_keymap("n", "<leader>a", [[:lua replace_word_under_cursor()<CR>]], { noremap = true, silent = true })

-- Define the function to replace the word under the cursor
function replace_word_under_cursor()
	local current_word = vim.fn.expand("<cword>")
	local replacement = vim.fn.input('Replace "' .. current_word .. '" with: ')
	if replacement ~= "" then
		vim.cmd("%s/\\v<" .. current_word .. ">/" .. replacement .. "/g")
	end
end

-- move lines up and down
vim.api.nvim_set_keymap("n", "<S-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-j>", ":m .+1<CR>==", { noremap = true, silent = true })

-- Move selected block of lines up
vim.api.nvim_set_keymap("x", "<S-k>", ":move '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Move selected block of lines down
vim.api.nvim_set_keymap("x", "<S-j>", ":move '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Function to display diagnostics with their sources
local function show_diagnostics_with_source()
	-- Fetch diagnostics for the current buffer
	local bufnr = vim.api.nvim_get_current_buf()
	local diagnostics = vim.diagnostic.get(bufnr)

	if not diagnostics or #diagnostics == 0 then
		print("No diagnostics found")
		return
	end

	-- Iterate through diagnostics
	for _, diagnostic in ipairs(diagnostics) do
		-- Get the client ID from the diagnostic
		local client_id = diagnostic.client_id
		local lsp_client = vim.lsp.get_client_by_id(client_id)
		local source = lsp_client and lsp_client.name or "Unknown"
		local message = string.format("%s [%s]: %s", source, diagnostic.severity, diagnostic.message)

		-- Print the diagnostic message
		print(message)
	end
end

-- Command to run the function
vim.api.nvim_create_user_command("ShowDiagnosticsWithSource", show_diagnostics_with_source, {})

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

-- Clear search highlights
vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>")
