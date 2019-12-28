Plug 'neoclide/coc.nvim', {'branch': 'release'}
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction
" inoremap <silent><expr> <TAB>
"               \ pumvisible() ? "\<C-n>" :
"               \ <SID>check_back_space() ? "\<TAB>" :
"               \ coc#refresh()
"
" inoremap <silent><expr> <S-TAB>
"               \ pumvisible() ? "\<C-p>" :
"               \ <SID>check_back_space() ? "\<TAB>" :
"               \ coc#refresh()
