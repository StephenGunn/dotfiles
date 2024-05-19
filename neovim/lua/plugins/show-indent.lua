return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {},
  config = function()
    local hooks = require("ibl.hooks")

    -- Register hook for highlight setup
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "IndentLine", { fg = "#1e1e1e" })
      vim.api.nvim_set_hl(0, "ScopeLine", { fg = "#28203e" })
      vim.api.nvim_set_hl(0, "WhiteSpaceChar", { fg = "#232323" })
      vim.api.nvim_set_hl(0, "ScopeStartLine", { underline = true, sp = "#FF5733" }) -- Set underline for scope start
    end)

    -- Setup indent-blankline with custom highlight groups
    require("ibl").setup({
      indent = { highlight = { "IndentLine" } },
      whitespace = {
        highlight = { "WhiteSpaceChar" },
        remove_blankline_trail = false,
      },
      scope = {
        highlight = { "ScopeLine" },
        show_start = true,
      },
    })
  end,
}
