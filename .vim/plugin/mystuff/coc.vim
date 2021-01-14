" I think nnoremap is unnecessary because i'm using <Plug>. I don't realy
" understand <Plug> though
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gh :<C-U>call CocAction('doHover')<CR>

xmap ga  <Plug>(coc-codeaction-selected)
nmap ga  <Plug>(coc-codeaction-selected)

nmap <leader>rn <Plug>(coc-rename)
nmap <silent> gw <Plug>(coc-references)

" " overwrite coc mappings in go files to youse fatih/vim-go
" augroup cocgroup
"   autocmd!
"   autocmd FileType go <buffer> nnoremap <silent> gd :GoDef<CR>
" augroup END


" nnoremap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
" nnoremap <expr><C-n> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"
nnoremap <expr><C-n> <Plug>coc-float-jump

command! -nargs=0 CocNextErr :call CocAction('diagnosticNext')<CR>
command! -nargs=0 CocPrevErr :call CocAction('diagnosticPrevious')<CR>


" Launch gopls when Go files are in use
" let g:LanguageClient_serverCommands = {
"        \ 'go': ['gopls']
"        \ }
" Run gofmt on save
" autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()
