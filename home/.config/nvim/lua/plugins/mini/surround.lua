local M = {}

function M.setup()
    -- Remap like tpope's vim-surround
    require("mini.surround").setup({
        mappings = {
            add = 'ys',
            delete = 'ds',
            replace = 'cs',
            find = 'sf',
            find_left = 'sF',
            highlight = 'sh',
            suffix_last = 'l',
            suffix_next = 'n',
        },
        search_method = 'cover_or_next',
        respect_selection_type = true,
    })
    vim.keymap.del('x', 'ys')
    vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

    local latex_surrounds = {
        Q = { output = { left = "``", right = "''" } },
        i = { output = { left = "\\textit{", right = "}" } },
        b = { output = { left = "\\textbf{", right = "}" } },
        t = { output = { left = "\\texttt{", right = "}" } },
        c = { output = { left = "\\corner{", right = "}" } },
        s = { output = { left = "\\set{", right = "}" } },
    }
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'tex',
        callback = function()
            vim.b.minisurround_config = { custom_surroundings = latex_surrounds }
        end,
    })
end

return M
