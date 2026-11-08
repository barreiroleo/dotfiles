local commands  = require("plugins.neotree.commands")
local mappings  = require("plugins.neotree.mappings")
local renderers = require("plugins.neotree.renderers")

local opts = {
    default_component_configs = {
        indent = {
            with_expanders = true
        },
    },

    event_handlers = {
        { event = "neo_tree_buffer_enter",
            handler = function(arg)
                vim.opt.number = true
                vim.opt.relativenumber = true
            end,
        }
    },

    filesystem = {
        bind_to_cwd = false,
        commands = commands,
        filtered_items = {
            visible = false,
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_by_name = {},
            hide_by_pattern = {},
            always_show = { ".gitignored" },
            never_show = {},
        },
        group_empty_dirs = true,
        follow_current_file = {
            enabled = true
        },
        use_libuv_file_watcher = true, -- OS level file watchers
        hijack_netrw_behavior = "open_default"
    },

    git_status = {
        window = {
            position = "right",
        }
    },

    popup_border_style = "rounded",

    renderers = renderers,

    source_selector = {
        winbar = false,
        statusline = true
    },

    window = {
        position = "left",
        width = 35,
        mappings = mappings.window,
    },
}

return opts
