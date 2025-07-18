-- needed keymap
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n","<leader>pv", "<cmd>Ex<CR>")

-- move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

-- move between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- center current line in screen when doing PageUp or PageDown
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- cool keybinding to switch projects while inside neovim
-- ## requires the vopener script ##
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww vopener<CR>")

--[[ ##################################################
--   ##                                              ##
--   ##              This is for CP                  ##
--   ##                                              ##
--   ################################################## ]]

vim.keymap.set("n", "<leader>cp", function() -- instead of this I should most probably create this as a snippet
	-- as if I am gonna continue competitive programming
	vim.cmd("read ~/.config/nvim/skeletons/cppsk.cpp")
	vim.cmd("50")
end)

vim.keymap.set("n", "<leader>cc", function()
	-- check file type
	local filetype = vim.bo.filetype
	local filename = vim.fn.expand("%")
	if filetype == "cpp" then
		vim.cmd("w")
		vim.cmd("!g++ -DLOCAL % -o %:t:r")
		vim.cmd("!./%:t:r")
		vim.cmd("!rm %:t:r")
	elseif filetype == "python" then
		vim.cmd("w")
		vim.cmd("split | terminal python3 " .. filename)
	end
end)

vim.keymap.set("n", "<leader>sp", function()
	vim.cmd("vsplit input.txt")
	vim.cmd("split output.txt")
	vim.cmd("split debug.txt")
end)
--  ##################################################
--  ##################################################
