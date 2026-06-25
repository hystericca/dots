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

vim.keymap.set("n", "<leader>fr", switch_recent_file, { desc = "Recent Files (Native)" })

local ok, pick = pcall(require, "mini.pick")
if not ok then
    return
end

pick.setup({})

vim.ui.select = pick.ui_select

vim.keymap.set("n", "<leader>ff", pick.builtin.files, { desc = "Find files (Mini)" })
vim.keymap.set("n", "<leader>fg", pick.builtin.grep_live, { desc = "Live grep (Mini)" })
vim.keymap.set("n", "<leader>fb", pick.builtin.buffers, { desc = "Buffers list (Mini)" })
