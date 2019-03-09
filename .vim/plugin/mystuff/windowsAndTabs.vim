" Tab navigation like chrome
nnoremap <S-tab> gT
nnoremap <tab> gt
nnoremap <C-t> :tabnew<CR>


"t change windows
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-l> :wincmd l<CR>

" open current buffer in new window
nmap <C-w>h :exe 'topleft  vnew '.expand('%:p')<CR>
nmap <C-w>l :exe 'botright vnew '.expand('%:p')<CR>
nmap <C-w>k :exe 'topleft  new '.expand('%:p')<CR>
nmap <C-w>j :exe 'botright new '.expand('%:p')<CR>

" new frame from frame
nmap <C-f>h :exe 'leftabove  vnew '.expand('%p')<CR>
nmap <C-f>l :exe 'rightbelow vnew '.expand('%p')<CR>
nmap <C-f>k :exe 'leftabove  new '.expand('%p')<CR>
nmap <C-f>j :exe 'rightbelow new '.expand('%p')<CR>

" easy split resizing
nnoremap <silent> <C-Right> <C-w>>
nnoremap <silent> <C-Left> <C-w><lt>
nnoremap <silent> <C-Up> <C-w>+
nnoremap <silent> <C-Down> <C-w>-

nnoremap <C-w>e <C-w>T

nnoremap <leader>o :buffers<CR>:buffer<Space>

"C-w H move buffer to left
"C-w K move buffer to up ... etc
"C-w r rotate windows
