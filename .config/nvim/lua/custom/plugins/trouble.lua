return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	config = function()
		local trouble = require("trouble")

		local opts = { new = true, refresh = true, mode = "diagnostics", focus = true }
		trouble.setup({
			position = "right",
		})

		vim.keymap.set("n", "<leader>tt", function()
			trouble.toggle(opts)
		end)

		vim.keymap.set("n", "[t", function()
			trouble.next({ skip_groups = true, jump = true })
		end)

		vim.keymap.set("n", "]t", function()
			trouble.previous({ skip_groups = true, jump = true })
		end)
	end,
	keys = {
		{
			"<leader>xQ",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (Trouble)",
		},
	},
}
