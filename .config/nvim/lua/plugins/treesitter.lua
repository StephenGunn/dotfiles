return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			local parsers = require("nvim-treesitter.parsers")

			-- Prefer git for fetching parsers and use SSH instead of HTTPS
			require("nvim-treesitter.install").prefer_git = true
			require("nvim-treesitter.install").command_extra_args = {}

			-- Fix nvim-treesitter's markdown injection directive for Neovim 0.11+.
			-- In newer Neovim, match[capture_id] is a list of TSNodes, not a single
			-- node; the { all = false } compat shim was removed in 0.12, so
			-- nvim-treesitter's directive crashes with `attempt to call method 'range'
			-- (a nil value)` on markdown files containing fenced code blocks with a
			-- language info string (e.g. ```ts). nvim-treesitter master is archived,
			-- so we patch the directive here.
			vim.treesitter.query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
				local nodes = match[pred[2]]
				local node = type(nodes) == "table" and nodes[1] or nodes
				if not node then
					return
				end
				local alias = vim.treesitter.get_node_text(node, bufnr):lower()
				local aliases = { ex = "elixir", pl = "perl", sh = "bash", ts = "typescript", uxn = "uxntal" }
				local ft = vim.filetype.match({ filename = "a." .. alias })
				metadata["injection.language"] = ft or aliases[alias] or alias
			end, { force = true })

			-- Add custom query for code title syntax
			local query = [[
				(fenced_code_block
				(info_string) @language
				(#match? @language "^(typescript):.*$"))
			]]
			vim.treesitter.query.set("markdown", "highlights", query)

			-- Add custom highlight group for code titles
			vim.api.nvim_set_hl(0, "CodeTitle", { fg = "#61afef", bold = true })

			-- Configure parser for markdown with typescript
			local parser_config = parsers.get_parser_configs()
			parser_config.markdown.filetype_to_parsername =
				vim.tbl_extend("force", parser_config.markdown.filetype_to_parsername or {}, {
					markdown = "markdown",
					typescript = "typescript",
				})

			configs.setup({
				auto_install = true,
				ensure_installed = {
					"svelte",
					"css",
					"scss",
					"typescript",
					"javascript",
					"json",
					"html",
					"lua",
					"http",
					"xml",
					"graphql",
					"elixir",
					"heex",
					"eex",
					"markdown",
					"markdown_inline",
				},
				ignore_install = {},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "markdown" },
				},
				parser_config = {
					markdown = {
						additional_vim_regex_highlighting = { "markdown" },
						enable = true,
						fenced_code_blocks = {
							enable = true,
							extended_info = true,
						},
					},
					typescript = {
						install_info = {
							url = "https://github.com/tree-sitter/tree-sitter-typescript",
							files = { "src/parser.c", "src/scanner.c" },
						},
						filetype = { "typescript", "typescript.tsx" },
						used_by = { "javascript", "tsx" },
					},
				},
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<c-backspace>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
					},
				},
				autopairs = {
					enable = true,
				},
				modules = {},
				sync_install = false,
			})

			-- Add filetype detection for code title syntax
			vim.filetype.add({
				pattern = {
					[".*%.ts"] = function(_, bufnr)
						local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
						if first_line and first_line:match("^```typescript:") then
							return "typescript"
						end
						return "typescript"
					end,
				},
			})

			-- Add syntax highlighting for code titles in markdown files
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function()
					vim.fn.matchadd("CodeTitle", "```typescript:\\S\\+")
				end,
			})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
