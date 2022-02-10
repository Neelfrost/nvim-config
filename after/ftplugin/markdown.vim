setlocal spell
setlocal linebreak
setlocal wrap
setlocal conceallevel=2
setlocal foldexpr=

" Bold word under cursor or selected
nmap <buffer> <M-b> <Plug>Ysurroundiw*<Plug>YsurroundW*
xmap <buffer> <M-b> <Plug>VSurround*gv<Plug>VSurround*
" Italics word under cursor or selected
nmap <buffer> <M-i> <Plug>Ysurroundiw_
xmap <buffer> <M-i> <Plug>VSurround_
