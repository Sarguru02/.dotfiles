require("config.opts")
require("config.lazy")
require("config.maps")


vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("sarguru-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

