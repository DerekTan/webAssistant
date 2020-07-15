"let g:webAssistant#leader_key = '<C-g>'
nnoremap <Leader>wgc :call g:webAssistant#GenCommonCommandSet()<CR>
vnoremap <Leader>wgs :<C-U> call g:webAssistant#GenStatusAction( line("'>") - line("'<") +1)<CR>
vnoremap <Leader>wgo :<C-U> call g:webAssistant#GenOption( line("'>") - line("'<") +1)<CR>
nnoremap <Leader>wgo :<C-U> call g:webAssistant#GenOption(v:count1)<CR>
vnoremap <Leader>wci :<C-U> call g:webAssistant#CollectID( line("'>") - line("'<") +1)<CR>
nnoremap <Leader>wci :<C-U> call g:webAssistant#CollectID(v:count1)<CR>
"vnoremap wt  :<C-U> echo line("'>")

