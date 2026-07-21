if has_key(g:plugs, "vimwiki")
  let g:vimwiki_list = [{'path': '~/Nextcloud/Wiki/', 'syntax': 'markdown'}]
  autocmd FileType vimwiki setlocal shiftwidth=4 tabstop=4 expandtab

  command! Diary VimwikiDiaryIndex
  augroup vimwikigroup
          autocmd!
          " automatically update links on read diary
          autocmd BufRead,BufNewFile diary.wiki VimwikiDiaryGenerateLinks
  augroup end
endif

" vim: ft=vim ts=2 sts=2 sw=2 nosr et
