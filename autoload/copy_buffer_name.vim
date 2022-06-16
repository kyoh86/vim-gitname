function! copy_buffer_name#copy(text)
  call setreg('+', a:text)
endfunction

function! copy_buffer_name#get_name(modifiers)
  return expand(join(['%'] + a:modifiers, ':'))
endfunction

function! copy_buffer_name#get_github()
  return trim(system('gh browse --no-browser ' .. expand('%')))
endfunction
