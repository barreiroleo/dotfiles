return {
    {
        'MagicDuck/grug-far.nvim',
        opts = {},
        keys = {
            vim.keymap.set('x', '<leader>si',
                function() require('grug-far').with_visual_selection({ prefills = { paths = vim.fn.expand("%") } }) end,
                { desc = 'grug-far: Search selection in current file' }),

            vim.keymap.set('n', '<leader>si',
                function() require('grug-far').open({ prefills = { paths = vim.fn.expand("%") } }) end,
                { desc = 'grug-far: Search in current file' }),


            vim.keymap.set('n', '<leader>ss',
                function()
                    local bufname = vim.fn.expand("%")

                    require('grug-far').open({
                        prefills = {
                            paths = bufname,
                            search = "foo::(bar)( |>|,|&|\\*|\\{|\\(|::)",
                            replacement = "fizz::$1$2"
                        }
                    })

                    -- Uncomment to search/replace more than one pattern at the same time
                    -- require('grug-far').open({
                    --     prefills = {
                    --         paths = bufname,
                    --         search = "foo::(fizz)( |>|,|&|\\*|\\{|\\(|::)",
                    --         replacement = "buzz::$1$2"
                    --     }
                    -- })
                end,
                { desc = 'grug-far: Search in current file' }),
        }
    }
}
