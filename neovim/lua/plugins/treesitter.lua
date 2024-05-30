-- treesitter_config.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

      -- Ensure the custom query is registered
      parser_config.svelte = {
        install_info = {
          url = "https://github.com/Himujjal/tree-sitter-svelte", -- Replace with the correct URL if needed
          files = { "src/parser.c", "src/scanner.cc" },
        },
        filetype = "svelte",
      }

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
  },
}
