let g:powerline_pycmd="py3"
:set laststatus=2
syntax on
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
