-- Catppuccin is built-in: Mocha, Macchiato, Frappe, Latte
-- config.color_scheme = "Catppuccin Mocha"

local custom_scheme = require("wezterm").color.get_builtin_schemes()["Catppuccin Mocha"]
custom_scheme.background = "#161616"
custom_scheme.tab_bar.background = "#040404"
custom_scheme.tab_bar.inactive_tab.bg_color = "#0f0f0f"
custom_scheme.tab_bar.new_tab.bg_color = "#080808"

return {
	color_schemes = { ["custom_scheme"] = custom_scheme },
	color_scheme = "custom_scheme",
}
