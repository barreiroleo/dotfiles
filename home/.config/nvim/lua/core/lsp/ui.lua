-- Diagnostic message display. Error lens
local function set_line_hl_from_existing()
    local error_hl = vim.api.nvim_get_hl(0, { name = 'ErrorMsg' })
    local warn_hl  = vim.api.nvim_get_hl(0, { name = 'WarningMsg' })
    vim.api.nvim_set_hl(0, 'DiagnosticLineErrorBg', { bg = error_hl.bg or "#3c1f1e" })
    vim.api.nvim_set_hl(0, 'DiagnosticLineWarnBg', { bg = warn_hl.bg or "#352e1e" })
end

set_line_hl_from_existing()
vim.api.nvim_create_autocmd('ColorScheme', { callback = set_line_hl_from_existing })

vim.diagnostic.config {
    -- virtual_lines = { current_line = true },
    virtual_text = {
        spacing = 4,
        severity = {
            min = vim.diagnostic.severity.WARN,
            max = vim.diagnostic.severity.ERROR
        },
        source = false,
        prefix = '■', -- Could be '●', '▎', 'x', '⯀'
        virt_text_pos = "eol_right_align",
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '',
        },
        linehl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticLineErrorBg',
            [vim.diagnostic.severity.WARN]  = 'DiagnosticLineWarnBg',
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
            [vim.diagnostic.severity.WARN] = 'WarningMsg',
        },
    },
    float = { source = true, border = "rounded" },
    underline = true,
    update_in_insert = true,
    severity_sort = true,
}

-- Override floating windows border globally
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    ---@diagnostic disable-next-line: assign-type-mismatch
    opts.border = opts.border or "rounded"
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

---NOTE: this function produce mocks diagnostics to test the behaviour
local function test_diagnostics()
    local diags = {}
    local base_diag = {
        bufnr = vim.api.nvim_get_current_buf(),
        code = "imagine-two-cows",
        col = 0,
        end_col = vim.api.nvim_win_get_cursor(0)[2],
        lnum = vim.api.nvim_win_get_cursor(0)[1] - 2,
        end_lnum = vim.api.nvim_win_get_cursor(0)[1] - 2,
        message = "Dummy error",
        namespace = 22,
        severity = 5,
        source = "Mocking error",
    }
    for i = 1, 4, 1 do
        diags[i] = vim.deepcopy(base_diag)
        diags[i].severity = i
        diags[i].lnum = base_diag.lnum + i
        diags[i].end_lnum = base_diag.end_lnum + i
    end
    vim.diagnostic.set(base_diag.namespace, base_diag.bufnr, diags)
end
-- test_diagnostics()
