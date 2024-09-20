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
				buffer_close_icon = "",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
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
			},
			highlights = {
				fill = {
					guifg = "#45475a", -- Darker foreground for fill (Catppuccin Mocha - Overlay1)
					guibg = "#1e1e2e", -- Background for fill (Catppuccin Mocha - Base)
				},
				background = {
					guifg = "#6c7086", -- Darker unselected tab text (Catppuccin Mocha - Overlay0)
					guibg = "#1e1e2e", -- Background for unselected tabs (Catppuccin Mocha - Base)
				},
				buffer_selected = {
					guifg = "#f5e0dc", -- Selected tab text (Catppuccin Mocha - Text)
					guibg = "#2b2d3a", -- Darker selected tab background (Catppuccin Mocha - Surface1)
					gui = "bold", -- Bold for selected tab
				},
				buffer_visible = {
					guifg = "#a6adc8", -- Visible but not selected tab text (Catppuccin Mocha - Subtext1)
					guibg = "#1e1e2e", -- Visible but unselected tab background (Catppuccin Mocha - Base)
				},
				modified = {
					guifg = "#f28fad", -- Darker modified icon (Catppuccin Mocha - Pink)
					guibg = "#1e1e2e", -- Modified icon background (Catppuccin Mocha - Base)
				},
				modified_selected = {
					guifg = "#f28fad", -- Modified icon for selected tab (Catppuccin Mocha - Pink)
					guibg = "#2b2d3a", -- Darker modified icon background for selected tab (Surface1)
				},
				separator = {
					guifg = "#1e1e2e", -- Darker separator (Base)
					guibg = "#1e1e2e", -- Match separator with background for smooth transitions
				},
				separator_selected = {
					guifg = "#2b2d3a", -- Separator color for selected tab (Surface1)
					guibg = "#2b2d3a", -- Match background for selected tab
				},
				separator_visible = {
					guifg = "#1e1e2e", -- Darker separator for visible but unselected tabs (Base)
					guibg = "#1e1e2e",
				},
				indicator_selected = {
					guifg = "#cba6f7", -- Darker indicator for selected tab (Catppuccin Mocha - Mauve)
					guibg = "#2b2d3a", -- Same as background for selected tab
				},
			},
		})
	end,
}
