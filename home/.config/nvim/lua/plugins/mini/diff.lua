local M = {}

function M.setup()
    require("mini.diff").setup({
        view = {
            style = 'sign',
        },
        mappings = {
            goto_prev = '[c',
            goto_next = ']c',
        },
    })
end

return M
