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

      lspconfig.lua_ls.setup({
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
      lspconfig.somesass_ls.setup({
        capabilities = capabilities,
        filetypes = {
          "sass",
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
      lspconfig.tsserver.setup({
        capabilities = capabilities,
      })

      -- Svelte LSP
      local lsp_capabilities = vim.lsp.protocol.make_client_capabilities() --or whatever your setup requires
      lsp_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
      -- whatever your other plugin requires, for example:
      -- lsp_capabilities.textDocument.completion = require('cmp_nvim_lsp').default_capabilities().textDocument.completion

      lspconfig.svelte.setup({
        capabilities = lsp_capabilities,
        on_attach = function(client, bufnr)
          if client.name == "svelte" then
            vim.api.nvim_create_autocmd("BufWritePost", {
              pattern = { "*.js", "*.ts" },
              group = vim.api.nvim_create_augroup("svelte_ondidchangetsorjsfile", { clear = true }),
              callback = function(ctx)
                -- Here use ctx.match instead of ctx.file
                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
              end,
            })
          end

          -- attach keymaps if needed
        end,
      })
      lspconfig.emmet_ls.setup({
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
}
