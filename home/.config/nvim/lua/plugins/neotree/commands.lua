local commands = {
    h_navigation = function(state)
        local node = state.tree:get_node()
        if node.type == 'directory' and node:is_expanded() then
            require 'neo-tree.sources.filesystem'.toggle_directory(state, node)
        else
            require 'neo-tree.ui.renderer'.focus_node(state, node:get_parent_id())
        end
    end,

    l_navigation = function(state)
        local node = state.tree:get_node()
        if node.type == 'directory' then
            if not node:is_expanded() then
                require 'neo-tree.sources.filesystem'.toggle_directory(state, node)
            elseif node:has_children() then
                require 'neo-tree.ui.renderer'.focus_node(state, node:get_child_ids()[1])
            end
        end
    end,

    tab_open = function(state)
        local node = state.tree:get_node()
        if require("neo-tree.utils").is_expandable(node) then
            state.commands["toggle_node"](state)
        else
            state.commands['open'](state)
            vim.cmd('Neotree reveal')
        end
    end,

    system_open = function (state)
        local node = state.tree:get_node()
        local path = node:get_id()
        vim.api.nvim_command(
            string.format("silent !xdg-open '%s'", path)
        )
    end
}

return commands
