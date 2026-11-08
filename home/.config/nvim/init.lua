vim.g.mapleader = ","
vim.g.maplocalleader = ";"

-- Start as `PROF=1 vim`
if vim.env.PROF then
    local snackspath = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
    vim.opt.rtp:append(snackspath)
    ---@diagnostic disable-next-line: missing-fields
    require("snacks.profiler").startup({
        startup = {
            event = "VimEnter", -- stop profiler on this event
        },
    })
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
    spec = { { import = "plugins" }, },
    change_detection = { notify = false },
    dev = {
        path = "~/develop/plugins/",
        patterns = { "barreiroleo" },
        fallback = true,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip", "matchit", "matchparen", "tarPlugin", "tutor", "zipPlugin", "tohtml",
                -- "netrwPlugin", Needed to download the language spells automatically
            },
        },
    },
    profiling = {
        loader = true,
        require = true,
    }
})
