return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup({
      -- Use pattern only to avoid LSP confusing the root detection
      detection_methods = { "pattern" },
      patterns = {
        -- More specific patterns first (for nested projects in monorepos)
        "svelte.config.js",
        "package.json",
        "tsconfig.json",
        "Dockerfile",
        "docker-compose.yml",
        -- Monorepo markers
        "pnpm-workspace.yaml",
        -- Stop at node_modules to prevent jumping into dependencies
        "!>node_modules",
        -- Git as last resort (so monorepo subdirs take precedence)
        ".git",
        "README.md",
      },
      -- Prevent jumping into dependency directories
      exclude_dirs = { "*/node_modules/*" },
      -- Changes working directory per tab, not globally
      scope_chdir = 'tab',
      -- Show directory changes (useful for debugging; set to true to hide)
      silent_chdir = false,
    })
  end,
}
