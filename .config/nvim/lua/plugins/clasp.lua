return {
	"xzbdmw/clasp.nvim",
	config = function()
		require("clasp").setup({
			pairs = { ["{"] = "}", ['"'] = '"', ["'"] = "'", ["("] = ")", ["["] = "]" },
		})

		-- jumping from smallest region to largest region
		vim.keymap.set({ "n", "i" }, "<c-p", function()
			require("clasp").wrap("next")
		end)

		-- jumping from largest region to smallest region
		vim.keymap.set({ "n", "i" }, "<c-p>", function()
			require("clasp").wrap("prev")
		end)

		-- If you want to exclude nodes whose end row is not current row
		vim.keymap.set({ "n", "i" }, "<c-p>", function()
			require("clasp").wrap("next", function(nodes)
				local n = {}
				for _, node in ipairs(nodes) do
					if node.end_row == vim.api.nvim_win_get_cursor(0)[1] - 1 then
						table.insert(n, node)
					end
				end
				return n
			end)
		end)
	end,
}
