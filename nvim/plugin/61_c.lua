local c_filetypes = { "c", "cpp", "objc", "objcpp", "metal" }

local c_group = vim.api.nvim_create_augroup("COptions", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = c_group,
    pattern = c_filetypes,
    callback = function()
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 4
        vim.bo.softtabstop = 4
        vim.bo.tabstop = 4
        vim.bo.cindent = true
    end,
})
