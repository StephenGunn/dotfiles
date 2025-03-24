return {
	dir = "~/projects/nvim-svelte-check",
	branch = "dev",
	config = function()
		local sc = require("svelte-check")
		sc.setup({
			command = "pnpm run check",
			debug_mode = true,
		})
	end,
	dev = true,
}
