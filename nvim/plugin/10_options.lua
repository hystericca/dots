vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- autoread
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    command = "checktime",
})

-- ui
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.termguicolors = true

-- terminal stuff
vim.opt.mouse = "a"
vim.opt.title = true
vim.opt.titlestring = "%t - nvim"
vim.opt.laststatus = 3

-- splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- scrolling
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false

-- editing
vim.opt.confirm = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

-- indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- files
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- completion
vim.opt.completeopt = { "menu", "menuone", "noselect", "fuzzy", "popup" }
vim.o.autocomplete = true

-- mac clipboard
vim.opt.clipboard = "unnamedplus"
