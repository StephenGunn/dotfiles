return {
	"catppuccin/nvim",
	name = "catppuccin",
	enabled = true, -- Re-enabled for native theme support
	priority = 1000,

	config = function()
		require("catppuccin").setup({
			flavour = "mocha", -- Set to Mocha flavour
			transparent_background = true, -- Transparent editor background
			integrations = {
				treesitter = true,
				nvimtree = true,
				bufferline = true, -- Enable bufferline integration
			},
			custom_highlights = function(colors)
				return {
					-- Ensure bufferline gets proper solid background
					BufferLineFill = { bg = colors.base }, -- Catppuccin base background
					BufferLineBackground = { bg = colors.base },
					TabLineFill = { bg = colors.base },
				}
			end,
			highlight_overrides = {
				mocha = {
					-- Keep UI elements with solid backgrounds
					Normal = { bg = "NONE" }, -- Transparent background for the main editing area
					LineNr = { bg = "NONE" }, -- Transparent background for line numbers (gutter)

					-- Optional: Set transparent background for cursor line
					-- CursorLine = { bg = "NONE" }, -- Makes the line highlight transparent

					-- Ensure that the rest of the UI elements are using default Catppuccin colors
				},
			},
		})

		-- Don't auto-apply, let theme-switcher control it
		-- vim.cmd.colorscheme("catppuccin")
	end,
}
