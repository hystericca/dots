local group = vim.api.nvim_create_augroup("ZigTools", { clear = true })

local function zig_root()
    local root = vim.fs.root(0, { "build.zig", "build.zig.zon", ".git" })
    return root or vim.uv.cwd()
end

local function current_file()
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
        vim.notify("No file to check", vim.log.levels.WARN)
        return nil
    end
    return file
end

local function quickfix(command, opts)
    opts = opts or {}

    if vim.fn.executable(command[1]) == 0 then
        vim.notify(command[1] .. " is not executable", vim.log.levels.ERROR)
        return
    end

    vim.system(
        command,
        {
            cwd = opts.cwd or zig_root(),
            text = true,
        },
        vim.schedule_wrap(function(result)
            local output = vim.trim((result.stdout or "") .. "\n" .. (result.stderr or ""))
            local title = opts.title or table.concat(command, " ")

            vim.fn.setqflist({}, "r", {
                title = title,
                lines = output == "" and {} or vim.split(output, "\n"),
            })

            if result.code == 0 then
                vim.notify(title .. " passed")
                pcall(vim.cmd, "cclose")
            else
                vim.notify(title .. " failed", vim.log.levels.ERROR)
                vim.cmd.copen()
            end
        end)
    )
end

vim.api.nvim_create_user_command("ZigCheck", function()
    local file = current_file()
    if not file then
        return
    end

    quickfix({ "zig", "ast-check", "--color", "off", file }, {
        title = "zig ast-check",
    })
end, { desc = "Run zig ast-check on current file" })

vim.api.nvim_create_user_command("ZigBuild", function()
    quickfix({ "zig", "build", "--color", "off" }, {
        title = "zig build",
    })
end, { desc = "Run zig build" })

vim.api.nvim_create_user_command("ZigTest", function()
    local file = current_file()
    if not file then
        return
    end

    quickfix({ "zig", "test", "--color", "off", file }, {
        title = "zig test current file",
    })
end, { desc = "Run zig test on current file" })

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "zig",
    callback = function(args)
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4

        vim.keymap.set("n", "<leader>zc", "<cmd>ZigCheck<CR>", {
            buffer = args.buf,
            silent = true,
            desc = "Zig ast-check",
        })

        vim.keymap.set("n", "<leader>zb", "<cmd>ZigBuild<CR>", {
            buffer = args.buf,
            silent = true,
            desc = "Zig build",
        })

        vim.keymap.set("n", "<leader>zt", "<cmd>ZigTest<CR>", {
            buffer = args.buf,
            silent = true,
            desc = "Zig test file",
        })
    end,
})
