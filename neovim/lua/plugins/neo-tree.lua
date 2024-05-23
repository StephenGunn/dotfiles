return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    vim.keymap.set("n", "<leader>N", ":Neotree reveal right<CR>")
    vim.keymap.set("n", "<leader>n", ":Neotree toggle right<CR>")

    require("neo-tree").setup({
      auto_open = true,
      update_to_buf_dir = {
        enable = true,
      },
      update_cwd = true,
      view = {
        width = 35,
        side = "right",
        auto_resize = true,
      },
      filesystem = {
        follow_current_file = { enable = true },
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            ".github",
            ".gitignore",
            "package-lock.json",
          },
          never_show = { ".git" },
        },
      },
    })
  end,
}
