return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  config = function()
    local ls = require("luasnip")

    -- Basic configuration
    ls.setup({
      history = true,
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
      ext_opts = {
        [require("luasnip.util.types").choiceNode] = {
          active = {
            virt_text = { { "●", "GruvboxOrange" } },
          },
        },
      },
    })

    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      local function safe_expand()
        local ok, result = pcall(function()
          return ls.expand_or_jumpable()
        end)
        return ok and result
      end

      if safe_expand() then
        ls.expand_or_jump()
      else
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n")
      end
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      local function safe_jump()
        local ok, result = pcall(function()
          return ls.jumpable(-1)
        end)
        return ok and result
      end

      if safe_jump() then
        ls.jump(-1)
      else
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n")
      end
    end, { silent = true })

    vim.keymap.set("i", "<C-n>", function()
      if ls.choice_active() then
        pcall(ls.change_choice, 1)
      end
    end)

    vim.keymap.set("i", "<C-p>", function()
      if ls.choice_active() then
        pcall(ls.change_choice, -1)
      end
    end)
  end,
}
