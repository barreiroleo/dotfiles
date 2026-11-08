local wezterm = require("wezterm")
local act = wezterm.action

local leader = { key = 'a', mods = 'ALT', timeout_milliseconds = 5000 }

local keys = {
    -- Send leader ("Alt-A") to terminal when pressing leader twice.
    {
        key = leader.key,
        mods = "LEADER|" .. leader.mods,
        action = act.SendKey{key=leader.key, mods=leader.mods}
    },
    -- Leader + '-'/'|' will split the current pane.
    { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-', mods = 'LEADER',       action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    -- Leader + 'z', zoom the current pane.
    { key = 'z', mods = 'LEADER',       action = act.TogglePaneZoomState },
    -- Leader + 'r' will put us in resize-pane mode until we cancel that mode.
    { key = 'r', mods = 'LEADER',       action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false } },
    { key = '[', mods = 'LEADER',       action = act.RotatePanes('CounterClockwise') },
    { key = ']', mods = 'LEADER',       action = act.RotatePanes('Clockwise') },
    -- Leader, vim-like direction hjkl to switch active pane.
    { key = 'h', mods = 'LEADER',       action = act.ActivatePaneDirection('Left') },
    { key = 'l', mods = 'LEADER',       action = act.ActivatePaneDirection('Right') },
    { key = 'k', mods = 'LEADER',       action = act.ActivatePaneDirection('Up') },
    { key = 'j', mods = 'LEADER',       action = act.ActivatePaneDirection('Down') },
    -- Leader + 'c', create a new tab.
    { key = 'c', mods = 'LEADER',       action = act.SpawnTab('CurrentPaneDomain') },
    -- Leader + '!', moves the current pane to a new tab
    { key = '!', mods = 'LEADER|SHIFT', action = wezterm.action_callback(function(win, pane) pane:move_to_new_tab() end) },
}

-- Leader + number to activate that tab
for i = 1, 8 do
    table.insert(keys, { key = tostring(i), mods = 'LEADER', action = act.ActivateTab(i - 1), })
end

local key_tables = {
    -- Defines the keys that are active in our resize-pane mode.
    -- Since we're likely to want to make multiple adjustments, we made the activation one_shot=false.
    -- We therefore need to define a key assignment for getting out of this mode.
    -- 'resize_pane' here corresponds to the name="resize_pane" in the key assignments above.
    resize_pane = {
        { key = 'h',      action = act.AdjustPaneSize { 'Left', 1 } },
        { key = 'l',      action = act.AdjustPaneSize { 'Right', 1 } },
        { key = 'k',      action = act.AdjustPaneSize { 'Up', 1 } },
        { key = 'j',      action = act.AdjustPaneSize { 'Down', 1 } },
        -- Cancel the mode by pressing escape
        { key = 'Escape', action = 'PopKeyTable' },
    },
}

return { leader = leader, keys = keys, key_tables = key_tables }
