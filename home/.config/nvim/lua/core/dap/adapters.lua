local dap = require("dap")

local bashdb = require('core.dap.config.bashdb')
local codelldb = require("core.dap.config.codelldb")
local cppdbg = require("core.dap.config.cppdbg")
local gdb = require("core.dap.config.gdb")
local netcoredbg = require('core.dap.config.netcoredbg')
-- local nlua = require("core.dap.config.nlua")

dap.adapters = {
    bashdb = bashdb.adapter,
    codelldb = codelldb.adapter,
    cppdbg = cppdbg.adapter,
    gdb = gdb.adapter,
    netcoredbg = netcoredbg.adapter,
    -- nlua = nlua.adapter,
}

local c_family = vim.iter({ codelldb.configurations, cppdbg.configurations }):flatten():totable()
dap.configurations = {
    c = c_family,
    cpp = c_family,
    rust = c_family,
    -- lua = nlua.configurations,
    bash = bashdb.configurations,
    cs = netcoredbg.configurations,
}
