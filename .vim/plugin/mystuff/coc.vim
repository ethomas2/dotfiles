" I think nnoremap is unnecessary because i'm using <Plug>. I don't realy
" understand <Plug> though
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gh :<C-U>call CocAction('doHover')<CR>
nmap <leader>rn <Plug>(coc-rename)
nmap <silent> gw <Plug>(coc-references)


" nnoremap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
nnoremap <expr><C-n> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"
