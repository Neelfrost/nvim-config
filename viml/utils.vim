" Sort lines based on length
function! SortLines() range
    execute a:firstline . ',' . a:lastline
                \   . 's/^\(.*\)$/\=strdisplaywidth( submatch(0) ) . " " . submatch(0)/'
    execute a:firstline . ',' . a:lastline . 'sort n'
    execute a:firstline . ',' . a:lastline . 's/^\d\+\s//'
    redraw!
endfunction
command! -range Sort <line1>,<line2>call SortLines()
