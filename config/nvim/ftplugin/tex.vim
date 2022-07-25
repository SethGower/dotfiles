" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif

" simple augroup for vimtex.
augroup MyVimtex
      autocmd!
        autocmd User VimtexEventQuit call system('latexmk -c') " Makes vimtex clean all log files and such when exiting vim, doesn't delete output files (pdfs)
        " autocmd BufWinEnter *.tex :VimtexCompile " compiles when a tex file is opened.
augroup END

if exists(":EasyAlign")
    map <leader>a& :EasyAlign &<CR>
endif

if exists(":Copilot")
  Copilot disable
endif

" If I am on ubuntu I am probably just using gnome, and gonna use evince
if substitute(system('lsb_release -is'), '\n', '', '') == 'Ubuntu'
  let g:vimtex_view_general_viewer = 'evince'
else
  let g:vimtex_view_general_viewer = 'zathura'
endif
let g:vimtex_compiler_progname = 'nvr'
let g:tex_flavor='latex'
let g:vimtex_quickfix_open_on_warning = 0
