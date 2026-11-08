-- Save and exec the current Lua or VimL file
local function save_and_exec ()
    local source_commands = {
        lua = 'luafi %',
        vim = 'source %',
        python = '!python %',
        cpp = '!clang++ %:p --std=c++23 -o %:p:r',
        c = '!clang %:p -o %:p:r',
        sh = "!bash %"
    }

    local ft = vim.api.nvim_get_option_value('filetype', {buf = 0})
    local command = source_commands[ft]
    if command == nil then
        vim.notify('This type cant not be sourced', vim.log.levels.ERROR, { title = 'Core utils' })
        return
    end
    -- Save and source
    local current_file_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')
    vim.notify(string.format('File %s Sourced', current_file_name), vim.log.levels.INFO, { title = 'Core utils' })

    -- If has nightly with Lua module loader
    if ft == "lua" and vim.loader then
        vim.loader.reset(vim.api.nvim_buf_get_name(0))
    end
    vim.cmd 'silent w'
    vim.cmd 'message clear'
    vim.cmd(command)
end

return save_and_exec
