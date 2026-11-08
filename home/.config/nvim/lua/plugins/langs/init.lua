return {
    { import = "plugins.langs.ltex_extra" },
    -- { import = "plugins.langs.markdown" },
    -- { import = "plugins.langs.plantuml" },

    {
        'brianhuster/live-preview.nvim',
        cmd = "LivePreview",
        opts = {},
    },

    {
        'mrcjkb/rustaceanvim',
        ft = { "rust" },
        -- version = '^4',
        config = function()
            vim.g.rustaceanvim = {
                tools = { code_actions = { ui_select_fallback = true } }
            }
        end
    },

    {
        'MeanderingProgrammer/render-markdown.nvim',
        ft= { "markdown" },
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
        ---@module 'render-markdown'
        opts = {
            -- FIX: broken on nightly?
            -- completions = { lsp = { enabled = true } },
        }
    },

    {
        'takeshiD/md-readable.nvim',
        commit = "fc44dce96815eaaf4e83ed11d2178c6ce073b1d3",
        pin = true,
        -- cmd = "MdReadable",
        keys = {
            {
                "<A-o>",
                function()
                    local reader = require("md-readable")
                    if vim.bo.filetype == "md-readable" then reader.action("source")
                    else reader.open("current")
                    end
                end,
                ft = { "markdown", "md-readable" },
                mode = "n",
                desc = "Toggle Markdown source/rendered view",
            },
        },
        opts = {
            layout = "separate",
            focus = { enable = false },
            minimap = { enable = false },
            images = { enable = true, remote = false },
            mermaid = { enable = true, renderer = "termaid" },
            watch = { enable = false },
        },
    }
}
