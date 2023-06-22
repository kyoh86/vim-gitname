function s:shell(...)
  " NOTE: this function cannot process multi-line output
  return trim(system(join(map(copy(a:000), {_, a -> shellescape(a)}), " ")))
endfunction

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

function bufref#git_rel_of(filename) abort
  let l:prefix = s:shell("git", "-C", fnamemodify(a:filename, ":p:h"), "rev-parse", "--show-prefix")
  return l:prefix .. fnamemodify(a:filename, ":t")
endfunction

function bufref#git_rel() abort
  return bufref#git_rel_of(expand("%"))
endfunction

function bufref#git_hub_url(reftype) abort
  return bufref#git_hub_url_of(a:reftype, expand("%"))
endfunction

function bufref#git_hub_url_of(reftype, filename) abort
  let l:dir = fnamemodify(a:filename, ":p:h")
  if a:reftype ==# "branch"
    let l:ref = s:shell("git", "-C", l:dir, "rev-parse", "--abbrev-ref", "HEAD")
  elseif a:reftype ==# "commit"
    let l:ref = s:shell("git", "-C", l:dir, "rev-list", "-1", "HEAD", "--", a:filename)
  elseif a:reftype ==# "head"
    let l:ref = s:shell("git", "-C", l:dir, "rev-parse", "HEAD")
  else
    echoerr "Invalid reftype: " .. a:reftype
  endif

  let l:remote = s:shell("git", "-C", l:dir, "ls-remote", "--get-url", "origin")
  let l:remote_url = s:remote_url(l:remote)
  if l:remote_url == v:null
    echoerr "Unsupported remote: " .. l:remote
  endif

  return l:remote_url .. "/blob/" .. l:ref .. "/" .. bufref#git_rel()
endfunction
