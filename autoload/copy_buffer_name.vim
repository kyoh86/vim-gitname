function! copy_buffer_name#copy(modifiers)
  setreg('+', expand(join(['%'] + a:modifiers, ':')))
endfunction
