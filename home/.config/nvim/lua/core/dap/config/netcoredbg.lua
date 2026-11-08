local M = {}

M.adapter = {
    type = 'executable',
    command = vim.fn.stdpath 'data' .. '/mason/bin/netcoredbg',
    args = { '--interpreter=vscode' },
}

M.configurations = {
    {
        name = '[netcoredbg] launch',
        type = 'netcoredbg',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end,
    },
    {
        name = '[netcoredbg] attach',
        type = 'netcoredbg',
        request = 'attach',
        -- processId = require('dap.utils').pick_process,
        pid = function()
            return require("dap.utils").pick_process({ filter = vim.fn.input("Process name: ") })
        end
    },
}

return M
