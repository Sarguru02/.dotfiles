-- helper function to define keymaps for harpoon navigation
local keys_for_navigation = function (keys, num)
    for i = 1, num do
        table.insert(keys, {
            "<leader>" .. i,
            mode = { "n" },
            function ()
                -- for convenience
                local harpoon = require("harpoon")

                harpoon:list():select(i)
            end,
            noremap = true,
            silent = true,
            desc = "navigate to harpoon file " .. i,
        })
    end
end

-- plugin dependencies
local dependencies = {}

-- plugin init function
local init = function () end

-- plugin opts
local opts = {}

-- plugin keys
local keys = {
    {
        "<leader>a",
        mode = { "n" },
        function ()
            -- for convenience
            local harpoon = require("harpoon")

            harpoon:list():add()
        end,
        noremap = true,
        silent = true,
        desc = "add file to harpoon",
    },
    {
        "<C-e>",
        mode = { "n" },
        function ()
            -- for convenience
            local harpoon = require("harpoon")

            harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        noremap = true,
        silent = true,
        desc = "toggle harpoon quick menu",
    },
}

-- add keymaps for navigating to harpoon files (1-9)
keys_for_navigation(keys, 4)


-- plugin configurations
return {
    "ThePrimeagen/harpoon",
    version = "*",
    branch = "harpoon2",
    enabled = true,
    lazy = true,
    event = {},
    cmd = {},
    ft = {},
    build = {},
    dependencies = dependencies,
    init = init,
    opts = opts,
    keys = keys,
}
