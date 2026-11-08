---@diagnostic disable: undefined-field
local keymap_manager = require("core.dap.keymap_manager")

vim.keymap.set("n", "A", function() vim.notify("[Local] A") end, { desc = "Local OG: A", buffer = 0, })
vim.keymap.set("n", "Z", function() vim.notify("[Global] Z") end, { desc = "Global OG: Z" })

---@type vim.api.keyset.keymap[]
local dap_keymaps = {
    { mode = "n", lhs = "A", rhs = function() vim.notify("[DAP] A", vim.log.levels.WARN) end, desc = "Global DAP: OVERRIDE A" },
    { mode = "n", lhs = "Z", rhs = function() vim.notify("[DAP] Z", vim.log.levels.WARN) end, desc = "Global DAP: OVERRIDE Z" },
}

--- NOTE: In order to test, enable and disable the shutdown
keymap_manager.setup(dap_keymaps)
keymap_manager.shutdown()
