-- if vim.uv.os_uname().sysname == "Linux" then
if vim.fn.has("wsl") == 0 then
    vim.notify("Not wsl. Automirror to /mnt/c/user/ will be skipped.")
    return
end
vim.notify("WSL detected. Automirror to /mnt/c/user/ set on.")

-- -- Copy config to windows's alacritty dir
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.lua" },
    callback = function()
        vim.cmd("silent !bash wezterm.sh ';' display 'Config copied'")
    end,
})

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
