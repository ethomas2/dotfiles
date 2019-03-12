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


set rtp+=~/.fzf
set rtp+=~/.vim/bundle/vim-colors-solarized

" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
 autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

"Language IDE-like stuff
Plug 'fatih/vim-go'
Plug 'bitc/vim-hdevtools'
Plug 'https://github.com/dan-t/vim-hsimport'
Plug 'https://github.com/junegunn/fzf.vim'
Plug 'https://github.com/prettier/vim-prettier' " TODO: write your own aucmd
Plug 'https://github.com/autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Coloring/syntax highlighting
Plug 'https://github.com/leafgarland/typescript-vim'
Plug 'https://github.com/mxw/vim-jsx'
Plug 'https://github.com/altercation/vim-colors-solarized'
" Mostly so f strings get syntax highlighted
Plug 'https://github.com/ethomas2/python-syntax', {
  \ 'branch': 'normal-f-strings',
  \ }
let g:python_highlight_all = 1


" Verbs
Plug 'tpope/vim-surround'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/tommcdo/vim-lion'

" Text objects
Plug 'https://github.com/kana/vim-textobj-entire'
Plug 'https://github.com/ethomas2/vim-indent-object', {
  \ 'branch': 'fix-bug',
  \ }
Plug 'https://github.com/kana/vim-textobj-user'
Plug 'https://github.com/glts/vim-textobj-comment'
Plug 'https://github.com/wellle/targets.vim'
Plug 'https://github.com/coderifous/textobj-word-column.vim'
let g:textobj_python_no_default_key_mappings = 1
Plug 'https://github.com/bps/vim-textobj-python'

" Other
Plug 'https://github.com/jgdavey/tslime.vim'
" Plug 'https://github.com/Konfekt/vim-alias'
call plug#end()

call textobj#user#map('python', {
      \   'class': {
      \     'select-a': '<buffer>al',
      \     'select-i': '<buffer>il',
      \     'move-n': '<buffer>]pl',
      \     'move-p': '<buffer>[pl',
      \   },
      \   'function': {
      \     'select-a': '<buffer>af',
      \     'select-i': '<buffer>if',
      \     'move-n': '<buffer>]pf',
      \     'move-p': '<buffer>[pf',
      \   }
      \ })

" let g:LanguageClient_serverCommands = {
"     \ 'python': ['pyls'],
"     \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
" nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>



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
if !has('nvim')
  set cryptmethod=blowfish
endif

set ruler

let g:lion_create_maps = 1
let g:lion_squeeze_spaces = 1
let g:jsonnet_fmt_on_save = 0

vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
let g:tslime_always_current_session = 1
let g:tslime_always_current_window = 1

" Adapted from https://stackoverflow.com/questions/2974192/how-can-i-pare-down-vims-buffer-list-to-only-include-active-buffers
command! -nargs=* CleanBuf call CloseHiddenBuffers()
function! CloseHiddenBuffers()
  " figure out which buffers are visible in any tab
  let visible = {}
  for t in range(1, tabpagenr('$'))
    for b in tabpagebuflist(t)
      let visible[b] = 1
    endfor
  endfor
  " close any buffer that are loaded and not visible
  let l:tally = 0
  for b in range(1, bufnr('$'))
    if buflisted(b) && !has_key(visible, b)
      let l:tally += 1
      exe 'bw ' . b
    endif
  endfor
  echon "Deleted " . l:tally . " buffers"
endfun

" FZF Config
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction
let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = {'down': '45%'}

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview('right:35%'))

" command! -nargs=* -complete=dir Rg
"   \ call fzf#vim#grep(
"   \   "rg --column --line-number --no-heading --fixed-strings --smart-case --hidden --color=always --glob '!.git/**' --glob '!.hg/**' --glob '!**/*.ico' --glob '!**/*.png' --glob '!**/*.jpg' --glob '!**/*.jpeg' --glob '!**/*.zip' --glob '!**/*.tar.gz' --glob '!**/*.gif' --glob '!**/*.avi' --glob '!**/*.mp4' --glob '!**/*.mp3' --glob '!**/*.ogg' --glob '!**/*.tgz' --glob '!**/*.gz' --glob '!**/*.ctg.z' --glob '!**/*.bcmap' ".<q-args>, 1,
"   \ fzf#vim#with_preview('right:35%'),
"   \ )

command! -bang -nargs=* Lines
  \ call fzf#vim#lines(<q-args>, fzf#vim#with_preview('right:35%'))

" Immediately trigger a search for the current keyword if there is one
nnoremap <expr> <leader>g (expand("<cword>") ==? "") ? ":Ag " : ":Ag \<C-r>\<C-w><CR>"

" Immediately trigger a search for the current selection if there is one
xnoremap <leader>g "zy:exe "Ag ".@z.""<CR>

let g:prettier#exec_cmd_path = "~/.config/yarn/global/node_modules/.bin/prettier"
let g:prettier#exec_cmd_async = 1

nnoremap <C-B> :Buffers<CR>

command! -nargs=* TSlimeReset unlet g:tslime

if filereadable("local.vim")
  source local.vim
endif

inoremap :pdb import pdb; pdb.set_trace()
inoremap ;pdb import pdb; pdb.set_trace()

function! Dbase()
  let l:path = expand('%')
  :new
  exe ".!git show $(git base):" . l:path
  :windo diffthis
endfunction
command! -nargs=0 Dbase call Dbase()

function! Dt()
  let l:path = expand('%')
  :new
  exe ".!git show HEAD:" . l:path
  :windo diffthis
endfunction
command! -nargs=0 Dt call Dt()

" <tab> is remapped to gt, (which also overrides <C-I>), so remap <C-J> to
" <C-I>/<tab>
nnoremap <C-n> <tab>
