function gitname#_git#root(path)
  let l:start = fnamemodify(a:path, ":p")
  let l:path = l:start
  while v:true
    let l:next = fnamemodify(l:path, ":h")
    if l:next ==# l:path
      return []
    endif
    let l:path = l:next
    let l:gitdir_candidate = l:path .. "/.git"
    if filereadable(l:gitdir_candidate) 
      for l:line in readfile(l:gitdir_candidate, "", 1)
        let l:gitdir = matchstr(l:line, '^gitdir:\s*\zs.*\ze$')
        if l:gitdir !=# ""
          return [l:path, l:gitdir, l:start[len(l:path)+1:]]
        endif
      endfor
    elseif isdirectory(l:gitdir_candidate)
      return [l:path, l:gitdir_candidate, l:start[len(l:path)+1:]]
    endif
  endwhile
  return []
endfunction

function gitname#_git#parse_head_commit(gitdir)
  for l:ref in readfile(a:gitdir .. "/HEAD", "", 1)
    let l:name = matchstr(l:ref, '^\mref:\s*\zsrefs/[^/]\+/[^/]\+\ze$')
    if l:name !=# ""
      for l:commit in readfile(a:gitdir .. "/" .. l:name, "", 1)
        if l:commit !=# ""
          return l:commit
        endif
      endfor
    endif
  endfor
  return ""
endfunction

function gitname#_git#parse_head_ref(gitdir)
  for l:line in readfile(a:gitdir .. "/HEAD", "", 1)
      let l:name = matchstr(l:line, '^\mref:\s*refs/\zs[^/]\+/[^/]\+\ze$')
      if l:name !=# ""
        return split(l:name, '/')
      endif
  endfor
  return []
endfunction

function gitname#_git#parse_config(gitdir)
  let l:lines = readfile(a:gitdir .. "/config")
  let l:sections = {}
  let l:currentSection = ""

  for l:line in l:lines
    if l:line =~ '^\s*\[.*\]\s*$'
      let l:currentSection = matchstr(l:line, '\[\zs.*\ze\]')
      let l:sections[l:currentSection] = {}
    elseif l:line =~ '^\s*[^#;]\+\s*=\s*.\+'
      let l:key = matchstr(l:line, '^\s*\zs[^#;]\+\ze\s*=\s*.\+')
      let l:value = matchstr(l:line, '^\s*[^#;]\+\s*=\s*\zs.\+\ze')
      let l:sections[l:currentSection][l:key] = l:value
    endif
  endfor

  return l:sections
endfunction
