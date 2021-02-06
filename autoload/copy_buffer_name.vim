function! copy_buffer_name#copy(modifiers)
  call setreg('+', expand(join(['%'] + a:modifiers, ':')))
endfunction
