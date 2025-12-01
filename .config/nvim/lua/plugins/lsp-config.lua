return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					-- "ts_ls", -- Now handled by typescript-tools.nvim
					"jsonls",
					"emmet_ls",
					"html",
					"cssls",
					"svelte",
					"ocamllsp",
					"tailwindcss",
					"somesass_ls",
					"elixirls",
					"rust_analyzer",
					"gopls",
					"marksman",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Lua LSP
			vim.lsp.config('lua_ls', {
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = {
								"vim",
								"require",
							},
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					},
				},
			})
			vim.lsp.enable('lua_ls')

			-- SASS LSP
			vim.lsp.config('somesass_ls', {
				capabilities = capabilities,
				filetypes = {
					"sass",
				},
			})
			vim.lsp.enable('somesass_ls')

			-- Tailwind CSS LSP
			vim.lsp.config('tailwindcss', {
				capabilities = capabilities,
			})
			vim.lsp.enable('tailwindcss')

			-- OCaml LSP
			vim.lsp.config('ocamllsp', {
				cmd = { "ocamllsp" },
				filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
				capabilities = capabilities,
			})
			vim.lsp.enable('ocamllsp')

			-- Markdown LSP
			vim.lsp.config('marksman', {
				capabilities = capabilities,
				filetypes = { "markdown", "markdown.mdx" },
			})
			vim.lsp.enable('marksman')

			-- Gleam LSP
			vim.lsp.config('gleam', {
				capabilities = capabilities,
			})
			vim.lsp.enable('gleam')

			-- Go LSP
			vim.lsp.config('gopls', {
				capabilities = capabilities,
			})
			vim.lsp.enable('gopls')

			-- JSON LSP
			vim.lsp.config('jsonls', {
				capabilities = capabilities,
			})
			vim.lsp.enable('jsonls')

			-- HTML LSP
			vim.lsp.config('html', {
				capabilities = capabilities,
				filetypes = {
					"html",
					"liquid",
				},
			})
			vim.lsp.enable('html')

			-- CSS LSP
			vim.lsp.config('cssls', {
				capabilities = capabilities,
				settings = {
					css = {
						validate = true,
						lint = {
							unknownAtRules = "ignore",
						},
					},
					scss = {
						validate = true,
						lint = {
							unknownAtRules = "ignore",
						},
					},
					less = {
						validate = true,
						lint = {
							unknownAtRules = "ignore",
						},
					},
				},
			})
			vim.lsp.enable('cssls')

			-- Svelte LSP
			local svelte_lsp_capabilities = vim.tbl_deep_extend("force", {}, capabilities)
			svelte_lsp_capabilities.workspace = { didChangeWatchedFiles = false }
			vim.lsp.config('svelte', {
				capabilities = svelte_lsp_capabilities,
				filetypes = { "svelte" },
				settings = {
					svelte = {
						plugin = {
							svelte = {
								defaultScriptLanguage = "ts",
							},
						},
					},
				},
			})
			vim.lsp.enable('svelte')

			-- Emmet LSP
			vim.lsp.config('emmet_ls', {
				capabilities = capabilities,
				filetypes = {
					"html",
					"css",
					"svelte",
					"scss",
					"less",
				},
				init_options = {
					html = {
						options = {
							["bem.enabled"] = true,
							["output.inlineBreak"] = 1,
						},
					},
				},
			})
			vim.lsp.enable('emmet_ls')

			-- Elixir LSP
			vim.lsp.config('elixirls', {
				capabilities = capabilities,
				cmd = { "elixir-ls" },
				on_attach = function(client)
					if client.server_capabilities.documentFormattingProvider then
						vim.cmd([[
            augroup LspFormatting
              autocmd! * <buffer>
              autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
            augroup END
          ]])
					end
				end,
			})
			vim.lsp.enable('elixirls')

			-- LSP keybindings moved to which-key.lua
			-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
			-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			-- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			-- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
			-- vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, {})
			-- vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			-- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
			-- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
			-- vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
