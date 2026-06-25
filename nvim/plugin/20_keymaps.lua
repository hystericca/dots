local map = vim.keymap.set

map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Buffer next" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Buffer close" })

local term_group = vim.api.nvim_create_augroup("TerminalKeymaps", { clear = true })
local terminal = { buf = nil, win = nil }

vim.api.nvim_create_autocmd("TermOpen", {
    group = term_group,
    callback = function(args)
        local opts = { buffer = args.buf, silent = true }

        map("t", "<C-[>", [[<C-\><C-n>]], vim.tbl_extend("force", opts, { desc = "Terminal normal mode" }))
        map(
            "t",
            "<M-v>",
            [[<C-\><C-n><cmd>TermToggle<CR>]],
            vim.tbl_extend("force", opts, { desc = "Terminal toggle" })
        )
    end,
})

local function toggle_terminal()
    if terminal.win and vim.api.nvim_win_is_valid(terminal.win) then
        vim.api.nvim_win_close(terminal.win, true)
        terminal.win = nil
        return
    end

    vim.cmd("botright 12split")
    terminal.win = vim.api.nvim_get_current_win()

    if terminal.buf and vim.api.nvim_buf_is_valid(terminal.buf) then
        vim.api.nvim_win_set_buf(terminal.win, terminal.buf)
    else
        vim.cmd("terminal")
        terminal.buf = vim.api.nvim_get_current_buf()
        vim.bo[terminal.buf].buflisted = false
        vim.bo[terminal.buf].bufhidden = "hide"
    end

    vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("TermToggle", toggle_terminal, {})
map("n", "<M-v>", toggle_terminal, { desc = "Terminal toggle" })
