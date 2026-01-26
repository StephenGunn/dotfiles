return {
	"neanias/everforest-nvim",
	version = false,
	lazy = false,
	priority = 1000,
	config = function()
		require("everforest").setup({
			background = "hard", -- Options: hard, medium, soft
			transparent_background_level = 2, -- 0 = opaque, 1 = medium, 2 = full transparency
			italics = false,
			disable_italic_comments = false,
		})
		-- Don't auto-apply, let theme-switcher control it
	end,
}
