function! Black()
  let l:winview = winsaveview()
  let l:bufContent = getbufline(bufnr('%'), 1, line("$"))
  " on lower vim versions you might need to '\n'.join(bufContent) before
  " feeding into system
  let l:out = system("black -q - ", l:bufContent)
  if v:shell_error != 0
    echo "black error"
    let l:err = system("black -q - 1>/dev/null", l:bufContent)
    echo l:err
    return
  endif
  :%delete _
  call setline(1, split(l:out, "\n"))
  call winrestview(l:winview)
endfunction
command! -nargs=0 Black call Black()

function! BlackErr()
  let l:winview = winsaveview()
  let l:bufContent = getbufline(bufnr('%'), 1, line("$"))
  " on lower vim versions you might need to '\n'.join(bufContent) before
  " feeding into system
  let l:out = system("black -q - 1>/dev/null", l:bufContent)
  if v:shell_error != 0
    echo l:out
    return
  endif
  :%delete _
  call setline(1, split(l:out, "\n"))
  call winrestview(l:winview)
endfunction
command! -nargs=0 BlackErr call BlackErr()
