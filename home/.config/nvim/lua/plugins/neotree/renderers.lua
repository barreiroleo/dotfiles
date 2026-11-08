---@module "renderers"
local M = {}

M.directory = {
    { "indent" },
    { "icon" },
    { "current_filter" },
    { "container",
        width = "100%",
        --max_width = 60,
        content = {
            { "name", zindex = 10 },
            { "symlink_target",
                zindex = 10,
                highlight = "NeoTreeSymbolicLinkTarget",
            },
            { "clipboard", zindex = 10 },
            { "diagnostics", errors_only = true, zindex = 20, align = "right" },
            { "git_status", zindex = 20, align = "right" },
        },
    }
}

M.file = {
    { "indent" },
    { "icon" },
    { "container",
        width = "100%",
        --max_width = 60,
        content = {
            { "name", zindex = 10 },
            { "symlink_target",
                zindex = 10,
                highlight = "NeoTreeSymbolicLinkTarget",
            },
            { "clipboard", zindex = 10 },
            { "bufnr", zindex = 10 },
            { "modified", zindex = 20, align = "right" },
            { "diagnostics", errors_only = true, zindex = 20, align = "right" },
            { "git_status", zindex = 20, align = "right" },
        },
    }
}

return M
