-- for convenience
local api = vim.api
local cmd = vim.cmd
local diagnostic = vim.diagnostic
local fn = vim.fn
local keymap = vim.keymap
local lsp = vim.lsp
local uv = vim.uv
local v = vim.v

-- plugin dependencies
local dependencies = {
	{
		"saghen/blink.cmp",
	},
	{
		"mason-org/mason.nvim",
	},
}

-- diagnostics signs
local signs = {
	ERROR = "E",
	WARN = "W",
	INFO = "I",
	HINT = "H",
}

-- plugin init function
local init = function() end

-- plugin opts
local opts = {
	diagnostics = {
		underline = true,
		virtual_text = true,
		virtual_lines = false,
		update_in_insert = false,
		severity_sort = true,
		float = {
			source = true,
			border = "rounded",
		},
		signs = {
			text = {
				[diagnostic.severity.ERROR] = signs.ERROR,
				[diagnostic.severity.WARN] = signs.WARN,
				[diagnostic.severity.HINT] = signs.HINT,
				[diagnostic.severity.INFO] = signs.INFO,
			},
		},
	},
	capabilities = {
		workspace = {
			fileOperations = {
				didRename = true,
				willRename = true,
			},
		},
	},
	servers = {
		denols = {
			root_dir = function(bufnr, on_dir)
				local lspconfig_util = require("lspconfig.util")

				local fname = api.nvim_buf_get_name(bufnr)
				local root = lspconfig_util.root_pattern("deno.json", "deno.jsonc")(fname)

				if root then
					on_dir(root)
				end
			end,
		},
		lua_ls = {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					runtime = {
						version = "LuaJIT",
					},
					telemetry = {
						enable = false,
					},
					workspace = {
						checkThirdParty = false,
						library = api.nvim_get_runtime_file("", true),
					},
				},
			},
		},
		vtsls = {
			root_dir = function(bufnr, on_dir)
				local lspconfig_util = require("lspconfig.util")

				local fname = api.nvim_buf_get_name(bufnr)
				local is_deno = lspconfig_util.root_pattern("deno.json", "deno.jsonc")

				if not is_deno(fname) then
					on_dir(fn.getcwd())
				end
			end,
		},
	},
}

-- plugin config function
local config = function(_, opts)
	-- for convenience
	local lsp_enabled = true
	local attached_buffers_by_client = {}
	local client_configs = {}

	local blink_cmp = require("blink.cmp")
	local mreg = require("mason-registry")

	local original_buf_attach_client = lsp.buf_attach_client

	local add_buf = function(client_id, bufnr)
		attached_buffers_by_client[client_id] = attached_buffers_by_client[client_id] or {}

		for _, value in ipairs(attached_buffers_by_client[client_id]) do
			if value == bufnr then
				return
			end
		end

		table.insert(attached_buffers_by_client[client_id], bufnr)
	end

	local client_stop = function(client)
		if client.is_stopped() then
			return
		end

		lsp.stop_client(client.id, false)

		local attempts = 0
		local max_attempts = 50
		local timer = uv.new_timer()

		local handle_client_timeout = function()
			attempts = attempts + 1

			if client.is_stopped() then
				timer:stop()
				timer:close()
				diagnostic.reset()
			elseif attempts >= max_attempts then
				lsp.stop_client(client.id, true)
				timer:stop()
				timer:close()
				diagnostic.reset()
			end
		end

		timer:start(100, 100, vim.schedule_wrap(handle_client_timeout))
	end

	local update_clients_ids = function(ids_map)
		local new_attached_buffers_by_client = {}
		local new_client_configs = {}

		for old_client_id, buffers in pairs(attached_buffers_by_client) do
			local new_client_id = ids_map[old_client_id]
			if new_client_id then
				new_attached_buffers_by_client[new_client_id] = buffers
				new_client_configs[new_client_id] = client_configs[old_client_id]
			end
		end

		attached_buffers_by_client = new_attached_buffers_by_client
		client_configs = new_client_configs
	end

	local toggle_lsp = function()
		if lsp_enabled then
			attached_buffers_by_client = {}
			client_configs = {}

			for _, client in ipairs(lsp.get_clients()) do
				client_configs[client.id] = client.config

				for bufnr, _ in pairs(client.attached_buffers or {}) do
					add_buf(client.id, bufnr)
					if lsp.buf_is_attached(bufnr, client.id) then
						lsp.buf_detach_client(bufnr, client.id)
					end
				end

				client_stop(client)
			end

			Snacks.notify.info("LSP servers disabled !!!")
		else
			local ids_map = {}

			for old_client_id, buffers in pairs(attached_buffers_by_client) do
				local client = client_configs[old_client_id]
				local new_client_id, error = lsp.start_client(client)

				if error then
					Snacks.notify.error("Failed to start LSP client: " .. tostring(error))
					return nil
				end

				ids_map[old_client_id] = new_client_id

				for _, bufnr in ipairs(buffers) do
					original_buf_attach_client(bufnr, new_client_id)
				end
			end

			update_clients_ids(ids_map)
			Snacks.notify.info("LSP servers enabled !!!")
		end

		lsp_enabled = not lsp_enabled
	end

	local capabilities = vim.tbl_deep_extend(
		"force",
		{},
		lsp.protocol.make_client_capabilities(),
		blink_cmp.get_lsp_capabilities(),
		opts.capabilities or {}
	)

	local on_attach = function(client, buffer)
		pcall(keymap.del, { "n", "x", "o" }, "]]", { buffer = buffer })
		pcall(keymap.del, { "n", "x", "o" }, "[[", { buffer = buffer })
		pcall(keymap.del, { "n" }, "K", { buffer = buffer })
		pcall(keymap.del, { "x" }, "gra")

		keymap.set("n", "gd", function()
			snacks.picker.lsp_definitions()
		end, { desc = "go to definitions", buffer = buffer })

		keymap.set("n", "gD", function()
			Snacks.picker.lsp_declarations()
		end, { desc = "go to declarations", buffer = buffer })

		keymap.set("n", "<leader>D", function()
			Snacks.picker.lsp_type_definitions()
		end, { desc = "go to type definitions", buffer = buffer })

		keymap.set("n", "gI", function()
			Snacks.picker.lsp_implementations()
		end, { desc = "go to implementations", buffer = buffer })

		keymap.set("n", "gr", function()
			Snacks.picker.lsp_references()
		end, { desc = "go to references", buffer = buffer })

		keymap.set("n", "<leader>ca", function()
			lsp.buf.code_action()
		end, { desc = "lsp code action", buffer = buffer })

		keymap.set("n", "<leader>rn", function()
			lsp.buf.rename()
		end, { desc = "lsp rename", buffer = buffer })

		keymap.set("n", "<leader>lr", function()
			cmd("LspRestart")
			Snacks.notify.info("LSP server restarted !!!")
		end, { desc = "lsp server restart", buffer = buffer })

		keymap.set("n", "<leader>ws", function()
			Snacks.picker.lsp_workspace_symbols()
		end, { desc = "lsp symbols in workspace", buffer = buffer })

		keymap.set("n", "K", function()
			lsp.buf.hover({ border = "rounded", focusable = true })
		end, { desc = "lsp hover", buffer = buffer })

		keymap.set("n", "gK", function()
			lsp.buf.signature_help({ border = "rounded", focusable = true })
		end, { desc = "lsp signature help", buffer = buffer })

		keymap.set("n", "<leader>e", function()
      diagnostic.open_float()
		end, { desc = "lsp signature help", buffer = buffer })
	end

	local setup = function(server)
		local server_opts = vim.tbl_deep_extend("force", {
			capabilities = capabilities,
		}, (opts.servers and opts.servers[server]) or {})

		if server_opts.enabled == false then
			Snacks.notify.warn("LSP server " .. server .. " is disabled !!!")
			return
		end

		lsp.config(server, server_opts)
		lsp.enable(server)
	end

	local handler = function()
		local enabled_servers = {}

		local enable_server = function(pkg)
			local pkg_obj

			if type(pkg) == "string" then
				local ok, result = pcall(function()
					return mreg.get_package(pkg)
				end)

				if not ok then
					Snacks.notify.error("Package " .. pkg .. " not found !!!")
					return
				end

				pkg_obj = result
			else
				pkg_obj = pkg
			end

			local lsp_server = vim.tbl_get(pkg_obj, "spec", "neovim", "lspconfig")

			if not lsp_server or enabled_servers[lsp_server] then
				return
			end

			setup(lsp_server)
			enabled_servers[lsp_server] = true
		end

		local enable_server_scheduled = vim.schedule_wrap(enable_server)

		for _, pkg_name in ipairs(mreg.get_installed_package_names()) do
			enable_server(pkg_name)
		end

		mreg:off("package:install:success", enable_server_scheduled)
		mreg:on("package:install:success", enable_server_scheduled)
	end

	if opts.diagnostics then
		diagnostic.config(opts.diagnostics)
	end

	handler()

	lsp.buf_attach_client = function(bufnr, client_id)
		if not lsp_enabled then
			client_configs[client_id] = client_configs[client_id]
				or (lsp.get_client_by_id(client_id) or {}).config
				or {}
			add_buf(client_id, bufnr)
			lsp.stop_client(client_id)
			return false
		end

		return original_buf_attach_client(bufnr, client_id)
	end

	keymap.set("n", "<leader>lt", function()
		toggle_lsp()
	end, { desc = "Toggle LSP servers" })

	api.nvim_create_autocmd("LspAttach", {
		group = api.nvim_create_augroup("sarguru-lsp-attach", { clear = true }),
		callback = function(args)
			local client = lsp.get_client_by_id(args.data.client_id)
			if client then
				on_attach(client, args.buf)
			end
		end,
	})
end

-- plugin keys
local keys = {}

-- plugin configurations
return {
	"neovim/nvim-lspconfig",
	version = "*",
	enabled = true,
	lazy = true,
	event = {
		"BufReadPost",
		"BufNewFile",
		"BufWritePre",
	},
	dependencies = dependencies,
	init = init,
	opts = opts,
	config = config,
	keys = keys,
}
