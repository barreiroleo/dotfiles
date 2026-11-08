---@diagnostic disable: undefined-field, undefined-doc-name

local wezterm = require("wezterm")
local colors = require("colors").colors

local WARN = string.format("%s  ", wezterm.nerdfonts.cod_warning)

--- Show a warning in the left when a keytable is active.
--- Show if leader key is active.
--- Show if a keytable table is active and which one.
---@param window WezWindow window object
---@param pane WezWindow pane object
local function update_status(window, pane)
    local r_status = ''
    local l_status = ''

    if window:leader_is_active() then
        r_status = string.format("%s Wait", r_status)
    end

    local name = window:active_key_table()
    if name then
        r_status = string.format("%s Mode: %s", r_status, name)
        l_status = string.format("%s %s", l_status, WARN)
    end

    window:set_right_status(wezterm.format {
        { Foreground = { AnsiColor = 'White' } },
        { Background = { Color = colors.tab_bar.active_tab.bg_color } },
        { Text = r_status }, 'ResetAttributes',
    })

    window:set_left_status(wezterm.format {
        { Foreground = { AnsiColor = 'White' } },
        { Background = { Color = '#A11A1A' } },
        { Text = l_status }, 'ResetAttributes',
    })
end

return update_status
