return {
  "numToStr/Comment.nvim",
  config = function()
    -- Setup Comment.nvim
    require("Comment").setup({
      mappings = {
        basic = false, -- Disable default basic mappings for comments
      },
    })

    -- Disable automatic comment continuation on Enter
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        vim.opt_local.formatoptions:remove({ "r", "o" }) -- Prevent comment continuation on 'Enter'
      end,
    })

    -- Function to insert a comment line with proper indentation and enter insert mode
    local function insert_comment_line()
      -- Insert a new line below with correct indentation
      vim.api.nvim_command("normal! o")
      -- Use Comment.nvim to comment the new line
      require("Comment.api").toggle.linewise.current()

      -- Manually re-indent the current line based on indentation rules
      vim.api.nvim_command("normal! ==")

      -- Move to the end of the comment symbol, add a space, and enter insert mode after the space
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("A ", true, false, true), "n", true)
    end

    -- Map <leader>/ to insert a new comment line and enter insert mode
    vim.keymap.set("n", "<leader>/", insert_comment_line, { noremap = true, silent = true })
  end,
}
