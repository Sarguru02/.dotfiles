-- for convenience
local api = vim.api
local cmd = vim.cmd

local ensure_installed = {
    lsp = {
        "lua-language-server",
        "clangd",
        "gopls",
        "rust-analyzer",
        "typescript-language-server",
        "python-lsp-server",
    },
    tools = {
        "stylua",
        "shfmt",
        "black",
    },
}

local config = function (_, opts)
    -- for convenience
    local mason = require("mason")
    local mreg = require("mason-registry")

    -- autimatically install required lsp servers and tools
    local ensure_tools_installed = function ()
        local tools = {}
        vim.list_extend(tools, ensure_installed.lsp)
        vim.list_extend(tools, ensure_installed.tools)

        for _, tool in ipairs(tools) do
            if mreg.has_package(tool) then
                local pkg = mreg.get_package(tool)

                if not pkg:is_installed() then
                    pkg:install()
                end
            end
        end
    end

    -- delay filetype event trigger
    local queue_filetype_event = function ()
        local event = require("lazy.core.handler.event")

        local trigger_filetype_event = function ()
            local trigger_opts = {
                event = "FileType",
                buf = api.nvim_get_current_buf(),
            }

            event.trigger(trigger_opts)
        end

        vim.defer_fn(trigger_filetype_event, 100)
    end

    -- configure mason
    mason.setup(opts)

    -- ensure the necessary tools are installed
    mreg.refresh(ensure_tools_installed)

    -- load the newly installed lsp server
    mreg:on("package:install:success", queue_filetype_event)
end

return {
  "mason-org/mason.nvim",
  version="*",
  enabled=true,
  lazy=true,
  cmd = {"Mason"},
  build = {":MasonUpdate"},
  config = config,
}
