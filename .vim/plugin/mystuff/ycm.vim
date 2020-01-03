" YouCompleteMe
" This is poorly done. See https://valloric.github.io/YouCompleteMe/#full-installation-guide
" installing cmake is hard. Consider installing from source or getting the
" premade binaries https://cmake.org/download/
" Plug 'https://github.com/Valloric/YouCompleteMe', {
"   \ 'do': 'sudo apt install build-essential cmake python3-dev' +
"   \ 'cd ~/.dotfiles/.vim/plugged/YouCompleteMe && python3 install.py --clang-completer',
"   \ }
" let g:ycm_enable_diagnostic_signs = 0
"
" nnoremap gd :YcmCompleter GoTo<CR>
" " nmap <silent> gd <Plug>(coc-definition)
" nnoremap gD :YcmCompleter GoToDefinition<CR>
" nnoremap gy :YcmCompleter GetType<CR>
" " nmap <silent> gy <Plug>(coc-type-definition)
" nnoremap gY :YcmCompleter GoToType<CR>
" nnoremap gx :YcmCompleter FixIt<CR>
" nnoremap go :YcmCompleter GetDoc<CR>
