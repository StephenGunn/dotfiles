return {
  {
    "nvim-svelte/nvim-svelte-check",
    config = function()
      require("svelte-check").setup({
        command = "pnpm run check", -- Default command for pnpm
      })
    end,
  },
}
