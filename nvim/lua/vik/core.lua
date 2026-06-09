local function trim_lsp_log(max_size)
    local ok, lsp_log = pcall(vim.lsp.log.get_filename)
    if not ok or not lsp_log then
        return
    end

    local stat = vim.uv.fs_stat(lsp_log)
    if not stat or stat.size <= max_size then
        return
    end

    local fd = vim.uv.fs_open(lsp_log, "w", 420)
    if fd then
        vim.uv.fs_close(fd)
    end
end

trim_lsp_log(10 * 1024 * 1024)
vim.lsp.log.set_level(vim.log.levels.ERROR)
