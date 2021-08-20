" Syntax highlighting based on detected language
syntax on

" Iceberg theme - I also use this theme in VSCode
colorscheme iceberg

" Default GUI  Window Geometry
if has("gui_running")
    " Preferred window size
    set lines=29 columns=105
endif

" Show tabs at the top of the editor
set showtabline=2

" Turn on Line numbering
set number

" Highlight all strings that match search
set hlsearch

" Turn on Mouse Aware mode, does lots of stuff
" What we're most interested in is the fact that
" it won't let us highlight the line numbers
set mouse+=a

" Yank and Paste using the system clipboard
set clipboard=unnamedplus

" Convert tabs to spaces
" Tabs are 4 spaces wide
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" Golang Specific stuff
" Go syntax highlighting
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

" Auto formatting and importing
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

" Status line types/signatures
let g:go_auto_type_info = 1

" Highlight whitespace at the end of the line
let g:better_whitespace_enabled=1
let g:better_whitespace_ctermcolor='red'

execute pathogen#infect()
filetype plugin indent on
