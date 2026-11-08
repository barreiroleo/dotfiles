---@class table<win_num, cur_pos>>
---@field win integer
---@field cursor table<integer, integer>
local prev_pos = {}

local function ToggleFocus()
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    if not string.find(bufname, "neo-tree ", nil, true) then
        prev_pos = { win = vim.api.nvim_get_current_win(), cursor = vim.api.nvim_win_get_cursor(0) }
        -- P({ "Saving pos: ", vim.api.nvim_win_get_number(prev_pos.win), prev_pos.cursor })
        require("neo-tree.command").execute({ dir = vim.uv.cwd() })
    else
        -- P({ "Going pos: ", vim.api.nvim_win_get_number(prev_pos.win), prev_pos.cursor })
        local function callback()
            vim.api.nvim_set_current_win(prev_pos.win)
            vim.api.nvim_win_set_cursor(prev_pos.win, prev_pos.cursor)
        end
        local res, err = pcall(callback)
    end
end

return {
    -- {
    --     'nvim-neo-tree/neo-tree.nvim',
    --     enabled = false,
    --     branch = 'main',
    --     dependencies = {
    --         'nvim-lua/plenary.nvim',
    --         'kyazdani42/nvim-web-devicons',
    --         'MunifTanjim/nui.nvim',
    --     },
    --     cmd = 'Neotree',
    --     keys = {
    --         -- { '<leader>e', ToggleFocus, desc = 'Neotree: Toggle focus' },
    --     },
    --     opts = require 'plugins.neotree.opts',
    --     init = function()
    --         vim.g.neo_tree_remove_legacy_commands = true
    --     end,
    --     deactivate = function() vim.cmd [[Neotree close]] end,
    -- }
}
