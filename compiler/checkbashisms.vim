" Vim Compiler File for shell (sh) scripts
" Compiler:     checkbashisms
" Maintainer:   Cong Ma <cma@pmo.ac.cn>
" Last Change:  2014-10-19
" Documentation:
"     Before using this script, you must have the "checkbashisms" binary
"     installed.  "checkbashisms: is part of the "devscripts" package,
"     originally written for Debian but is available for many other distros:
"     https://packages.debian.org/wheezy/devscripts
"
"     To install, place the checkbashisms.vim in the ~/.vim/compiler
"     directory.
"
"     To automatically set the compiler for sh scripts, put the command in
"     your ~/.vimrc:
"
"         if executable("checkbashisms")
"             autocmd FileType sh compiler checkbashisms
"         endif
"
"     You can use the ":Checkbashisms" command to inspect your shell script.
"     By default, a quickfix cwindow will be opened.  To disable, put in your
"     ~/.vimrc:
"
"         let g:checkbashisms_cwindow = 0
"
"     To automatically check on write, you can 
"
"         let g:checkbashisms_onwrite = 1
"
"     Check-on-write is disabled by default.

if exists("current_compiler")
    finish
endif
let current_compiler = "checkbashisms"

if exists(":CompilerSet") != 2          " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

" Check on write - default: disabled
if !exists('g:checkbashisms_onwrite')
    let g:checkbashisms_onwrite = 0
endif

" Automatic opening of quickfix cwindow - default: enabled
if !exists('g:checkbashisms_cwindow')
    let g:checkbashisms_cwindow = 1
endif

if exists(':Checkbashisms') != 2
    command Checkbashisms :call Checkbashisms(0)
endif

CompilerSet makeprg=checkbashisms\ -fnp\ '%'
CompilerSet errorformat=%Wpossible\ bashism\ in\ %f\ line\ %l\ (%m):,%C%.%#,%Z.%#

" The following are adapted from the pylint compiler plugin
if !exists("*s:Checkbashisms")
function! Checkbashisms(writing)
    setlocal sp=>%s\ 2>&1

    " If check is executed by buffer write - do not jump to first error
    if !a:writing
        silent make
    else
        silent make!
    endif

    if g:checkbashisms_cwindow
        cwindow
    endif

    redraw!

endfunction
endif

" keep track of whether or not we are showing a message
let b:showing_message = 0

" WideMsg() prints [long] message up to (&columns-1) length
" guaranteed without "Press Enter" prompt.
if !exists("*s:WideMsg")
    function s:WideMsg(msg)
        let x=&ruler | let y=&showcmd
        set noruler noshowcmd
        redraw
        echo a:msg
        let &ruler=x | let &showcmd=y
    endfun
endif

if !exists('*s:GetCheckbashismsMessage')
function s:GetCheckbashismsMessage()
    let l:cursorPos = getpos(".")

    " Bail if Checkbashisms hasn't been called yet.
    if !exists('b:matchedlines')
        return
    endif
    " if there's a message for the line the cursor is currently on, echo
    " it to the console
    if has_key(b:matchedlines, l:cursorPos[1])
        let l:checkbashismsMatch = get(b:matchedlines, l:cursorPos[1])
        call s:WideMsg(l:checkbashismsMatch['message'])
        let b:showing_message = 1
        return
    endif
	" otherwise, if we're showing a message, clear it
    if b:showing_message == 1
        echo
        let b:showing_message = 0
    endif
endfunction
endif

let &cpo = s:cpo_save
unlet s:cpo_save
