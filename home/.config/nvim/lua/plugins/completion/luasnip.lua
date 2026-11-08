-- U+25AA 	▪ 	Black small square
-- U+25C6 	◆ 	Black diamond
-- U+25C7 	◇ 	White diamond
-- U+25C8 	◈ 	White diamond containing small black diamond

-- Taken from MariaSolOs, thanks
vim.api.nvim_create_autocmd('ModeChanged', {
    group = vim.api.nvim_create_augroup('UserAutocmd_unlink_snippet', { clear = true }),
    desc = 'Cancel the snippet session when leaving insert mode',
    pattern = { 's:n', 'i:*' },
    callback = function(args)
        local luasnip = require("luasnip")
        if
            luasnip.session
            and luasnip.session.current_nodes[args.buf]
            and not luasnip.session.jump_active
            and not luasnip.choice_active()
        then
            luasnip.unlink_current()
        end
    end
})

return {
    'L3MON4D3/LuaSnip',
    lazy = true,
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
        local types = require("luasnip.util.types")
        local loader = require("luasnip.loaders.from_vscode")

        require('luasnip').config.setup {
            history = false,
            region_check_events = { 'InsertLeave', 'InsertEnter' },
            delete_check_events = { 'InsertLeave', 'InsertEnter', 'TextChanged' },
            ext_opts = {
                [types.insertNode] = { unvisited = { hl_mode = 'combine', virt_text = { { '◈', 'Conceal' } }, virt_text_pos = 'inline' }, },
                -- [types.choiceNode] = { active    = { hl_mode = 'combine', virt_text = { { '◈', 'Conceal' } }, virt_text_pos = 'inline' }, },
                [types.exitNode]   = { unvisited = { hl_mode = 'combine', virt_text = { { '◈', 'Conceal' } }, virt_text_pos = 'inline' }, },
                -- [types.snippet]    = { active   = { hl_mode = 'combine', virt_text = { { '◈', 'Conceal' } }, virt_text_pos = 'inline' } },
            },
        }

        loader.lazy_load()
        loader.lazy_load({ paths = "./snippets" })
        vim.cmd('command! LuaSnipEdit :lua require("luasnip.loaders").edit_snippet_files()')
    end,
}
