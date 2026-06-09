local ok, lackluster = pcall(require, "lackluster")
if not ok then
    vim.notify("lackluster.nvim is not installed or not loaded", vim.log.levels.WARN)
    return
end

local dark_colors = {
    black = "#000000",
    gray1 = "#000000",
    gray2 = "#111111",
    gray3 = "#242424",
    gray4 = "#4a4a4a",
    gray5 = "#666666",
    gray6 = "#888888",
    gray7 = "#b8b8b8",
    gray8 = "#d8d8d8",
    gray9 = "#ffffff",
    luster = "#ffffff",
}

local dark_backgrounds = {
    normal = "#000000",
    telescope = "#000000",
    menu = "#111111",
    popup = "#111111",
}

local dark_ui_highlights = {
    Normal = { fg = "#eeeeee", bg = "#000000" },
    NormalNC = { fg = "#d8d8d8", bg = "#000000" },

    Comment = { fg = "#7a7a7a", italic = true },

    LineNr = { fg = "#5f5f5f" },
    CursorLine = { bg = "#111111" },
    CursorLineNr = { fg = "#ffffff", bg = "#111111", bold = true },

    Visual = { bg = "#333333" },

    Pmenu = { fg = "#eeeeee", bg = "#111111" },
    PmenuSel = { fg = "#ffffff", bg = "#333333", bold = true },
    PmenuSbar = { bg = "#111111" },
    PmenuThumb = { bg = "#444444" },

    Search = { fg = "#ffffff", bg = "#444444", bold = true },
    IncSearch = { fg = "#000000", bg = "#ffffff", bold = true },
    CurSearch = { fg = "#000000", bg = "#ffffff", bold = true },

    MsgArea = { fg = "#b8b8b8", bg = "#000000" },
    ModeMsg = { fg = "#ffffff", bg = "#000000", bold = true },
    MoreMsg = { fg = "#ffffff", bg = "#000000" },
    Question = { fg = "#ffffff", bg = "#000000" },

    FloatBorder = { fg = "#666666", bg = "#111111" },
    NormalFloat = { fg = "#eeeeee", bg = "#111111" },

    TelescopeNormal = { fg = "#eeeeee", bg = "#000000" },
    TelescopeBorder = { fg = "#444444", bg = "#000000" },
    TelescopePromptNormal = { fg = "#eeeeee", bg = "#111111" },
    TelescopePromptBorder = { fg = "#444444", bg = "#111111" },
    TelescopePromptTitle = { fg = "#000000", bg = "#ffffff", bold = true },
    TelescopePreviewTitle = { fg = "#000000", bg = "#b8b8b8", bold = true },
    TelescopeResultsTitle = { fg = "#000000", bg = "#b8b8b8", bold = true },
    TelescopeSelection = { fg = "#ffffff", bg = "#222222", bold = true },
    TelescopeMatching = { fg = "#ffffff", bold = true },

    DiagnosticError = { fg = "#ff5f5f" },
    DiagnosticWarn = { fg = "#d7af5f" },
    DiagnosticInfo = { fg = "#8fb2d1" },
    DiagnosticHint = { fg = "#888888" },

    IlluminatedWordText = { bg = "#202020", underline = false },
    IlluminatedWordRead = { bg = "#202020", underline = false },
    IlluminatedWordWrite = { bg = "#282828", underline = false },

    GitSignsCurrentLineBlameIcon = { fg = "#777777" },
    GitSignsCurrentLineBlame = { fg = "#666666", italic = true },
}

local function extend_highlights(highlights)
    return vim.tbl_deep_extend("force", vim.deepcopy(dark_ui_highlights), highlights)
end

local variants = {
    mina = {
        background = "dark",
        label = "Mina",
        description = "Black UI with dim useful syntax color",
        theme = nil,
        colors = dark_colors,
        backgrounds = dark_backgrounds,
        highlights = extend_highlights({
            Function = { fg = "#b99ad6", bold = true },
            Keyword = { fg = "#b88783", bold = true },
            Type = { fg = "#b8946a", bold = true },
            String = { fg = "#8fb2d1" },
            Constant = { fg = "#7f9fca" },
            Number = { fg = "#7f9fca" },
            Boolean = { fg = "#7f9fca" },
            Operator = { fg = "#b88783" },
            Delimiter = { fg = "#8a8a8a" },
            Identifier = { fg = "#c8c8c8" },

            ["@function"] = { fg = "#b99ad6", bold = true },
            ["@function.call"] = { fg = "#b99ad6" },
            ["@method"] = { fg = "#b99ad6" },
            ["@method.call"] = { fg = "#b99ad6" },

            ["@keyword"] = { fg = "#b88783", bold = true },
            ["@keyword.function"] = { fg = "#b88783", bold = true },
            ["@keyword.return"] = { fg = "#b88783", bold = true },
            ["@keyword.operator"] = { fg = "#b88783", bold = true },

            ["@type"] = { fg = "#b8946a", bold = true },
            ["@type.builtin"] = { fg = "#b8946a", bold = true },

            ["@string"] = { fg = "#8fb2d1" },
            ["@constant"] = { fg = "#7f9fca" },
            ["@constant.builtin"] = { fg = "#7f9fca" },
            ["@number"] = { fg = "#7f9fca" },
            ["@boolean"] = { fg = "#7f9fca" },

            ["@operator"] = { fg = "#b88783" },
            ["@punctuation"] = { fg = "#8a8a8a" },
            ["@punctuation.delimiter"] = { fg = "#8a8a8a" },
            ["@punctuation.bracket"] = { fg = "#8a8a8a" },

            ["@variable"] = { fg = "#c8c8c8" },
            ["@variable.member"] = { fg = "#c8c8c8" },
            ["@property"] = { fg = "#c8c8c8" },
            ["@comment"] = { fg = "#5f5f5f", italic = true },
        }),
    },

    minalowlight = {
        background = "dark",
        label = "Mina Lowlight",
        description = "Black UI with grayscale syntax",
        theme = nil,
        colors = dark_colors,
        backgrounds = dark_backgrounds,
        highlights = extend_highlights({
            Function = { fg = "#ffffff" },
            Keyword = { fg = "#ffffff", bold = true },
            Type = { fg = "#eeeeee", bold = true },
            String = { fg = "#cfcfcf" },
            Constant = { fg = "#d8d8d8" },
            Number = { fg = "#d8d8d8" },
            Boolean = { fg = "#d8d8d8" },
            Operator = { fg = "#eeeeee" },
            Delimiter = { fg = "#8a8a8a" },
            Identifier = { fg = "#c8c8c8" },

            ["@function"] = { fg = "#ffffff" },
            ["@function.call"] = { fg = "#ffffff" },
            ["@method"] = { fg = "#ffffff" },
            ["@method.call"] = { fg = "#ffffff" },

            ["@keyword"] = { fg = "#ffffff", bold = true },
            ["@keyword.function"] = { fg = "#ffffff", bold = true },
            ["@keyword.return"] = { fg = "#ffffff", bold = true },

            ["@type"] = { fg = "#eeeeee", bold = true },
            ["@type.builtin"] = { fg = "#eeeeee", bold = true },

            ["@string"] = { fg = "#cfcfcf" },
            ["@constant"] = { fg = "#d8d8d8" },
            ["@constant.builtin"] = { fg = "#d8d8d8" },
            ["@number"] = { fg = "#d8d8d8" },
            ["@boolean"] = { fg = "#d8d8d8" },

            ["@operator"] = { fg = "#eeeeee" },
            ["@punctuation"] = { fg = "#8a8a8a" },

            ["@variable"] = { fg = "#c8c8c8" },
            ["@variable.member"] = { fg = "#c8c8c8" },
            ["@property"] = { fg = "#c8c8c8" },
            ["@comment"] = { fg = "#7a7a7a", italic = true },
        }),
    },
}

local order = {
    "mina",
    "minalowlight",
}

local aliases = {
    dark = "mina",
    lowlight = "minalowlight",
    ["mina-lowlight"] = "minalowlight",
    mina_lowlight = "minalowlight",
}

local function resolve(name)
    name = name or "mina"
    return aliases[name] or name
end

local state_path = vim.fn.stdpath("state") .. "/mina-theme"

local function read_persisted()
    local ok_read, lines = pcall(vim.fn.readfile, state_path)

    if not ok_read or #lines == 0 then
        return nil
    end

    local name = resolve(vim.trim(lines[1]))
    return variants[name] and name or nil
end

local function persist(name)
    name = resolve(name)

    if not variants[name] then
        return
    end

    vim.fn.mkdir(vim.fn.fnamemodify(state_path, ":h"), "p")

    local ok_write, err = pcall(vim.fn.writefile, { name }, state_path)
    if not ok_write then
        vim.notify("Theme preference was not saved: " .. tostring(err), vim.log.levels.WARN)
    end
end

local function clear_persisted()
    if vim.fn.filereadable(state_path) == 1 then
        vim.fn.delete(state_path)
    end
end

local function refresh_statusline()
    if _G.Statusline and _G.Statusline.refresh then
        _G.Statusline.refresh()
    else
        pcall(vim.cmd, "redrawstatus")
    end
end

local function apply(name, opts)
    opts = opts or {}

    name = resolve(name)

    local variant = variants[name]
    if not variant then
        name = "mina"
        variant = variants.mina
    end

    vim.g.mina_theme_variant = name
    vim.g.gray_theme_variant = name
    vim.o.background = variant.background

    lackluster.setup({
        tweak_color = variant.colors,
        tweak_background = variant.backgrounds,
        tweak_highlight = variant.highlights,
    })

    lackluster.load({
        theme = variant.theme,
    })

    refresh_statusline()
    vim.schedule(refresh_statusline)

    if opts.persist then
        persist(name)
    end
end

local function pick_with_builtin_select()
    vim.ui.select(order, {
        prompt = "Theme",
        format_item = function(item)
            local variant = variants[item]
            return variant.label .. " - " .. variant.description
        end,
    }, function(choice)
        if choice then
            apply(choice, { persist = true })
        end
    end)
end

local function pick()
    local ok_pickers, pickers = pcall(require, "telescope.pickers")
    local ok_finders, finders = pcall(require, "telescope.finders")
    local ok_conf, conf = pcall(require, "telescope.config")
    local ok_actions, actions = pcall(require, "telescope.actions")
    local ok_state, action_state = pcall(require, "telescope.actions.state")

    if not (ok_pickers and ok_finders and ok_conf and ok_actions and ok_state) then
        pick_with_builtin_select()
        return
    end

    local current = resolve(vim.g.mina_theme_variant or vim.g.gray_theme_variant)

    pickers
        .new({}, {
            prompt_title = "Themes",

            finder = finders.new_table({
                results = order,

                entry_maker = function(name)
                    local variant = variants[name]
                    local marker = name == current and "* " or "  "

                    return {
                        value = name,
                        display = marker .. variant.label .. "  " .. variant.description,
                        ordinal = name .. " " .. variant.label .. " " .. variant.description,
                    }
                end,
            }),

            sorter = conf.values.generic_sorter({}),

            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)

                    if selection then
                        apply(selection.value, { persist = true })
                    end
                end)

                return true
            end,
        })
        :find()
end

local function system_variant()
    return "mina"
end

apply(vim.g.mina_theme_variant or vim.g.gray_theme_variant or read_persisted() or system_variant())

vim.api.nvim_create_user_command("ThemePick", pick, {
    desc = "Pick Mina theme",
})

vim.api.nvim_create_user_command("ThemeMina", function()
    apply("mina", { persist = true })
end, {
    desc = "Use Mina theme",
})

vim.api.nvim_create_user_command("ThemeMinaLowlight", function()
    apply("minalowlight", { persist = true })
end, {
    desc = "Use Mina Lowlight theme",
})

vim.api.nvim_create_user_command("ThemeDark", function()
    apply("mina", { persist = true })
end, {
    desc = "Use Mina theme",
})

vim.api.nvim_create_user_command("ThemeToggle", function()
    local current = resolve(vim.g.mina_theme_variant or vim.g.gray_theme_variant)
    apply(current == "mina" and "minalowlight" or "mina", { persist = true })
end, {
    desc = "Toggle Mina and Mina Lowlight",
})

vim.api.nvim_create_user_command("ThemeSystem", function()
    clear_persisted()
    apply(system_variant())
end, {
    desc = "Use system theme and clear saved Mina theme",
})
