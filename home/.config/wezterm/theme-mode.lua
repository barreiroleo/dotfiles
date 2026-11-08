local wezterm = require("wezterm")

---@class ThemeScheme
---@field color_scheme string
---@field background string?

---@type ThemeScheme
local Dark = { color_scheme = "Colorful Colors (terminal.sexy)", background = "#282c34" }
---@type ThemeScheme
local Light = { color_scheme = "GruvboxLight", background = nil }

---@enum ModeKind
local ModeKind = {
    Dark = "Dark",
    Light = "Light",
    DarkHighContrast = "DarkHighContrast",
    LightHighContrast = "LightHighContrast"
}


local M = {}

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
---@return ModeKind
function M.GetThemeMode()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return ModeKind.Dark
end

---@param mode ModeKind?
---@return ThemeScheme
function M.GetSchemeForMode(mode)
    mode = mode or M.GetThemeMode()
    local isDarkMode = mode == ModeKind.Dark or mode == ModeKind.DarkHighContrast
    return isDarkMode and Dark or Light
end

return M
