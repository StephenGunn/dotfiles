return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact", "svelte" },
  config = function()
    -- First, remove the ts_ls setup to avoid conflicts
    local lspconfig = require("lspconfig")

    require("typescript-tools").setup({
      settings = {
        -- spawn additional tsserver instance to calculate diagnostics on it
        separate_diagnostic_server = true,
        -- "change"|"insert_leave" determine when the client asks the server about diagnostic
        publish_diagnostic_on = "insert_leave",
        -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
        -- "remove_unused_imports"|"organize_imports") -- or string "all"
        expose_as_code_action = {
          "fix_all",
          "add_missing_imports",
          "remove_unused",
          "remove_unused_imports",
          "organize_imports",
        },
        -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
        -- memory limit in megabytes or "auto"(basically no limit)
        tsserver_max_memory = "auto",
        -- Formatting and preferences
        tsserver_format_options = {
          allowIncompleteCompletions = false,
          allowRenameOfImportPath = false,
        },
        tsserver_file_preferences = {
          includeInlayParameterNameHints = false,
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = false,
          includeInlayVariableTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = false,
          includeInlayFunctionLikeReturnTypeHints = false,
          includeInlayEnumMemberValueHints = false,
          includeCompletionsForModuleExports = true,
          quotePreference = "double",
          -- Import organization preferences
          importModuleSpecifierPreference = "shortest",
          includePackageJsonAutoImports = "auto",
          includeCompletionsWithSnippetText = true,
          includeAutomaticOptionalChainCompletions = true,
        },
        -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
        complete_function_calls = true,
        include_completions_with_insert_text = true,
      },
      -- Use the same capabilities as other LSPs
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      -- Add the same keymaps as other LSPs
      -- on_attach keybindings are now handled by which-key.lua globally
    })

    -- TypeScript keybindings moved to which-key.lua
    -- vim.keymap.set("n", "<leader>io", "<cmd>TSToolsOrganizeImports<cr>", { desc = "Organize imports" })
    -- vim.keymap.set("n", "<leader>is", "<cmd>TSToolsSortImports<cr>", { desc = "Sort imports" })
    -- vim.keymap.set("n", "<leader>iu", "<cmd>TSToolsRemoveUnusedImports<cr>", { desc = "Remove unused imports" })
    -- vim.keymap.set("n", "<leader>ia", "<cmd>TSToolsAddMissingImports<cr>", { desc = "Add all missing imports" })
    -- vim.keymap.set("n", "<leader>if", "<cmd>TSToolsFixAll<cr>", { desc = "Fix all auto-fixable issues" })
    -- vim.keymap.set("n", "<leader>ir", "<cmd>TSToolsRemoveUnused<cr>", { desc = "Remove all unused statements" })
    -- vim.keymap.set("n", "<leader>id", "<cmd>TSToolsGoToSourceDefinition<cr>", { desc = "Go to source definition" })
    -- vim.keymap.set("n", "<leader>iR", "<cmd>TSToolsFileReferences<cr>", { desc = "Find file references" })
    -- vim.keymap.set("n", "<leader>iF", "<cmd>TSToolsRenameFile<cr>", { desc = "Rename file and update imports" })
  end,
}

