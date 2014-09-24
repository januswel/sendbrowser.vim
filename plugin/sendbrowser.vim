" vim plugin file
" Filename:     sendbrowser.vim
" Maintainer:   janus_wel <janus.wel.3@gmail.com>
" Dependency: {{{1
"   This plugin requires following files
"
"   - https://github.com/januswel/jwlib.git
"       - autoload/jwlib/shell.vim
"       - autoload/jwlib/os.vim
" License:      MIT License {{{1
"   See under URL.  Note that redistribution is permitted with LICENSE.
"   https://github.com/januswel/sendbrowser.vim/blob/master/LICENSE

" preparations {{{1
" check if this plugin is already loaded or not
if exists('loaded_sendbrowser')
    finish
endif
let loaded_sendbrowser = 1

" check vim has required features
"if !(has('win32') && has('multi_byte'))
if !has('multi_byte')
    finish
endif

" reset the value of 'cpoptions' for portability
let s:save_cpoptions = &cpoptions
set cpoptions&vim

" main {{{1
" commands {{{2
if exists(':SendBrowser') != 2
    command -nargs=0 -range=% SendBrowser
                \ <line1>,<line2>call s:SendBrowser()
endif

" mappings {{{2
if !(exists('no_plugin_maps') && no_plugin_maps)
    \ && !(exists('no_sendbrowser_maps') && no_sendbrowser_maps)

    if !hasmapto('<Plug>SendBrowser', 'n')
        nmap <unique><Leader>vh <Plug>SendBrowser
    endif
endif
nnoremap <silent><Plug>SendBrowser
            \ :%call <SID>SendBrowser()<CR>

" functions {{{2
function! s:SendBrowser() range
    " assertion
    if exists(':TOhtml') != 2
        throw 'command ":TOhtml" is required'
    endif

    " generate html
    execute printf('%d,%dTOhtml', a:firstline, a:lastline)

    " when generating html is succeeded, current window will be the one
    " that has generated html.
    if &filetype =~? 'html'
        " change file path and write it
        let tempfile = tempname() . '.html'
        silent execute 'saveas!' tempfile

        " browse html with default http user agent
        let path = jwlib#shell#ShellFriendly(tempfile)
        call jwlib#os#Launch(path)

        " delete the buffer and comb out it from the buffer list
        bdelete
    endif
endfunction

" post-processings {{{1
" restore the value of 'cpoptions'
let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions

" }}}1
" vim: ts=4 sw=4 sts=0 et fdm=marker fdc=3
