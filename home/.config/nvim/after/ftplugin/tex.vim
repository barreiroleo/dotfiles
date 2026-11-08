function! s:start_delete(key)
    let l:result = a:key
    if !s:deleting
        let l:result = "\<C-G>u".l:result
    endif
    let s:deleting = 1
    return l:result
endfunction

function! s:check_undo_break(char)
    if s:deleting
        let s:deleting = 0
        call feedkeys("\<BS>\<C-G>u".a:char, 'n')
    endif
endfunction

augroup smartundo
    autocmd!
    autocmd InsertEnter * let s:deleting = 0
    autocmd InsertCharPre * call s:check_undo_break(v:char)
augroup END

" This will work for <BS>, <C-W> (delete a word), and <C-U> (delete to beginning of line).
inoremap <expr> <BS> <SID>start_delete("\<BS>")
inoremap <expr> <C-W> <SID>start_delete("\<C-W>")
inoremap <expr> <C-U> <SID>start_delete("\<C-U>")

inoremap . .<C-G>u
inoremap , ,<C-G>u
inoremap <CR> <CR><C-G>u

" Create surrounding command (ysc) & Create surrounding environment (yse)
augroup latexSurround
  autocmd!
  autocmd FileType tex call s:latexSurround()
augroup END

function! s:latexSurround()
  let b:surround_{char2nr("e")}
    \ = "\\begin{\1environment: \1}\n\t\r\n\\end{\1\1}"
  let b:surround_{char2nr("c")} = "\\\1command: \1{\r}"
endfunction

" Conceal level: Replace symbols keywords with unicode: \lambda -> λ
function ToggleConcealLevel()
    if &conceallevel == 0
        setlocal conceallevel=2
    else
        setlocal conceallevel=0
    endif
endfunction

command! ToggleConcealLevel call ToggleConcealLevel()
setlocal conceallevel=0

set textwidth=100
set colorcolumn=100
