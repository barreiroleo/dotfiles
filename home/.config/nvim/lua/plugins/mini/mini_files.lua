---@param win_id integer
local function set_blend(win_id)
    -- Customize window-local settings
    vim.wo[win_id].winblend = 30
    local config = vim.api.nvim_win_get_config(win_id)
    config.border, config.title_pos = 'double', 'right'
    vim.api.nvim_win_set_config(win_id, config)
end

---@param buf_id integer
local function set_toggle_hidden_files_keymap(buf_id)
    local show_dotfiles = true
    local filter_show = function(_) return true end
    local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, '.') end
    --
    local toggle_dotfiles_action = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        MiniFiles.refresh({ content = { filter = new_filter } })
    end
    vim.keymap.set('n', '.', toggle_dotfiles_action, { buffer = buf_id, desc = "MiniFiles: Toggle hidden files" })
end

---Set keymaps for open file in split windows
---@param buf_id integer
local set_keymap_split = function(buf_id)
    local rhs = function(direction)
        -- Make new window and set it as target
        local new_target_window
        vim.api.nvim_win_call(MiniFiles.get_explorer_state().target_window or 0, function()
            vim.cmd('belowright ' .. direction .. ' split')
            new_target_window = vim.api.nvim_get_current_win()
        end)
        MiniFiles.set_target_window(new_target_window)
    end
    -- Adding `desc` will result into `show_help` entries
    vim.keymap.set('n', "gs", function() rhs("horizontal") end,
        { buffer = buf_id, desc = "MiniFiles: Split belowright horizontal" })
    vim.keymap.set('n', "gv", function() rhs("vertical") end,
        { buffer = buf_id, desc = "MiniFiles: Split belowright vertical" })
end

local function toggle_minifiles_window()
    if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0)) end
end

local M = {}

function M.setup()
    require("mini.files").setup()

    vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesWindowOpen',
        callback = function(args)
            local win_id = args.data.win_id
            set_blend(win_id)
        end,
    })

    vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
            local buf_id = args.data.buf_id
            set_toggle_hidden_files_keymap(buf_id)
            set_keymap_split(buf_id)
            set_keymap_split(buf_id)
        end,
    })
end

return M
