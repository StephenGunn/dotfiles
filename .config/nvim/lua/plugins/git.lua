return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed, not both.
			"nvim-telescope/telescope.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
		},
		config = true,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("gitsigns").setup()

			vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>")
			vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame <CR>")
		end,
	},
}
