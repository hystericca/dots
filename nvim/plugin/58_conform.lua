local ok, conform = pcall(require, "conform")
if not ok then
    return
end

local c_filetypes = { "c", "cpp", "objc", "objcpp", "metal" }
local web_filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "jsonc",
    "css",
}

local biome_indent_args = {
    "format",
    "--stdin-file-path",
    "$FILENAME",
    "--indent-style",
    "space",
    "--indent-width",
    "4",
}

local formatters_by_ft = {}

for _, filetype in ipairs(c_filetypes) do
    formatters_by_ft[filetype] = { "clang-format" }
end

for _, filetype in ipairs(web_filetypes) do
    formatters_by_ft[filetype] = { "biome" }
end

formatters_by_ft.lua = { "stylua" }
formatters_by_ft.zig = { "zigfmt" }
formatters_by_ft.python = { "ruff_organize_imports", "ruff_fix", "ruff_format" }

conform.setup({
    formatters_by_ft = formatters_by_ft,
    format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
    },
    formatters = {
        ["clang-format"] = {
            prepend_args = function(_, ctx)
                local dir = vim.fs.dirname(ctx.filename)
                local found = vim.fs.find({ ".clang-format", "_clang-format" }, {
                    upward = true,
                    path = dir,
                })[1]

                if found then
                    return { "--style=file" }
                end

                return {
                    "--style=file:" .. vim.fn.expand("~/.config/clang-format"),
                }
            end,
        },
        biome = {
            args = biome_indent_args,
            "--indent-style",
            "space",
            "--indent-width",
            "4",
        },
    },
})
