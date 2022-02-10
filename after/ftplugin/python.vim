setlocal textwidth=120
setlocal foldmethod=indent
setlocal foldnestmax=1
setlocal colorcolumn=120

" Run script with terminal
nnoremap <silent><buffer> <Leader>t :AsyncRun -save=1 -mode=term -pos=external python "$(VIM_FILEPATH)"<CR>
" Run script without terminal
nnoremap <silent><buffer> <Leader>r :AsyncRun -save=1 python "$(VIM_FILEPATH)"<CR>
