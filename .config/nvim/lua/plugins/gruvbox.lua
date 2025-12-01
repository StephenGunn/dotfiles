return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	enabled = true,
	config = function()
		require("gruvbox").setup({
			contrast = "", -- Use regular Gruvbox (not hard)
			transparent_mode = true, -- Transparent editor background
			dim_inactive = false,
			bold = true,
			italic = {
				strings = false,
				emphasis = false,
				comments = false,
				operators = false,
				folds = false,
			},
			overrides = {
				-- Keep bufferline and UI elements with solid backgrounds
				SignColumn = { bg = "NONE" },
				BufferLineFill = { bg = "#282828" }, -- Gruvbox background
				BufferLineBackground = { bg = "#282828" },
				TabLineFill = { bg = "#282828" },
			},
		})
	end,
}
