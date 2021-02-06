command! CopyBufferName call copy_buffer_name#copy([])
command! CopyBufferFullName call copy_buffer_name#copy(['p'])

nnoremap <Plug>(copy-buffer-name) :<C-u>CopyBufferName<CR>
nnoremap <Plug>(copy-buffer-full-name) :<C-u>CopyBufferFullName<CR>
