-- Credits to: https://github.com/evelez7/auto-switch-theme.nvim

local M = {}

local function apply_theme(background)
    local user_colorscheme = M.config[background]
    if (user_colorscheme) then
        vim.cmd.colorscheme(user_colorscheme)
    end
end

local function apply_custom_highlights(colorscheme)
    local overrides_map = M.config.overrides_map_cb[colorscheme]
    if overrides_map then
        overrides_map()
    end
end

---Apply theme on background change
---Note: The ColorScheme event triggers before the OptionnSet event.
---      We need to reapply the custom highlights on OptionSet event
---      otherwise the colorscheme will stomp over the custom highlights.
---      As consequenece, highlights are applied twice on Background changes.
local function setup_background_watcher()
    vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "background",
        desc = "Auto switch colorscheme on background change",
        callback = function()
            apply_theme(vim.o.background)
            apply_custom_highlights(vim.g.colors_name)
        end,
    })
end

---Apply custom highlights every time a colorscheme is switched.
local function setup_colorscheme_watcher()
    vim.api.nvim_create_autocmd("ColorScheme", {
        desc = "Apply custom highlights on colorscheme switch",
        callback = function(args)
            apply_custom_highlights(args.match)
        end,
    })
end

local function setup_theme_switcher()
    vim.api.nvim_create_user_command("ColorschemeSwitch", function(opts)
        local _ = opts.args
        local target = (vim.o.background == "dark") and "light" or "dark"
        vim.o.background = target
    end, {
        nargs = 0,
        desc = "Toggle between light and dark theme",
    })
end

--- =======================================================================
--- External API
--- =======================================================================

---@class AutoSwitchConfig
---@field light string Default light theme
---@field dark string Default dark theme
---@field overrides_map_cb? table<string, function?>  Store custom hl by colorscheme
M.config = {
    light = "default",
    dark = "default",
    overrides_map_cb = {}
}

---@param opts AutoSwitchConfig
function M.setup(opts)
    M.config = vim.tbl_extend("force", M.config, opts or {})
    setup_background_watcher()
    setup_colorscheme_watcher()
    setup_theme_switcher()
    apply_theme(vim.o.background)
    apply_custom_highlights(vim.g.colors_name)
end

---@param opts AutoSwitchConfig
function M.lazy_setup(opts)
    vim.api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        callback = function()
            require("core.utils.auto-switch-theme").setup(opts)
        end
    })
end

return M
