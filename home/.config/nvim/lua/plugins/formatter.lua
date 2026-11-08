return {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo", "Format" },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                rust = { "rustfmt" },
                json = { "jq" },
                python = { --[[ "black", ]] "yapf" },
                sh = { "shfmt" },
                cmake = { "cmake_format" },
                markdown = { "prettier" },
                yaml = { "prettier" },
                html = { "prettier" },
            },
            formatters = {
                jq = { append_args = { "--indent", "4" } },
                -- cmake_format: MasonInstall cmakelang
                cmake_format = {
                    append_args = {
                        "--first-comment-is-literal",
                        "--line-width", "100",
                        "--tab-size", "4",
                        "--bullet-char", "-",
                    }
                }
            }
        })

        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

        -- Create a range compatible command
        vim.api.nvim_create_user_command("Format", function(args)
            local range = nil
            if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                range = {
                    start = { args.line1, 0 },
                    ["end"] = { args.line2, end_line:len() },
                }
            end
            require("conform").format({ async = true, lsp_fallback = true, range = range })
        end, { range = true })
    end,

    keys = {
        { "gq",  "<cmd>Format<CR>", mode = "v", desc = "Conform: Range format" },
        { "gqf", "<cmd>Format<CR>", mode = "n", desc = "Conform: File format" }
    }
}
