return {
  "karb94/neoscroll.nvim",
  config = function()
    require("neoscroll").setup({
      -- All these keys will be mapped to their corresponding default scrolling animation
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb", "PageUp", "PageDown" },
    })

    local t = {}
    -- Syntax: t[keys] = {function, {function arguments}}
    t["PageUp"] = { "scroll", { "-vim.wo.scroll", "true", "350", [['sine']] } }
    t["PageDown"] = { "scroll", { "vim.wo.scroll", "true", "350", [['sine']] } }

    require("neoscroll.config").set_mappings(t)
  end,
}
