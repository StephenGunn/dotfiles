return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    
    -- Use the new spec format
    wk.add({
      -- Normal mode mappings
      { "<leader>s", ":w<CR>", desc = "Save file" },
      { "<leader>w", ":bd<CR>", desc = "Close buffer" },
      { "<leader>W", ':silent! execute "%bd\\|e#\\|bd#"<CR>', desc = "Close all other buffers" },
      { "<leader>Q", ":bw<CR>", desc = "Force close buffer" },
      
      -- Paste operations
      { "<leader>p", '"+]p', desc = "Paste indented" },
      { "<leader>P", '"+]P', desc = "Paste before indented" },
      { "<leader><leader>p", '"_dP', desc = "Paste over selection (keep register)" },
      { "<leader>fp", "+p", desc = "Paste without indent" },
      { "<leader>fP", "+P", desc = "Paste before without indent" },
      
      -- Indentation controls
      { "<Tab>", ">>", desc = "Indent line" },
      { "<S-Tab>", "<<", desc = "Unindent line" },
      
      -- Search and replace
      { "<leader>z", [[:%s/<C-R><C-W>/<C-R>0/g<CR>]], desc = "Replace word under cursor" },
      
      -- Quickfix
      { "<leader>o", ":copen<CR>", desc = "Open quickfix" },
      { "<leader>j", ":cn<CR>:cclose<CR>:only<CR>", desc = "Next quickfix" },
      { "<leader>k", ":cp<CR>:cclose<CR>:only<CR>", desc = "Previous quickfix" },
      
      -- Diagnostics
      { "<leader>e", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
      { "<leader>r", vim.diagnostic.goto_next, desc = "Next diagnostic" },
      { "<leader>E", ":lua YankDiagnosticError()<CR>", desc = "Copy diagnostic error" },
      { "<leader>F", vim.diagnostic.open_float, desc = "Diagnostic float" },
      
      -- Delete operations
      { "<leader>d", '"_d', desc = "Delete (no register)" },
      { "<leader>dd", '"_dd', desc = "Delete line (no register)" },
      
      -- LSP
      { "<leader>rn", vim.lsp.buf.rename, desc = "Rename symbol" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
      
      -- Telescope
      { "<leader>t", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>a", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>u", "<cmd>Telescope undo<cr>", desc = "Undo history" },
      
      -- Git group
      { "<leader>g", group = "git" },
      { "<leader>gg", "<cmd>lazygit<cr>", desc = "LazyGit" },
      { "<leader>gp", ":Gitsigns preview_hunk<CR>", desc = "Preview hunk" },
      { "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", desc = "Toggle blame" },
      { "<leader>gf", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>ga", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", desc = "Live grep with args" },
      
      -- Find group
      { "<leader>f", group = "find" },
      { "<leader>fr", "<cmd>Telescope lsp_references<cr>", desc = "Find references" },
      
      -- TypeScript/Imports group
      { "<leader>i", group = "imports" },
      { "<leader>i<Space>", function()
        vim.lsp.buf.code_action({
          filter = function(action)
            return action.title and action.title:match("Add import from")
          end,
          apply = true,
        })
      end, desc = "Add import" },
      { "<leader>io", "<cmd>TSToolsOrganizeImports<cr>", desc = "Organize imports" },
      { "<leader>is", "<cmd>TSToolsSortImports<cr>", desc = "Sort imports" },
      { "<leader>iu", "<cmd>TSToolsRemoveUnusedImports<cr>", desc = "Remove unused imports" },
      { "<leader>ia", "<cmd>TSToolsAddMissingImports<cr>", desc = "Add all missing imports" },
      { "<leader>if", "<cmd>TSToolsFixAll<cr>", desc = "Fix all auto-fixable" },
      { "<leader>ir", "<cmd>TSToolsRemoveUnused<cr>", desc = "Remove unused statements" },
      { "<leader>id", "<cmd>TSToolsGoToSourceDefinition<cr>", desc = "Go to source definition" },
      { "<leader>iR", "<cmd>TSToolsFileReferences<cr>", desc = "Find file references" },
      { "<leader>iF", "<cmd>TSToolsRenameFile<cr>", desc = "Rename file & update imports" },
      
      -- Todo comments
      { "<leader>J", function() require("todo-comments").jump_next() end, desc = "Next todo" },
      { "<leader>K", function() require("todo-comments").jump_prev() end, desc = "Previous todo" },
      { "<leader>T", "<cmd>TodoTelescope<cr>", desc = "Todo telescope" },
      
      -- Trouble group
      { "<leader>x", group = "trouble" },
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
      
      -- Code group
      { "<leader>c", group = "code" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP definitions" },
      
      -- Neo-tree
      { "<leader>n", ":Neotree filesystem toggle right<CR>", desc = "Toggle file tree" },
      { "<leader>N", ":Neotree filesystem reveal right<CR>", desc = "Reveal in tree" },
      
      -- Comments
      { "<leader>/", "o<ESC>k:normal gcc<CR>gi", desc = "New comment line" },
      
      -- HTML/Tags group  
      { "<leader>h", group = "html/tags" },
      { "<leader>ht", "vat", desc = "Select outer tag" },
      { "<leader>hi", "vit", desc = "Select inner tag" },
      { "<leader>hd", "dat", desc = "Delete outer tag" },
      { "<leader>hc", "cit", desc = "Change inner tag" },
      { "<leader>hC", "cat", desc = "Change outer tag" },
      
      -- Non-leader mappings
      { "gt", vim.lsp.buf.type_definition, desc = "Type definition" },
      { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
      { "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
      { "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
      { "gr", vim.lsp.buf.references, desc = "Find references" },
      
      { "K", vim.lsp.buf.hover, desc = "Hover documentation" },
      { "<C-k>", vim.lsp.buf.signature_help, desc = "Signature help" },

      -- Buffer navigation
      { "<S-l>", ":BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<S-h>", ":BufferLineCyclePrev<CR>", desc = "Previous buffer" },
      
      -- Line movement (in normal mode)
      { "<S-j>", ":m .+1<CR>==", desc = "Move line down" },
      -- Removed <S-k> to avoid conflict with K (hover)
      
      -- Window splits
      { "<C-PageDown>", ":vsplit<CR>", desc = "Vertical split" },
      { "<C-PageUp>", ":wincmd h<CR>", desc = "Go to left split" },
      
      -- Other
      { "<Esc>", ":nohlsearch<CR>", desc = "Clear search" },
      
      -- Treesitter navigation
      { ")", desc = "Next function/block start" },
      { "(", desc = "Previous function/block start" },
      { "]", desc = "Next function/block end" },
      { "[", desc = "Previous function/block end" },
      
      -- Visual and Visual Block mode keybindings (combined to avoid duplicates)
      { "<S-j>", ":move '>+1<CR>gv=gv", desc = "Move selection down", mode = {"v", "x"} },
      { "<S-k>", ":move '<-2<CR>gv=gv", desc = "Move selection up", mode = {"v", "x"} },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action", mode = {"v", "x"} },
      { "<leader>F", vim.diagnostic.open_float, desc = "Diagnostic float", mode = {"v", "x"} },
      { "<leader>r", vim.diagnostic.goto_next, desc = "Next diagnostic", mode = {"v", "x"} },
      { "<leader>e", vim.diagnostic.goto_prev, desc = "Previous diagnostic", mode = {"v", "x"} },
      { "<Tab>", ">gv", desc = "Indent selection", mode = {"v", "x"} },
      { "<S-Tab>", "<gv", desc = "Unindent selection", mode = {"v", "x"} },
      
      -- Insert mode keybindings
      { "<C-b>", function() require('cmp').scroll_docs(-4) end, desc = "Scroll docs back", mode = "i" },
      { "<C-f>", function() require('cmp').scroll_docs(4) end, desc = "Scroll docs forward", mode = "i" },
      { "<C-Space>", function() require('cmp').complete() end, desc = "Trigger completion", mode = "i" },
      { "<C-e>", function() require('cmp').abort() end, desc = "Abort completion", mode = "i" },
      { "<C-y>", function() require('cmp').confirm({ select = true }) end, desc = "Confirm completion", mode = "i" },
    })
  end,
}