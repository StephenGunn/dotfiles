return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,

	config = function()
		require("catppuccin").setup({
			flavour = "mocha", -- Set to Mocha flavour
			transparent_background = false, -- Disable global transparency
			integrations = {
				treesitter = true,
				nvimtree = true,
				bufferline = true, -- Enable bufferline integration with default Catppuccin colors
			},
			highlight_overrides = {
				mocha = {
					-- Make only the editing area and the line number column transparent
					BufferLineFill = { bg = "#1b1b29" }, -- Even darker background for the bufferline fill area
					Normal = { bg = "NONE" }, -- Transparent background for the main editing area
					LineNr = { bg = "NONE" }, -- Transparent background for line numbers (gutter)

					-- Optional: Set transparent background for cursor line
					-- CursorLine = { bg = "NONE" }, -- Makes the line highlight transparent

					-- Ensure that the rest of the UI elements are using default Catppuccin colors
				},
			},
		})

		-- Apply Catppuccin colorscheme
		vim.cmd.colorscheme("catppuccin")
	end,
}
