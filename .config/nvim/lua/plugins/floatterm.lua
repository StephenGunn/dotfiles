return {
	"voldikss/vim-floaterm",
	config = function()
		vim.api.nvim_set_keymap(
			"n",
			"<leader>y",
			":FloatermNew --height=0.8 --width=0.8 --wintype=float --name=floaterm_center --position=center --autoclose=2<CR>",
			{ noremap = true, silent = true }
		)
	end,
}
