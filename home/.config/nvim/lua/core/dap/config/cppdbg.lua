local M = {}

M.adapter = {
    id = 'cppdbg',
    type = 'executable',
    command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
}

local common = {
    setupCommands = {
        {
            description = "Enable pretty-printing for gdb",
            text = "-enable-pretty-printing",
            ignoreFailures = true
        },
        {
            description = "ignore SIGUSR1 signal",
            text = "handle SIGUSR1 nostop noprint pass"
        },
    }
}

M.configurations = {
    {
        name = '[cppdbg] Launch file',
        type = 'cppdbg',
        request = 'launch',
        cwd = '${workspaceFolder}',
        stopAtEntry = false,
        setupCommands = common.setupCommands,
        program = function()
            return vim.fn.input('ctrl-d: list matches\nctrl-a: complete\n path to executable: ',
                vim.fn.getcwd() .. "/build/", 'file')
        end
    },

    {
        name = '[cppdbg] Attach to PID',
        type = 'cppdbg',
        request = 'attach',
        cwd = '${workspaceFolder}',
        stopAtEntry = false,
        setupCommands = common.setupCommands,
        pid = function()
            return require("dap.utils").pick_process({ filter = vim.fn.input("Process name: ") })
        end
    },
}

return M
