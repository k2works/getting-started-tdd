if !exists('g:test#fsharp#patterns')
  let g:test#fsharp#patterns = {
        \ 'test': [
        \   '\v^\s*let ``(.+)``\s*\(',
        \   '\v^\s*let ([[:alnum:]_'']+)\s*\(',
        \ ],
        \ 'namespace': [
        \   '\v^\s*module ([[:alnum:]_\.]+)',
        \   '\v^\s*namespace ([[:alnum:]_\.]+)',
        \ ],
        \}
endif

function! test#fsharp#get_project_path(file) abort
  let l:directory = fnamemodify(a:file, ':p:h')

  while !empty(l:directory)
    let l:project_files = filter(split(globpath(l:directory, '*.fsproj'), '\n'), '!empty(v:val)')
    if !empty(l:project_files)
      return l:project_files[0]
    endif

    let l:parent = fnamemodify(l:directory, ':h')
    if l:parent ==# l:directory
      break
    endif
    let l:directory = l:parent
  endwhile

  return ''
endfunction
