return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      -- Prefer git for fetching parsers and use SSH instead of HTTPS
      require("nvim-treesitter.install").prefer_git = true

      -- Set the command used by Treesitter to clone repositories via SSH
      require("nvim-treesitter.install").command_extra_args = {}

      -- Adjust the repository URL to use SSH instead of HTTPS
      -- require("nvim-treesitter.install").url = function(repo)
      --   return string.format("git@github.com:%s", repo)
      -- end
      configs.setup({
        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        -- Ensure specific parsers are installed
        ensure_installed = {
          "svelte",
          "css",
          "scss",
          "typescript",
          "javascript",
          "json",
          "html",
          "lua",
          "http",
          "xml",
          "graphql",
          "elixir",
          "heex",
          "eex",
          "rust",
        },

        -- Parsers to ignore when installing all
        ignore_install = {},

        -- Enable tree-sitter based highlighting
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        -- Enable tree-sitter based indentation
        indent = { enable = true },

        -- Enable and configure incremental selection
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<c-backspace>",
          },
        },

        -- Enable and configure text objects
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },

        -- Enable auto-pairs integration (if using a compatible plugin)
        autopairs = {
          enable = true,
        },

        -- Enable autotagging of HTML tags (requires `windwp/nvim-ts-autotag` plugin)
        autotag = {
          enable = true,
        },

        -- Configure modules (new field requirement)
        modules = {}, -- This field can be customized if you use additional modules

        sync_install = false,
      })
    end,
  },
}
