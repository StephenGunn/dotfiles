return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        theme = "auto", -- Auto-detect theme from colorscheme
      },
      sections = {
        lualine_c = {
          {
            "filename",
            path = 1, -- Shows the full path to the file
          },
          {
            function()
              return vim.fn.getcwd() -- Returns the current working directory
            end,
            icon = "", -- Optional: add an icon for the CWD
          },
        },
      },
    })
  end,
}
