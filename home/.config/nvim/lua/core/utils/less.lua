-- Command less. Usefull to inspect vim outputs in teporary buffer
-- Use: <cmd>less messages<cr>
vim.cmd [[
    command! -nargs=+ -complete=command Less call Less(win_getid(), <q-mods>, <q-args>)

    function! Less(winid, mods, args) abort
        execute (len(a:mods) ? a:mods . ' new' : 'botr 20new')
        call setline(1,split(win_execute(a:winid, a:args),"\n"))
        setl bt=nofile bh=wipe nobl nomod
    endfunction
]]
