local map = vim.keymap.set

vim.lsp.enable("clangd")

vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = true,
    severity_sort = true,
})

local function lsp_keymaps(bufnr)
    local function opts(desc)
        return {
            buffer = bufnr,
            desc = "LSP " .. desc,
        }
    end

    map("n", "K", vim.lsp.buf.hover, opts("Hover"))
    map("i", "<C-s>", vim.lsp.buf.signature_help, opts("Signature Help"))

    map("n", "gD", vim.lsp.buf.declaration, opts("Declaration"))
    map("n", "gd", vim.lsp.buf.definition, opts("Definition"))
    map("n", "gr", vim.lsp.buf.references, opts("References"))

    map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Type Definition"))

    map("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code Action"))
    map("n", "<leader>ra", vim.lsp.buf.rename, opts("Rename"))

    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Workspace Add"))
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Workspace Remove"))

    map("n", "<leader>wl", function()
        vim.print(vim.lsp.buf.list_workspace_folders())
    end, opts("Workspace List"))
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if not client then
            return
        end

        lsp_keymaps(args.buf)

        if client:supports_method("textDocument/completion", args.buf) then
            vim.lsp.completion.enable(true, client.id, args.buf, {
                autotrigger = true,
            })
        end
    end,
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },

            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME .. "/lua",
                    vim.fn.stdpath("config") .. "/lua",
                    "${3rd}/luv/library",
                },
            },

            completion = {
                workspaceWord = false,
                keywordSnippet = "Disable",
                callSnippet = "Replace",
            },
        },
    },
})

vim.o.pumheight = 5
