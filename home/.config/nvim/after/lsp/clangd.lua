-- https://github.com/llvm/llvm-project/blob/main/clang-tools-extra/clangd/tool/ClangdMain.cpp
-- https://github.com/llvm/llvm-project/blob/main/clang-tools-extra/clangd/CodeComplete.h
--
-- Clang-tidy: Clangd only supports "pure" matchers, not those based on clang static analyzer
-- https://github.com/clangd/clangd/issues/905

-- local compilation_flags = {
--     -- Use files open in the editor when parsing headers instead of reading from the disk
--     '--use-dirty-headers=true',
-- }

--- https://clangd.llvm.org/extensions.html#file-status
local function force_diagnostics(bufnr)
    -- Clangd diagnostics sometimes get behind. This sends a textDocument/didChange notify with an extra arg.
    local method_name = "textDocument/didChange"
    local client = vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })[1]
    if not client then
        vim.notify("No clangd client found for buffer " .. bufnr, vim.log.levels.WARN)
        return
    end

    local params = vim.lsp.util.make_text_document_params(bufnr)
    params["wantDiagnostics"] = true

    local ok = client:notify(method_name, params)
    if not ok then
        vim.notify("Failed to send " .. method_name .. " notification to clangd", vim.log.levels.ERROR)
    end
end

require("core.lsp.on_attach_fn").on_attach_client_name("clangd",
    function(client, lsp_attach_args, callback_args)
        vim.keymap.set({ "n", "i" }, "<A-o>", "<cmd>LspClangdSwitchSourceHeader<cr>",
            { desc = "Clang: Switch source/header", buffer = lsp_attach_args.buf })
        vim.keymap.set({ "n", "i" }, "<leader>k", "<cmd>LspClangdShowSymbolInfo<cr>",
            { desc = "Clang: Show symbol info", buffer = lsp_attach_args.buf })

        vim.api.nvim_buf_create_user_command(lsp_attach_args.buf, "LspClangdForceDiagnostics", function()
            force_diagnostics(lsp_attach_args.buf)
        end, { desc = "Force diagnostics generation for clangd" })

        -- Disable semantic tokens for clangd
        -- client.server_capabilities.semanticTokensProvider = nil
    end
)

return {
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
        -- Controls the flags used when no compile command is found. Like compile_flags.txt
        fallbackFlags = { '-std=c++23' }
    },

    cmd = {
        vim.fn.exepath("/usr/bin/clangd") or vim.fn.stdpath("data") .. "/mason/bin/clangd",
        "-j=6",
        "--background-index",
        "--background-index-priority=background",
        "--clang-tidy", -- Run through nvim-lint. See comment on top.
        "--completion-style=detailed",
        "--header-insertion=never",
        "--log=error",
        "--malloc-trim",
        "--pch-storage=memory",
        "--fallback-style=webkit",
    },
}
