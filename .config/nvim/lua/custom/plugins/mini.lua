return {
	{
		"echasnovski/mini.ai",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
		end,
	},
	{
		"echasnovski/mini.surround",
		config = function()
			require("mini.surround").setup()
		end,
	},
	{
		"echasnovski/mini.statusline",
		config = function()
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},
	{
		"echasnovski/mini.pairs",
		config = function()
			require("mini.pairs").setup()
		end,
	},
}
