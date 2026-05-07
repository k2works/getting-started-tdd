if !exists('g:test#fsharp#dotnettest#file_pattern')
  let g:test#fsharp#dotnettest#file_pattern = '\v\.fs$'
endif

function! test#fsharp#dotnettest#test_file(file) abort
  if fnamemodify(a:file, ':t') !~# g:test#fsharp#dotnettest#file_pattern
    return 0
  endif

  let l:project_path = test#fsharp#get_project_path(a:file)
  if empty(l:project_path) || !s:is_test_project(l:project_path)
    return 0
  endif

  return s:is_xunit_test_file(a:file)
endfunction

function! test#fsharp#dotnettest#build_position(type, position) abort
  let l:project_path = test#fsharp#get_project_path(a:position['file'])
  if empty(l:project_path)
    return []
  endif

  let l:project_arg = shellescape(l:project_path)
  let l:search_config = { 'namespaces_with_same_indent': 1 }

  if a:type ==# 'suite'
    return [l:project_arg]
  endif

  if a:type ==# 'nearest'
    let l:name = test#base#nearest_test(a:position, g:test#fsharp#patterns, l:search_config)
    let l:scope = s:scope(l:name)

    if !empty(l:scope['test'])
      return [l:project_arg, '--filter', shellescape('FullyQualifiedName=' . l:scope['qualified'])]
    elseif !empty(l:scope['namespace'])
      return [l:project_arg, '--filter', shellescape('FullyQualifiedName~' . l:scope['namespace'])]
    else
      return [l:project_arg]
    endif
  endif

  if a:type ==# 'file'
    let l:file_position = copy(a:position)
    let l:file_position['line'] = '$'
    let l:name = test#base#nearest_test(l:file_position, g:test#fsharp#patterns, l:search_config)
    let l:scope = s:scope(l:name)

    if !empty(l:scope['namespace'])
      return [l:project_arg, '--filter', shellescape('FullyQualifiedName~' . l:scope['namespace'])]
    else
      return [l:project_arg]
    endif
  endif

  return []
endfunction

function! test#fsharp#dotnettest#build_args(args) abort
  return [join(a:args, ' ')]
endfunction

function! test#fsharp#dotnettest#executable() abort
  return 'dotnet test'
endfunction

function! s:scope(name) abort
  let l:namespace = join(a:name['namespace'], '.')
  let l:test_name = join(a:name['test'], '.')
  let l:qualified_name = join(filter([l:namespace, l:test_name], '!empty(v:val)'), '.')

  return {
        \ 'namespace': l:namespace,
        \ 'test': l:test_name,
        \ 'qualified': l:qualified_name,
        \}
endfunction

function! s:is_test_project(project_path) abort
  if !filereadable(a:project_path)
    return 0
  endif

  let l:project = join(readfile(a:project_path), "\n")
  return l:project =~# '<IsTestProject>\s*true\s*</IsTestProject>'
        \ || l:project =~# '<PackageReference Include="xunit"'
endfunction

function! s:is_xunit_test_file(file) abort
  if !filereadable(a:file)
    return 0
  endif

  let l:source = join(readfile(a:file), "\n")
  return l:source =~# '\<open Xunit\>'
        \ && l:source =~# '\[<\(Fact\|Theory\)\>'
endfunction
