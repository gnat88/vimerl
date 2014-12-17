" Vim plugin file
" Language: Erlang
" Author:   Ricardo Catalinas Jiménez <jimenezrick@gmail.com>
" License:  Vim license
" Version:  2012/11/25

if exists('g:loaded_erlang_skel') || v:version < 700 || &compatible
	finish
else
	let g:loaded_erlang_skel = 1
endif

if !exists('g:erlang_skel_replace')
	let g:erlang_skel_replace = 1
endif

if !exists('g:erlang_skel_dir')
	let g:erlang_skel_dir = expand('<sfile>:p:h') . '/erlang_skels'
endif

function s:LoadSkeleton(skel_name)
	if g:erlang_skel_replace
		%delete
	else
		let current_line = line('.')
		call append(line('$'), '')
		normal G
	endif
	if exists('g:erlang_skel_header')
		execute 'read' g:erlang_skel_dir . '/' . 'header'
		for [name, value] in items(g:erlang_skel_header)
			call s:SubstituteField(name, value)
		endfor
		if !has_key(g:erlang_skel_header, 'year')
			call s:SubstituteField('year', strftime('%Y'))
    endif
    call s:SubstituteField('VERSION', strftime('%Y-%m-%d'))
		call append(line('$'), '')
		normal G
	endif
	execute 'read' g:erlang_skel_dir . '/' . a:skel_name
	call s:SubstituteField('modulename', expand('%:t:r'))
	if g:erlang_skel_replace
		normal gg
		delete
	else
		call cursor(current_line, 1)
	endif
endfunction

function s:SubstituteField(name, value)
	execute '%substitute/\$' . toupper(a:name) . '/' . a:value . '/'
endfunction

" 增加文件头
function s:LoadHeader()
  execute 'read' g:erlang_skel_dir . '/' . 'header'
		for [name, value] in items(g:erlang_skel_header)
			call s:SubstituteField(name, value)
		endfor
		if !has_key(g:erlang_skel_header, 'year')
			call s:SubstituteField('year', strftime('%Y'))
    endif
    call s:SubstituteField('VERSION', strftime('%Y-%m-%d'))
    "不知道为什么读取的文件从第二行开始，要删除第一行空白
    normal gg
    delete
endfunction

" 增加函数注释
function s:LoadFunHeader()
  execute 'read' g:erlang_skel_dir . '/' . 'funheader'
	call s:SubstituteField('DATE', strftime('%Y-%m-%d'))
endfunction

" 从当前行注释到指定行
function s:AddComment(line_no)
  execute '.,' . a:line_no . 's/^/%%/'
endfunction

" 取消从当前行到指定行的注释
function s:UnComment(line_no)
  execute '.,' . a:line_no . 's/%%/'
endfunction

command ErlangApplication silent call s:LoadSkeleton('application')
command ErlangSupervisor  silent call s:LoadSkeleton('supervisor')
command ErlangGenServer   silent call s:LoadSkeleton('gen_server')
command ErlangGenFsm      silent call s:LoadSkeleton('gen_fsm')
command ErlangGenEvent    silent call s:LoadSkeleton('gen_event')
command ErlangCommonTest  silent call s:LoadSkeleton('common_test')
command ErlangUnitTest  silent call s:LoadSkeleton('unit_test')
command ErlangFileHeader  silent call s:LoadHeader()
command ErlangFunHeader   silent call s:LoadFunHeader()
command -nargs=1 Erlc  silent call s:AddComment(<args>)
command -nargs=1 Erlunc  silent call s:UnComment(<args>)



