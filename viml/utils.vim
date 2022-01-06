" Custom fold text
function! CustomFoldText() abort
    let right_padding = exists('g:GuiLoaded') ? 7 : 10
    let line = getline(v:foldstart)
    let cmt_str = substitute(&commentstring, '\s*%s$', '', 'g')
    " remove comment string
    let line_text = substitute(line, cmt_str, '', 'g')
    " remove \{\{\{
    let line_text = substitute(line_text, '{\{2,}', '', 'g')
    " remove '-'
    let line_text = substitute(line_text, '-\{2,}', '', 'g')
    " remove ' '
    let line_text = substitute(line_text, '\s\+', ' ', 'g')
    let line_count = 0.65 * winwidth(0) > len(line_text)
                \   ? printf('%d lines ⋯', v:foldend - v:foldstart + 1)
                \   : ' ⋯'
    return '   ⋯ ' . line_text
                \   . repeat(' ', winwidth(0) - len(line_count) - len(line_text) - 5 - right_padding)
                \   . line_count
endfunction

" Sort lines based on length
function! SortLines() range
    execute a:firstline . ',' . a:lastline
                \   . 's/^\(.*\)$/\=strdisplaywidth( submatch(0) ) . " " . submatch(0)/'
    execute a:firstline . ',' . a:lastline . 'sort n'
    execute a:firstline . ',' . a:lastline . 's/^\d\+\s//'
    redraw!
endfunction
command! -range Sort <line1>,<line2>call SortLines()
