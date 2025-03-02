return {
	"preservim/vim-markdown",
	init = function()
		-- Enable syntax highlighting for code blocks
		vim.g.vim_markdown_fenced_languages = {
			"ts=typescript",
			"typescript=typescript",
		}
		-- Disable folding
		vim.g.vim_markdown_folding_disabled = 1
		-- Don't conceal syntax
		vim.g.vim_markdown_conceal = 0
	end,
	ft = { "markdown" },
}
