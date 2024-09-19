return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,

  config = function()
    require("catppuccin").setup({
      flavour = "mocha",          -- Choose your preferred flavour
      transparent_background = true, -- Enable transparent background
      -- You can include other configuration options here
      integrations = {
        -- Enable integrations for plugins you use
        treesitter = true,
        nvimtree = true,
        -- Add more integrations as needed
      },
    })
    -- Set the colorscheme after setting up Catppuccin
    vim.cmd.colorscheme("catppuccin")
  end,
}
