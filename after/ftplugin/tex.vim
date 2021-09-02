" ---------------------------------- Options --------------------------------- "

setlocal spell
setlocal linebreak
setlocal wrap

" --------------------------------- Functions -------------------------------- "

" Auto insert \item, \task on <CR>
" https://stackoverflow.com/questions/2547739/auto-insert-text-at-a-newline-in-vim
function! AutoItem()
    let [end_lnum, end_col] = searchpairpos('\\begin{', '', '\\end{', 'nW')
    if match(getline(end_lnum), '\(itemize\|enumerate\|description\)') != -1
        return "\\item "
    elseif match(getline(end_lnum), '\(tasks\)') != -1
        return "\\task "
    else
        return ""
    endif
endfunction

function! GetLine()
    let list = ['\\task $', '\item $']
    if getline('.') =~ list[0] || getline('.') =~ list[1]
        return 1
    else
        return 0
    endif
endfunction

" Inverse search
" https://github.com/lervag/vimtex/blob/master/doc/vimtex.txt
function! SetServerName()
    let nvim_server_file = has('win32')
                \ ? $TEMP . "/curnvimserver.txt"
                \ : "/tmp/curnvimserver.txt"
    call system(printf("echo %s > %s", v:servername, nvim_server_file))
endfunction

" Replace \ with / in LaTex input fields
function! FixInputs()
    let l:save = winsaveview()
    keeppatterns %s/\(input\|include\)\({.\+\)\\\(.\+}\)/\1\2\/\3/ge "
    call winrestview(l:save)
endfunction

" Set and Restore indent
function! SetIndentLine()
    let g:indent_blankline_char = '·'
    let g:indent_blankline_space_char = '·'
endfunction

function! ResetIndentLine()
    let g:indent_blankline_char = '│'
    let g:indent_blankline_space_char = ' '
endfunction

" Clean up auxiliary files
function! CleanAuxFiles(...) abort
    let l:files = ['toc', 'out', 'aux', 'log', 'indent.log', 'nav', 'snm', 'vrb', 'fdb_latexmk', 'fls']
    call map(l:files, {_, x -> printf('"%s\%s.%s"',
                \ fnamemodify(b:vimtex.tex, ':p:h'), fnamemodify(b:vimtex.tex, ':t:r'), x)})
    silent! execute '!del ' . join(l:files)
endfunction

" ------------------------------- Autocommands ------------------------------- "

augroup VIMTEX_COMMON
    autocmd!
    call SetServerName()
augroup END

augroup TEX_AUTOCOMMANDS
    autocmd!
    " Fix inputs
    autocmd BufWritePre *.tex :call FixInputs()
    " Set and Restore indent
    autocmd BufEnter *.tex :call SetIndentLine()
    autocmd BufLeave * :call ResetIndentLine()
    " Clean up auxiliary files on quit
    autocmd User VimtexEventQuit VimtexStopAll
    autocmd User VimtexEventQuit :call CleanAuxFiles()
    autocmd BufWritePost *.tex silent! execute '!py "D:\My Folder\Dev\Python\latex\remove_indentlogs.py"'
augroup END

" --------------------------------- Mappings --------------------------------- "

" Auto \item, \task
inoremap <buffer> <expr> <CR> GetLine()
            \ ? '<C-w><C-w>'
            \ : (col(".") < col("$") ? '<CR>' : '<CR>'.AutoItem() )
nnoremap <expr> o "o".AutoItem()
nnoremap <expr> O "O".AutoItem()

" Push to next item of the list
nnoremap <Insert> i<CR>\item <Esc>
" Adjoin next item
nnoremap <Delete> gJi<C-o>dW<C-o>dW <Esc>

" Bold - italics word under cursor or selected
vnoremap <M-b> di\textbi{}<Esc>P
nnoremap <M-b> diwi\textbi{}<Esc>P

" Bold word under cursor or selected
vnoremap <M-B> di\textbf{}<Esc>P
nnoremap <M-B> diwi\textbf{}<Esc>P

" Put the word inside chem environment
nnoremap <M-v> diwi\ch{}<Esc>P
vnoremap <M-v> di\ch{}<Esc>P

" Append period or comma to selected lines
vnoremap np :norm A.<CR>
vnoremap nc :norm A,<CR>
