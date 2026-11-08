local cmd_backsearch = require("core.lsp.texlab_util").cmd_backsearch

local SearchCmds = {
    -- evincesyn = {
    --     executable = "evince-synctex",
    --     args = { "--forward", "%l", "--pdffile", "%p", "--texfile", "%f", "--cmd", cmd_backsearch("%f", "%l", "\r") }
    -- },
    -- zathura = {
    --     executable = "zathura",
    --     args = { "-x", cmd_backsearch("'%{input}'", "%{line}", "<CR>"),
    --         "--synctex-forward", "%l:1:%f", "%p" }
    -- },
    --
    -- command: sioyek --inverse-search "echo %1 %2 %3" ~/develop/proyects/pps/build/main.pdf
    -- produce: file line col: /mnt/sdb1/PPS/src/./ch-02/Actividades.tex 16 0
    sioyek = {
        executable = "sioyek",
        args = { "--inverse-search", cmd_backsearch("%1", "%2", "%3"), "--forward-search-file", "%f",
            "--forward-search-line", "%l", "%p" }
    },
}

local BuildCmds = {
    latexmk = {
        executable = "latexmk",
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f", "-output-directory=../build" },
        onSave = true,
        forwardSearchAfter = true
    },
    tectonic = {
        executable = "tectonic",
        args = { "-X", "compile", "%f", "--keep-logs", "--keep-intermediates", "--synctex", "--outdir build" },
        onSave = true,
        forwardSearchAfter = false
    }
}

require("core.lsp.on_attach_fn").on_attach_client_name("texlab",
    function(client, lsp_attach_args, callback_args)
        -- vim.fn.serverstart("/tmp/nvim.latex")
    end
)

return {
    filetypes = { 'bib', 'plaintex', 'tex' },
    settings = {
        texlab = {
            build = BuildCmds.latexmk,
            forwardSearch = SearchCmds.sioyek,
            auxDirectory = '../build',
            chktex = {
                onOpenAndSave = true,
            },
            diagnosticsDelay = 300,
            formatterLineLength = 80, -- 0 disable
            bibtexFormatter = 'latexindent',
            latexFormatter = 'latexindent',
            latexindent = {
                modifyLineBreaks = true,
            },
        },
    },
}
