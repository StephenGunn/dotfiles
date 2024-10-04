return {
	{
		"nvchad/volt",
		lazy = true,
	},
	{
		"nvchad/minty",
		lazy = true,
		config = function()
			-- Open huefy and shades with default settings
			require("minty.huefy").open()
			require("minty.shades").open()

			-- Optional configurations
			require("minty.huefy").open({ border = true }) -- Open huefy with border
			require("minty.shades").open({ border = true }) -- Open shades without border
		end,
	},
}
