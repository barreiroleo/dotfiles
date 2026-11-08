local wezterm = require("wezterm")
local update_status = require("update-status")
local colors = require("colors")
local keymaps = require("keymaps")

---@return {prog: string[]?, domain: string?}
local function get_default_prog()
    if wezterm.target_triple == "x86_64-pc-windows-msvc" then
        -- return { prog = {"Ubuntu"}, domain = "WSL:Ubuntu" }
        return { prog = {"ubuntu"}, domain = "WSL:archlinux" }
    end
    if wezterm.target_triple == "x86_64-apple-darwin" then end
    if wezterm.target_triple == "x86_65-unknown-linux-gnu" then end
    return { prog = nil, domain = nil}
end

local default_shell = get_default_prog()

local config = wezterm.config_builder()

-- Shell: Native or WSL
config.default_prog = default_shell.prog
config.default_domain = default_shell.domain

-- Colors
config.colors = colors.colors
config.background = colors.background
config.color_scheme = colors.color_scheme

-- Tabs
-- config.enable_wayland = true
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

-- Window
config.window_background_opacity = 1
config.window_padding = { left = 2, right = 2, top = 2, bottom = 2, }

-- Fonts
config.font = wezterm.font("JetBrainsMono Nerd Font Propo")
-- config.font = wezterm.font("Maple Mono NF", { weight = "Regular" })
-- config.font = wezterm.font("VictorMono Nerd Font Propo")
config.font_size = 9.0
config.line_height = 1.00

-- Keybindings
config.leader = keymaps.leader
config.keys = keymaps.keys
config.key_tables = keymaps.key_tables


wezterm.on('update-status', function(window, pane)
    update_status(window, pane)
end)

return config
