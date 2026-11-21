" Smoke tests for the generated Vim colorschemes. Run from repo root:
"   vim -N -u NONE -i NONE -es -S tests/run.vim
set nocompatible
let &runtimepath = getcwd() . ',' . &runtimepath

let s:failures = 0
function! s:check(name, cond) abort
  if a:cond
    call writefile(['ok   ' . a:name], '/dev/stdout', 'a')
  else
    let s:failures += 1
    call writefile(['FAIL ' . a:name], '/dev/stdout', 'a')
  endif
endfunction

function! s:bg(group) abort
  return synIDattr(synIDtrans(hlID(a:group)), 'bg#')
endfunction

function! s:fg(group) abort
  return synIDattr(synIDtrans(hlID(a:group)), 'fg#')
endfunction

function! s:is(name, background, normal_bg) abort
  return get(g:, 'colors_name', '') ==# a:name && &background ==# a:background
        \ && s:bg('Normal') ==# a:normal_bg
endfunction

let s:night = '#1d1f21'
let s:day = '#ffffff'

colorscheme tanuki-night
call s:check('night loads', s:is('tanuki-night', 'dark', s:night))
call s:check('night Function blue', s:fg('Function') ==# '#81a2be')

colorscheme tanuki-day
call s:check('day loads', s:is('tanuki-day', 'light', s:day))
call s:check('day Function #990000', s:fg('Function') ==# '#990000')

colorscheme tanuki-night
call s:check('day -> night', s:is('tanuki-night', 'dark', s:night))

set background=light
call s:check('night + bg=light -> day', s:is('tanuki-day', 'light', s:day))

set background=dark
call s:check('day + bg=dark -> night', s:is('tanuki-night', 'dark', s:night))

colorscheme default
set background=light
colorscheme tanuki-night
call s:check('bg=light then :colo tanuki-night', s:is('tanuki-night', 'dark', s:night))

" Any error message while loading counts as a failure, and is printed.
call s:check('no error messages', v:errmsg ==# '')
if v:errmsg !=# ''
  call writefile(['     ' . v:errmsg] + split(execute('messages'), "\n"), '/dev/stdout', 'a')
endif

call writefile(['', s:failures . ' failure(s)'], '/dev/stdout', 'a')
" -es exits with 1 after any error message, so set the exit code explicitly.
execute 'cquit ' . (s:failures > 0 ? 1 : 0)
