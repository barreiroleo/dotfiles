function R()
    local plugins = require("lazy").plugins()
    local plugin_names = {}
    for _, plugin in ipairs(plugins) do
        table.insert(plugin_names, plugin.name)
    end

    vim.ui.select(plugin_names, {
        title = "Reload plugin",
    }, function(selected)
        require("lazy").reload({ plugins = { selected } })
    end)
end

function RR(...)
    require("plenary.reload").reload_module(...)
    return require(...)
end

require("core.utils.highlight_repeats")
require("core.utils.search_selection")
require("core.utils.less")
require("core.utils.lsp_progress").setup()
