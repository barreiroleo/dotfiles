local M = {}

M.adapter = {
    function(callback, config)
        callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
    end
}

M.configurations = {
    {
        type = 'nlua',
        request = 'attach',
        name = "Attach to running Neovim instance at 127.0.0.1:8086",
    },
    {
        type = 'nlua',
        request = 'attach',
        name = "Attach to running Neovim instance at <ip><port>: ",
        host = function()
            local value = vim.fn.input('Host [127.0.0.1]: ')
            if value ~= "" then return value end
            return '127.0.0.1'
        end,
        port = function()
            local value = tonumber(vim.fn.input('Port [8086]: '))
            if value ~= "" then return value end
            return '8086'
        end,
    }
}



return M
