--- Dark and Light colorschemes
local COLORSCHEME_DARK = "vague"
local COLORSCHEME_LIGHT = "vscode"

---Repository to store functors to customizer highlights according the colorscheme
---@type table<string, function?>
local CUSTOM_HIGHLIGHT_MAP = {
    ["common"] = function()
        -- DAP UI highlights
        vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
        -- Diagnostic highlights
        if vim.o.background == "dark" then
            vim.cmd.highlight("ErrorMsg guibg=#250000 guifg=0")
            vim.cmd.highlight("WarningMsg guibg=#252500 guifg=0")
        end
    end,

    ["default"] = function()
        vim.cmd.highlight("ColorColumn guibg=#303236")
    end
}

require("core.utils.auto-switch-theme").lazy_setup({
    dark = COLORSCHEME_DARK,
    light = COLORSCHEME_LIGHT,
    overrides_map_cb = CUSTOM_HIGHLIGHT_MAP
})

return {
    -- I've found gruvbox's highlight to enoying bright. Specially with LSP references and copilot.
    {
        "sainnhe/gruvbox-material",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function(_, opts)
            vim.o.termguicolors = true
            vim.g.gruvbox_material_background = "hard"
            vim.g.gruvbox_material_foreground = "material"
            vim.g.gruvbox_material_better_performance = 1
            vim.g.gruvbox_material_enable_bold = true
            vim.g.gruvbox_material_enable_italic = true
            vim.g.gruvbox_material_transparent_background = false

            CUSTOM_HIGHLIGHT_MAP["gruvbox-material"] = function()
                vim.cmd.highlight("LspInlayHint cterm=italic,underline guifg=#686868")
                vim.cmd.highlight("TreesitterContextBottom gui=underline guisp=Grey")
                -- vim.cmd.highlight("Normal guifg=#c5c9c5 guibg=#12120f")
                -- vim.cmd.highlight("NormalNC guifg=#c8c093 guibg=#12120f")
                vim.cmd.highlight("NormalFloat guifg=#c8c093 guibg=#0d0c0c")
                vim.cmd.highlight("FloatBorder guifg=#54546d guibg=#0d0c0c")
                vim.api.nvim_set_hl(0, "LazyDimmed", { default = true, link = "Comment" })
            end
        end
    },

    -- Still love kanagawa dragon, but I'm tired of it.
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            compile = true,
            background = { dark = "dragon" },
            transparent = false,
            dimInactive = true,
            overrides = function(colors)
                -- Supported keywords are the same for :h nvim_set_hl {val} parameter.
                return {
                    CursorLine              = { bg = colors.theme.ui.bg_m3 },
                    TreesitterContextBottom = { underline = true },
                    -- Dark completion:
                    -- https://github.com/rebelot/kanagawa.nvim#dark-completion-popup-menu
                    Pmenu                   = { link = "Normal" },
                    -- PmenuSel                = { link = "CursorLine" },
                    -- https://github.com/rebelot/kanagawa.nvim/blob/master/lua/kanagawa/highlights/plugins.lua#L196
                    BlinkCmpMenuBorder      = { link = "Pmenu" },
                    BlinkCmpLabelDetail     = { fg = colors.theme.syn.comment },
                    LineNr                  = { bg = "#1c1b1b" },
                }
            end,
        },
        config = function(_, opts)
            require("kanagawa").setup(opts)
        end,
    },

    {
        "thesimonho/kanagawa-paper.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            cache = true,
        },
        config = function(_, opts)
            require("kanagawa-paper").setup(opts)
        end,
        init = function()
            CUSTOM_HIGHLIGHT_MAP["kanagawa-paper"] = function()
                vim.cmd.highlight("Normal guibg=#16161d")
                vim.cmd.highlight("NormalNC guibg=#131319")
                vim.cmd.highlight("ColorColumn guibg=#21212b")
                vim.cmd.highlight("NormalFloat guibg=#21212b")
                vim.cmd.highlight("FloatBorder guibg=#21212b")
            end
        end
    },

    -- Still prefeer vague over rose-pine
    {
        "vague2k/vague.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function(_, opts)
            require("vague").setup(opts)
        end
    },

    -- {
    --     "rose-pine/neovim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    --     config = function(_, opts)
    --         require("rose-pine").setup(opts)
    --     end
    -- },

    {
        "Mofiqul/vscode.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function(_, opts)
            require("vscode").setup(opts)
        end
    },

    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {
    --         flavour = "mocha",
    --         color_overrides = {
    --             mocha = { base = "#0a0a0a", mantle = "#0a0a0a", crust = "#0a0a0a", },
    --         },
    --      },
    --     config = function(_, opts)
    --         require("catppuccin").setup(opts)
    --     end,
    -- },

    {
        "wtfox/jellybeans.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function(_, opts)
            require("jellybeans").setup(opts)
        end,
        init = function()
            CUSTOM_HIGHLIGHT_MAP["jellybeans"] = function()
                vim.api.nvim_set_hl(0, "SnacksPickerPreviewBorder", { default = true, link = "FloatBorder" })
            end
            CUSTOM_HIGHLIGHT_MAP["jellybeans-muted"] = CUSTOM_HIGHLIGHT_MAP["jellybeans"]
        end
    },

    -- {
    --     "olimorris/onedarkpro.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    --     config = function(_, opts)
    --         require("onedarkpro").setup(opts)
    --     end,
    -- },

    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = { style = "night", },
    --     config = function(_, opts)
    --         require("tokyonight").setup(opts)
    --     end,
    -- },

    -- {
    --     "EdenEast/nightfox.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    --     config = function(_, opts)
    --         require("nightfox").setup(opts)
    --     end,
    -- },

    -- {
    --     "gbprod/nord.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    --     config = function(_, opts)
    --         require("nord").setup(opts)
    --     end,
    -- },

    -- I've tweaked background more gruvbox-ish. Interesting.
    {
        'AlexvZyl/nordic.nvim',
        lazy = false,
        priority = 1000,
        opts = {},
        config = function(_, opts)
            require("nordic").setup(opts)
        end,
        init = function()
            CUSTOM_HIGHLIGHT_MAP["nordic"] = function()
                vim.cmd.highlight("Normal guibg=#0f1115")
                vim.cmd.highlight("NormalNC guibg=##0a0c0f")
                vim.cmd.highlight("FloatBorder guifg=#54546d")
                vim.cmd.highlight("TreesitterContextBottom gui=underline guisp=Grey")
            end
        end
    },

    -- {
    --     "loctvl842/monokai-pro.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         require("monokai-pro").setup()
    --     end,
    -- },

    -- {
    --     'projekt0n/github-nvim-theme',
    --     name = 'github-theme',
    --     lazy = false,
    --     priority = 1000,
    --     opts = {
    --         options = {
    --             styles = {             -- Style to be applied to different syntax groups
    --                 comments = 'italic', -- Value is any valid attr-list value `:help attr-list`
    --                 functions = 'NONE',
    --                 keywords = 'bold',
    --                 variables = 'NONE',
    --                 conditionals = 'NONE',
    --                 constants = 'NONE',
    --                 numbers = 'NONE',
    --                 operators = 'NONE',
    --                 strings = 'NONE',
    --                 types = 'NONE',
    --             },
    --         }
    --     },
    --     init = function()
    --         CUSTOM_HIGHLIGHT_MAP["github_dark_default"] = function()
    --             -- vim.cmd.highlight("Normal guibg=#0a0a0a")
    --             -- vim.cmd.highlight("NormalNC guibg=#0a0a0a")
    --         end
    --     end
    -- },

    -- {
    --     "Aejkatappaja/cendre",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {
    --         background = "hard", -- "hard" | "medium" | "soft"
    --         italic_virtual_text = true,
    --     },
    -- },

    -- {
    --     "ember-theme/nvim",
    --     name = "ember",
    --     priority = 1000,
    --     opts = {
    --         variant = "ember", -- "ember" | "ember-soft" | "ember-light"
    --     },
    -- },

    -- {
    --     "daaanny90/zed.nvim",
    --     commit = "6f5e43ec71252b1fd3fbb5ee157e77e63585deae",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    --     config = function(_, opts)
    --         require("zed").setup(opts)
    --     end
    -- },
}
