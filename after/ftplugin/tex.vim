" ---------------------------------- Options --------------------------------- "

setlocal spell
setlocal linebreak
setlocal wrap
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal noexpandtab
setlocal foldmethod=manual
setlocal foldexpr=vimtex#fold#level(v:lnum)
setlocal foldtext=CustomFoldText()

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

function! MiscFixes()
    let l:save = winsaveview()
    " Replace \ with / in LaTeX input fields
    keeppatterns %s/\(input\|include\)\({.\+\)\\\(.\+}\)/\1\2\/\3/ge
    " do not remove trailing space after LaTeX \item
    keeppatterns %s/\\item$/\\item /e
    " do not remove trailing space after LaTeX \task
    keeppatterns %s/\\task$/\\task /e
    " remove duplicate '\items' on sameline
    keeppatterns %s/^\s*\\item\s*\\item/\\item/e
    " '\item\something' -> '\item \something'
    keeppatterns %s/\\item\\/\\item \\/e
    " '%\label{fig:main_label}%' -> ''
    keeppatterns %s/^\s\+%\\label{fig:main_label}%\n//e
    call winrestview(l:save)
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
                ".bak",
                "indent",
                "output",
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
    " Fix inputs
    autocmd BufWritePre *.tex :call MiscFixes()
    " Clean up auxiliary files on quit
    autocmd User VimtexEventQuit :silent! VimtexStopAll
    autocmd User VimtexEventQuit :silent! call CleanAuxFiles()
augroup END

" --------------------------------- Mappings --------------------------------- "

" Override VimtexClean
nnoremap <silent><buffer> <Leader>lc :call CleanAuxFiles()<CR>

" Auto \item, \task
inoremap <buffer><expr> <CR> GetLine()
            \ ? '<C-w><C-w>'
            \ : (col('.') < col('$') ? '<CR>' : '<CR>' . AutoItem())
nnoremap <buffer><expr> o 'o' . AutoItem()
nnoremap <buffer><expr> O 'O' . AutoItem()

" Insert \item, \task on Numpad Enter
imap <buffer> <kEnter> <C-o>o

" Push to next item of the list
nnoremap <buffer> <Insert> i<CR>\item <Esc>
" Adjoin next item
nnoremap <buffer> <Delete> gJi<C-o>dW<C-o>dW <Esc>

" Bold - italics word under cursor or selected
nmap <buffer> <M-B> <Plug>Ysurroundiw}i\textbi<Esc>
xmap <buffer> <M-B> <Plug>VSurround}i\textbi<Esc>

" Bold word under cursor or selected
nmap <buffer> <M-b> <Plug>Ysurroundiw}i\textbf<Esc>
xmap <buffer> <M-b> <Plug>VSurround}i\textbf<Esc>

" Underline word under cursor or selected
nmap <buffer> <M-f> <Plug>Ysurroundiw}i\ul<Esc>
xmap <buffer> <M-f> <Plug>VSurround}i\ul<Esc>
nmap <buffer> <M-F> <Plug>Ysurroundiw}i\underline<Esc>
xmap <buffer> <M-F> <Plug>VSurround}i\underline<Esc>

" Put the word inside chem environment
nmap <buffer> <M-v> <Plug>Ysurroundiw}i\ch<Esc>
xmap <buffer> <M-v> <Plug>VSurround}i\ch<Esc>

" Put the word inside math environment
nmap <buffer> <M-m> <Plug>Ysurroundiw$
xmap <buffer> <M-m> <Plug>VSurround$

" Append period or comma to selected lines
vnoremap <buffer> np :norm A.<CR>
vnoremap <buffer> nc :norm A,<CR>

nmap <buffer> <C-t> gui}gzi}
