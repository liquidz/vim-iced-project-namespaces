if exists('g:loaded_iced_project_namespaces')
  finish
endif
let g:loaded_iced_project_namespaces = 1

if !exists('g:vim_iced_version')
      \ || g:vim_iced_version < 20600
  echoe 'iced-project-namespaces requires vim-iced v2.5.2 or later.'
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

command! IcedBrowseNamespace call iced#namespaces#list()

let &cpo = s:save_cpo
unlet s:save_cpo

