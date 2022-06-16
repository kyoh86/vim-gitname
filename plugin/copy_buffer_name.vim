command! CopyBufferName call copy_buffer_name#copy(copy_buffer_name#get_name([]))
command! CopyBufferFullName call copy_buffer_name#copy(copy_buffer_name#get_name(['p']))
command! CopyBufferGithub call copy_buffer_name#copy(copy_buffer_name#get_github())

nnoremap <Plug>(copy-buffer-name) :<C-u>CopyBufferName<CR>
nnoremap <Plug>(copy-buffer-full-name) :<C-u>CopyBufferFullName<CR>
nnoremap <Plug>(copy-buffer-github) :<C-u>CopyBufferGithub<CR>
