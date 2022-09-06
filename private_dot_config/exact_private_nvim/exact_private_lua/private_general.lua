--------------------------
--
-- General Options
--
--------------------------

-- Define a leader key.
vim.g.mapleader = ","

-- Auto write when a file is being built (:make).
vim.opt.autowrite = true

-- Use proper terminal colours.
vim.opt.termguicolors = true

-- Store the undo history in a file.
vim.opt.undofile = true

--------------------------
--
-- General Key Bindings
--
--------------------------

-- Reload the vim config.
vim.keymap.set("n", "<Leader>rv", ":source $MYVIMRC<CR>", {
	silent = true,
})

-- Update the vim config.
vim.keymap.set("n", "<Leader>uv", ":vs $MYVIMRC<CR>", {
	silent = true,
})

-- Clear out the search results.
vim.keymap.set("n", "<Leader>/", ":noh<CR>", {
	silent = true,
})

-- Go to the matching bracket when pressing the tab key.
vim.keymap.set({"n", "v"}, "<Tab>", "%", {
	silent = true,
	remap = true,
})

-- Disable arrow keys.
vim.keymap.set({"n", "i", "v"}, "<Up>", "<Nop>")
vim.keymap.set({"n", "i", "v"}, "<Down>", "<Nop>")
vim.keymap.set({"n", "i", "v"}, "<Left>", "<Nop>")
vim.keymap.set({"n", "i", "v"}, "<Right>", "<Nop>")

-- Go to the next buffer.
vim.keymap.set("n", "<Leader>n", ":bnext<CR>", {
	silent = true,
})
-- Go to the previous buffer.
vim.keymap.set("n", "<Leader>p", ":bprev<CR>", {
	silent = true,
})

-- List all active buffers.
vim.keymap.set("n", "<Leader>b", ":ls<CR>", {
	silent = true,
})

-- Close the current buffer.
vim.keymap.set("n", "<Leader>c", ":bd<CR>", {
	silent = true,
})

-- Close all buffers.
vim.keymap.set("n", "<Leader>ca", ":%bd<CR>", {
	silent = true,
})

-- Close the current window.
vim.keymap.set("n", "<Leader><Esc>", ":q<CR>", {
	silent = true,
})
vim.keymap.set("n", "<Leader>q", ":q<CR>", {
	silent = true,
})

-- Simplify navigation between buffers.
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
