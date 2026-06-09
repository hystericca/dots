-- ~/.config/nvim/plugin/70_statusline.lua

local M = {}

local modes = {
    n = "NORMAL",
    no = "OP",
    nov = "OP",
    noV = "OP",
    ["no\22"] = "OP",
    niI = "NORMAL",
    niR = "NORMAL",
    niV = "NORMAL",
    nt = "NORMAL",

    v = "VISUAL",
    V = "V-LINE",
    ["\22"] = "V-BLOCK",

    s = "SELECT",
    S = "S-LINE",
    ["\19"] = "S-BLOCK",

    i = "INSERT",
    ic = "INSERT",
    ix = "INSERT",

    R = "REPLACE",
    Rc = "REPLACE",
    Rx = "REPLACE",
    Rv = "V-REPLACE",
    Rvc = "V-REPLACE",
    Rvx = "V-REPLACE",

    c = "COMMAND",
    cv = "EX",
    ce = "EX",

    r = "PROMPT",
    rm = "MORE",
    ["r?"] = "CONFIRM",

    ["!"] = "SHELL",
    t = "TERMINAL",
}

local mode_colors = {
    NORMAL = { group = "StatusLineModeNormal", fg = "#000000", bg = "#eeeeee" },
    INSERT = { group = "StatusLineModeInsert", fg = "#000000", bg = "#b8b8b8" },
    VISUAL = { group = "StatusLineModeVisual", fg = "#000000", bg = "#d7af5f" },
    ["V-LINE"] = { group = "StatusLineModeVisual", fg = "#000000", bg = "#d7af5f" },
    ["V-BLOCK"] = { group = "StatusLineModeVisual", fg = "#000000", bg = "#d7af5f" },
    REPLACE = { group = "StatusLineModeReplace", fg = "#000000", bg = "#ff5f5f" },
    ["V-REPLACE"] = { group = "StatusLineModeReplace", fg = "#000000", bg = "#ff5f5f" },
    COMMAND = { group = "StatusLineModeCommand", fg = "#000000", bg = "#eeeeee" },
    TERMINAL = { group = "StatusLineModeTerminal", fg = "#000000", bg = "#8fb2d1" },
}

local palette = {}

local function hex(value, fallback)
    if type(value) == "number" then
        return string.format("#%06x", value)
    end

    return value or fallback
end

local function hl_color(group, attr, fallback)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, {
        name = group,
        link = false,
    })

    if not ok then
        return fallback
    end

    return hex(hl[attr], fallback)
end

local function colors()
    local dark = vim.o.background == "dark"

    local bg = hl_color("Normal", "bg", dark and "#000000" or "#ffffff")
    local fg = hl_color("Normal", "fg", dark and "#eeeeee" or "#111111")
    local muted = hl_color("Comment", "fg", dark and "#7a7a7a" or "#6a6a6a")
    local dim = hl_color("LineNr", "fg", dark and "#5f5f5f" or "#8a8a8a")
    local surface = hl_color("CursorLine", "bg", dark and "#111111" or "#eeeeee")

    palette = {
        bg = bg,
        fg = fg,
        soft = dark and "#b8b8b8" or "#444444",
        muted = muted,
        dim = dim,
        surface = surface,
        surface_hi = hl_color("Visual", "bg", dark and "#333333" or "#d0d0d0"),
        inactive_bg = bg,
        inactive_fg = dim,
        error = hl_color("DiagnosticError", "fg", dark and "#ff5f5f" or "#af0000"),
        warn = hl_color("DiagnosticWarn", "fg", dark and "#d7af5f" or "#875f00"),
    }

    local mode_fg = dark and "#000000" or "#ffffff"

    mode_colors.NORMAL = {
        group = "StatusLineModeNormal",
        fg = mode_fg,
        bg = fg,
    }

    mode_colors.INSERT = {
        group = "StatusLineModeInsert",
        fg = mode_fg,
        bg = dark and "#b8b8b8" or "#444444",
    }

    mode_colors.VISUAL = {
        group = "StatusLineModeVisual",
        fg = mode_fg,
        bg = dark and "#888888" or "#666666",
    }

    mode_colors["V-LINE"] = mode_colors.VISUAL
    mode_colors["V-BLOCK"] = mode_colors.VISUAL

    mode_colors.REPLACE = {
        group = "StatusLineModeReplace",
        fg = "#000000",
        bg = palette.error,
    }

    mode_colors["V-REPLACE"] = mode_colors.REPLACE
    mode_colors.COMMAND = mode_colors.NORMAL

    mode_colors.TERMINAL = {
        group = "StatusLineModeTerminal",
        fg = mode_fg,
        bg = dark and "#666666" or "#888888",
    }
end

local function set_hl()
    colors()

    vim.api.nvim_set_hl(0, "StatusLine", { fg = palette.fg, bg = palette.bg })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = palette.inactive_fg, bg = palette.inactive_bg })
    vim.api.nvim_set_hl(0, "StatusLineBlank", { fg = palette.bg, bg = palette.bg })

    for _, color in pairs(mode_colors) do
        vim.api.nvim_set_hl(0, color.group, {
            fg = color.fg,
            bg = color.bg,
            bold = true,
        })
    end

    vim.api.nvim_set_hl(0, "StatusLineFile", { fg = palette.fg, bg = palette.bg, bold = true })
    vim.api.nvim_set_hl(0, "StatusLineProject", { fg = palette.fg, bg = palette.bg, bold = true })
    vim.api.nvim_set_hl(0, "StatusLinePath", { fg = palette.muted, bg = palette.bg })
    vim.api.nvim_set_hl(0, "StatusLinePathSep", { fg = palette.dim, bg = palette.bg })

    vim.api.nvim_set_hl(0, "StatusLineGit", { fg = palette.soft, bg = palette.bg, bold = true })
    vim.api.nvim_set_hl(0, "StatusLineGitIcon", { fg = palette.fg, bg = palette.bg })
    vim.api.nvim_set_hl(0, "StatusLineGitAdd", { fg = palette.soft, bg = palette.bg })
    vim.api.nvim_set_hl(0, "StatusLineGitChange", { fg = palette.muted, bg = palette.bg })
    vim.api.nvim_set_hl(0, "StatusLineGitDelete", { fg = palette.dim, bg = palette.bg })

    vim.api.nvim_set_hl(0, "StatusLineMuted", { fg = palette.muted, bg = palette.bg })
    vim.api.nvim_set_hl(0, "StatusLineDim", { fg = palette.dim, bg = palette.bg })
    vim.api.nvim_set_hl(0, "StatusLineError", { fg = palette.error, bg = palette.bg, bold = true })
    vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = palette.warn, bg = palette.bg, bold = true })

    vim.api.nvim_set_hl(0, "MsgArea", { fg = palette.muted, bg = palette.inactive_bg })
    vim.api.nvim_set_hl(0, "ModeMsg", { fg = palette.fg, bg = palette.inactive_bg, bold = true })
    vim.api.nvim_set_hl(0, "MoreMsg", { fg = palette.fg, bg = palette.inactive_bg })
    vim.api.nvim_set_hl(0, "Question", { fg = palette.fg, bg = palette.inactive_bg })
end

local function esc(text)
    return tostring(text):gsub("%%", "%%%%")
end

local function mode_name()
    local mode = vim.api.nvim_get_mode().mode
    return modes[mode] or mode:upper()
end

local function mode_component()
    local mode = mode_name()
    local hl = (mode_colors[mode] or mode_colors.NORMAL).group

    return "%#" .. hl .. "# " .. esc(mode) .. " %#StatusLine# "
end

local function current_width()
    local winid = vim.g.actual_curwin or 0
    local ok, width = pcall(vim.api.nvim_win_get_width, winid)

    return ok and width or vim.o.columns
end

local function split_path(path)
    local parts = {}

    for part in path:gmatch("[^/]+") do
        parts[#parts + 1] = part
    end

    return parts
end

local function compact_path(parts, width)
    local max_parts = width >= 132 and 5 or width >= 100 and 4 or width >= 72 and 3 or 2

    if #parts <= max_parts then
        return parts
    end

    local compact = { parts[1], "…" }
    local keep = max_parts - 2

    for i = #parts - keep + 1, #parts do
        compact[#compact + 1] = parts[i]
    end

    return compact
end

local function basename(path)
    path = (path or ""):gsub("/+$", "")
    return path:match("([^/]+)$") or path
end

local function relative_to(root, path)
    if root == "" or path == "" then
        return nil
    end

    root = root:gsub("\\", "/"):gsub("/+$", "")
    path = path:gsub("\\", "/")

    if path == root then
        return basename(path)
    end

    local prefix = root .. "/"
    if path:sub(1, #prefix) == prefix then
        return path:sub(#prefix + 1)
    end

    return nil
end

local function project_markers()
    return {
        ".git",
        "package.json",
        "Cargo.toml",
        "go.mod",
        "pyproject.toml",
        "flake.nix",
        "stylua.toml",
    }
end

local function path_context()
    local full = vim.api.nvim_buf_get_name(0):gsub("\\", "/")

    if full == "" then
        return nil
    end

    local ok, root = pcall(vim.fs.root, 0, project_markers())
    root = ok and root or nil

    local rel = root and relative_to(root, full) or nil
    rel = rel or vim.fn.fnamemodify(full, ":~:."):gsub("\\", "/")

    local dir, file = rel:match("^(.*)/([^/]+)$")
    local parts = dir and split_path(dir) or {}
    local project = root and basename(root) or nil

    if project and project:sub(1, 1) == "." and #parts > 0 then
        project = table.remove(parts, 1)
    end

    project = project and project ~= "" and project or "cwd"

    return {
        project = project,
        parts = parts,
        file = file or rel,
    }
end

local function path_component(width)
    local context = path_context()

    if not context then
        return "%#StatusLineFile#[No Name]%#StatusLine#"
    end

    local parts = compact_path(context.parts, width)

    if width < 64 then
        return "%#StatusLineFile#" .. esc(context.file) .. "%#StatusLine#"
    end

    local trail = ""

    if width >= 88 and #parts > 0 then
        local styled_parts = {}

        for _, part in ipairs(parts) do
            styled_parts[#styled_parts + 1] = esc(part)
        end

        trail = table.concat({
            "%#StatusLinePath#",
            table.concat(styled_parts, "%#StatusLinePathSep# · %#StatusLinePath#"),
            "%#StatusLinePathSep# / ",
        })
    end

    return table.concat({
        "%#StatusLineProject#",
        esc(context.project),
        "%#StatusLinePathSep# › ",
        trail,
        "%#StatusLineFile#",
        esc(context.file),
        "%#StatusLine#",
    })
end

local function filename_component(width)
    local flags = {}

    if vim.bo.modified then
        flags[#flags + 1] = "+"
    end

    if vim.bo.readonly or not vim.bo.modifiable then
        flags[#flags + 1] = "ro"
    end

    local suffix = #flags > 0 and (" %#StatusLineWarn#" .. table.concat(flags, " ")) or ""

    return path_component(width) .. suffix .. "%#StatusLine#"
end

local function git_component()
    local status = vim.b.gitsigns_status_dict or {}
    local branch = status.head or vim.b.gitsigns_head

    if not branch or branch == "" then
        return ""
    end

    local parts = {
        "%#StatusLineGitIcon# ",
        "%#StatusLineGit#",
        esc(branch),
    }

    local added = status.added or 0
    local changed = status.changed or 0
    local removed = status.removed or 0

    if added > 0 then
        parts[#parts + 1] = "%#StatusLineGitAdd# +" .. added
    end

    if changed > 0 then
        parts[#parts + 1] = "%#StatusLineGitChange# ~" .. changed
    end

    if removed > 0 then
        parts[#parts + 1] = "%#StatusLineGitDelete# -" .. removed
    end

    return table.concat(parts)
end

local function diagnostics_component()
    if not vim.diagnostic or not vim.diagnostic.count then
        return ""
    end

    local counts = vim.diagnostic.count(0)
    local errors = counts[vim.diagnostic.severity.ERROR] or 0
    local warnings = counts[vim.diagnostic.severity.WARN] or 0
    local parts = {}

    if errors > 0 then
        parts[#parts + 1] = "%#StatusLineError# " .. errors
    end

    if warnings > 0 then
        parts[#parts + 1] = "%#StatusLineWarn# " .. warnings
    end

    return table.concat(parts, "  ")
end

local function filetype_component()
    local filetype = vim.bo.filetype ~= "" and vim.bo.filetype or "plain"
    return "%#StatusLineMuted#" .. esc(filetype)
end

local function location_component()
    return "%#StatusLineMuted#%l:%c %#StatusLineDim#%p%%"
end

local function right_components(width)
    local parts = {}
    local diagnostics = diagnostics_component()
    local git = git_component()

    if width >= 84 and git ~= "" then
        parts[#parts + 1] = git
    end

    if diagnostics ~= "" then
        parts[#parts + 1] = diagnostics
    end

    if width >= 72 then
        parts[#parts + 1] = filetype_component()
    end

    parts[#parts + 1] = location_component()

    return table.concat(parts, "%#StatusLineBlank#  ")
end

function M.render()
    local width = current_width()

    return table.concat({
        mode_component(),
        "%<",
        filename_component(width),
        "%#StatusLineBlank#",
        "%=",
        right_components(width),
        "%#StatusLineBlank# ",
    })
end

local function setup_heirline()
    local ok, heirline = pcall(require, "heirline")

    if not ok then
        vim.o.statusline = "%!v:lua.Statusline.render()"
        return
    end

    local mode = {
        provider = function()
            return " " .. esc(mode_name()) .. " "
        end,

        hl = function()
            local color = mode_colors[mode_name()] or mode_colors.NORMAL

            return {
                fg = color.fg,
                bg = color.bg,
                bold = true,
            }
        end,

        update = {
            "ModeChanged",
            "CmdlineEnter",
            "CmdlineLeave",
        },
    }

    local file = {
        provider = function()
            return filename_component(current_width())
        end,

        update = {
            "BufEnter",
            "BufFilePost",
            "BufWritePost",
            "DirChanged",
            "OptionSet",
        },
    }

    local right = {
        provider = function()
            return right_components(current_width())
        end,

        update = {
            "BufEnter",
            "DiagnosticChanged",
            "User",
        },
    }

    heirline.setup({
        statusline = {
            mode,
            { provider = " ", hl = "StatusLineBlank" },
            { provider = "%<" },
            file,
            { provider = "%=", hl = "StatusLineBlank" },
            right,
            { provider = " ", hl = "StatusLineBlank" },
        },
    })
end

function M.refresh()
    set_hl()

    local ok, utils = pcall(require, "heirline.utils")
    if ok then
        utils.on_colorscheme()
    end

    pcall(vim.cmd, "redrawstatus")
end

_G.Statusline = M

M.refresh()

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("salar_statusline", { clear = true }),
    callback = M.refresh,
})

setup_heirline()
