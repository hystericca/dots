local ok, oil = pcall(require, "oil")
if not ok then
    return
end

oil.setup({
    default_file_explorer = true,

    columns = {
        "icon",
    },

    delete_to_trash = false,
    skip_confirm_for_simple_edits = false,
    prompt_save_on_select_new_entry = true,

    view_options = {
        show_hidden = true,
        natural_order = true,
    },
})

vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open Oil" })
