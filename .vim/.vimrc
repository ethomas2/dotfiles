"When moving to a new vim
"Copy vimrc
"Install vundle https://github.com/gmarik/vundle#about
"run :BundleInstall Syntastic
"run :BundleInstall Valloric/YouCompleteMe (you may have to install vim from source to to get this working)
"compile you complete me
"remove dumb 80 character line limit from ~/.vim/bundle/YouCompleteMe/style_format.sh
"run :Bundleinstall terryma/vim-multiple-cursors
"download vim fanfingtastic and put in ~/.vim/plugins
"
":CtrlPClearCache


" Things required for vundle
set nocompatible              " be iMproved, required
filetype off                  " required


set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.fzf
set rtp+=~/.vim/bundle/vim-colors-solarized
call vundle#begin()

Plugin 'gmarik/vundle'

"Language IDE-like stuff
Plugin 'fatih/vim-go'
Plugin 'bitc/vim-hdevtools'
Plugin 'https://github.com/dan-t/vim-hsimport'
" consider https://github.com/romainl/ctags-patterns-for-javascript

" Coloring/syntax highlighting
Plugin 'https://github.com/leafgarland/typescript-vim'
Plugin 'https://github.com/mxw/vim-jsx'
Plugin 'https://github.com/altercation/vim-colors-solarized'

" Verbs
Plugin 'tpope/vim-surround'
Plugin 'https://github.com/tpope/vim-commentary'
Plugin 'https://github.com/tommcdo/vim-lion'

" Text objects
Plugin 'https://github.com/kana/vim-textobj-entire'
Plugin 'https://github.com/michaeljsmith/vim-indent-object'
Plugin 'https://github.com/kana/vim-textobj-user'
Plugin 'https://github.com/glts/vim-textobj-comment'
Plugin 'https://github.com/wellle/targets.vim'
Plugin 'https://github.com/coderifous/textobj-word-column.vim'

" Other
Plugin 'https://github.com/christoomey/vim-tmux-navigator'

call vundle#end()

filetype plugin indent on    " required
autocmd BufRead,BufNewFile *go setlocal filetype=go

set noswapfile

let mapleader=" "

"set backspace=indent,eol,start
"set foldmethod=indent
"set foldlevel=99
"set foldlevelstart=99


" Change colorscheme from default to ron
colorscheme ron

" Turn on line numbering. Turn it on and of with set number and set number!
set nu
" set rnu


" Stop vim from inserting two periods after formatting something with gq
" https://stackoverflow.com/questions/4760428/how-can-i-make-vims-j-and-gq-commands-use-one-space-after-a-period
set nojoinspaces

syntax enable
let g:solarized_termtrans = 1
let g:solarized_bold = 1
let g:solarized_termcolors = 256
set background=dark
colorscheme solarized

function! EraseTrailingWhiteSpace()
  if search('\s\+$', 'nw') != 0
    %s/\s\+$//e
    normal!``
  endif
endfunction

augroup mygroup
  "every time you source ~/.vimrc, it re-adds everything in this group
  "multiple source ~/.vimrc will end up with multiple copies of the same autocmd
  "therefore erase this group before making all the autocmds,
  autocmd!

  "open vim with with cursor position where it was last
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

  "erase whitespace at the end of new lines
  autocmd BufWritePre *
    \ if  argv(0) != ".git/addp-hunk-edit.diff" |
    \   call EraseTrailingWhiteSpace() |
    \ endif

  "if you change vimrc, resource it
  autocmd BufWritePost  .vimrc  source %
  autocmd BufWritePost */plugin/mystuff/*.vim source %

  au FileType haskell nnoremap <silent> <buffer> <Leader>ht :HdevtoolsType<CR>
  au FileType haskell nnoremap <silent> <buffer> <Leader>hc :HdevtoolsClear<CR>
  au FileType haskell nnoremap <silent> <buffer> <Leader>hi :HdevtoolsInfo<CR>
  au BufWritePre *go GoImports

  " Not working. Idk why. See
  " https://vi.stackexchange.com/questions/5201/how-do-i-tell-vim-that-some-file-extensions-are-synonymous
  au BufRead,BufNewFile Dockerfile* setfiletype dockerfile

  " autocmd BufNewFile,BufRead *.ts set  ft=javascript
  " autocmd BufNewFile,BufRead *.tsx set ft=javascript
  " autocmd BufNewFile,BufRead *.jsx set ft=javascript
augroup END


" searching
set smartcase
set incsearch
set ic "ignore case
"set hls "Higlhight search

" Wrap text instead of being on one line
"set lbr

"tabs
set expandtab "Use spaces instead of tabs
set smarttab "Be smart when using tabs ;)
" 1 tab == 2 spaces
set shiftwidth=2
set softtabstop=2
set ai "Auto indent (copy indent from current line onto next line)
set si "Smart indent (indent where the syntax would want an indent)
set wrap "Wrap lines
" Indent automatically depending on filetype
filetype indent on
set laststatus=2

" default backpace behavior in vim is dumb
" https://vi.stackexchange.com/questions/2162/why-doesnt-the-backspace-key-work-in-insert-mode
set backspace=indent,eol,start


"test functions
noremap mm =
nnoremap <silent> <Leader>n  :set rnu!<CR>
set splitright
nnoremap n /<CR>
nnoremap N ?<CR>
"let g:syntastic_python_python_exec = 'python3'


command! -nargs=0 Fold :set foldmethod=indent

let g:textobj_comment_no_default_key_mappings = 1
xmap agc <Plug>(textobj-comment-a)
omap agc <Plug>(textobj-comment-a)
xmap igc <Plug>(textobj-comment-i)
omap igc <Plug>(textobj-comment-i)


xmap cm  <Plug>Commentary
nmap cm  <Plug>Commentary
omap cm  <Plug>Commentary
nmap cmm <Plug>CommentaryLine
nmap cgc <Plug>ChangeCommentary
nmap cmu <Plug>Commentary<Plug>Commentary

nnoremap ; :

nnoremap <C-p> :FZF<CR>
let g:go_doc_keywordprg_enabled = 0
let g:go_def_mapping_enabled = 0
let g:go_list_type = "quickfix"
let g:go_def_mode = 'godef'

" from old vimrc
set cryptmethod=blowfish

set ruler

let g:lion_create_maps = 1
let g:lion_squeeze_spaces = 1
let g:jsonnet_fmt_on_save = 0

function! TmuxRun()
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - 1]
    let lines[0] = lines[0][col1 - 1:]
    let output = join(lines, "\n")
    " TODO: also substitute all instances of $
    let cmd =  "r !tmux send-keys -t right \"" . substitute(output, '"', '\\"', "g") . "\" Enter"
    execute cmd
endfunction
xnoremap <leader>r :call TmuxRun()<CR>
