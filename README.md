`checkbashisms.vim` is a Vim compiler script that checks a shell (sh) script
for common BASH-specific incompatibilities.

Before using this script, you must have the `checkbashisms` binary installed.
`checkbashisms` is part of the [`devscripts`][devscripts] package, originally
written for [Debian][debian] but is available for many other distros.

To install, place the `checkbashisms.vim` file in the `~/.vim/compiler`
directory.

To automatically set the compiler for sh scripts, put the command in your
`~/.vimrc`:

```viml
if executable("checkbashisms")
    autocmd FileType sh compiler checkbashisms
endif
```

You can use the `:Checkbashisms` command to inspect your shell script.  By
default, a quickfix cwindow will be opened.  To disable, put in your
`~/.vimrc`:

```viml
let g:checkbashisms_cwindow = 0
```

To automatically check on write, you can specify

```viml
let g:checkbashisms_onwrite = 1
```

Check-on-write is disabled by default.

This software is inspired by the [Pylint plugin for Vim][pylintvim], and
incorporates ideas from the [`syntastic`][syntastic] plugin.


[devscripts]: https://packages.debian.org/wheezy/devscripts "devscripts"
[debian]: https://www.debian.org/ "Debian GNU/Linux"
[syntastic]: http://www.vim.org/scripts/script.php?script_id=2736 "syntastic"
[pylintvim]: https://github.com/congma/pylint.vim "Pylint plugin for Vim"
