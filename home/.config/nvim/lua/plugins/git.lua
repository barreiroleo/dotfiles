return {
    {
        "tpope/vim-fugitive",
        cmd = { "Git" }
    },

    {
        "barrettruth/diffs.nvim",
        lazy = false,
        init = function()
            vim.g.diffs = { integrations = { fugitive = true } }
        end,
    },

    -- {
    --     "barreiroleo/diff-tools.nvim",
    --     opts = {}
    -- },

    {
        'kokusenz/deltaview.nvim',
        opts = {
            line_numbers = true,
            keyconfig = {
                -- Remove global keybinds
                dm_toggle_keybind = "", -- <leader>dm
                dv_toggle_keybind = "", -- <leader>dl
                d_toggle_keybind = "",  -- <leader>da
                -- Navigate between hunks in a diff
                next_hunk = "<Tab>",
                prev_hunk = "<S-Tab>",
                -- Open help legend
                help_legend = "d?"
            }
        }
    }

    -- {
    --     "sindrets/diffview.nvim",
    --     cmd = { "DiffviewFileHistory", "DiffviewOpen" },
    --     opts = {
    --         default_args = {
    --             DiffviewOpen = { "--imply-local" },
    --         }
    --     }
    -- },

    -- {
    --     "lewis6991/gitsigns.nvim",
    --     event = { "BufNewFile", "BufReadPre" },
    --     opts = {
    --         current_line_blame = true,
    --         current_line_blame_opts = {
    --             virt_text_pos = 'right_align',
    --         },
    --     }
    -- },
}
