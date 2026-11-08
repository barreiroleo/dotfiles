-- Shorthands
vim.keymap.set("n", "<leader><leader>x", require("core.utils.save_and_exec"), { desc = "Utils: Save and execute the current file" })
vim.keymap.set("v", "<leader><leader>x", "<cmd>source<CR>", { desc = "Utils: Run the current lua visual selection" })
vim.keymap.set("n", "<leader><leader>r", function() R() end, { desc = "Utils: Dynamic reload plugin" })

-- Move cursor support for wrapped lines
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Editor: Cursor move up", expr = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Editor: Cursor move down", expr = true })

-- Move Lines
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Editor: Swap line down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Editor: Swap line up" })
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Editor: Swap line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Editor: Swap line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Editor: Swap line down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Editor: Swap line up" })

-- Can indent without exit from visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Editor: Indent to left" })
vim.keymap.set("v", ">", ">gv", { desc = "Editor: Indent to right" })

-- Breaks the undofile blocks
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- Search
-- Sanner N-n search: https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Search: Next search result" })
vim.keymap.set({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Search: Nrev search result" })
vim.keymap.set("n", "<esc>", "<cmd>noh<cr><esc>", { desc = "Search: Escape and clear hlsearch" })
-- Sets the word under the cursor as the search pattern, highlights all matches, but don't move the cursor
vim.keymap.set('n', '*', function()
    vim.fn.setreg('/', '\\<' .. vim.fn.expand('<cword>') .. '\\>')
    vim.opt.hlsearch = true
end, { silent = true, desc = "Search: Highlight word under cursor" })

-- Terminal escape
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Term: Enter normal mode" })

-- Sanner ctrl-L: https://github.com/mhinz/vim-galore#saner-ctrl-l
-- Clear search, diff update and redraw. Taken from runtime/lua/_editor.lua
vim.keymap.set("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Utils: Redraw" })

-- Buffers and tabs
vim.keymap.set("n", "]t", "<cmd>tabnext<cr>", { desc = "Tab: Next tab" })
vim.keymap.set("n", "[t", "<cmd>tabprevious<cr>", { desc = "Tab: Previous tab" })
vim.keymap.set("n", "<leader>bd", "<cmd>bp | bd #<cr>", { desc = "Buffer: Buffer delete" })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -1<cr>", { desc = "Window: Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +1<cr>", { desc = "Window: Increase window width" })
vim.keymap.set("n", "<C-Up>", "<cmd>resize +1<cr>", { desc = "Window: Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -1<cr>", { desc = "Window: Decrease window height" })

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserAutocmd_LspAttach", { clear = false }),
    callback = function(args)
        local key = vim.keymap.set
        key('n', 'gD', vim.lsp.buf.declaration, { buffer = args.buf, desc = "LSP: Go to declaration" })
        key('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf, desc = "LSP: Go to definition" })
        key('n', 'K', vim.lsp.buf.hover, { buffer = args.buf, desc = "LSP: Hover symbol information" })
        key('n', 'gic', vim.lsp.buf.incoming_calls, { buffer = args.buf, desc = "LSP: Incomming calls" })
        key('n', 'goc', vim.lsp.buf.outgoing_calls, { buffer = args.buf, desc = "LSP: Outcomming calls" })
        key('n', 'gt', vim.lsp.buf.type_definition, { buffer = args.buf, desc = "LSP: Go to type definition" })
        key('n', 'gh', vim.lsp.buf.typehierarchy, { buffer = args.buf, desc = "LSP: Go to type hierarchy" })

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            local toggle_hints = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end
            key("n", "<leader>th", toggle_hints, { buffer = args.buf, desc = "LSP: Toggle inlay hints" })
        end
    end,
})
