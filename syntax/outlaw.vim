" Author:       Lifepillar
" Maintainer:   Lifepillar
" License:      This file is placed in the public domain.

if exists("b:current_syntax")
  finish
endif

syntax case ignore
syntax sync minlines=10 maxlines=100
syn keyword outlawKeyword contained TODO FIXME XXX DEBUG NOTE
hi def link OutlawKeyword Special

let s:tab = &l:expandtab ? repeat(' ', &l:shiftwidth) : '\t'
let s:num = get(b:, 'outlaw_levels', get(g:, 'outlaw_levels',
      \ ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X']))
let s:mark = substitute(get(b:, 'outlaw_topic_mark', get(g:, 'outlaw_topic_mark', '\(=== \|\[x\] \|\[ \] \|\[-\] \)')), '\\ze', '', 'g')
let s:hg = get(b:, 'outlaw_highlight_groups', get(g:, 'outlaw_highlight_groups',
      \ ['Statement', 'Identifier', 'Constant', 'PreProc']))
let s:tag = get(b:, 'outlaw_ft_tag', get(g:, 'outlaw_ft_tag', '\~\~\~'))

for i in range(0, len(s:num) - 1)
  execute 'syn match OutlawHead'.s:num[i] '/\m^'.repeat(s:tab,i).s:mark.'.*$/ contains=outlawKeyword'
  execute 'hi def link OutlawHead'.s:num[i] s:hg[i % len(s:hg)]
endfor

" Embedded syntaxes
for ft in get(b:, 'outlaw_nested_ft', get(g:, 'outlaw_nested_ft', []))
  execute 'syn include @Outlaw'.ft 'syntax/'.ft.'.vim'
  unlet b:current_syntax
  execute 'syn region Outlaw'.ft 'start="'.s:tag.ft.'" end="'.s:tag.'" keepend contains=@Outlaw'.ft
endfor

let b:current_syntax = "outlaw"

