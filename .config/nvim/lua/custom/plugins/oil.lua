return {
	"stevearc/oil.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },

	config = function()
		require("oil").setup({
			default_file_explorer = true,
			keymaps = {
				[".."] = "actions.toggle_hidden",
			},
			view_options = {
				show_hidden = true,
			}
		})
		vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>", { desc = "Open parent directory" })
	end,
}
