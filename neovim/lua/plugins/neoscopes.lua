return {
	"smartpde/neoscopes",
	-- Optionally, install telescope for nicer scope selection UI.
	dependencies = { "nvim-telescope/telescope.nvim" },
	config = function()
		local scopes = require("neoscopes")
		scopes.add({
			name = "conspiracy",
			dirs = {
				"~/Projects/conspiracy/front",
				"~/Projects/conspiracy/back",
			},
		})
		-- Select the current scope with telescope (if installed) or native UI
		-- otherwise.
		vim.api.nvim_set_keymap("n", "<Leader>fs", [[<cmd>lua require("neoscopes").select()<CR>]], { noremap = true })
	end,
}
