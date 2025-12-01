return {
	"dylanaraps/wal.vim",
	lazy = false,
	priority = 1000, -- Load before other plugins

	config = function()
		-- Apply wal colorscheme
		vim.cmd.colorscheme("wal")
	end,
}
