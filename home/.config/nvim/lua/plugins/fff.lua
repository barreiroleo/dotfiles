return {
    'dmtrKovalenko/fff.nvim',
    lazy = false,
    branch = 'main',
    build = function()
        require("fff.download").download_or_build_binary()
    end,
    opts = {},
    keys = {
        { "<leader>ff", function() require('fff').find_files() end, desc = 'FFF: Find files' },
        { "<leader>fg", function() require('fff').live_grep() end,  desc = 'FFF: Live grep' },
        {
            "<leader>fz",
            function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end,
            desc = 'FFF: Live fuzzy grep',
        },
        {
            "<leader>fw",
            function() require('fff').live_grep_under_cursor() end,
            mode = { 'n', 'x' },
            desc = 'FFF: Search current word / selection',
        },
    },
}
