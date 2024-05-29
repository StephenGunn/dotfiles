-- lsp_config.lua
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
          "tsserver",
          "jsonls",
          "emmet_ls",
          "html",
          "cssls",
          "svelte",
          "somesass_ls",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      lspconfig.tsserver.setup({
        capabilities = capabilities,
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.somesass_ls.setup({
        capabilities = capabilities,
        filetypes = {
          "sass",
          "svelte",
        },
      })
      lspconfig.jsonls.setup({
        capabilities = capabilities,
      })
      lspconfig.html.setup({
        capabilities = capabilities,
      })
      lspconfig.cssls.setup({
        capabilities = capabilities,
      })
      lspconfig.svelte.setup({
        capabilities = capabilities,
        settings = {
          svelte = {
            plugin = {
              sass = {
                enable = true,
                diagnostics = true,
                lint = true,
              },
            },
          },
        },
      })
      lspconfig.emmet_ls.setup({
        capabilities = capabilities,
        filetypes = {
          "html",
          "typescriptreact",
          "javascriptreact",
          "css",
          "svelte",
          "scss",
          "less",
          "javascript",
          "typescript",
          "vue",
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

      -- Additional keybindings for LSP
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, {})
      vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
  {
    -- Plugin for SASS syntax highlighting
    "cameron-wags/rainbow_csv.nvim",
    config = function()
      vim.cmd([[
        autocmd BufNewFile,BufRead *.sass set syntax=sass
      ]])
    end,
  },
}
