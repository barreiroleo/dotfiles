--- @param trunc_width number? trunctates component when screen width is less then trunc_width
--- @param trunc_len number? truncates component to trunc_len number of chars
--- @param hide_width number? hides component when window width is smaller then hide_width
--- @param use_ellipsis boolean? whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, use_ellipsis)
    return function(str)
        local win_width = vim.fn.winwidth(0)
        if hide_width and win_width < hide_width then
            return ''
        elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
            return str:sub(1, trunc_len) .. (use_ellipsis and '...' or '')
        end
        return str
    end
end

local lint_component = {
    function()
        local linters = require("lint").get_running()
        if #linters == 0 then return "" end
        return "[" .. table.concat(linters, ", ") .. "]"
    end,
    fmt = trunc(80, 10, nil, true),
    icon = "󱉶 "
}

local lsp_component = {
    require("core.utils.lsp_progress").get_statusline_data,
    fmt = trunc(80, 10, nil, true),
    -- icon = "" "✓"
}

return {
    "nvim-lualine/lualine.nvim",
    event = { "BufNewFile", "BufReadPre", "InsertEnter" },
    opts = {
        options = {
            component_separators = '',
            section_separators = { left = '', right = '' },
        },
        inactive_sections = {
            lualine_c = { { 'filename', path = 1 } }
        },
        sections = {
            lualine_a = { { 'mode', --[[ separator = { left = '' }, right_padding = 2 ]] } },
            lualine_b = { { 'branch', fmt = trunc(80, 0, nil, true) }, 'diagnostics' },
            lualine_c = { { 'filename', path = 1 }, '%=', --[[ Centered components goes here ]] },
            lualine_x = { lint_component, lsp_component --[[ 'lsp_status' ]] },
            lualine_z = { { 'location', --[[ separator = { right = '' }, left_padding = 2 ]] } },
        },
        tabline = {
            lualine_b = { { 'buffers', buffers_color = { active = 'lualine_b_insert' } } },
            lualine_z = { 'tabs' }
        }
    },
    -- config = function(_, opts)
    --     require("lualine").setup(
    --         vim.tbl_deep_extend("force", require("lualine").get_config(), opts)
    --     )
    -- end,
}
