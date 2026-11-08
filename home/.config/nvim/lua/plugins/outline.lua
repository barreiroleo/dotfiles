return {
    {
        'folke/trouble.nvim',
        cmd = "Trouble",
        opts = {
            modes = {
                --- https://github.com/folke/trouble.nvim/blob/main/docs/examples.md#diagnostics-cascade
                --- Shows only the most severe diagnostics:
                cascade = {
                    mode = "diagnostics", -- inherit from diagnostics mode
                    filter = function(items)
                        local severity = vim.diagnostic.severity.HINT
                        for _, item in ipairs(items) do
                            severity = math.min(severity, item.severity)
                        end
                        return vim.tbl_filter(function(item)
                            return item.severity == severity
                        end, items)
                    end,
                    --- https://github.com/folke/trouble.nvim/blob/main/docs/examples.md#preview-in-a-split-to-the-right-of-the-trouble-list
                    preview = {
                        type = "split",
                        relative = "win",
                        position = "right",
                        size = 0.4,
                    },
                },
            }
        },
        init = function()
            vim.api.nvim_create_autocmd("QuickFixCmdPost", {
                callback = function()
                    vim.cmd([[Trouble qflist open]])
                end,
            })
        end,
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer Diagnostics (Trouble)", },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)", },
            { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location List (Trouble)", },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix List (Trouble)", },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)", },
            { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)", },
        },
    },

    {
        'stevearc/quicker.nvim',
        ft = "qf",
        opts = {},
    },

    -- {
    --     'hedyhli/outline.nvim',
    --     cmd = 'Outline',
    --     keys = {
    --         { '<leader>cs', function() require("outline").toggle() end, desc = 'Outline: Symbols LSP navigation' }
    --     },
    --     opts = {
    --         preview_window = { live = true },
    --     }
    -- },

    {
        "barreiroleo/hierarchy.nvim",
        cmd = "FunctionReferences",
        opts = {}
    },

    {
        "barreiroleo/callgraph.nvim",
        cmd = "Callgraph",
        ---@type callgraph.Opts
        opts = {
            run = {
                direction = "out",
                depth_limit_in = 10,
                depth_limit_out = 5,
                filter_location = { "/usr/include/c", "/usr/include/c++" },
                -- filter_location = function(uri)
                --     for _, filter in ipairs({ "/usr/include/c", "/usr/include/c++" }) do
                --         if uri:find(filter or "", 1, true) then
                --             vim.notify("Filtered out call to " .. uri, vim.log.levels.TRACE)
                --             return true
                --         end
                --     end
                --     return false
                -- end,
                root_location = vim.uri_from_fname(vim.fn.getcwd()),
            },
            export = {
                file_path = vim.fs.normalize("/tmp/callgraph.dot"),
                graph_name = "CallGraph",
                direction = "LR", -- TB, LR, BT, RL
            },
            _dev = {
                dump_tree = false,
                dump_locations = false,
            }
        },
        keys = {
            -- { '<leader>ca', function() require("callgraph").add_location() end,             desc = 'Callgraph: add location to analyze' },
            -- { '<leader>ci', function() require("callgraph").run({ direction = "in" }) end,  desc = 'Callgraph: incoming calls' },
            -- { '<leader>co', function() require("callgraph").run({ direction = "out" }) end, desc = 'Callgraph: outgoing calls' },
            -- { '<leader>cm', function() require("callgraph").run({ direction = "mix" }) end, desc = 'Callgraph: incoming/outgoing calls' },
        },
    },
}
