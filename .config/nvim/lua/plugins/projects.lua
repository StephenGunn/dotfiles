return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup({
      detection_methods = { "pattern", "lsp" },
      patterns = {
        "svelte.config.js",
        "package.json",
        "pnpm-workspace.yaml",
        "tsconfig.json",
        "Dockerfile",
        "docker-compose.yml",
        "README.md",
      },
    })
  end,
}
