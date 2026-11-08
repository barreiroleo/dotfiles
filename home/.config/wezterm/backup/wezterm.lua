local wezterm = require("wezterm") -- wezterm API
local utils = require("utils")

local colorscheme = require("colorscheme")
local gpu = utils:use_interated_gpu()

---@return {prog: string[]?, domain: string?}
local function get_default_prog()
    if wezterm.target_triple == "x86_64-pc-windows-msvc" then
        return { prog = {"Ubuntu"}, domain = "WSL:Ubuntu" }
    end
    if wezterm.target_triple == "x86_64-apple-darwin" then end
    if wezterm.target_triple == "x86_65-unknown-linux-gnu" then end
    return { prog = nil, domain = nil}
end

local default_shell = get_default_prog()

wezterm.on('format-window-title', function(_tab, _pane, _tabs, _panes, _config)
    return "wezterm"
end)

local config = {
    -- webgpu_power_performance = "LowPower",
    -- webgpu_preferred_adapter = gpu.webgpu_power_performance,
    -- front_end = gpu.front_end,
    -- front_end = "WebGpu", -- WebGpu, Software, OpenGL

    -- Shell: Native or WSL
    default_prog = default_shell.prog,
    default_domain = default_shell.domain,

    -- Environment
    -- config.term

    -- Window
    hide_tab_bar_if_only_one_tab = true,
    window_background_opacity = 0.99,
    window_padding = { left = 2, right = 2, top = 2, bottom = 2, },

    -- Fonts
    font = wezterm.font("JetBrainsMono Nerd Font Propo", { stretch = "Expanded", weight = "Regular" }),
    -- font = wezterm.font("Maple Mono NF", { weight = "Regular" }),
    -- font = wezterm.font("VictorMono Nerd Font Propo" ),
    font_size = 10.25,
    line_height = 1.00,

    -- Colors
    color_scheme = 'Colorful Colors (terminal.sexy)'
    -- color_scheme = colorscheme.color_scheme,
    -- color_schemes = colorscheme.color_schemes,
}

return utils:merge_tables(wezterm.config_builder(), config)
