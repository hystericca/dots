local map = vim.keymap.set
local group = vim.api.nvim_create_augroup("vik.lsp", { clear = true })

local completion_kind_icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰊄",
}

local filetype_icons = {
    lua = "",
    zig = "",
    rust = "",
    javascript = "",
    typescript = "",
    javascriptreact = "",
    typescriptreact = "",
    python = "",
    go = "",
    c = "",
    cpp = "",
    java = "",
    ruby = "",
    php = "",
    html = "",
    css = "",
    scss = "",
    json = "",
    yaml = "",
    yml = "",
    toml = "",
    markdown = "",
    vim = "",
    vimdoc = "",
    sh = "",
    bash = "",
    zsh = "",
    fish = "",
    gitcommit = "",
    gitrebase = "",
    nix = "",
    make = "",
    cmake = "",
    dockerfile = "",
    swift = "",
    typst = "",
    wgsl = "󰘚",
}

local function format_completion_item(bufnr, item)
    local kind = vim.lsp.protocol.CompletionItemKind[item.kind] or "Text"
    local kind_icon = completion_kind_icons[kind] or "󰉿"

    local filetype = vim.bo[bufnr].filetype
    local source_icon = filetype_icons[filetype] or ""

    return {
        kind = kind_icon .. " " .. kind,
        menu = source_icon,
    }
end

local function enable_completion(client, bufnr)
    if not client or not client:supports_method("textDocument/completion", bufnr) then
        return
    end

    vim.lsp.completion.enable(true, client.id, bufnr, {
        autotrigger = true,
        convert = function(item)
            return format_completion_item(bufnr, item)
        end,
    })
end

local tsgo_document_extensions = {
    cjs = true,
    cts = true,
    js = true,
    jsx = true,
    mjs = true,
    mts = true,
    ts = true,
    tsx = true,
}

local function is_tsgo_document_uri(uri)
    if type(uri) ~= "string" then
        return false
    end

    local path = vim.uri_to_fname(uri)
    local extension = path:match("%.([%w]+)$")
    return extension ~= nil and tsgo_document_extensions[extension] == true
end

local function filter_tsgo_notifications(client)
    if client._config_tsgo_notify_filter then
        return
    end

    client._config_tsgo_notify_filter = true
    local notify = client.notify

    client.notify = function(self, method, params)
        if method == "workspace/didChangeWatchedFiles" then
            return true
        end

        if method == "textDocument/didSave" then
            local uri = vim.tbl_get(params or {}, "textDocument", "uri")
            if not is_tsgo_document_uri(uri) then
                return true
            end
        end

        return notify(self, method, params)
    end
end

local function on_attach(_, bufnr)
    local function opts(desc)
        return { buffer = bufnr, desc = "LSP " .. desc }
    end

    map("n", "K", vim.lsp.buf.hover, opts("Hover"))
    map("i", "<C-s>", vim.lsp.buf.signature_help, opts("Signature help"))

    map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
    map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
    map("n", "gr", vim.lsp.buf.references, opts("References"))
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))

    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))
    map("n", "<leader>wl", function()
        vim.print(vim.lsp.buf.list_workspace_folders())
    end, opts("List workspace folders"))

    map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
    map("n", "<leader>ra", vim.lsp.buf.rename, opts("Rename"))
end

local function on_init(client, _)
    if client.name == "tsgo" then
        filter_tsgo_notifications(client)
    end

    if client.supports_method and client:supports_method("textDocument/semanticTokens") then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false,
    severity_sort = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        on_attach(client, args.buf)
        enable_completion(client, args.buf)
    end,
})

map("i", "<C-Space>", function()
    vim.lsp.completion.get()
end, { desc = "LSP complete" })

vim.lsp.config("*", {
    on_init = on_init,
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
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

vim.lsp.config("tinymist", {})

-- TODO: sort out this bitch ass lsp
--[[
vim.lsp.config("nixd", {
	cmd = { "nixd" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", "default.nix", "shell.nix", ".git" },
	settings = {
		nixd = {
			formatting = {
				command = { "nixfmt", "--indent=4" },
			},
		},
	},
})
]]

vim.lsp.config("wgsl_analyzer", {
    root_dir = function(bufnr, on_dir)
        local file = vim.api.nvim_buf_get_name(bufnr)
        local root = vim.fs.root(bufnr, { "wesl.toml", "package.json", ".git" })
        on_dir(root or (file ~= "" and vim.fs.dirname(file)) or vim.uv.cwd())
    end,
})

local web_filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "jsonc",
    "css",
}

vim.lsp.config("tsgo", {
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = false,
            },
        },
    },
})

vim.lsp.config("biome", {
    filetypes = web_filetypes,
    root_dir = function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, {
            "biome.json",
            "biome.jsonc",
            "package.json",
            "bun.lock",
            "bun.lockb",
            "pnpm-lock.yaml",
            "package-lock.json",
            "yarn.lock",
            ".git",
        })

        on_dir(root or vim.fn.getcwd())
    end,
})

vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--fallback-style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never}",
    },
    filetypes = {
        "c",
        "cpp",
        "objc",
        "objcpp",
        "cuda",
    },
    root_markers = {
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac",
        ".git",
    },
})

local python_root_markers = { "pyproject.toml", "uv.lock", "ruff.toml", ".ruff.toml", "ty.toml", ".git" }

vim.lsp.config("ruff", {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = python_root_markers,
})

vim.lsp.config("ty", {
    cmd = { "ty", "server" },
    filetypes = { "python" },
    root_markers = python_root_markers,
})

local function swift_root_dir(bufnr, on_dir)
    local file = vim.api.nvim_buf_get_name(bufnr)
    local dir = file ~= "" and vim.fs.dirname(file) or vim.uv.cwd()
    if not dir then
        return
    end

    local markers = vim.fs.find(function(name)
        return name == "Package.swift"
            or name == ".git"
            or name:match("%.xcodeproj$") ~= nil
            or name:match("%.xcworkspace$") ~= nil
    end, { path = dir, upward = true, limit = 1 })

    on_dir(markers[1] and vim.fs.dirname(markers[1]) or dir)
end

vim.lsp.config("sourcekit", {
    cmd = { "sourcekit-lsp" },
    filetypes = { "swift" },
    root_dir = swift_root_dir,
})

vim.lsp.enable({
    "lua_ls",
    -- "tinymist",
    -- "nixd",
    -- "wgsl_analyzer",
    -- "tsgo",
    -- "biome",
    "clangd",
    "sourcekit",
})
