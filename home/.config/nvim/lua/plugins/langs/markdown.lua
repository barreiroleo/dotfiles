return {
    -- -- FIX: If the plug not load at :MarkdownPreview, check for tslib asserts at :messages and run
    -- -- vim.fn["mkdp#util#install"]()
    -- { "iamcco/markdown-preview.nvim",
    --     ft = { "markdown" },
    --     build = function() vim.fn["mkdp#util#install"]() end,
    --     -- config = function()
    --     --     -- Launch with java -jar ~/.local/bin/plantuml.jar -picoweb:8000
    --     --     local cmd = 'java -jar ~/.local/bin/plantuml.jar -picoweb:8000'
    --     --     vim.uv.spawn(cmd, { stdio = { vim.uv.new_pipe(), vim.uv.new_pipe(), vim.uv.new_pipe() }, },
    --     --         function(code, signal) -- on exit
    --     --             print('exit code', code)
    --     --             print('exit signal', signal)
    --     --         end
    --     --     )
    --     --     vim.g.mkdp_preview_options = {
    --     --         uml = { server = "http://localhost:8000", imageFormat = "png" },
    --     --     }
    --     -- end
    -- },

    {
        'brianhuster/live-preview.nvim',
        cmd = "LivePreview",
        ft = "markdown",
        opts = {},
    },

    {
        "OXY2DEV/markview.nvim",
        lazy = false,
    },
}
