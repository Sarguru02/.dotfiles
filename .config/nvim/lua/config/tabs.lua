-- Tab keymaps for Neovim

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- New tab
keymap('n', '<leader>tn', ':tabnew<CR>', opts)

-- Close current tab
keymap('n', '<leader>xt', ':tabclose<CR>', opts)

-- Cycle through tabs
keymap('n', '<leader><TAB>', ':tabnext<CR>', opts)

-- Go to tab 1 through 9
for i = 1, 9 do
  keymap('n', '<leader>t' .. i, ':tabnext ' .. i .. '<CR>', opts)
end
