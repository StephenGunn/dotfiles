return {
	dir = "~/projects/nvim-svelte-check",
	branch = "main",
	config = function()
		local sc = require("svelte-check")
		sc.setup({
			command = "pnpm run check",
			debug_mode = false,
		})
	end,
	dev = true,
}
