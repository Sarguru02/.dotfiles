return {
	{
		"echasnovski/mini.ai",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
		end,
    lazy=true,
    event = { "VeryLazy"},
	},
	{
		"echasnovski/mini.surround",
		config = function()
			require("mini.surround").setup()
		end,
    lazy=true,
    event = { "VeryLazy"},
	},
	{
		"echasnovski/mini.statusline",
		config = function()
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = true })
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
    lazy=true,
    event = { "VeryLazy"},
	},
	{
		"echasnovski/mini.pairs",
		config = function()
			require("mini.pairs").setup()
		end,
    lazy=true,
    event = { "VeryLazy"},
	},
  {
		"echasnovski/mini.diff",
    version = "*",
    config = function ()
      require("mini.diff").setup()
    end,
    lazy=true,
    event = {"VeryLazy"},
  },
}
