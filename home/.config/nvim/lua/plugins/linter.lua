---@param filename string
---@return string
local function find_file_root(filename)
    ---@diagnostic disable-next-line: undefined-field
    local stop, path = vim.uv.os_homedir(), vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    return vim.fs.find(filename, { upward = true, stop = stop, path = path })[1]
end

return {
    "mfussenegger/nvim-lint",
    event = { "BufNewFile", "BufReadPre" },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            dockerfile = { 'hadolint' },
            json = { 'jsonlint' },
            lua = { 'selene' },
            sql = { 'sqlfluff' },
        }

        -- Extend default args
        local extra_args = {
            ["selene"] = { "--config", find_file_root('selene.toml') },
            ["cmakelint"] = { "--linelength=120" },
            ["sqlfluff"] = { "--dialect", "sqlite" }
        }
        vim.iter(extra_args):each(function(linter, args)
            lint.linters[linter].args = vim.tbl_deep_extend('force', lint.linters[linter].args, args)
        end)

        vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
            callback = function() lint.try_lint() end,
        })

        vim.api.nvim_create_user_command("LintCpp", function() lint.try_lint("clangtidy") end, {})
    end,
}
