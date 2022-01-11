" Set current file's dir to cwd
" Set window title
augroup SET_CWD
    autocmd!
    autocmd BufEnter *.* silent! lcd %:p:h
    autocmd BufEnter * lua set_title()
augroup END

" Remove trailing whitespace and newlines
augroup PERFORM_CLEANUP
    autocmd!
    autocmd BufWritePre * silent! lua perform_cleanup()
augroup END

" Highlight on yank
augroup HL_ON_YANK
    autocmd!
    autocmd TextYankPost * lua vim.highlight.on_yank({ higroup = 'Visual', timeout = 500, on_visual = true, on_macro = true })
augroup END

" Automatically reload the file if it is changed outside of nvim
augroup AUTO_READ
    autocmd!
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
    autocmd FileChangedShellPost * echohl WarningMsg | redraw | echo 'File changed on disk. Buffer reloaded!' | echohl None
augroup END

" Update lualine on lsp progress
augroup UPDATE_STATUS_LINE
    autocmd!
    autocmd User LspProgressUpdate redrawstatus
augroup END

" Force disable inserting comment leader after hitting o or O
" Force disable inserting comment leader after hitting <Enter> in insert mode
augroup FORCE_FORMAT_OPTIONS
    autocmd!
    autocmd BufEnter * setlocal formatoptions-=r formatoptions-=o
augroup END