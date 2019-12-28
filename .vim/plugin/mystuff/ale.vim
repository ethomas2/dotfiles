
Plug 'https://github.com/dense-analysis/ale'
let g:ale_echo_msg_format = '%linter% :: %s'
let g:ale_linters = {'python': ['flake8', 'mypy']}

command! -nargs=0 AT ALEToggle

command! -nargs=0 AT ALEToggle
