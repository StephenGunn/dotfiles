return {
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			local notify = require("notify")

			-- Add the background_colour option here
			notify.setup({
				background_colour = "#1e1e2e", -- Replace with a color that suits your theme
			})

			local filtered_message = { "No information available" }

			-- Override notify function to filter out messages
			---@diagnostic disable-next-line: duplicate-set-field
			vim.notify = function(message, level, opts)
				local merged_opts = vim.tbl_extend("force", {
					on_open = function(win)
						local buf = vim.api.nvim_win_get_buf(win)
						-- Use set_option_value instead of the deprecated set_option
						vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
					end,
				}, opts or {})

				for _, msg in ipairs(filtered_message) do
					if message == msg then
						return
					end
				end
				return notify(message, level, merged_opts)
			end

			-- Keybinding to dismiss all notifications with <leader><Esc>
			vim.keymap.set("n", "<leader><Esc>", function()
				require("notify").dismiss({ silent = true, pending = true })
			end, { noremap = true, silent = true })

			-- Update colors to use Catppuccin colors
			vim.cmd([[
        highlight NotifyERRORBorder guifg=#ed8796
        highlight NotifyERRORIcon guifg=#ed8796
        highlight NotifyERRORTitle  guifg=#ed8796
        highlight NotifyINFOBorder guifg=#8aadf4
        highlight NotifyINFOIcon guifg=#8aadf4
        highlight NotifyINFOTitle guifg=#8aadf4
        highlight NotifyWARNBorder guifg=#f5a97f
        highlight NotifyWARNIcon guifg=#f5a97f
        highlight NotifyWARNTitle guifg=#f5a97f
      ]])
		end,
	},
}
