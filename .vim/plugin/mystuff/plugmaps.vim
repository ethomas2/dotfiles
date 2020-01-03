" Coc
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <TAB>
              \ pumvisible() ? "\<C-n>" :
              \ <SID>check_back_space() ? "\<TAB>" :
              \ coc#refresh()
 inoremap <silent><expr> <S-TAB>
               \ pumvisible() ? "\<C-p>" :
               \ <SID>check_back_space() ? "\<TAB>" :
              \ coc#refresh()


" ALE
let g:ale_echo_msg_format = '%linter% :: %s'
let g:ale_linters = {'python': ['flake8', 'mypy']}
command! -nargs=0 AT ALEToggle
