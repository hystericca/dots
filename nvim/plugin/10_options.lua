vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.autoread = true

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.hl_op({ higroup = "Visual", timeout = 300 })
    end,
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

-- 8-character tabs for C/C++ files
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "objcpp" },
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.shiftwidth = 8
        vim.opt_local.tabstop = 8
        vim.opt_local.softtabstop = 8
    end,
})

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

-- maybe maybe
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "objcpp", "zig" },
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

-- native search & find options (path, wildignore, grepprg)
vim.opt.path:append("**")
vim.opt.wildignore:append({ "**/node_modules/*", "**/.git/*", "**/build/*", "**/dist/*", "**/target/*" })

if vim.fn.executable("rg") == 1 then
    vim.opt.grepprg = "rg --vimgrep --smart-case --no-heading"
    vim.opt.grepformat = "%f:%l:%c:%m"
end

-- open quickfix window automatically on grep
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    pattern = "grep",
    command = "cwindow",
})
