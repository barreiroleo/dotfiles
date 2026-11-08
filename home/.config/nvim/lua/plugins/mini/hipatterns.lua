local M = {}

function M.setup()
local hipatterns = require('mini.hipatterns')
    hipatterns.setup({
        highlighters = {
            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })
end

return M
