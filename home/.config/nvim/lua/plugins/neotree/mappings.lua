local Mappings = {}

Mappings.window = {
    ["S"] = "open_split",
    ["s"] = "open_vsplit",
    ["P"] = "toggle_preview",

    ["a"] = {
        "add", -- `:h neo-tree-mappings` for details
        config = { show_path = "relative" } -- "none", "relative", "absolute"
    },
    ["c"] = {
        "copy",
        config = { show_path = "relative" }
    },

    -- Check customs names in "configs.neotree.commands"
    ["h"] = "h_navigation",
    ["l"] = "l_navigation",
    ["<tab>"] = "tab_open",
    ["o"] = "system_open"
}


return Mappings
