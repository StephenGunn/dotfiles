return {
	"goolord/alpha-nvim",
	event = "VimEnter", -- load plugin after all configuration is set
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			[[   __                _                                              ]],
			[[   \ \   ___ __   __(_)  __ _  _ __     /\/\    ___    ___   _ __   ]],
			[[    \ \ / _ \\ \ / /| | / _` || '_ \   /    \  / _ \  / _ \ | '_ \  ]],
			[[ /\_/ /| (_) |\ V / | || (_| || | | | / /\/\ \| (_) || (_) || | | | ]],
			[[ \___/  \___/  \_/  |_| \__,_||_| |_| \/    \/ \___/  \___/ |_| |_| ]],
		}

		_Gopts = {
			position = "center",
			hl = "Type",
			-- wrap = "overflow";
		}

		-- Set menu
		dashboard.section.buttons.val = {
			-- dashboard.button("SPC j", "󰈚   Restore Session", ":SessionRestore<cr>"),
			dashboard.button("e", "   New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "   Find file", ":Telescope find_files<CR>"),
			dashboard.button("g", "󰱼   Find word", ":Telescope live_grep<CR>"),
			dashboard.button("r", "   Recent", ":Telescope oldfiles<CR>"),
			dashboard.button("c", "   Config", ":e $MYVIMRC <CR>"),
			dashboard.button("m", "󱌣   Mason", ":Mason<CR>"),
			dashboard.button("l", "󰒲   Lazy", ":Lazy<CR>"),
			dashboard.button("u", "󰂖   Update plugins", "<cmd>lua require('lazy').sync()<CR>"),
			dashboard.button("q", "   Quit NVIM", ":qa<CR>"),
		}

		local function footer()
			return "Stephen Gunn - JovianMoon.io"
		end
		dashboard.section.footer.val = footer()

		dashboard.opts.opts.noautocmd = true
		alpha.setup(dashboard.opts)

		require("alpha").setup(dashboard.opts)
	end,
}
