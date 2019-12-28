" https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Rust
Plug 'prabirshrestha/vim-lsp'
if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
        \ 'whitelist': ['rust'],
        \ })
endif
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/scrap/vim-lsp.log')
