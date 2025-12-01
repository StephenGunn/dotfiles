return {
	"shaunsingh/nord.nvim",
	priority = 1000,
	enabled = true,
	config = function()
		vim.g.nord_contrast = true
		vim.g.nord_borders = false
		vim.g.nord_disable_background = true -- Transparent editor background
		vim.g.nord_italic = false
		vim.g.nord_uniform_diff_background = true
		vim.g.nord_bold = true

		-- Enable bufferline integration
		vim.g.nord_enable_sidebar_background = true -- Solid background for UI elements
	end,

	init = function()
		-- Set bufferline backgrounds after nord loads
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "nord",
			callback = function()
				vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "#2e3440" }) -- Nord background
				vim.api.nvim_set_hl(0, "BufferLineBackground", { bg = "#2e3440" })
				vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#2e3440" })
			end,
		})
	end,
}
