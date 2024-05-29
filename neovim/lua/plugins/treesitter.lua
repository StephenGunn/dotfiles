-- treesitter_config.lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      ensure_installed = {
        "svelte",
        "css",
        "scss",
        "typescript",
        "javascript",
        "json",
        "html",
        "lua",
      },
    })
  end,
}
