
" stolen from tslime
function! s:tmux_target()
  return '"' . g:tslime['session'] . '":' . g:tslime['window'] . "." . g:tslime['pane']
endfunction

function! Capture_Pane()
  if !exists("g:tslime") " stolen from tslime
    call <SID>Tmux_Vars()
  endif

  call system("tmux capture-pane -t " . s:tmux_target() )
endfunction

function! LoadStacktrace()
  call Capture_Pane()
  call unstack#UnstackFromTmuxPasteBuffer()
  call accordion#Start(2)
endfunction

command! LoadStacktrace call LoadStacktrace()

