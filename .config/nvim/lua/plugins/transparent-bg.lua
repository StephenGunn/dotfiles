return {
	"xiyaowong/transparent.nvim",
	config = function()
		require("transparent").setup({
			-- Enable transparency globally
			enable = true,
			-- Exclude specific highlight groups from being made transparent
			extra_groups = {
				"BufferLineFill",
				"BufferLineBackground",
				"BufferLineBufferSelected",
				"BufferLineBufferVisible",
				"BufferLineModified",
				"BufferLineModifiedSelected",
				"BufferLineSeparator",
				"BufferLineSeparatorSelected",
				"BufferLineIndicatorSelected",
				-- You can add other highlight groups you want to keep opaque
			},
			-- You can also exclude other parts if needed:
			exclude = {},
		})
	end,
}
