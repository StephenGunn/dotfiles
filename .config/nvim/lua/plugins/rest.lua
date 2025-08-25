return {
  "rest-nvim/rest.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  ft = "http",
  config = function()
    require("rest-nvim").setup({
      -- Open request results in a horizontal split
      result_split_horizontal = false,
      -- Keep the http file buffer above|left when split
      result_split_in_place = false,
      -- Stay in current window after request
      stay_in_current_window_after_split = true,
      -- Skip SSL cert verification
      skip_ssl_verification = false,
      -- Encode URL before making request
      encode_url = true,
      -- Highlight request on run
      highlight = {
        enabled = true,
        timeout = 150,
      },
      result = {
        -- Toggle showing URL, HTTP info, headers at top of result window
        show_url = true,
        show_curl_command = false,
        show_http_info = true,
        show_headers = true,
        -- Executables or functions for formatting response body [optional]
        -- Set them to false if you want to disable them
        formatters = {
          json = "jq",
          html = function(body)
            return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
          end
        },
      },
      -- Jump to request line on run
      jump_to_request = false,
      env_file = '.env',
      custom_dynamic_variables = {},
      yank_dry_run = true,
    })
    
    -- Keybindings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "http",
      callback = function()
        local buff = tonumber(vim.fn.expand("<abuf>"), 10)
        vim.keymap.set("n", "<leader>rr", "<cmd>RestNvim<cr>", { buffer = buff, desc = "Run request under cursor" })
        vim.keymap.set("n", "<leader>rl", "<cmd>RestNvimLast<cr>", { buffer = buff, desc = "Run last request" })
        vim.keymap.set("n", "<leader>rp", "<cmd>RestNvimPreview<cr>", { buffer = buff, desc = "Preview curl command" })
      end,
    })
  end,
}