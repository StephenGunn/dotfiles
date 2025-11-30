return {
  "ggandor/leap.nvim",
  enabled = true,
  -- Remove the keys section since it can cause issues per documentation
  config = function()
    local leap = require("leap")

    -- Apply your custom configurations
    leap.opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
    leap.opts.preview_filter = function(ch0, ch1, ch2)
      return not (ch1:match("%s") or ch0:match("%w") and ch1:match("%w") and ch2:match("%w"))
    end

    -- Set the custom highlight for backdrop
    vim.api.nvim_set_hl(0, "LeapBackdrop", { fg = "#585B70", blend = 30 })

    -- Create manual keymaps instead of deprecated create_default_mappings()
    vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap-forward)')
    vim.keymap.set({'n', 'x', 'o'}, 'S', '<Plug>(leap-backward)')
    vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)')

    -- Set the repeat keys if you want them
    require("leap.user").set_repeat_keys("<enter>", "<backspace>")
  end,
}
