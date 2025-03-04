-- Set up logging function
local function log_event(msg)
	vim.fn.writefile({ os.date("%H:%M:%S") .. ": " .. msg }, "/tmp/nvim_shutdown.log", "a")
end

-- Initial startup log
log_event("Starting Neovim initialization...")

-- Set the path where lazy.nvim will be installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Log pre-shutdown
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		log_event("VimLeavePre triggered")
	end,
})

-- make .svx get treated as .md files --
vim.filetype.add({
	extension = {
		svx = "markdown",
	},
})

-- Log actual leave
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		log_event("VimLeave triggered")
	end,
})

-- Log when lazy starts shutting down
vim.api.nvim_create_autocmd("User", {
	pattern = "LazyLoad",
	callback = function(event)
		log_event("LazyLoad: " .. vim.inspect(event.data))
	end,
})

-- Log lazy completion
vim.api.nvim_create_autocmd("User", {
	pattern = "LazyDone",
	callback = function()
		log_event("LazyDone triggered")
	end,
})

-- Add logging for buffer cleanup
vim.api.nvim_create_autocmd("BufUnload", {
	callback = function(ev)
		log_event("Buffer unloading: " .. ev.buf)
	end,
})

-- Rest of your init code
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

-- Log before loading options
log_event("Loading vim-options...")
require("vim-options")

-- Log before lazy setup
log_event("Starting lazy plugin setup...")
require("lazy").setup("plugins", {
	-- Add change handler for more logging
	change = function()
		log_event("Lazy plugin state changed")
	end,
})

vim.g.python3_host_prog = "/usr/bin/python3"
log_event("Initialization complete")

-- () for navigating to the START of code blocks and functions
vim.keymap.set("n", ")", function()
	local ts_move = require("nvim-treesitter.textobjects.move")
	-- Try function start first, then block start
	local ok = pcall(ts_move.goto_next_start, "@function.outer")
	if not ok then
		pcall(ts_move.goto_next_start, "@block.outer")
	end
end, { desc = "Next block/function start" })

vim.keymap.set("n", "(", function()
	local ts_move = require("nvim-treesitter.textobjects.move")
	-- Try function start first, then block start
	local ok = pcall(ts_move.goto_previous_start, "@function.outer")
	if not ok then
		pcall(ts_move.goto_previous_start, "@block.outer")
	end
end, { desc = "Previous block/function start" })

-- [] for navigating to the END of code blocks and functions
vim.keymap.set("n", "]", function()
	local ts_move = require("nvim-treesitter.textobjects.move")
	-- Try function end first, then block end
	local ok = pcall(ts_move.goto_next_end, "@function.outer")
	if not ok then
		pcall(ts_move.goto_next_end, "@block.outer")
	end
end, { desc = "Next block/function end" })

vim.keymap.set("n", "[", function()
	local ts_move = require("nvim-treesitter.textobjects.move")
	-- Try function end first, then block end
	local ok = pcall(ts_move.goto_previous_end, "@function.outer")
	if not ok then
		pcall(ts_move.goto_previous_end, "@block.outer")
	end
end, { desc = "Previous block/function end" })
