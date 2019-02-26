set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

let g:LanguageClient_serverCommands.python = ['pyls']

" Map renaming in python
autocmd FileType python nnoremap <buffer>
  \ <leader>lr :call LanguageClient_textDocument_rename()<cr>
