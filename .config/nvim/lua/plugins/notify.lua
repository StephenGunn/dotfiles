return {
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			local notify = require("notify")

			-- Get background color from current colorscheme
			local function get_bg_color()
				local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
				if normal_bg then
					return string.format("#%06x", normal_bg)
				end
				return "#000000" -- Fallback
			end

			-- Add the background_colour option here
			notify.setup({
				background_colour = get_bg_color(),
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


			-- Update colors to match active colorscheme
			local function apply_notify_colors()
				local function get_hl(name)
					local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
					return ok and hl or {}
				end

				local error_color = get_hl("DiagnosticError").fg or get_hl("Error").fg
				local info_color = get_hl("DiagnosticInfo").fg or get_hl("Function").fg
				local warn_color = get_hl("DiagnosticWarn").fg or get_hl("WarningMsg").fg

				if error_color then
					vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = error_color })
					vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = error_color })
					vim.api.nvim_set_hl(0, "NotifyERRORTitle", { fg = error_color })
				end

				if info_color then
					vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = info_color })
					vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = info_color })
					vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = info_color })
				end

				if warn_color then
					vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = warn_color })
					vim.api.nvim_set_hl(0, "NotifyWARNIcon", { fg = warn_color })
					vim.api.nvim_set_hl(0, "NotifyWARNTitle", { fg = warn_color })
				end
			end

			-- Apply colors when colorscheme changes
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = function()
					vim.defer_fn(apply_notify_colors, 100)
					-- Update background color too
					vim.defer_fn(function()
						notify.setup({ background_colour = get_bg_color() })
					end, 100)
				end,
			})

			-- Apply colors on initial load
			vim.defer_fn(apply_notify_colors, 100)
		end,
	},
}
