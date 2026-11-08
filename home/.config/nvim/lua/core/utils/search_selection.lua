-- Search and repce the visual selection.
-- Search: Visual select and hit //
-- Substitute: Visual select, hit /s and write the replace.
vim.cmd([[
    function! GetVisualSelection()
        let raw_search = @"
        let @/=substitute(escape(raw_search, '\/.*$^~[]'), "\n", '\\n', "g")
    endfunction
    xnoremap // ""y:call GetVisualSelection()<bar>:set hls<cr>
    if has('nvim')
        set inccommand=nosplit
        xnoremap /s ""y:call GetVisualSelection()<cr><bar>:%s/
    else
        xnoremap /s ""y:call GetVisualSelection()<cr><bar>:%s//
    endif
]])
