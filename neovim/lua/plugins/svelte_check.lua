return {
	"StephenGunn/sveltecheck.nvim",
	branch = "main",
	config = function()
		local sc = require("sveltecheck")
		sc.setup({
			command = "pnpm run check",
		})
	end,
}
