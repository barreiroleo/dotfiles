return {
    { "nvim-lua/plenary.nvim", },

    {
        "tpope/vim-dispatch",
        cmd = { "Make", "Copen", "Dispatch", "Start", "Spawn" }
    },
    {
        "andymass/vim-matchup",
        event = { 'BufNewFile', 'BufReadPre' },
    },

    -- {
    --     'mbbill/undotree',
    --     cmd = "UndotreeShow"
    -- },

    {
        "danymat/neogen",
        opts = { snippet_engine = "nvim" },
        keys = {
            { "<leader>dg", function() require('neogen').generate() end, mode = { "n", "v" }, desc = "Neogen: Generate docs" }
        },
    },
    -- {
    --     "kkoomen/vim-doge",
    --     event = { 'BufNewFile', 'BufReadPre' },
    --     build = "<cmd>call doge#install()",
    --     config = function()
    --         vim.g.doge_doc_standard_cpp = "doxygen_cpp_comment_slash"
    --     end,
    --     keys = {
    --         { "<leader>dg", "<cmd>DogeGenerate<cr>", mode = { "n", "v" }, desc = "VimDoge: Generate docs" }
    --     },
    -- },

    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = { "lewis6991/async.nvim", },
        keys = {
            { "<leader>rr", function() require("refactoring").select_refactor() end, mode = { "n", "x" }, desc = "Refactoring: Select refactor" },
        },
        opts = {
            prompt_func_return_type = { cpp = true, c = true },
            prompt_func_param_type = { cpp = true, c = true },
        },
    },
}
