return {
    {
        "tpope/vim-dadbod",
        dependencies = {
            "kristijanhusak/vim-dadbod-ui",
            "kristijanhusak/vim-dadbod-completion",
        },
        ft = "sql",
        cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer', },
        init = function()
            -- vim.api.nvim_create_autocmd("FileType", {
            --     pattern = { "sql", "mysql", "plsql" },
            --     callback = function()
            --         require('cmp').setup.buffer({ sources = { { name = 'vim-dadbod-completion' } } })
            --     end,
            -- })
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.dbs = {
                ['dev-mysql'] = 'mysql://root:root@127.0.0.1',
                ['dev-redis'] = 'redis://',
                ['dev-sqlite'] = 'sqlite:db.sqlite3',
            }
        end
    }
}
