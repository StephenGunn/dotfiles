return {
	"folke/todo-comments.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	opts = {}, -- This uses the default settings
	config = function(_, opts)
		-- Initialize the plugin with default options
		require("todo-comments").setup(opts)

		-- Load telescope extension
		pcall(require("telescope").load_extension, "todo-comments")

		-- Keybindings moved to which-key.lua
		-- Set up key mappings
		-- vim.keymap.set("n", "<leader>J", function()
		-- 	require("todo-comments").jump_next()
		-- end, { desc = "Next todo comment" })
		--
		-- vim.keymap.set("n", "<leader>K", function()
		-- 	require("todo-comments").jump_prev()
		-- end, { desc = "Previous todo comment" })
		--
		-- vim.keymap.set("n", "<leader>T", function()
		-- 	vim.cmd("TodoTelescope")
		-- end, { desc = "Todo Telescope" })
	end,
}
