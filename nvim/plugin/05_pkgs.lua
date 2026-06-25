if not vim.pack then
    return
end

vim.pack.add({
    { src = "https://codeberg.org/ziglang/zig.vim.git" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/slugbyte/lackluster.nvim" },
    { src = "https://github.com/nvim-mini/mini.pairs" },
    { src = "https://github.com/nvim-mini/mini.pick" },
    { src = "https://github.com/stevearc/conform.nvim"},
})
