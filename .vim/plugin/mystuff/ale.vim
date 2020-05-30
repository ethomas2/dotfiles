let g:ale_echo_msg_format = '%linter% :: %s'
let g:ale_linters = {'python': [], 'typescript': []}  " disable ale for python. I think coc gives me everything i need
let g:ale_pattern_options = {
\   '.*py$': {'ale_enabled': 0},
\   '.*ts$': {'ale_enabled': 0},
\   '.*tsx$': {'ale_enabled': 0},
\   '.*go$': {'ale_enabled': 0},
\}

command! -nargs=0 AT ALEToggle
