function! ale_linters#vhdl#vsg_ale#GetCommand(buffer)
    return "vsg --config ./vsg_config.yaml -of syntastic -f " . expand('%p')
endfunction

function! ale_linters#vhdl#vsg_ale#Handle(buffer, lines)
    let l:pattern = '^\(\w\{-}\):\s\+\(.*\)(\(\d\+\))\(\w\+\)\s\+--\s\+\(.*\)$'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        call add(l:output, {
        \   'lnum': l:match[3],
        \   'col': 0,
        \   'text': l:match[2] . ": " . l:match[4] . " - Solution: " . l:match[5],
        \})
    endfor
    return l:output
endfunction

call ale#linter#Define('vhdl', {
\   'name': 'vsg_ale',
\   'executable': 'vsg',
\   'output_stream': 'stdout',
\   'lint_file': 0,
\   'command': function('ale_linters#vhdl#vsg_ale#GetCommand'),
\   'callback': 'ale_linters#vhdl#vsg_ale#Handle',
\})
