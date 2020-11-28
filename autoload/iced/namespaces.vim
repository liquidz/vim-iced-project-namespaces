let s:save_cpo = &cpo
set cpo&vim

function! s:open(mode, ns_name) abort
  let path = ''
  let kondo = iced#system#get('clj_kondo')

  if kondo.is_analyzed()
    let path = kondo.ns_path(a:ns_name)
  else
    let resp = iced#promise#sync('iced#nrepl#op#cider#ns_path', [a:ns_name])
    if !has_key(resp, 'path') || empty(resp['path']) || !filereadable(resp['path'])
      return iced#message#error('not_found')
    endif
    let path = resp['path']
  endif

  let cmd = ':edit'
  if a:mode ==# 'v'
    let cmd = ':split'
  elseif a:mode ==# 't'
    let cmd = ':tabedit'
  endif
  exe printf('%s %s', cmd, path)
endfunction

function! s:select(resp) abort
  if !has_key(a:resp, 'value') | return iced#message#error('not_found') | endif
  call iced#selector({'candidates': a:resp['value'], 'accept': funcref('s:open')})
endfunction

function! iced#namespaces#list() abort
  let kondo = iced#system#get('clj_kondo')

  call iced#message#info('fetching')
  if kondo.is_analyzed()
    call s:select({'value': kondo.ns_list()})
  else
    return iced#promise#call('iced#nrepl#eval', ['(require ''iced.alias.orchard.namespace)'])
         \.then({_ -> iced#eval_and_read('(->> (iced.alias.orchard.namespace/project-namespaces) sort distinct (map str))', funcref('s:select'))})
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
