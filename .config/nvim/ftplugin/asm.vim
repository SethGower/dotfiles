if exists("b:did_ftplugin")
    finish
endif

let g:ale_asm_cc_executable = "arm-none-eabi-gcc"

setlocal comments+=:;
setlocal comments+=:#
setlocal formatoptions+=cro
let g:ale_asm_gcc_executable = 'arm-none-eabi-gcc'
