return {
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
        },
        config = function()
            -- Setup adapters
            require("core.dap.adapters")
            -- Setup dap config by VsCode launch.json file
            local vscode = require("dap.ext.vscode")
            local json = require("plenary.json")
            ---@diagnostic disable-next-line: duplicate-set-field
            vscode.json_decode = function(str)
                return vim.json.decode(json.json_strip_comments(str))
            end
        end,

        keys = {
            { "<leader>dC",   function() require("dap").set_breakpoint(vim.fn.input '[Condition] > ') end,       desc = "DAP: Conditional breakpoint" },
            { "<leader>dLC",  function() require("dap").set_breakpoint(nil, nil, vim.fn.input('Log msg: ')) end, desc = "DAP: Breakpoint log" },
            { "<F9>",         function() require("dap").toggle_breakpoint() end,                                 desc = "DAP: Breakpoint toggle" },
            { "<F6>",         function() require("dap").goto_() end,                                             desc = "DAP: Goto line" },
            { "<F5>",         function() require("dap").continue() end,                                          desc = "DAP: Continue" },
            { "<leader><F5>", function() require("dap").run_last() end,                                          desc = "DAP: Run last" },
            { "<F11>",        function() require("dap").step_into() end,                                         desc = "DAP: Step Into" },
            { "<F10>",        function() require("dap").step_over() end,                                         desc = "DAP: Step Over" },
            { "<F12>",        function() require("dap").step_out() end,                                          desc = "DAP: Step Out" },
        }
    },

    {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {},
        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")
            local on_events = require("core.dap")
            dapui.setup(opts)
            dap.listeners.after.event_initialized["dapui_config"] = function()
                on_events.on_start()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                on_events.on_stop()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                on_events.on_stop()
            end
        end,

        keys = {
            { "<leader>du", function() require("dapui").toggle({}) end,                           desc = "Dap UI" },
            { "<leader>de", function() require("dapui").eval() end,                               desc = "Eval",               mode = { "n", "v" } },
            { "<leader>dE", function() require("dapui").eval(vim.fn.input '[Expression] > ') end, desc = "DAP: Evaluate input" },
        },
    },

    {
        "theHamsta/nvim-dap-virtual-text",
        lazy = true,
        opts = {
            enabled = true,
            commented = true,
            clear_on_continue = true,
            virt_text_pos = "eol"
        }
    },
}
