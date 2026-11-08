---@param list HarpoonList
local open_all = function(list)
    for i = 1, #list.items do list:select(i) end
end

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = "nvim-lua/plenary.nvim",

    config = function()
        local harpoon = require("harpoon")
        local harpoon_extensions = require("harpoon.extensions")
        harpoon:setup({ settings = { save_on_toggle = true } })

        harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
        harpoon:extend({
            UI_CREATE = function(cx)
                vim.keymap.set("n", "<C-v>", function()
                    harpoon.ui:select_menu_item({ vsplit = true })
                end, { buffer = cx.bufnr })

                vim.keymap.set("n", "<C-x>", function()
                    harpoon.ui:select_menu_item({ split = true })
                end, { buffer = cx.bufnr })

                vim.keymap.set("n", "<C-t>", function()
                    harpoon.ui:select_menu_item({ tabedit = true })
                end, { buffer = cx.bufnr })

                vim.keymap.set("v", "<CR>", function()
                    local range = vim.iter({ vim.fn.line('v'), vim.fn.line('.') })
                    for line in range do
                        harpoon:list():select(line)
                    end
                end, { buffer = cx.bufnr })
            end,
        })
    end,

    keys = {
        { "<leader>we", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, { desc = "Harpoon: Toogle quick menu" } },
        { "<leader>wd", function() require("harpoon"):list():prev() end,                                   { desc = "Harpoon: Previous" } },
        { "<leader>wf", function() require("harpoon"):list():next() end,                                   { desc = "Harpoon: Next" } },
        { "<leader>wa", function() open_all(require("harpoon"):list()) end,                                { desc = "Harpoon: Open all items" } },

        { "<leader>a",  function() require("harpoon"):list():add() end,                                    { desc = "Harpoon: Add" } },
        { "<leader>1",  function() require("harpoon"):list():select(1) end,                                { desc = "Harpoon: Select 1" } },
        { "<leader>2",  function() require("harpoon"):list():select(2) end,                                { desc = "Harpoon: Select 2" } },
        { "<leader>3",  function() require("harpoon"):list():select(3) end,                                { desc = "Harpoon: Select 3" } },
        { "<leader>4",  function() require("harpoon"):list():select(4) end,                                { desc = "Harpoon: Select 4" } },
        { "<leader>5",  function() require("harpoon"):list():select(5) end,                                { desc = "Harpoon: Select 5" } },
    }
}
