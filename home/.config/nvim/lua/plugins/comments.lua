return {
    {
        "numToStr/Comment.nvim",
        event = { "BufNewFile", "BufReadPre" },
        opts = {}
    },

    {
        "folke/todo-comments.nvim",
        event = { "BufNewFile", "BufReadPre" },
        dependencies = "nvim-lua/plenary.nvim",
        opts = {
            highlight = {
                -- vimgrep regex, supporting the pattern TODO(username):
                pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
            },
            search = {
                -- ripgrep regex, supporting the pattern TODO(username):
                pattern = [[\b(KEYWORDS)(\(\w*\))*:]],
            },
        }
    },
}
