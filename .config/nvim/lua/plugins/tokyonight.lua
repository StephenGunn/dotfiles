return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			style = "night", -- Options: storm, moon, night, day
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		})
		-- Don't auto-apply, let theme-switcher control it
	end,
}
