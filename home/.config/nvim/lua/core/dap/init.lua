local dapui = require("dapui")
local keymap_manager = require("core.dap.keymap_manager")
local dap_keymaps = require("core.dap.keymaps")

return {
    --- Open DAP UI, setup temporary keymaps, hide diagnostics
    on_start = function()
        dapui.open()
        keymap_manager.setup(dap_keymaps)
        vim.diagnostic.hide(nil, 0)
    end,

    --- Close DAP UI, restore temporary keymaps, show diagnostics
    on_stop = function()
        vim.diagnostic.show()
        keymap_manager.shutdown()
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { desc = "DAP: Hover variables" })
        dapui.close()
    end
}
