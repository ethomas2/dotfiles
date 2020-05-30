" Things required for vundle
set nocompatible              " be iMproved, required


set rtp+=~/.fzf
set rtp+=~/.vim/bundle/vim-colors-solarized


" Figure out the system Python for Neovim.
" From https://github.com/neovim/neovim/issues/1887
" Necessary for :Black
if exists("$VIRTUAL_ENV")
    let g:python_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), '\n', '', 'g')
    let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), '\n', '', 'g')
else
    let g:python_host_prog=substitute(system("which python3"), '\n', '', 'g')
    let g:python3_host_prog=substitute(system("which python3"), '\n', '', 'g')
endif
let g:python3_host_prog='/usr/bin/python3'

" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
 autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Language/IDE like things
Plug 'https://github.com/dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}


Plug 'fatih/vim-go'
let g:go_fmt_command = "goimports"

Plug 'bitc/vim-hdevtools'
Plug 'https://github.com/dan-t/vim-hsimport'
Plug 'https://github.com/junegunn/fzf.vim'
Plug 'https://github.com/prettier/vim-prettier' " TODO: write your own aucmd
" Plug 'psf/black'
Plug 'https://github.com/rust-lang/rust.vim'
let g:rustfmt_autosave = 1
Plug 'https://github.com/tell-k/vim-autopep8'
let g:autopep8_disable_show_diff=1



Plug 'https://github.com/scrooloose/nerdtree'

" Coloring/syntax highlighting
Plug 'https://github.com/leafgarland/typescript-vim'
autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx " hack to make coc.vim work with tsx files
" Plug 'https://github.com/HerringtonDarkholme/yats.vim'
Plug 'https://github.com/mxw/vim-jsx'
Plug 'https://github.com/altercation/vim-colors-solarized'
" Mostly so f strings get syntax highlighted
Plug 'https://github.com/ethomas2/python-syntax', {
  \ 'branch': 'normal-f-strings',
  \ }
let g:python_highlight_all = 1
Plug 'https://github.com/lifepillar/pgsql.vim'
let g:sql_type_default = 'pgsql'
Plug 'https://github.com/hashivim/vim-terraform'
let g:terraform_fmt_on_save=1


" Verbs
Plug 'tpope/vim-surround'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/tommcdo/vim-lion'
Plug 'https://github.com/machakann/vim-swap'

" Text objects
Plug 'https://github.com/kana/vim-textobj-entire'
Plug 'https://github.com/ethomas2/vim-indent-object', {
  \ 'branch': 'fix-bug',
  \ }
Plug 'https://github.com/kana/vim-textobj-user'
Plug 'https://github.com/glts/vim-textobj-comment'
Plug 'https://github.com/wellle/targets.vim'
Plug 'https://github.com/coderifous/textobj-word-column.vim'

" Other
Plug 'https://github.com/jgdavey/tslime.vim'
Plug 'https://github.com/tpope/vim-dispatch'
Plug 'https://github.com/kassio/neoterm'
Plug 'https://github.com/jceb/vim-editqf'
Plug 'https://github.com/ethomas2/vim-unstack' " can't get this to work
Plug 'https://github.com/mattboehm/vim-accordion'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'https://github.com/tpope/vim-rhubarb'
Plug 'https://github.com/kshenoy/vim-signature'
let g:SignatureMarkLineHL = 'Search' " Consider other highlight groups. This one is sort of annoying
let g:SignatureMarkTextHL = 'None'
let g:SignatureForceRemoveGlobal = 1 " See https://github.com/kshenoy/vim-signature/issues/72
" Plug 'https://github.com/jiangmiao/auto-pairs'
call plug#end()


"





autocmd BufRead,BufNewFile *go setlocal filetype=go

set noswapfile

let mapleader=" "


" Turn on line numbering. Turn it on and of with set number and set number!
set nu


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
  autocmd BufWritePost  local.vim  source %
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
nnoremap <silent> <Leader>n  :set rnu!<CR>
set splitright
nnoremap n /<CR>
nnoremap N ?<CR>


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

if !has('nvim')
  set cryptmethod=blowfish
endif

set ruler

let g:lion_create_maps = 1
let g:lion_squeeze_spaces = 1
let g:jsonnet_fmt_on_save = 0

vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
nmap <C-c><C-q> :Tmux q<CR>
let g:tslime_always_current_session = 1
let g:tslime_always_current_window = 1

" Adapted from https://stackoverflow.com/questions/2974192/how-can-i-pare-down-vims-buffer-list-to-only-include-active-buffers
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
command! -nargs=* CleanBuf call CloseHiddenBuffers()
command! -nargs=* BufClean call CloseHiddenBuffers()

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

command! -bang -nargs=* Lines
  \ call fzf#vim#lines(<q-args>, fzf#vim#with_preview('right:35%'))

" Immediately trigger a search for the current keyword if there is one
nnoremap <expr> <leader>g (expand("<cword>") ==? "") ? ":Ag " : ":Ag \<C-r>\<C-w><CR>"

" Immediately trigger a search for the current selection if there is one
xnoremap <leader>g "zy:exe "Ag ".@z.""<CR>

let g:prettier#exec_cmd_path = "~/.config/yarn/global/node_modules/.bin/prettier"
let g:prettier#exec_cmd_async = 1
let g:prettier#autoformat = 0
" autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue,*.yaml,*.html PrettierAsync

nnoremap <C-B> :Buffers<CR>

command! -nargs=* TSlimeReset unlet g:tslime
command! -nargs=* TS unlet g:tslime
command! -nargs=* Ts unlet g:tslime
" cnoreabbrev ts TSlimeReset

if filereadable("local.vim")
  source local.vim
endif


command! -nargs=0 NoScroll diffoff | windo set nocursorbind | windo set noscrollbind

function! Dbase()
  " fnamemodify: https://stackoverflow.com/a/24463362/4993041
  let l:path = fnamemodify(expand("%"), ":~:.")
  let l:ft = &ft
  let l:orig_window = winnr()
  :windo diffoff
  exe "normal! " . l:orig_window . "\<C-W>\<C-W>"
  :diffthis
  :new
  exe ".!git show $(git base):" . l:path
  exe "set ft=" . l:ft
  :diffthis
  au BufUnload <buffer> windo NoScroll
  exe ":normal! \<C-W>p"
endfunction
command! -nargs=0 Dbase call Dbase()
command! -nargs=0 GDbase call Dbase()
command! -nargs=0 Gdbase call Dbase()

function! Gdt(...)
  let commit = a:0 > 0 ? a:1 : "HEAD"
  " fnamemodify: https://stackoverflow.com/a/24463362/4993041
  let l:path = fnamemodify(expand("%"), ":~:.")
  let l:ft = &ft
  let l:orig_window = winnr()
  :windo diffoff
  exe "normal! " . l:orig_window . "\<C-W>\<C-W>"
  :diffthis
  :new
  exe ".!git show " . commit . ":" . l:path
  exe "set ft=" . l:ft
  :diffthis
  au BufUnload <buffer> windo NoScroll
  " BufUnload function() { normal! l:orig_window "\<C-W>\<C-W>"; }
  exe ":normal! \<C-W>p"
endfunction
command! -nargs=? Gdt call Gdt(<f-args>)
cnoreabbrev gdt Gdt


function! Gshow(...)
  let commit = a:1
  " fnamemodify: https://stackoverflow.com/a/24463362/4993041
  let l:path = fnamemodify(expand("%"), ":~:.")
  let l:ft = &ft
  :new
  exe ".!git show " . commit . ":" . l:path
  exe "set ft=" . l:ft
endfunction
command! -nargs=? Gshow call Gdt(<f-args>)

" <tab> is remapped to gt, (which also overrides <C-I>), so remap <C-J> to
" <C-I>/<tab>
nnoremap <C-n> <tab>

" For local replace
nnoremap gr :%s/<C-R><C-w>//gc<left><left><left>

" For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

" disable GOD DAMN MOTHER FUCKING SCROLL WHEEL FOR THE FUCKING LOVE OF CHRIST
noremap <UP> <nop>
noremap <DOWN> <nop>
cnoremap <UP> <nop>
cnoremap <DOWN> <nop>
inoremap <UP> <nop>
inoremap <DOWN> <nop>

cnoreabbrev nt NERDTreeToggle

" command! -nargs=0 QAdd caddexpr expand("%") . ":" . line(".") .  ":" . getline(".")

" when command buffer gets too big do some combination of <C-w>_ and set
" cmdheight=1

function! SaveTempFile()
  let l:fname = system('tempfile -s .vim')
  :exe ":w! " . l:fname
endfunction
command! -nargs=0 SaveTempFile call SaveTempFile()
cnoreabbrev wt SaveTempFile

" see https://stackoverflow.com/a/11450865/4993041
" only clears global marks
command! -nargs=0 ClearMarks delmarks A-Za-z | SignatureRefresh

let g:loaded_clipboard_provider = 1
set clipboard^=unnamedplus

" from https://stackoverflow.com/questions/4256697/vim-search-and-highlight-but-do-not-jump
nnoremap <silent> <Leader>s :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
nnoremap <silent> <Leader>h :set nohls<CR>


cnoremap <C-a> <C-b>

" https://vim.fandom.com/wiki/Simplifying_regular_expressions_using_magic_and_no-magic
" cnoremap %s/ %smagic/
" cnoremap \>s/ \>smagic/

autocmd BufNewFile,BufRead .envrc set filetype=sh

command! -nargs=0 Tasks :tabnew /home/evan/github.com/tempoautomation/digital-factory/tasks.md

