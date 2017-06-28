"==============================================================
"    file: typescript.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfyzhong@qq.com
" created: 2017-06-17 08:56:21
"==============================================================

function! s:parser0(word, abbr)
    let param = a:abbr

    " remove ()
    while param =~# '\m: ([^()]*)' 
        let param = substitute(param, '\m: \zs([^()]*)', '', 'g')
    endwhile

    " remove []
    while param =~# '\m\[[^[]*\]'
        let param = substitute(param, '\m\[[^[]*\]', '', 'g')
    endwhile

    " fun      (method) A.fun()
    let pattern = printf('\m^%s\s*(method)\s*.*%s\%%(<[^()<>]*>\)\?(\([^()]*\)).*', a:word, a:word)
    let param = substitute(param, pattern, '\1', '')
    let param = substitute(param, ':[^,)]*', '', 'g')
    let param = '('.param.')'
    return [param]
endfunction

" deoplete
" {'word': 'concat', 'menu': 'TS Array<number>.concat(...i..(+1 overload)', 'info': 'Array<number>.concat(...items: number[][]): number[] (+1 overload)^@Combines two or more arrays.', 'kind': 'M', 'abbr': 'concat'}
function! s:parser1(word, info)
    let param = split(a:info, '\n')[0]
    let pattern = printf('\m^.*%s\%%(<[^()<>]>\)\?(\(.*\)', a:word)
    let param = substitute(param, pattern, '\1', '')
    let param = substitute(param, '\m([^()]*)', '', 'g')
    let param = substitute(param, '\m\[[^\[\]]*\]', '', 'g')
    let param = substitute(param, '\m).*', '', '')
    let param = substitute(param, ':[^,)]*', '', 'g')
    let param = '('.param.')'
    return [param]
endfunction

function! cm_parser#typescript#parameters(completed_item) "{{{
    let kind = get(a:completed_item, 'kind', '')
    let l:abbr = get(a:completed_item, 'abbr', '')
    let word = get(a:completed_item, 'word', '')
    let info = get(a:completed_item, 'info', '')
    if kind ==# 'm' &&  l:abbr =~# '\m^'.word.'\s*(method)'
        return <SID>parser0(word, l:abbr)
    elseif kind  ==# 'M' && info =~# '\m\<'.word.'\>\%(<[^<>()]*>\)\?('
        return <SID>parser1(word, info)
    endif
    return []
endfunction "}}}

function! cm_parser#typescript#parameter_delim() "{{{
    return ','
endfunction "}}}

function! cm_parser#typescript#parameter_begin() "{{{
    return '('
endfunction "}}}

function! cm_parser#typescript#parameter_end() "{{{
    return ')'
endfunction "}}}
