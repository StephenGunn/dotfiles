return {
	{
		"atiladefreitas/lazyclip",
		config = function()
			require("lazyclip").setup()
		end,
		keys = {
			{ "<leader>Cw", ":lua require('lazyclip').show_clipboard()<CR>", desc = "Open Clipboard Manager" },
		},
	},
}
