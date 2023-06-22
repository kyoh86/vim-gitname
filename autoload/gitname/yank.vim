function gitname#yank#git_rel() abort
  call setreg("+", gitname#git_rel())
endfunction

function gitname#yank#hub_url(reftype, ranges) range abort
  let l:range = get(a:ranges, "range", 0)
  if l:range == 0
    call setreg("+", gitname#hub_url(a:reftype))
  elseif l:range == 1
    call setreg("+", gitname#hub_url(a:reftype) .. "#L" .. get(a:ranges, "line1", line(".")))
  elseif l:range == 2
    call setreg("+", gitname#hub_url(a:reftype) .. "#L" .. get(a:ranges, "line1", a:firstline) .. "-L" .. get(a:ranges, "line2", a:lastline))
  endif
endfunction
