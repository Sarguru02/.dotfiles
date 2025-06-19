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

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.csv",
  callback = function()
    vim.cmd("CsvViewEnable display_mode=border header_lnum=1")
  end,
})
