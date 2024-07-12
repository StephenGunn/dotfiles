return {
  "smartpde/neoscopes",
  -- Optionally, install telescope for nicer scope selection UI.
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    local scopes = require("neoscopes")
    scopes.add({
      name = "conspiracy",
      dirs = {
        "~/Projects/conspiracy/front",
        "~/Projects/conspiracy/back",
      },
    })
  end,
}
