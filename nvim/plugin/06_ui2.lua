local ok, ui2 = pcall(require, "vim._core.ui2")
if not ok then
    vim.notify("vim._core.ui2 is not available in this Neovim build", vim.log.levels.WARN)
    return
end

ui2.enable({
    enable = true,

    msg = {
        target = "msg",

        pager = {
            height = 1,
        },

        msg = {
            height = 0.5,
            timeout = 4500,
        },

        dialog = {
            height = 0.5,
        },

        cmd = {
            height = 0.5,
        },
    },
})
