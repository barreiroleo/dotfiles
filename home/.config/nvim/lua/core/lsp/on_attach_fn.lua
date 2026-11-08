local M = {}

---@class LspAttachArgs: vim.api.keyset.create_autocmd.callback_args
---@field data.client_id integer ID of the LSP client

---@alias on_attach_callback fun(client: vim.lsp.Client, autocmd_args:LspAttachArgs, on_attach: any)

---LspAttach wrapper to not override lsp-config's on_attach callback.
---@param name string LSP server's name
---@param callback on_attach_callback Callback function to run on_attach event
---@param callback_args? any Callback arguments
function M.on_attach_client_name(name, callback, callback_args)
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserAutocmd_LspAttach_" .. name, { clear = false }),

        callback = function(lsp_attach_args)
            ---@cast lsp_attach_args LspAttachArgs
            local client = vim.lsp.get_client_by_id(lsp_attach_args.data.client_id)
            if not client or client.name ~= name then return end

            callback(client, lsp_attach_args, callback_args)
        end,
    })
end

-- ---Wrapper example
-- ---@type on_attach_callback
-- local function on_attach_wrapper(client, lsp_attach_args, callback_args)
--     vim.keymap.set({ "n", "i" }, "<A-o>", "<cmd>LspClangdSwitchSourceHeader<cr>",
--         { desc = "Clang: Switch source/header", buffer = lsp_attach_args.buf })
--     vim.keymap.set({ "n", "i" }, "<leader>k", "<cmd>LspClangdShowSymbolInfo<cr>",
--         { desc = "Clang: Show symbol info", buffer = lsp_attach_args.buf })
-- end
--
-- M.on_attach_client_name("clangd", on_attach_wrapper, {})
--
-- require("core.lsp.on_attach_fn").on_attach_client_name("clangd", function(cmd_args, _on_attach_args) end, {})

return M
