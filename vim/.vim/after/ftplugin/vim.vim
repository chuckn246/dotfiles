setlocal fileformat=unix
setlocal foldmethod=indent
setlocal autoindent
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2

" Comments starts with # in Vim9 script.  We have to guess which one to use.
if "\n" .. getline(1, 10)->join("\n") =~# '\n\s*vim9\%[script]\>'
  setlocal commentstring=#\ %s
else
  setlocal commentstring=\"\ %s
endif

" vim: ft=vim ts=2 sts=2 sw=2 nosr et
