function! Black()
  let l:winview = winsaveview()
  let l:bufContent = getbufline(bufnr('%'), 1, line("$"))
  " on lower vim versions you might need to '\n'.join(bufContent) before
  " feeding into system
  let l:out = system("black -q - ", l:bufContent)
  if v:shell_error != 0
    echo "black error"
    return
  endif
  :%delete _
  call setline(1, split(l:out, "\n"))
  call winrestview(l:winview)
endfunction
command! -nargs=0 Black call Black()

if exists("g:black_autosave")
  augroup myBlackGroup
    autocmd!
    autocmd BufWritePre *py call Black()
  augroup END
endif
