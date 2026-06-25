-- workspace switcher
local function switch_workspace()
    local dev_dir = vim.fn.expand("~/Developer")
    local config_dir = vim.fn.stdpath("config")

    local paths = { config_dir }

    local handle = vim.uv.fs_scandir(dev_dir)
    if handle then
        while true do
            local name, type = vim.uv.fs_scandir_next(handle)
            if not name then
                break
            end
            if type == "directory" and name:sub(1, 1) ~= "." then
                table.insert(paths, dev_dir .. "/" .. name)
            end
        end
    end

    table.sort(paths)

    vim.ui.select(paths, {
        prompt = "Switch Workspace:",
        format_item = function(item)
            return item:gsub(vim.fn.expand("~"), "~")
        end,
    }, function(choice)
        if choice then
            vim.cmd("cd " .. choice)
            if vim.fn.exists(":Oil") == 2 then
                vim.cmd("Oil " .. choice)
            else
                vim.cmd("edit .")
            end
            print("Switched CWD to: " .. choice)
        end
    end)
end

vim.keymap.set("n", "<leader>fp", switch_workspace, { desc = "Switch Workspace (Native)" })

-- buffer switcher
local function switch_buffer()
    local buffers = {}
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
            local name = vim.api.nvim_buf_get_name(bufnr)
            if name ~= "" then
                table.insert(buffers, { bufnr = bufnr, name = name })
            end
        end
    end

    if #buffers == 0 then
        print("No loaded buffers")
        return
    end

    vim.ui.select(buffers, {
        prompt = "Switch Buffer:",
        format_item = function(item)
            return string.format("[%d] %s", item.bufnr, vim.fn.fnamemodify(item.name, ":~:."))
        end,
    }, function(choice)
        if choice then
            vim.api.nvim_set_current_buf(choice.bufnr)
        end
    end)
end

vim.keymap.set("n", "<leader>fb", switch_buffer, { desc = "switch buffer" })

-- recent files switcher
local function switch_recent_file()
    local oldfiles = vim.v.oldfiles
    if #oldfiles == 0 then
        print("No recent files")
        return
    end

    vim.ui.select(oldfiles, {
        prompt = "Recent Files:",
        format_item = function(item)
            return item:gsub(vim.fn.expand("~"), "~")
        end,
    }, function(choice)
        if choice then
            vim.cmd("edit " .. choice)
        end
    end)
end

vim.keymap.set("n", "<leader>fr", switch_recent_file, { desc = "recent files" })
