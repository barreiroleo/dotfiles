return {
    -- Just testing blink from time to time
    { import = "plugins.completion.blink" },

    -- {
    --     'iguanacucumber/magazine.nvim',
    --     enabled = true,
    --     dependencies = {
    --         { 'hrsh7th/cmp-nvim-lsp' },
    --         { 'hrsh7th/cmp-buffer' },
    --         { 'hrsh7th/cmp-path' },
    --         {
    --             'saadparwaiz1/cmp_luasnip',
    --             dependencies = { 'L3MON4D3/LuaSnip' }
    --         },
    --     },
    --     event = { "InsertEnter", --[[ "CmdlineEnter" ]] },
    --     config = function()
    --         require("plugins.completion.cmp")
    --         -- require("plugins.completion.native")
    --     end
    -- },

    -- { import = "plugins.completion.luasnip" }
}
