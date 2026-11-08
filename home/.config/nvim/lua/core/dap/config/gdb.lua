local M = {}

M.adapter = {
    id = 'gdb',
    type = 'executable',
    command = "gdb",
    args = { "-i", "dap" }
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
        name = '[gdb] Launch file',
        type = 'gdb',
        request = 'launch',
        cwd = '${workspaceFolder}',
        stopAtBeginningOfMainSubprogram = false,
        setupCommands = common.setupCommands,
        program = function()
            return vim.fn.input('ctrl-d: list matches\nctrl-a: complete\n path to executable: ',
                vim.fn.getcwd() .. "/build/", 'file')
        end
    },

    {
        name = '[gdb] Attach to PID',
        type = 'gdb',
        request = 'attach',
        cwd = '${workspaceFolder}',
        stopAtBeginningOfMainSubprogram = false,
        setupCommands = common.setupCommands,
        pid = function()
            return require("dap.utils").pick_process({ filter = vim.fn.input("Process name: ") })
        end
    },
}

return M
