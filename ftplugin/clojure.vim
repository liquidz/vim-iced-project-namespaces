if exists('g:loaded_iced_project_namespaces')
  finish
endif
let g:loaded_iced_project_namespaces = 1

let s:save_cpo = &cpo
set cpo&vim

command! IcedBrowseNamespace call iced#namespaces#list()

let &cpo = s:save_cpo
unlet s:save_cpo

