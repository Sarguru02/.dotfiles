-- plugin dependencies
local dependencies = {}

-- plugin init function
local init = function()
	-- autocmd for the lazy event
	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "VeryLazy",
		callback = function()
			-- setup some globals for debugging (lazy-loaded)
			_G.dd = function(...)
				Snacks.debug.inspect(...)
			end
			_G.bt = function()
				Snacks.debug.backtrace()
			end

			-- override print to use snacks for `:=` command
			vim.print = _G.dd
			Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>w")
		end,
	})
end

-- plugin configurations
--

local keys = {
	-- git keymaps
	{
		"<leader>lg",
		mode = { "n" },
		function()
			Snacks.lazygit.open()
		end,
		noremap = true,
		silent = true,
		desc = "open lazygit",
	},
	{
		"<leader>b",
		mode = { "n" },
		function()
			Snacks.picker.git_branches({
				all = true,
			})
		end,
		noremap = true,
		silent = true,
		desc = "find the git branches",
	},
	{
		"<leader>gl",
		mode = { "n" },
		function()
			Snacks.picker.git_log()
		end,
		noremap = true,
		silent = true,
		desc = "find the git log",
	},
	{
		"<leader>gs",
		mode = { "n" },
		function()
			Snacks.picker.git_status()
		end,
		noremap = true,
		silent = true,
		desc = "find the git status",
	},
	{
		"<leader>gd",
		mode = { "n" },
		function()
			Snacks.picker.git_diff()
		end,
		noremap = true,
		silent = true,
		desc = "find the git diff",
	},

	-- find files keymaps
	{
		"<leader>ff",
		mode = { "n" },
		function()
			Snacks.picker.files({
				show_empty = true,
				hidden = true,
				ignored = true,
				follow = true,
				supports_live = true,
			})
		end,
		noremap = true,
		silent = true,
		desc = "find files in the current working directory",
	},
	{
		"<leader><leader>",
		mode = { "n" },
		function()
			Snacks.picker.buffers()
		end,
		noremap = true,
		silent = true,
		desc = "find the open buffers",
	},
	{
		"<leader>sn",
		mode = { "n" },
		function()
			Snacks.picker.files({
				show_empty = true,
				hidden = true,
				ignored = true,
				follow = true,
				supports_live = true,
				cwd = vim.fn.stdpath("config"),
			})
		end,
		noremap = true,
		silent = true,
		desc = "find files in the nvim configuration directory",
	},
	{
		"<leader>fr",
		mode = { "n" },
		function()
			Snacks.picker.recent()
		end,
		noremap = true,
		silent = true,
		desc = "find the recent files",
	},

	-- search and grep keymaps
	{
		"<leader>fs",
		mode = { "n" },
		function()
			Snacks.picker.grep({
				hidden = true,
				ignored = true,
				follow = true,
				regex = true,
				live = true,
				show_empty = true,
				supports_live = true,
			})
		end,
		noremap = true,
		silent = true,
		desc = "search for a string in the cwd",
	},
	{
		"<leader>sw",
		mode = { "n" },
		function()
			Snacks.picker.grep_word()
		end,
		noremap = true,
		silent = true,
		desc = "search for the word under the cursor",
	},
	{
		"<leader>sd",
		mode = { "n" },
		function()
			Snacks.picker.diagnostics()
		end,
		noremap = true,
		silent = true,
		desc = "search for diagnostics",
	},
	{
		"<leader>sh",
		mode = { "n" },
		function()
			Snacks.picker.help()
		end,
		noremap = true,
		silent = true,
		desc = "search for help",
	},
	{
		"<leader>ps",
		mode = { "n" },
		function()
			Snacks.picker.pick()
		end,
		noremap = true,
		silent = true,
		desc = "search for picker options",
	},
	{
		"<leader>sr",
		mode = { "n" },
		function()
			Snacks.picker.resume()
		end,
		noremap = true,
		silent = true,
		desc = "resume the last search",
	},
	{
		"<leader>u",
		mode = { "n" },
		function()
			Snacks.picker.undo()
		end,
		noremap = true,
		silent = true,
		desc = "search for undo history",
	},
	-- utilities keymaps
	{
		"<leader>sc",
		mode = { "n" },
		function()
			Snacks.scratch()
		end,
		noremap = true,
		silent = true,
		desc = "toggle the scratch buffer",
	},
	{
		"<leader>sl",
		mode = { "n" },
		function()
			Snacks.scratch.select()
		end,
		noremap = true,
		silent = true,
		desc = "select a scratch buffer from a list of scratch buffers",
	},
	{
		"<leader>n",
		mode = { "n" },
		function()
			Snacks.notifier.show_history()
		end,
		noremap = true,
		silent = true,
		desc = "show all notifications history",
	},
	{
		"<leader>hn",
		mode = { "n" },
		function()
			Snacks.notifier.hide()
		end,
		noremap = true,
		silent = true,
		desc = "hide all the notifications",
	},
	{
		"<C-n>",
		mode = { "n" },
		function()
			Snacks.explorer.open()
		end,
		noremap = true,
		silent = true,
		desc = "open the snacks explorer",
	},
	{
		"<leader>zz",
		mode = { "n" },
		function()
			Snacks.zen.zen()
		end,
		noremap = true,
		silent = true,
		desc = "toggle zen mode",
	},
}

local dashboard = {
	enabled = true,
	width = 60,
	row = nil,
	col = nil,
	sections = {
		{ section = "header", gap = 1, padding = 2 },
		{ section = "keys", gap = 1, padding = 1 },
		{
			section = "terminal",
			cmd = "colorscripts -r --no-title; sleep .1",
			random = 10,
			pane = 2,
			indent = 7,
			height = 30,
		},
		{ section = "startup" },
	},
}

local opts = {
	animate = { enabled = true },
	bigfile = {
		enabled = true,
		notify = true,
		size = 1.5 * 1024 * 1024,
		line_length = 1000,
	},
	bufdelete = {
		enabled = true,
	},
	dashboard = dashboard,
	debug = { enabled = true },
	dim = {
		enabled = true,
		scope = {
			min_size = 5,
			max_size = 20,
			siblings = true,
		},
	},
	explorer = {
		enabled = true,
		replace_netrw = true,
	},
	git = { enabled = true },
	image = {
		enabled = true,
		formats = {
			"png",
			"jpg",
			"jpeg",
			"gif",
			"bmp",
			"webp",
			"tiff",
			"heic",
			"avif",
			"mp4",
			"mov",
			"avi",
			"mkv",
			"webm",
			"pdf",
		},
		doc = {
			enabled = true,
			inline = true,
			float = true,
			max_width = 80,
			max_height = 40,
		},
	},
	indent = {
		enabled = true,
		indent = {
			enabled = true,
			priority = 1,
			only_scope = false,
			only_current = false,
			char = "▏",
		},
		scope = {
			enabled = true,
			priority = 200,
			underline = false,
			only_current = false,
			char = "▏",
		},
		chunk = {
			enabled = false,
			priority = 200,
			only_current = false,
			char = {
				corner_top = "╭",
				corner_bottom = "╰",
				horizontal = "─",
				vertical = "│",
				arrow = ">",
			},
		},
	},
	input = { enabled = true },
	layout = { enabled = true },
	lazygit = {
		enabled = true,
		configure = true,
	},
	notifier = {
		enabled = true,
		timeout = 3000,
		width = {
			min = 40,
			max = 0.4,
		},
		height = {
			min = 1,
			max = 0.6,
		},
		margin = {
			top = 0,
			right = 1,
			bottom = 0,
		},
		padding = true,
		sort = {
			"level",
			"added",
		},
		level = vim.log.levels.TRACE,
		style = "compact",
		top_down = true,
		date_format = "%R",
		more_format = " ↓ %d lines ",
		refresh = 50,
	},
	notify = { enabled = true },
	picker = {
		enabled = true,
		sources = {
      files = {
        hidden=true,
        ignored=true,
      },
			explorer = {
				layout = { layout = { position = "right" } },
				focus = "input",
			},
		},
    hidden=true,
    ignored=true,
		focus = "input",
		layout = {
			cycle = true,
		},
		matcher = {
			fuzzy = true,
			smartcase = true,
			ignorecase = true,
			sort_empty = false,
			filename_bonus = true,
			file_pos = true,
			cwd_bonus = false,
			frecency = true,
			history_bonus = false,
		},
		ui_select = true,
	},
	profiler = {
		enabled = true,
	},
	quickfile = {
		enabled = true,
	},
	rename = {
		enabled = true,
	},
	scope = {
		enabled = false,
	},
	scratch = {
		enabled = true,
	},
	scroll = {
		enabled = false,
	},
	statuscolumn = {
		enabled = false,
		refresh = 50,
		folds = {
			open = false,
			git_hl = false,
		},
	},
	toggle = {
		enabled = true,
	},
	util = {
		enabled = true,
	},
	win = {
		enabled = true,
	},
	words = {
		enabled = true,
		notify_jump = false,
		notify_end = true,
		foldopen = true,
		jumplist = true,
	},
	zen = {
		enabled = true,
		toggles = {
			dim = true,
			git_signs = true,
			diagnostics = true,
			inlay_hints = true,
		},
		show = {
			statusline = true,
			tabline = false,
		},
		zoom = {
			toggles = {
				dim = false,
				git_signs = true,
				diagnostics = true,
				inlay_hints = true,
			},
			show = {
				statusline = true,
				tabline = true,
			},
		},
	},
	styles = {},
}
return {
	"folke/snacks.nvim",
	version = "*",
	enabled = true,
	lazy = false,
	priority = 1000,
	init = init,
	opts = opts,
	keys = keys,
}
