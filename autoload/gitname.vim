function s:remote_url(remote)
  let l:cases = [
        \ ['^git@\(.*github\.com\):\(.\{-\}\)\(\.git\)\?$', {m -> "https://" .. m[1] .. '/' .. m[2]}],
        \ ['^ssh://git@\(.*github\.com/.\{-\}\)\(\.git\)\?$', {m -> "https://" .. m[1]}],
        \ ['^https://\(.*@\)\?\(.*github\.com/.\{-\}\)\(\.git\)\?$', {m -> "https://" .. m[2]}],
      \ ]

  for [l:pat, l:Rep] in l:cases
    let l:matches = matchlist(a:remote, l:pat)
    if len(l:matches) != 0
      return l:Rep(l:matches)
    endif
  endfor

  return v:null
endfunction

function gitname#git_rel_of(filename) abort
  let [_, _, l:rel] = gitname#_git#root(a:filename)
  return l:rel
endfunction

function gitname#git_rel() abort
  return gitname#git_rel_of(expand("%"))
endfunction

function gitname#hub_url(reftype) abort
  return gitname#hub_url_of(a:reftype, expand("%"))
endfunction

function gitname#hub_url_of(reftype, filename) abort
  let [_, l:gitdir, _] = gitname#_git#root(a:filename)
  let l:dir = fnamemodify(a:filename, ":p:h")
  if a:reftype ==# "branch"
    let [l:type, l:ref] = gitname#_git#parse_head_ref(l:gitdir)
    if l:type !=# "heads"
      throw "invalid status: current HEAD is not attached for a branch"
    endif
  elseif a:reftype ==# "head"
    let l:ref = gitname#_git#parse_head_commit(l:gitdir)
    if l:ref ==# ""
      throw "invalid status: current directory does NOT have git HEAD"
    endif
  else
    throw "Invalid reftype: " .. a:reftype
  endif

  let l:remote = get(get(gitname#_git#parse_config(l:gitdir), 'remote "origin"', {}), 'url', v:null)
  if l:remote == v:null
    throw 'Failed to find remote "origin" url'
  endif
  let l:remote_url = s:remote_url(l:remote)
  if l:remote_url == v:null
    throw "Unsupported remote: " .. l:remote
  endif

  return l:remote_url .. "/blob/" .. l:ref .. "/" .. gitname#git_rel()
endfunction
