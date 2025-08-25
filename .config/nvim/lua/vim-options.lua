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

-- Keybindings moved to which-key.lua
-- vim.api.nvim_set_keymap("n", "<Leader>p", ":PasteWithIndent<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<Leader>P", ":PasteWithIndentBefore<CR>", { noremap = true, silent = true })

-- Moved to which-key.lua
-- vim.api.nvim_set_keymap("n", "<leader>z", [[:%s/<C-R><C-W>/<C-R>0/g<CR>]], { noremap = true, silent = true })

-- Quickfix keybindings moved to which-key.lua
-- vim.api.nvim_set_keymap("n", "<leader>o", ":copen<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>j", ":cn<CR>:cclose<CR>:only<CR>", { noremap = true, silent = true })

-- Moved to which-key.lua
-- vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {})

-- Moved to which-key.lua
-- vim.api.nvim_set_keymap("n", "<leader>k", ":cp<CR>:cclose<CR>:only<CR>", { noremap = true, silent = true })

-- Buffer and file operations moved to which-key.lua
-- vim.api.nvim_set_keymap("n", "<leader>w", ":bd<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<leader>W", ':silent! execute "%bd\\|e#\\|bd#"<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>s", ":w<CR>", { noremap = true, silent = true })

-- enable sign column
vim.opt.signcolumn = "yes"

-- In the quickfix list, open the selected file in a full window
vim.cmd([[
    augroup quickfix_full_window
        autocmd!
        autocmd FileType qf nnoremap <buffer><silent> <CR> <CR>:cclose<CR>:only<CR>
    augroup END
]])

-- Line movement keybindings moved to which-key.lua
-- vim.api.nvim_set_keymap("n", "<S-k>", ":m .-2<CR>==", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<S-j>", ":m .+1<CR>==", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("x", "<S-k>", ":move '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Diagnostic error yanking moved to which-key.lua
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>E",
-- 	[[:lua YankDiagnosticError()<CR>]],
-- 	{ noremap = true, silent = true, desc = "Copy error" }
-- )

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

-- Moved to which-key.lua
-- vim.api.nvim_set_keymap("x", "<S-j>", ":move '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Diagnostics keybindings moved to which-key.lua
-- vim.keymap.set({ "n", "v" }, "<leader>F", vim.diagnostic.open_float, {})
-- vim.keymap.set({ "n", "v" }, "<leader>r", vim.diagnostic.goto_next, {})
-- vim.keymap.set({ "n", "v" }, "<leader>e", vim.diagnostic.goto_prev, {})

-- add clipboard support
vim.opt.clipboard = "unnamedplus"

-- change the active line number color to something a little brighter
vim.o.cursorline = true
vim.cmd([[highlight CursorLineNr guifg=#5c53bd guibg=NONE]])

-- Delete operations moved to which-key.lua
-- vim.api.nvim_set_keymap("n", "<leader>Q", ":bw<CR>", { silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>d", '"_d', { silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>dd", '"_dd', { silent = true })

-- Emmet configuration
vim.cmd([[
  let g:user_emmet_mode='i'
  let g:user_emmet_leader_key=','
]])

-- Window split keybindings moved to which-key.lua
-- vim.api.nvim_set_keymap("n", "<C-PageDown>", ":vsplit<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<C-PageUp>", ":wincmd h<CR>", { noremap = true, silent = true })

-- Moved to which-key.lua (as <leader><leader>p to avoid conflict)
-- vim.keymap.set("n", "<leader>p", '"_dP')

-- Window navigation moved to which-key.lua
-- vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
-- vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
-- vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
-- vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Buffer navigation moved to which-key.lua
-- vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>")
-- vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>")

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

-- Search highlight clearing moved to which-key.lua
-- vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })

-- Function to copy diagnostics to clipboard
local function copy_diagnostics_to_clipboard()
	-- Get diagnostics for the current buffer
	local diagnostics = vim.diagnostic.get(0)

	if vim.tbl_isempty(diagnostics) then
		print("No diagnostics found in the current buffer.")
		return
	end

	-- Prepare a table to hold formatted diagnostic messages
	local lines = {}

	for _, diag in ipairs(diagnostics) do
		-- Get severity as a string
		local severity = vim.diagnostic.severity[diag.severity] or "UNKNOWN"

		-- Format: [Severity] Line X: Message
		local line = string.format("[%s] Line %d: %s", severity, diag.lnum + 1, diag.message)
		table.insert(lines, line)
	end

	-- Concatenate all lines into a single string separated by newlines
	local diagnostics_text = table.concat(lines, "\n")

	-- Copy the text to the system clipboard
	-- Use the '+' register which is typically the system clipboard
	vim.fn.setreg("+", diagnostics_text)

	-- Optional: Notify the user
	print(string.format("Copied %d diagnostics to the clipboard.", #diagnostics))
end

-- Import keybinding moved to which-key.lua
-- vim.keymap.set("n", "<leader>i", function()
-- 	vim.lsp.buf.code_action({
-- 		filter = function(action)
-- 			-- Match the import action text pattern
-- 			return action.title and action.title:match("Add import from")
-- 		end,
-- 		apply = true,
-- 	})
-- end, { desc = "Auto add import" })

-- Create a user command to invoke the function
vim.api.nvim_create_user_command(
	"CopyDiagnostics",
	copy_diagnostics_to_clipboard,
	{ desc = "Copy all diagnostics from the current buffer to the clipboard" }
)

-- Function to copy messages to clipboard
local function copy_messages_to_clipboard()
	-- Get all messages
	local messages = vim.fn.execute("messages")
	
	-- Copy to system clipboard
	vim.fn.setreg("+", messages)
	
	-- Show confirmation
	vim.notify("Messages copied to clipboard!", vim.log.levels.INFO)
end

-- Create user command for copying messages
vim.api.nvim_create_user_command(
	"CopyMessages",
	copy_messages_to_clipboard,
	{ desc = "Copy all messages to the clipboard" }
)

-- Automatically set LuaRocks paths
local function add_luarocks_paths()
	local lua_path = vim.fn.system("luarocks path --lr-path"):gsub("\n", "")
	local lua_cpath = vim.fn.system("luarocks path --lr-cpath"):gsub("\n", "")

	-- Prepend LuaRocks paths
	package.path = package.path .. ";" .. lua_path
	package.cpath = package.cpath .. ";" .. lua_cpath
end

add_luarocks_paths()
