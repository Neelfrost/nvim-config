" ---------------------------------- Options --------------------------------- "

setlocal spell
setlocal linebreak
setlocal wrap
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal foldmethod=expr
setlocal foldexpr=vimtex#fold#level(v:lnum)

" --------------------------------- Functions -------------------------------- "

" Auto insert \item, \task on <CR>
" https://stackoverflow.com/questions/2547739/auto-insert-text-at-a-newline-in-vim
function! AutoItem()
    let [end_lnum, end_col] = searchpairpos('\\begin{', '', '\\end{', 'nW')
    if match(getline(end_lnum), '\(itemize\|enumerate\|description\)') != -1
        return '\item '
    elseif match(getline(end_lnum), '\(tasks\)') != -1
        return '\task '
    else
        return ''
    endif
endfunction

function! GetLine()
    let list = ['\\task $', '\\item $']
    return getline('.') =~ list[0] || getline('.') =~ list[1]
endfunction

" Replace \ with / in LaTeX input fields
function! FixInputs()
    let l:save = winsaveview()
    keeppatterns %s/\(input\|include\)\({.\+\)\\\(.\+}\)/\1\2\/\3/ge
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
let l:cur_tex_path = fnamemodify(b:vimtex.tex, ':p:h')
python3 << EOF
import vim
import os
cur_tex_path = vim.eval("l:cur_tex_path")

for folder, _, files in os.walk(cur_tex_path):
    for file in files:
        if file.endswith(
            (
                ".toc",
                ".out",
                ".aux",
                ".log",
                ".nav",
                ".snm",
                ".vrb",
                ".fls",
                "indent.log",
                ".fdb_latexmk",
                "synctex(busy)",
            )
        ):
            os.remove(os.path.join(folder, file))
EOF
echo 'Auxiliary files cleaned!'
endfunction

" ------------------------------- Autocommands ------------------------------- "

augroup TEX_AUTOCOMMANDS
    autocmd!
    autocmd BufRead *.tex lua require("cmp").setup.buffer({
    \     sources = {
    \        { name = "omni" },
    \        { name = "ultisnips" },
    \        { name = "buffer" },
    \    },
    \ })
    " Fix inputs
    autocmd BufWritePre *.tex :call FixInputs()
    " Set and Restore indent
    autocmd BufEnter *.tex :call SetIndentLine()
    autocmd BufLeave * :call ResetIndentLine()
    " Clean up auxiliary files on quit
    autocmd User VimtexEventQuit :silent! VimtexStopAll
    autocmd User VimtexEventQuit :silent! call CleanAuxFiles()
augroup END

" --------------------------------- Mappings --------------------------------- "

" Override VimtexClean
nnoremap <silent> <Leader>lc :call CleanAuxFiles()<CR>

" Auto \item, \task
inoremap <expr> <CR> GetLine()
            \ ? '<C-w><C-w>'
            \ : (col('.') < col('$') ? '<CR>' : '<CR>' . AutoItem())
nnoremap <expr> o 'o' . AutoItem()
nnoremap <expr> O 'O' . AutoItem()

" Insert \item, \task on Numpad Enter
imap <kEnter> <C-o>o

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

" Underline word under cursor or selected
vnoremap <M-u> di\ul{}<Esc>P
nnoremap <M-u> diwi\ul{}<Esc>P

" Put the word inside chem environment
nnoremap <M-v> diwi\ch{}<Esc>P
vnoremap <M-v> di\ch{}<Esc>P

" Append period or comma to selected lines
vnoremap np :norm A.<CR>
vnoremap nc :norm A,<CR>
