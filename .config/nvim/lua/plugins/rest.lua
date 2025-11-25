return {
  "rest-nvim/rest.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "http")
    end,
  },
  ft = "http",
  opts = {},
  config = function(_, opts)
    require("rest-nvim").setup(opts)

    -- Set up jq formatting for JSON in rest.nvim result buffers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "json",
      callback = function(ev)
        -- Only apply to buffers that look like rest.nvim results
        local bufname = vim.api.nvim_buf_get_name(ev.buf)
        if bufname == "" or bufname:match("rest_nvim_") then
          vim.bo[ev.buf].formatexpr = ""
          vim.bo[ev.buf].formatprg = "jq ."
        end
      end,
    })
  end,
}
