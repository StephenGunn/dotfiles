return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup({
			options = {
				numbers = "ordinal",
				close_command = "bdelete! %d",
				right_mouse_command = "bdelete! %d",
				left_mouse_command = "buffer %d",
				middle_mouse_command = nil,
				indicator_icon = "▎",
				buffer_close_icon = "",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				name_formatter = function(buf) -- buf = buffer object
					if buf.name:match("%.md") then
						return vim.fn.fnamemodify(buf.name, ":t:r")
					end
				end,
				max_name_length = 18,
				max_prefix_length = 15, -- prefix used when a buffer is deduplicated
				tab_size = 18,
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					return "(" .. count .. ")"
				end,
				offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = true,
				show_tab_indicators = true,
				persist_buffer_sort = true,
				separator_style = "thin",
				enforce_regular_tabs = false,
				always_show_bufferline = true,
				sort_by = "extension",
				-- Use colorscheme's highlights automatically
				themable = true,
			},
		})

		-- Function to apply colorscheme-based highlights to bufferline
		local function apply_bufferline_colors()
			local function get_hl(name)
				local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
				return ok and hl or {}
			end

			local normal = get_hl("Normal")
			local comment = get_hl("Comment")
			local keyword = get_hl("Keyword")
			local string_hl = get_hl("String")
			local visual = get_hl("Visual")
			local error_hl = get_hl("Error")
			local cursorline = get_hl("CursorLine")
			local statusline = get_hl("StatusLine")
			local pmenu = get_hl("Pmenu")
			local bufferlinefill = get_hl("BufferLineFill")

			-- Get bufferline background - use BufferLineFill if set by theme, otherwise fallback
			local bufferline_bg = bufferlinefill.bg or statusline.bg or pmenu.bg or cursorline.bg or normal.bg

			-- Get selected tab background - slightly different from main bufferline bg
			local selected_bg = cursorline.bg or visual.bg or bufferline_bg

			-- Only set if not already defined by colorscheme overrides
			if not bufferlinefill.bg then
				vim.api.nvim_set_hl(0, "BufferLineFill", {
					bg = bufferline_bg,
				})
			end

			-- Set all bufferline highlight backgrounds to prevent transparency
			local hl_groups = {
				{ "BufferLineBufferSelected", { fg = keyword.fg or "#ffffff", bg = selected_bg, bold = true } },
				{ "BufferLineBuffer", { fg = comment.fg or "#808080", bg = bufferline_bg } },
				{ "BufferLineBufferVisible", { fg = string_hl.fg or "#a0a0a0", bg = bufferline_bg } },
				{ "BufferLineModified", { fg = error_hl.fg or "#ff0000", bg = bufferline_bg } },
				{ "BufferLineModifiedSelected", { fg = error_hl.fg or "#ff0000", bg = selected_bg } },
				{ "BufferLineModifiedVisible", { bg = bufferline_bg } },
				{ "BufferLineNumbers", { bg = bufferline_bg } },
				{ "BufferLineNumbersVisible", { bg = bufferline_bg } },
				{ "BufferLineNumbersSelected", { bg = selected_bg } },
				{ "BufferLineTab", { bg = bufferline_bg } },
				{ "BufferLineTabSelected", { bg = selected_bg } },
				{ "BufferLineTabClose", { bg = bufferline_bg } },
				{ "BufferLineCloseButton", { bg = bufferline_bg } },
				{ "BufferLineCloseButtonVisible", { bg = bufferline_bg } },
				{ "BufferLineCloseButtonSelected", { bg = selected_bg } },
				{ "BufferLineSeparator", { bg = bufferline_bg } },
				{ "BufferLineSeparatorVisible", { bg = bufferline_bg } },
				{ "BufferLineSeparatorSelected", { bg = selected_bg } },
				{ "BufferLineIndicatorVisible", { bg = bufferline_bg } },
				{ "BufferLineIndicatorSelected", { bg = selected_bg } },
				{ "BufferLineDuplicate", { bg = bufferline_bg } },
				{ "BufferLineDuplicateVisible", { bg = bufferline_bg } },
				{ "BufferLineDuplicateSelected", { bg = selected_bg } },
				{ "BufferLinePick", { bg = bufferline_bg } },
				{ "BufferLinePickVisible", { bg = bufferline_bg } },
				{ "BufferLinePickSelected", { bg = selected_bg } },
			}

			for _, hl in ipairs(hl_groups) do
				vim.api.nvim_set_hl(0, hl[1], hl[2])
			end

			-- Set diagnostic backgrounds
			local diagnostic_groups = { "Error", "Warning", "Info", "Hint", "Diagnostic" }
			for _, group in ipairs(diagnostic_groups) do
				vim.api.nvim_set_hl(0, "BufferLine" .. group, { bg = bufferline_bg })
				vim.api.nvim_set_hl(0, "BufferLine" .. group .. "Visible", { bg = bufferline_bg })
				vim.api.nvim_set_hl(0, "BufferLine" .. group .. "Selected", { bg = selected_bg })
				-- Diagnostic-specific groups
				if group ~= "Diagnostic" then
					vim.api.nvim_set_hl(0, "BufferLine" .. group .. "Diagnostic", { bg = bufferline_bg })
					vim.api.nvim_set_hl(0, "BufferLine" .. group .. "DiagnosticVisible", { bg = bufferline_bg })
					vim.api.nvim_set_hl(0, "BufferLine" .. group .. "DiagnosticSelected", { bg = selected_bg })
				end
			end

			-- Set DevIcon backgrounds to match buffer context
			-- Get all highlight groups and find DevIcon ones
			for hl_name, _ in pairs(vim.api.nvim_get_hl(0, {})) do
				if hl_name:match("^DevIcon") then
					local icon_hl = get_hl(hl_name)
					-- Create BufferLine variants for each DevIcon with proper backgrounds
					vim.api.nvim_set_hl(0, "BufferLine" .. hl_name, {
						fg = icon_hl.fg,
						bg = bufferline_bg,
					})
					vim.api.nvim_set_hl(0, "BufferLine" .. hl_name .. "Selected", {
						fg = icon_hl.fg,
						bg = selected_bg,
					})
					vim.api.nvim_set_hl(0, "BufferLine" .. hl_name .. "Visible", {
						fg = icon_hl.fg,
						bg = bufferline_bg,
					})
				end
			end
		end

		-- Apply colors when colorscheme changes
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = function()
				vim.defer_fn(apply_bufferline_colors, 100)
			end,
		})

		-- Apply colors on initial load
		vim.defer_fn(apply_bufferline_colors, 100)
	end,
}
