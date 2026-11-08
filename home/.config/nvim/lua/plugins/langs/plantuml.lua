return {
    { 'weirongxu/plantuml-previewer.vim',
        ft = { 'plantuml', 'puml', 'uml', 'md' },
        dependencies = {
            'tyru/open-browser.vim',
            'aklt/plantuml-syntax',
        },
        init = function()
            -- Custom filetypes
            vim.filetype.add {
                extension = {
                    puml = function(path, bufnr)
                        return 'plantuml'
                    end,
                },
            }
        end,
        config = function()
            vim.g.plantuml_previewer = { plantuml_jar_path = vim.fs.normalize '~/.local/bin/plantuml.jar' }
            vim.g.plantuml_previewer = { save_format = 'svg' }
            vim.g.plantuml_previewer = { debug_mode = 1 }
        end,
    },
}
