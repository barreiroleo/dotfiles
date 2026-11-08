-- vim.o:  behaves like :let &{option-name}
-- vim.go: behaves like :let &g:{option-name}
-- vim.bo: behaves like :let &l:{option-name} for buffer-local options
-- vim.wo: behaves like :let &l:{option-name} for window-local options
vim.cmd.packadd("cfilter")
vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")
vim.opt.exrc = true -- Auto exec {.nvim.lua, .nvimrc, .exrc}

-- Editing
vim.opt.shiftwidth = 4     -- Size of indent
vim.opt.tabstop = 4        -- Number of spaces tabs count for
vim.opt.expandtab = true   -- Use spaces instead of tabs
vim.opt.shiftround = true  -- Round indent to a multiple of shiftwidth
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.wrap = false       -- Disable line wrap
vim.opt.textwidth = 100    -- Broke lines after N when insert
vim.opt.spelllang = { "en", "es" }

-- Searching
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split" -- Shows all effects of subtitutions in a preview window
if vim.fn.executable("rg") then
    vim.o.grepprg = "rg --vimgrep --smart-case"
    vim.o.grepformat = "%f:%l:%c:%m"
end

-- Behaviour
vim.opt.clipboard = "unnamedplus"
vim.opt.confirm = true              -- Confirm to save changes before exiting modified buffer
vim.opt.mouse = "a"
vim.opt.nrformats = "alpha,hex,bin" -- Increment/decrements: 0b01 0x1 a1
vim.opt.updatetime = 200            -- Save swap file and trigger CursorHold
vim.opt.undofile = true

-- CMD completion
-- longest -> First wild char tap (Tab press). Insert longest common occurrence.
-- :full ->   Second tap. Open and populate the wild menu with full completions.
-- ,full ->   Third tap. Select next/prev completions.
vim.opt.wildmode = "longest:full,full"

-- Visual
vim.opt.colorcolumn = "+1"
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.wo.signcolumn = "yes"
vim.opt.list = true -- Show tabs, trailing spaces, etc
vim.opt.listchars = { trail = '⋅', tab = '  ↦' }

vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.winborder = "rounded"

-- Fix markdown indentation settings
vim.g.markdown_folding = 1           -- Enable the markdown plugin
vim.g.markdown_recommended_style = 0 -- expandtab will be set by default
-- Fix TeX recognized as latex instead of plaintex
vim.g.tex_flavor = "latex"
-- Disable health checks for these providers.
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Default to treesitter folding. Prefer LSP folding if client supports it
vim.o.foldlevel = 99
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method('textDocument/foldingRange') then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
        end
    end,
})
vim.api.nvim_create_autocmd('LspDetach', {
    callback = function(args)
        local win = vim.api.nvim_get_current_win()
        vim.wo[win][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end,
})
