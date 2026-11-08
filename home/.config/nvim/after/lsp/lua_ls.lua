-- local function get_paths()
--     local cwd = vim.uv.cwd()
--     local runtime_paths = {
--         vim.fn.expand("$VIMRUNTIME/lua"),                  -- "/usr/share/nvim/runtime/lua"
--         -- vim.fn.stdpath("data") .. "/lazy/",             -- "~/.local/share/nvim/lazy/"
--         vim.fn.stdpath("data") .. "/lazy/neotest",         -- "~/.local/share/nvim/lazy/neotest",
--         vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig",  -- "~/.local/share/nvim/lazy/nvim-lspconfig",
--         vim.fn.stdpath("data") .. "/lazy/nvim-treesitter", -- "~/.local/share/nvim/lazy/nvim-treesitter",
--         vim.fn.stdpath("data") .. "/lazy/plenary.nvim",    -- "~/.local/share/nvim/lazy/plenary.nvim",
--     }
--     local config_paths = vim.list_extend({
--         vim.fn.stdpath("config") .. "/after", -- "~/.config/nvim/after"
--         vim.fn.stdpath("config") .. "/lua",   -- "~/.config/nvim/lua"
--     }, runtime_paths)
--
--     local configPatterns = { vim.fn.stdpath("config"), vim.fs.normalize("~/dotfiles/nvim/") }
--     local pluginPatterns = { vim.fs.normalize("~/develop/plugins/") }
--
--     if string.find(cwd, configPatterns[1]) or string.find(cwd, configPatterns[2]) then
--         return config_paths
--     elseif string.find(cwd, pluginPatterns[1]) then
--         return runtime_paths
--     end
--     return {}
-- end

return {
    settings = {
        Lua = {
            runtime = { version = "Lua 5.1" },
            diagnostics = {
                globals = { "vim", "it", "describe", "before_each", "after_each", "LOG", "P" },
            },
            -- workspace = {
            --     -- Include all the runtime paths
            --     -- library = vim.api.nvim_get_runtime_file("", true)
            --     library = get_paths(),
            --     -- checkThirdParty = false, -- Disable luv questions
            -- },
            completion = {
                keywordSnippet = 'Replace',
                callSnippet = 'Replace',
            },
            telemetry = {
                enable = false,
            },
        },
    }
}

