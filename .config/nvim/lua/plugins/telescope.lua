return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { 
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
		},
		config = function()
			local builtin = require("telescope.builtin")
			-- Keybindings moved to which-key.lua
			-- vim.keymap.set("n", "<leader>t", builtin.find_files, {})
			-- vim.keymap.set("n", "<leader>gf", builtin.live_grep, {})
			--
			-- -- add keybind to see function references in telescope
			-- vim.keymap.set(
			-- 	"n",
			-- 	"<leader>fr",
			-- 	require("telescope.builtin").lsp_references,
			-- 	{ noremap = true, silent = true },
			-- 	-- add keybind to show buffer symbols in telescope
			-- 	vim.keymap.set(
			-- 		"n",
			-- 		"<leader>a",
			-- 		"<Cmd>lua require('telescope.builtin').lsp_document_symbols({show_line = true})<CR>",
			-- 		{ desc = "search lsp document tree" }
			-- 	)
			-- )
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				pickers = {
					find_files = {
						hidden = true,
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					},
					live_grep_args = {
						auto_quoting = true, -- enable/disable auto-quoting
						-- define mappings, e.g.
						mappings = { -- extend mappings
							i = {
								["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
								["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }),
							},
						},
					},
				},
			})
			require("telescope").load_extension("ui-select")
			require("telescope").load_extension("live_grep_args")
		end,
	},
}
