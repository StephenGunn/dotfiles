return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "VeryLazy",
  config = function()
    local hooks = require("ibl.hooks")

    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "IndentLine", { fg = "#32324b" })
      vim.api.nvim_set_hl(0, "ScopeLine", { fg = "#52527c" })
      vim.api.nvim_set_hl(0, "WhiteSpaceChar", { fg = "#32324b" })
      vim.api.nvim_set_hl(0, "ScopeStartLine", { underline = true, sp = "#FF5733" })
    end)
    require("ibl").setup({
      scope = {
        show_start = true,
        highlight = "ScopeLine",
      },
      indent = {
        char = "┊",
        tab_char = "┊",
        smart_indent_cap = true,
        highlight = "IndentLine",
      },
      whitespace = {
        highlight = { "WhiteSpaceChar" },
        remove_blankline_trail = true,
      },
    })
  end,
}
