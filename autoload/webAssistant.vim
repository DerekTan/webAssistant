let s:spaces = '                                                                   '

function! s:Strip(input_string)
    return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! g:webAssistant#GenCommonCommandSet()
    let l:e_line = input('The end line to collect eventType & value:')
    echo "\n"

    let l:d_line = line('.')
    let l:s_line = l:d_line + 1
    if match(getline(l:d_line), 'elementId') >= 0
        " collect data
        let l:name = ''
        let l:value = ''
        let l:name_value = {}
        for ln in range(s_line, e_line)
            let l:line_str = getline(ln)
            if match(l:line_str, 'elementId') >= 0
                " elementId: 'Home_TareWeight',
                let l:value = matchstr(l:line_str, '''.*''')
                " echom l:value
            elseif match(l:line_str, 'eventType') >= 0
                " eventType: 'SE_Web',
                let l:name = matchstr(l:line_str, '''.*''')
                " echom l:name
                if strlen(l:value) > 0
                    let l:name_value[l:name] = l:value  " add name:value to dict
                    let l:value = ''                         " clear name
                endif
"            elseif match(l:line_str, 'this.elementMap.get(.*).value') >= 0
"                let l:value = matchstr(l:line_str, 'this.elementMap.get(.*).value')
"                " echom l:value
"                if strlen(l:name) > 0
"                    let l:name_value[l:name] = l:value  " add name:value to dict
"                    let l:name = ''                         " clear name
"                endif
            else
            endif
        endfor

        " insert data
        if len(l:name_value) > 0
            let l:inum = indent('.')
            if l:inum > 0
                let l:prefix_spaces = s:spaces[:l:inum-1]
            else
                let l:prefix_spaces = ''
            endif
            let l:i = 0
            " insert head
            call append(l:d_line+l:i, l:prefix_spaces         . 'elementAction: [')
            let l:i = l:i + 1
            call append(l:d_line+l:i, l:prefix_spaces.s:spaces[:&ts-1]   . '{')
            let l:i = l:i + 1
            call append(l:d_line+l:i, l:prefix_spaces.s:spaces[:&ts*2-1] . 'eventType: ''click'',')
            let l:i = l:i + 1
            call append(l:d_line+l:i, l:prefix_spaces.s:spaces[:&ts*2-1] . 'eventHandler: function (e)')
            let l:i = l:i + 1
            call append(l:d_line+l:i, l:prefix_spaces.s:spaces[:&ts*2-1] . '{')
            let l:i = l:i + 1
            "call append(l:d_line+l:i, l:prefix_spaces.s:spaces[:&ts*3-1] . 'console.log(val);')
            "let l:i = l:i + 1
            call append(l:d_line+l:i, l:prefix_spaces.s:spaces[:&ts*3-1] . 'EventService.dispatchProcessEvent(''Common Command Set'',')
            let l:i = l:i + 1
            call append(l:d_line+l:i, l:prefix_spaces.s:spaces[:&ts*4-1] . '{')
            let l:i = l:i + 1
            call append(l:d_line+l:i, l:prefix_spaces.s:spaces[:&ts*5-1] . 'detail: {')
            let l:i = l:i + 1
            " insert collected data
            for [key, value] in items(l:name_value)
                call append(l:d_line+l:i, l:prefix_spaces.s:spaces[:&ts*6-1].key.' : $('.value.').value,')
                let l:i = l:i + 1
            endfor
            "insert tail
            call append(l:d_line+l:i, l:prefix_spaces.s:spaces[:&ts*5-1] . '},')
            let l:i = l:i + 1
            call append(l:d_line+l:i, l:prefix_spaces.s:spaces[:&ts*4-1] . '});')
            let l:i = l:i + 1
            call append(l:d_line+l:i, l:prefix_spaces.s:spaces[:&ts*2-1] . '},')
            let l:i = l:i + 1
            call append(l:d_line+l:i, l:prefix_spaces.s:spaces[:&ts-1] . '},')
            let l:i = l:i + 1
            call append(l:d_line+l:i, l:prefix_spaces       . '],')
            let l:i = l:i + 1
            echom l:i . ' lines generated'
        endif
    endif
endfunction

"--------------------------------------------------------------------------------------------------
"  g:webAssistant#GenStatusAction
"--------------------------------------------------------------------------------------------------
"! \brief  First select 'elementId, eventType', then call this function to generate status actions
"--------------------------------------------------------------------------------------------------
function! g:webAssistant#GenStatusAction(ln)
    " echom a:ln
    let l:i = 0
    let l:s_line = line('.')
    let l:d_line = line('.') + a:ln - 1
    for relative_i in range(a:ln)
        " get data from each line
        let l:line_str = getline(l:s_line + relative_i)
        let l:a = split(l:line_str, ',')
        let l:web_id = s:Strip(l:a[0])
        if match(l:web_id, '^''.*''$') < 0
            let l:web_id = "'".l:web_id."'"
        endif
        let l:json_id = s:Strip(l:a[1])
        if match(l:json_id, '^''.*''$') < 0
            let l:json_id = "'".l:json_id."'"
        endif

        " insert data
        call append(l:d_line+l:i, '{')
        let l:i = l:i + 1
        call append(l:d_line+l:i, s:spaces[:&ts-1] . 'elementId: '.l:web_id.',')
        let l:i = l:i + 1
        call append(l:d_line+l:i, s:spaces[:&ts*2-1] . 'statusAction: [')
        let l:i = l:i + 1
        call append(l:d_line+l:i, s:spaces[:&ts*3-1] . '{')
        let l:i = l:i + 1
        call append(l:d_line+l:i, s:spaces[:&ts*4-1] . 'eventType: '.l:json_id.',')
        let l:i = l:i + 1
"        call append(l:d_line+l:i, s:spaces[:&ts*4-1] . 'eventHandler: function (detail) {')
"        let l:i = l:i + 1
"        call append(l:d_line+l:i, s:spaces[:&ts*5-1] . 'this.elementMap.get('.l:web_id.').value = detail;')
"        let l:i = l:i + 1
"        call append(l:d_line+l:i, s:spaces[:&ts*4-1] . '},')
"        let l:i = l:i + 1
        call append(l:d_line+l:i, s:spaces[:&ts*3-1] . '},')
        let l:i = l:i + 1
        call append(l:d_line+l:i, s:spaces[:&ts*2-1] . '],')
        let l:i = l:i + 1
        call append(l:d_line+l:i, '},')
        let l:i = l:i + 1
    endfor

    " remove lines
    call cursor(l:s_line, 0)
    silent execute 'norm! '.a:ln.'dd'
endfunction

"--------------------------------------------------------------------------------------------------
"  g:webAssistant#GenOption
"--------------------------------------------------------------------------------------------------
"! \brief  First select 'value - dispStr', then call this function to generate options
"--------------------------------------------------------------------------------------------------
function! g:webAssistant#GenOption(ln)
    let l:i = 0
    let l:s_line = line('.')
    let l:e_line = line('.') + a:ln - 1

    silent execute l:s_line.','.l:e_line.'s/^\s*\(\S\{-}\)\s\{-}-\s*\(.*\)\s*$/<option value="\1">\2<\/option>/g'
    call cursor(l:s_line, 0)
    silent execute 'norm! '.a:ln.'=='
    let l:suffix = a:ln>1?'s':''
    echom a:ln.' line'.l:suffix.' modified'

"    for relative_i in range(a:ln)
"
"        " get data from each line
"        let l:line_str = getline(l:s_line + relative_i)
"        let l:a = split(l:line_str, '-')
"        let l:value = s:Strip(l:a[0])
"        let l:disp_str = s:Strip(l:a[1])
"
"        " insert data
"        call append(l:d_line+l:i, '<option value="'.l:value.'">'.l:disp_str.'</option>')
"        let l:i = l:i + 1
"
"    endfor
"
"    " remove lines
"    execute 'norm! '.a:ln.'dd'

endfunction

"--------------------------------------------------------------------------------------------------
"  g:webAssistant#CollectID
"--------------------------------------------------------------------------------------------------
"! \brief  First select 'value - dispStr', then call this function to generate options
"--------------------------------------------------------------------------------------------------
function! g:webAssistant#CollectID(ln)
    let l:save_cursor = getpos('.')
    let l:i = 0
    let l:s_line = line('.')

"    silent execute l:s_line.','.l:e_line.'s/^\s*\(\S\{-}\)\s\{-}-\s*\(.*\)\s*$/<option value="\1">\2<\/option>/g'
"    call cursor(l:s_line, 0)
"    silent execute 'norm! '.a:ln.'=='
"    let l:suffix = a:ln>1?'s':''
"    echom a:ln.' line'.l:suffix.' modified'

    " collect ids to an array
    let l:ids = []
    for relative_i in range(a:ln)
        " get data from each line
        let l:line_str = getline(l:s_line + relative_i)
        if match(l:line_str, '\<\(id\|ID\)\>') >= 0
            let l:id_str = substitute(l:line_str, '^.\{-}\<\%(id\|ID\)\>\s*=\s*\([''"]\)\(.\{-}\)\1.*$', '\2', '')
            " insert data
            call add(l:ids, l:id_str)
            let l:i = l:i + 1
        endif
    endfor

    " copy ids to an register, here we use default copy register @"
    let @" = join(l:ids, "\n")

    " Restore cursor position
    call setpos('.', l:save_cursor)

    " 
    let l:suffix = l:i>1?'s':''
    echom l:i.' ID'.l:suffix.' copied'

endfunction
