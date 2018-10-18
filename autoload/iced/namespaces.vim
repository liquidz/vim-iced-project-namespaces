let s:save_cpo = &cpo
set cpo&vim

function! s:open(mode, ns_name) abort
  let resp = iced#nrepl#op#cider#sync#ns_path(a:ns_name)
  if !has_key(resp, 'path') || empty(resp['path']) || !filereadable(resp['path'])
    return iced#message#error('not_found')
  endif

  let cmd = ':edit'
  if a:mode ==# 'v'
    let cmd = ':split'
  elseif a:mode ==# 't'
    let cmd = ':tabedit'
  endif
  exe printf('%s %s', cmd, resp['path'])
endfunction

function! s:select(resp) abort
  if !has_key(a:resp, 'value') | return iced#message#error('not_found') | endif
  call iced#selector({'candidates': a:resp['value'], 'accept': funcref('s:open')})
endfunction

function! iced#namespaces#list() abort
  call iced#message#info('fetching')
  let code = '(do' .
        \ '(require ''orchard.namespace)' .
        \ '(->> (orchard.namespace/project-namespaces) sort distinct (map str))' .
        \ ')'
  call iced#eval_and_read(code, funcref('s:select'))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
