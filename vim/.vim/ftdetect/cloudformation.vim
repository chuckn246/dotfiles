autocmd BufNewFile,BufRead *.cfn.{yaml,yml} set filetype=yaml.cloudformation
autocmd BufNewFile,BufRead * if getline(1) =~ '^AWSTemplateFormatVersion:'
      \| setlocal filetype=yaml.cloudformation
      \| endif

" vim: ft=vim ts=2 sts=2 sw=2 nosr et
