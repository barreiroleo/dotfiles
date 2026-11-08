-- https://github.com/nvim-treesitter/nvim-treesitter/discussions/8621#discussioncomment-16411732

local default_langs = { "c", "cpp", "make", "cmake",
    "lua", "luadoc", "vim", "vimdoc",
    "rust", "java", "python", "bash",
    "markdown",
    "json", "toml", "yaml", "sql", "dockerfile",
}

local function is_parser_installed(lang)
    local installed = require("nvim-treesitter").get_installed()
    return vim.tbl_contains(installed, lang)
end

local function is_parser_available(lang)
    local available = require("nvim-treesitter").get_available()
    return vim.tbl_contains(available, lang)
end

local function start_treesitter(buf, lang)
    if not vim.treesitter.language.add(lang) then
        vim.notify(
            "Cannot load treesitter parser for language " .. lang,
            vim.log.levels.WARN
        )
        return
    end
    vim.treesitter.start(buf)
    vim.bo[buf].syntax = "ON"
    if vim.treesitter.query.get(lang, "indents") then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
end

---@param ev vim.api.keyset.create_autocmd.callback_args
local function filetype_hook(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang then
        return
    end
    local buf = ev.buf
    if is_parser_installed(lang) then
        start_treesitter(buf, lang)
    elseif is_parser_available(lang) then
        require("nvim-treesitter").install({ lang }):await(function()
            start_treesitter(buf, lang)
        end)
    end
end

return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        branch = "main",
        init = function()
            require('nvim-treesitter').install(default_langs):wait(300000) -- wait max. 5 min
            vim.api.nvim_create_autocmd("FileType", { callback = filetype_hook, })
        end
    },

    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = 'nvim-treesitter/nvim-treesitter',
        opts = { multiline_threshold = 1, } -- Avoid showing '{' only lines
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = 'nvim-treesitter/nvim-treesitter',
        opts = {
            textobjects = {
                select = { lookahead = true, },
                move = { set_jumps = true, },
            },
        },
        init = function()
            local select = require "nvim-treesitter-textobjects.select".select_textobject
            vim.keymap.set({ "x", "o" }, "af", function() select("@function.outer", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "if", function() select("@function.inner", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "ac", function() select("@class.outer", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "ic", function() select("@class.inner", "textobjects") end, { desc = "Select inner part of a class region" })
            vim.keymap.set({ "x", "o" }, "as", function() select("@local.scope", "locals") end, { desc = "Select language scope" })

            local move = require("nvim-treesitter-textobjects.move")
            vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end)
        end
    }
}
