vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.signcolumn = "yes"
vim.o.shiftwidth = 2
vim.o.autoread = true
vim.o.laststatus = 3
vim.o.cmdheight = 0
vim.o.undofile = true
vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 12

vim.opt.termguicolors = true

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
