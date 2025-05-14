-- needed keymap
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

-- move between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- temporary buffer if you need a scratch buffer
vim.api.nvim_set_keymap('n', '<leader>n', ':new | setlocal buftype=nofile bufhidden=hide noswapfile<CR>', { noremap = true, silent = true })

--[[##################################################
--  #                                                #
--  #            This is for CP                      #
--  #                                                #
--  ##################################################]]

vim.keymap.set("n", "<leader>cp", function()
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

