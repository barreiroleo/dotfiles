return {
    "jbyuki/one-small-step-for-vimkind",
    enabled = false,
    ft = "lua",
    init = function()
        vim.api.nvim_create_user_command("VimkindLuaServerStart",
            function(_) require("osv").launch({ port = 8086 }) end, {})
        vim.api.nvim_create_user_command("VimkindLuaServerRunThis",
            function(_) require("osv").run_this() end, {})
        vim.api.nvim_create_user_command("VimkindLuaServerStop",
            function(_) require("osv").stop() end, {})
    end,

    config = function()
        local dap = require("dap")

        dap.adapters.nlua = function(callback, conf)
            local adapter = {
                type = "server",
                host = conf.host or "127.0.0.1",
                port = conf.port or 8086,
            }
            if conf.start_neovim then
                local dap_run = dap.run
                dap.run = function(c)
                    adapter.port = c.port
                    adapter.host = c.host
                end
                require("osv").run_this()
                dap.run = dap_run
            end
            callback(adapter)
        end

        dap.configurations.lua = {
            {
                type = "nlua",
                request = "attach",
                name = "Run this file",
                start_neovim = {},
            },
            {
                type = "nlua",
                request = "attach",
                name = "Attach to running Neovim instance (port = 8086)",
                port = 8086,
            },
        }
    end,
}
