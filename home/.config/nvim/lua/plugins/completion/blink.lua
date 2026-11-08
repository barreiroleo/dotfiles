local custom_menu = {
    draw = {
        -- 󰊕 Function   std::make_unique<typename Tp>(Args &&...)   [LSP]
        columns = {
            { 'kind_icon',  "kind",             gap = 1 },
            { 'label',      'label_description' },
            { 'source_name' },
        },
        components = {
            source_name = {
                text = function(ctx)
                    if vim.api.nvim_strwidth(ctx.source_name) > 3 then
                        return string.format("[%s]", vim.fn.strcharpart(ctx.source_name, 0, 3))
                    end
                    return string.format("[%s]", ctx.source_name)
                end,
                highlight = 'BlinkCmpKind'
            }
        }
    }
}

local copilot_tab_nes = {
    function(cmp)
        if vim.b[vim.api.nvim_get_current_buf()].nes_state then
            cmp.hide()
            return (
                require("copilot-lsp.nes").apply_pending_nes()
                and require("copilot-lsp.nes").walk_cursor_end_edit()
            )
        end
        if cmp.snippet_active() then
            return cmp.accept()
        else
            return cmp.select_and_accept()
        end
    end,
    "snippet_forward",
    "fallback",
}

return {
    {
        "fang2hou/blink-copilot",
        lazy = true,
        opts = {
            max_completions = 3,
            max_attempts = 4,
        }
    },

    -- {
    --     "supermaven-inc/supermaven-nvim",
    --     opts = {
    --         disable_inline_completion = false, -- disables inline completion for use with cmp
    --         disable_keymaps = false            -- disables built in keymaps for more manual control
    --     }
    -- },

    {
        'saghen/blink.cmp',
        event = "InsertEnter",
        dependencies = {
            "saghen/blink.lib",
            "fang2hou/blink-copilot",
            -- "supermaven-inc/supermaven-nvim",
            -- "huijiro/blink-cmp-supermaven",
            "kristijanhusak/vim-dadbod-completion",
            "rafamadriz/friendly-snippets",
        },
        -- build = function()
        --     -- Build rust fuzzy, Use `gb` in `:Lazy` to rebuild the plugin as needed
        --     require('blink.cmp').build():wait(60000)
        -- end,
        -- version = '1.*', -- Release tag to download pre-built binaries

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            cmdline = { enabled = false },
            keymap = {
                preset = 'super-tab',
                ['<C-e>'] = { 'hide', 'hide_signature' },
                -- ["<Tab>"] = copilot_tab_nes,
            },
            fuzzy = { implementation = "lua" },

            completion = {
                menu = custom_menu,
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
                ghost_text = { enabled = true },
            },

            signature = { enabled = true },
            -- snippets = { preset = "luasnip" },
            sources = {
                default = { "lsp", "path", "snippets", "buffer", --[[ "supermaven", ]] "copilot", --[[ "omni," ]] },
                per_filetype = {
                    lua = { inherit_defaults = true, 'lazydev' },
                    sql = { inherit_defaults = true, 'dadbod' },
                },
                providers = {
                    lazydev = {
                        name = "Lazy",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                    copilot = {
                        name = "copilot",
                        module = "blink-copilot",
                        score_offset = -1,
                        async = true,
                    },
                    dadbod = {
                        name = "Dadbod",
                        module = "vim_dadbod_completion.blink",
                        score_offset = 100
                    },
                    -- supermaven = {
                    --     name = "supermaven",
                    --     module = "blink-cmp-supermaven",
                    --     async = true
                    -- },
                },
            },
        },
    },
}
