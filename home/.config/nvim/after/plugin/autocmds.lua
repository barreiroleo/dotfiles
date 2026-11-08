local function augroup(name)
    return vim.api.nvim_create_augroup("UserAutocmd_" .. name, { clear = false })
end

-- Highlight yanked content
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("HighlightYank"),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Remove trailing space on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = augroup("RemoveTrailingSpaces"),
    callback = function()
        vim.cmd [[%s/\s\+$//e]]
    end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("CloseWith<q>"),
    pattern = {
        -- Core: <cmd>help, <cmd>Man, <cmd>messages, Quickfix, <cmd>InspectTree
        "help", "man", "notify", "qf", "lspinfo","fugitive", "DiffviewFileHistory",
        "neotest-summary"
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- Set wrap and spellcheckss
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("SetSpell"),
    pattern = { "gitcommit", "markdown", "md", "text", "txt" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Set commit length
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("SetSpell"),
    pattern = { "gitcommit" },
    callback = function()
        vim.opt_local.colorcolumn = {50,72}
    end,
})

-- Disable smartcase for command line
vim.api.nvim_create_autocmd("CmdlineEnter",
    { group = augroup("NoSmartcaseInCmdline"), pattern = { ":" }, command = "set nosmartcase" })
vim.api.nvim_create_autocmd("CmdlineLeave",
    { group = augroup("NoSmartcaseInCmdline"), pattern = { ":" }, command = "set smartcase" })

-- Cursorline off in insert mode
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" },
    { group = augroup("SmartCursorline"), pattern = { "*" }, command = "set cursorline" })
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" },
    { group = augroup("NoSmartcaseInCmdline"), pattern = { "*" }, command = "set nocursorline" })
