-- none-ls config

return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
        -- Add other formatters as needed
      },
    })

    -- Set keymap for manual formatting
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, {})

    -- Function to determine if a file should be formatted
    local function should_format()
      -- Get the filename and file extension
      local filename = vim.fn.expand("%:t")
      local extension = vim.fn.expand("%:e")

      -- List of filenames and extensions to exclude from formatting
      local exclude_filenames = { ".env", ".bashrc", ".bash_profile", ".http" }
      local exclude_extensions = { "env", "http" }

      -- Check if the filename or extension is in the exclusion list
      return not vim.tbl_contains(exclude_filenames, filename)
          and not vim.tbl_contains(exclude_extensions, extension)
    end

    -- Automatically format code on save, excluding certain files
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function()
        if should_format() then
          vim.lsp.buf.format({ async = false })
        end
      end,
    })
  end,
}
