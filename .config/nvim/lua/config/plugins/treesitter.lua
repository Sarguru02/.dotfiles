return {
	"nvim-treesitter/nvim-treesitter",
  lazy=false,
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
      "haskell",
			"bash",
			"c",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"vim",
			"vimdoc",
			"c",
			"cpp",
			"rust",
			"go",
		},
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { "ruby" },
		},
		indent = { enable = true, disable = { "ruby" } },
	},
	config = function(_, opts)
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup(opts)
	end,
}
