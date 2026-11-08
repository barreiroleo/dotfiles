---@diagnostic disable: undefined-field

local M = {}
local s_backup_keymaps = {}
local s_collides = {}

---Get the current keymaps that are in conflict with the new ones to set
---@param current_keys vim.api.keyset.keymap[]
---@param target_keys vim.api.keyset.keymap[]
---@return vim.api.keyset.keymap[]
---@nodiscard
function M.get_keymaps_to_backup(current_keys, target_keys)
    local keymaps = current_keys
    local filter = function(buf_key)
        for _, dap_key in ipairs(target_keys) do
            if dap_key.lhs == buf_key.lhs then return true end
        end
        return false
    end
    return vim.tbl_filter(filter, keymaps)
end

---Unassign the conflicting buffer keymaps.
---Buffer keymaps has precedence over globals. We need to unassign the conflicting in order to use the new globals
---@param keymap_conflicts vim.api.keyset.keymap[]
function M.unset_buffer_key_conflicts(keymap_conflicts)
    for _, keymap in ipairs(keymap_conflicts) do
        if keymap.buffer ~= 0 then
            vim.keymap.del(keymap.mode, keymap.lhs, { buffer = keymap.buffer })
        end
    end
end

---Assing the new set of keymaps
---@param target_keys vim.api.keyset.keymap[]
function M.set_keymaps(target_keys)
    for _, keymap in ipairs(target_keys) do
        vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, { desc = keymap.desc })
    end
end

---Restore the original keymaps
---@param backup_keys vim.api.keyset.keymap[]
function M.restore_keymaps(backup_keys)
    for _, keymap in ipairs(backup_keys) do
        --- In this context "0" means global, not current buffer
        if keymap.buffer == 0 then
            vim.api.nvim_set_keymap(keymap.mode, keymap.lhs, keymap.rhs or "",
                { desc = keymap.desc, noremap = keymap.noremap, callback = keymap.callback })
        else
            vim.api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs or "",
                { desc = keymap.desc, noremap = keymap.noremap, callback = keymap.callback })
        end
    end
end

---Wrapper to setup the target set of keymaps
---@param target_keymap vim.api.keyset.keymap[]
function M.setup(target_keymap)
    --- TODO: Include the keymaps for all local buffers
    s_backup_keymaps = vim.tbl_deep_extend("keep", vim.api.nvim_buf_get_keymap(0, 'n'), vim.api.nvim_get_keymap('n'))
    s_collides = M.get_keymaps_to_backup(s_backup_keymaps, target_keymap)
    -- P({ string.format("BACKUP - [%d] keys\n", #collides), collides })
    M.unset_buffer_key_conflicts(s_collides)
    M.set_keymaps(target_keymap)
end

---Wrapper to restore the last backup of keymaps
function M.shutdown()
    M.restore_keymaps(s_collides)
end

return M
