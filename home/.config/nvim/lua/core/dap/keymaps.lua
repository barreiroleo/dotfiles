---@format disable-next
---@type vim.api.keyset.keymap[]
local debug_keymaps = {
    { mode = "n", lhs = "<leader>db", rhs = function() require("dap").step_back() end,                                                 desc = "DAP: Step back" },
    { mode = "n", lhs = "<leader>dR", rhs = function() require("dap").run_to_cursor() end,                                             desc = "DAP: Run to cursor" },
    { mode = "n", lhs = "<leader>dp", rhs = function() require("dap").pause() end,                                                     desc = "DAP: Pause" },

    { mode = "n", lhs = "<leader>dq", rhs = function() require("dap").close() end,                                                     desc = "DAP: Quit" },
    { mode = "n", lhs = "<leader>dr", rhs = function() require("dap").repl.open() end,                                                 desc = "DAP: Open REPL" },

    { mode = "n", lhs = "<leader>dd", rhs = function() require("dap").disconnect() end,                                                desc = "DAP: Disconnect" },
    { mode = "n", lhs = "<leader>dg", rhs = function() require("dap").session() end,                                                   desc = "DAP: Get session" },
    { mode = "n", lhs = "<leader>dt", rhs = function() require("dap").terminate() end,                                                 desc = "DAP: Terminate" },
    { mode = "n", lhs = "K",          rhs = function() require("dap.ui.widgets").hover() end,                                          desc = "DAP: Hover variables" },
    { mode = "n", lhs = "<leader>dp", rhs = function() require("dap.ui.widgets").preview() end,                                        desc = "DAP: Hover variable but in preview window" },
    { mode = "n", lhs = "<leader>df", rhs = function() require('dap.ui.widgets').centered_float(require('dap.ui.widgets').frames) end, desc = "DAP: Frames" },
    { mode = "n", lhs = "<leader>ds", rhs = function() require('dap.ui.widgets').centered_float(require('dap.ui.widgets').scopes) end, desc = "DAP: Scopes" },
}

return debug_keymaps
