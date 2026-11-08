return {
    {
        'nvim-mini/mini.nvim',
        version = false,
        lazy = false,
        init = function()
            require("mini.files").setup()
            require("mini.icons").setup()
            require("mini.pairs").setup()
            require("plugins.mini.diff").setup()
            require("plugins.mini.hipatterns").setup()
            require("plugins.mini.surround").setup()
        end,
        keys = { {
            "<leader>E",
            function()
                if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0)) end
            end,
            desc = "MiniFiles: Toggle explorer"
        } },
    },
}
