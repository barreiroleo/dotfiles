-- -- Copy config to windows's alacritty dir
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.toml" },
    callback = function()
        vim.cmd("silent !bash alacritty.sh ';' display 'Config copied'")
    end,
})

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
