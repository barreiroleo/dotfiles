local M = {}

---@return lsp.ClientCapabilities
function M.extend_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local completion_capabilities = nil

    local ok, module = nil, nil

    ok, module = pcall(require, "blink.cmp")
    if ok and not completion_capabilities then
        vim.notify("Extending blink.cmp capabilities", vim.log.levels.DEBUG)
        completion_capabilities = module.get_lsp_capabilities()
    end

    ok, module = pcall(require, "cmp_nvim_lsp")
    if ok and not completion_capabilities then
        vim.notify("Extending nvim-cmp capabilities", vim.log.levels.DEBUG)
        completion_capabilities = module.default_capabilities()
    end

    if not completion_capabilities then
        vim.notify("Failed to extend completion capabilities. Using defaults.", vim.log.levels.WARN)
    end
    capabilities = vim.tbl_deep_extend('force', capabilities, completion_capabilities or {})
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true -- Required by basedpyright
    return capabilities
end

return M
