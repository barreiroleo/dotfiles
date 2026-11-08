return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufNewFile", "BufReadPre" },
        cmd = { "Mason", "MasonInstall" },
        dependencies = {
            { "mason-org/mason.nvim" },
            { "mason-org/mason-lspconfig.nvim" },
            { "folke/lazydev.nvim" }
        },
        config = function()
            vim.lsp.config("*", {
                capabilities = require("core.lsp.capabilities").extend_capabilities()
            })

            local servers = { "clangd", "lua_ls", "sqruff"  }
            local to_install = vim.tbl_filter(function(s)
                local is_installed = vim.fn.executable(s) == 1
                vim.lsp.enable(s, is_installed)
                return not is_installed
            end, servers)

            require("core.lsp.ui")
            require('mason').setup({
                -- registries = { "file:~/develop/mason-registry/" }
            })
            require("mason-lspconfig").setup({
                ensure_installed = to_install,
                automatic_enable = { exclude = { "rust_analyzer" } },
            })
        end,
    },

    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "snacks.nvim",        words = { "Snacks" } },
            },
        }
    },

    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                help = true,
            },
        },
    },

    -- TODO(lbarreiro): Fork it or wait until is unified with the lsp bundled by copilot.lua
    -- {
    --     "copilotlsp-nvim/copilot-lsp",
    --     opts = {},
    --     init = function()
    --         vim.g.copilot_nes_debounce = 500
    --         vim.lsp.enable("copilot_ls")
    --
    --         vim.keymap.set("n", "<leader><tab>", function()
    --             local nes = require("copilot-lsp.nes")
    --             local _ = nes.walk_cursor_start_edit() or (nes.apply_pending_nes() and nes.walk_cursor_end_edit())
    --         end, { desc = "Copilot: Apply NES suggestion" })
    --
    --         vim.keymap.set("n", "<leader><esc>", function()
    --             require("copilot-lsp.nes").clear()
    --         end, { desc = "Copilot: Clear NES suggestion" })
    --     end,
    -- },
}
