-- telescope

vim.keymap.set("n", "<leader>fs", ":Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fp", ":Telescope git_files<cr>")
vim.keymap.set("n", "<leader>fz", ":Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fo", ":Telescope oldfiles<cr>")

-- tree
vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<cr>") 
vim.keymap.set("n", "<leader>r", ":NVimTreeFocus<cr>")

-- comment toggle
vim.keymap.set("n", "<leader>/", ":CommentToggle<cr>")
