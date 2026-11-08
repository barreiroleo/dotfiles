return {
    "barreiroleo/ltex_extra.nvim",
    branch = "dev",
    ft = { "markdown", "tex" },
    -- opts = {
    --     init_check = true,   -- boolean : whether to load dictionaries on startup
    --     path = ".ltex",      -- string : path to store dictionaries. Relative path uses current working directory
    --     -- path = vim.fn.expand("~") .. "/.local/share/ltex",
    --     server_start = true, -- boolean : Enable the call to ltex. Usefull for migration and test
    --     server_opts = {
    --         on_attach = function(client, bufnr)
    --             print("Loading ltex from ltex_extra")
    --             require("core.lsp.opts").on_attach(client, bufnr)
    --         end,
    --         capabilities = require("core.lsp.opts").capabilities,
    --         filetypes = { 'bib', 'markdown', 'org', 'plaintex', 'rst', 'rnoweb', 'tex' },
    --         settings = {
    --             ltex = {
    --                 settings = {
    --                     checkFrequency = 'save',
    --                     language = { "en-US", 'es-AR' },
    --                     additionalRules = {
    --                         enablePickyRules = true,
    --                         motherTongue = 'es-AR',
    --                     },
    --                 }
    --             },
    --         }
    --     },
    -- },
    config = function()
        local function find_root()
            local file_path = vim.api.nvim_buf_get_name(0)
            local root_pattern = require("lspconfig").util.root_pattern
            -- Look for existing `.ltex` directory first. If it doesn't exist,
            -- look for .git/.hg directories. If everything else fails, get absolute path to the file parent
            return root_pattern('.ltex', '.hg', '.git')(file_path) or vim.fn.fnamemodify(file_path, ':p:h')
        end
        require("ltex_extra").setup({
            load_langs = { 'es-AR', 'en-US' }, -- table <string> : language for witch dictionaries will be loaded
            log_level = "info",                -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
            -- path = find_root(),                -- string : path to store dictionaries. Relative path uses current working directory
            path = ".ltex",                -- string : path to store dictionaries. Relative path uses current working directory
            _use_plenary = true
        })
    end
}
