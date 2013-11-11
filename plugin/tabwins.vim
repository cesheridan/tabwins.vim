" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" ||                                                             ||   ~
" ||             _        _                _                     ||   ~
" ||            | |      | |              (_)                    ||   ~
" ||            | |_ __ _| |__   __      ___ _ __  ___           ||   ~
" ||            | __/ _` | '_ \  \ \ /\ / / | '_ \/ __|          ||   ~
" ||            | || (_| | |_) |  \ V  V /| | | | \__ \          ||   ~
" ||             \__\__,_|_.__/    \_/\_/ |_|_| |_|___/          ||   ~
" ||                                                             ||   ~
" ||                                                             ||   ~
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

"###############################################################################
"       Filename:  tabwins.vim
"         Author:  Charles E. Sheridan
"        License:  Copyright (c) 2013, Charles E. Sheridan
"                  This program is free software; you can redistribute it
"                  and/or modify it under the terms of the GNU General Public
"                  License as published by the Free Software Foundation,
"                  version 2 of the License.
"                  This program is distributed in the hope that it will be
"                  useful, but WITHOUT ANY WARRANTY; without even the implied
"                  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
"                  PURPOSE.
"                  See the GNU General Public License version 2 for more details.
"  Documentation:  See tabwins.txt
"                  OR
"                  http://htmlpreview.github.io/?https://github.com/cesheridan/tabwins/blob/master/tabwins.txt.html
"###############################################################################

let g:tabwins_version = 1.7.0

" User decides whether to reload.  Overhead should be small,
" so default is to permit reload, facilitating iterative update.
"    if exists("g:tabwins_is_loaded")
"      finish
"    endif
let g:tabwins_is_loaded = 'Y'


" --------------------------------------------------------------- 
"  GLOBALS
" --------------------------------------------------------------- 
if !exists("g:tabwins_max_v_size")
  let       g:tabwins_max_v_size = 15
endif
if !exists("g:tabwins_max_h_size")
  let       g:tabwins_max_h_size = 15
endif
"these maxes are only for building symmetrical tab cmds, these
"are not relevant for asym tabs, for which cmds are not 
"auto-generated.

if !exists("g:load_tabwins_menu_is_wanted")
  let       g:load_tabwins_menu_is_wanted = 'Y'
endif

if !exists("g:tabwins_menu_number")
  let       g:tabwins_menu_number = 9998
endif

" Configs for netrw display.
if !exists("g:tabwins_netrw_liststyle_default")
let         g:tabwins_netrw_liststyle_default   = 1
endif

let         g:tabwins_netrw_line_number_dirpath = 3
"so that top line of netrw window is the path, replacing 2 lines
"of netwr banner overhead above with file listings.

if !exists("g:tabwins_netrw_line_number_default ")
  let       g:tabwins_netrw_line_number_default = g:tabwins_netrw_line_number_dirpath
endif

" --------------------------------------------------------------- 
function! Report_error(args_hash)
" --------------------------------------------------------------- 
  let l:args = extend({ 
\   'message' : 'ERROR!'},
\   deepcopy(a:args_hash,1)
\)
  echohl  ERROR
  echomsg l:args['message']
  echohl  NONE
endfunction
" --------------------------------------------------------------- 
function! Create_tab (primary_axis, primary_size, secondary_size)
" --------------------------------------------------------------- 
  if (a:primary_axis !~? '^[HV]\c')
    let l:message =
    \ 'ERROR: Invalid primary_axis: ' . a:primary_axis . '.'
    \ 'Valid values begin with "H" or "V"'
    call Report_error({ 'message' : l:message })
    return 0
  endif

  tab new

  "`tab new` above creates the first window for primary_size & secondary_size,
  "so the l:counts are now both 1.
  let l:count1 = 1
  let l:count2 = 1

  while (count1 <= a:primary_size) 
    "<= rather than '<' so that if primary_size==1, the below
    "logic does not prevent creation of windows in the
    "secondary axis -- this applies when the caller 
    "specifies secondary_size > primary_size when primary_size==1
    "-- e.g. 1 vertical window, partitioned into 3
    "horizontal windows, w/ args being ('vertical', 1, 3)
    "
    "The primary axis creates windows via
    "`botright`, while the secondary window creation 
    "does not -- that's what enforces the primary.

    "NOTE-DOC: approach of [v]split and :enew to 
    "assure that each window in the grid has a unique 
    "buffer.  If instead there was not :enew and instead
    "code like 'botright vsplit new', all the windows 
    "would have the same buffer with same name of 'new'
    "A change in one window would be seen in all windows.
    "Closing one window would close the buffer in all windows.
    "Thus :enew ...
    if (count1!=1) "`tab` created the first window
      if (a:primary_axis =~? '^V\c')
        botright vsplit
        enew
      else
        botright split 
        enew
      endif
    endif

    let l:count1 = l:count1 + 1

    "Now if the secondary axis has more than 1 window
    "inside each of the primary windows, create
    "the secondary windows, i.e. secondary windows
    "inside the primary window just created.
    while (count2 < a:secondary_size)
      if a:secondary_size > 1
        if (a:primary_axis =~? '^V\c')
          split 
          enew
        else
          vsplit 
          enew
        endif
      endif
      let l:count2 = l:count2 + 1
    endwhile

    let l:count2 = 1 
    "secondary l:counter needs to be re-inited for each 
    "primary iteration.

    "Move to Window #1
    :1wincmd w
  endwhile
endfunction
" --------------------------------------------------------------- 
function! Explore_netrw_directory_buffer(args_hash)
" --------------------------------------------------------------- 
" Format a buffer after it's been loaded from an :Explore cmd.
  let l:args = extend({
\   'line_number_at_window_top' : g:netrw_line_number_first_file_system_item,
\   },
\   deepcopy(a:args_hash,1)
\ )
  "Adjust the line number shown at window top.
  execute   l:args['line_number_at_window_top']
  normal zt

  setlocal number
  "Seems to get overridden every time that `i` runs.
endfunction
" --------------------------------------------------------------- 
function! Explore_file_system_element(args_hash)
" --------------------------------------------------------------- 
  " NOTE-DOC: Handles both files and dirs.
  let l:args = extend({
\   'explore_cmd_name'          : 'Explore',
\   'netrw_liststyle'           : g:tabwins_netrw_liststyle_default,
\   'file_system_element_names' : '',
\   'line_number_at_window_top' : g:tabwins_netrw_line_number_default,
\   },
\   deepcopy(a:args_hash,1)
\ )
  " NOTE-DOC: This may run into problems if the caller sends in multiple
  " file elements.

  " NOTE-VIM-DOC-expand()-eval: Use this to assure that file_system_element_names
  " is a string.  Otherwise, the caller could pass in a shell var identifier,
  " such as $a_dirpath, and !isdirectory() below would 
  " evaluate the arg as a literal, i.e. as '$a_dirpath', and thus 
  " call edit even if the eval of the var is a dir.
  " expand() is a Vim variant of eval()
  let       l:args['file_system_element_names'] 
  \= expand(l:args['file_system_element_names'])

  if !isdirectory (l:args['file_system_element_names'])
    "Explore does not handle files, it seems, so send files to :edit.
    execute 'silent! edit ' . l:args['file_system_element_names']
    redraw 
    "so user needn't press key to move to normal mode in the buffer

    redrawstatus
    "get rid of the blue message about hitting a key FAIL!!!

    "silent! & the redraws together free the user from having to hit a 
    "key in order to load & see the new buffer content
    return
  endif

  " NOTE-DOC: Logically, the below should be in the format func 
  " called below.  However, the w: setting made there does NOT 
  " take hold in the window, even if it's followed by :redraw !!!
  " The setting would take effect only on the NEXT exec of this 
  " function, not this current exec.

  " NOTE-DOC: setting w:netrw_liststyle does not by itself make the 
  " current netwr window display the intended
  " liststyle -- w:netrw_liststyle is just a variable.

  " NOTE-DOC-VIM-WindowVar_vs_GlobalVar: MUST refer to the
  " w-scoped 'w:netrw_liststyle' in order to actually make
  " the window show the intended liststyle.  Merely setting
  " g:netrw_liststyle will NOT determine how the Explore 
  " cmd draws the netrw window !!
  let w:netrw_liststyle = l:args['netrw_liststyle']

 "execute l:args['explore_cmd_name'] . ' ' . l:args['file_system_element_names']
  "NOTE-DOC: a:args could be a var that needs interpretation,
  "so build the commmand via :execute rather than calling
  "`:Explore` directly.
  execute ':silent! ' . l:args['explore_cmd_name'] . ' ' . l:args['file_system_element_names']

  redraw
  redrawstatus 
  " get rid of the blue message about hitting a key" FAIL!!!

  call Explore_netrw_directory_buffer({
  \ 'line_number_at_window_top' : l:args['line_number_at_window_top']})
endfunction
" --------------------------------------------------------------- 
function! Fill_tab(args_hash)
" --------------------------------------------------------------- 
  let l:args = extend({
\   'explore_cmd_name'          : 'Explore',
\   'window_fill_specs'         : [],
\   'netrw_liststyle'           : g:tabwins_netrw_liststyle_default,
\   'line_number_at_window_top' : g:tabwins_netrw_line_number_default,
\   'first_window_number'       : 1,
\   'ending_window_number'      : 1,
\   },
\   deepcopy(a:args_hash,1)
\ )
  let g:initial_netrw_liststyle =  g:netrw_liststyle
  let g:netrw_liststyle         =  l:args['netrw_liststyle']

  "In the current tab, cycles thru windows from 'first_window_number',
  "filling them successively with the output of Function_ref().
  "NOTE-DOC: default to starting at window #1.

  "NOTE-DOC: this does not check whether there are enough windows for all 
  "the buffers -- if that happens, likely that multiple bufs will be opened 
  "successively into the last window of the current tab.

  " NOTE-DOC: below hash for Vim v7.2 -- see NOTE-DOC further down 
  let l:current_window_number =  l:args['first_window_number']
  for l:window_fill_spec in (l:args['window_fill_specs'])
    "Go to the window
    execute l:current_window_number . 'wincmd w'
    " --------------------------------------------------------
    " NOTE-DOC: below for Vim v7.3 or later -- see NOTE-DOC further down re
    " the  bug in v7.2
    "let  Function_ref = function(l:window_fill_spec)
    "call Function_ref(a:args_hash['filesystem_access_schema'])
    "NOTE-DOC-VIM: Func Ref Vars MUST begin a Capital !!!
    " --------------------------------------------------------
    " --------------------------------------------------------
    " NOTE-DOC: below for Vim v7.2 -- see NOTE-DOC further down 
    " Have to use a hash so that run-time Vim sees a different var
    " on each iteration.
    " NOTE-VIM-DOC: Technique to avoid a Var overwrite inside an iteration --
    " use a new index into a hash !!!
    if(filereadable(l:window_fill_spec) || isdirectory(l:window_fill_spec))
      call Explore_file_system_element({
      \  'file_system_element_names' : l:window_fill_spec,
      \  'explore_cmd_name'          : l:args['explore_cmd_name'],
      \  'netrw_liststyle'           : l:args['netrw_liststyle'],
      \  'line_number_at_window_top' : l:args['line_number_at_window_top']
      \})
    else
      silent! execute l:window_fill_spec
    endif

    let l:current_window_number = l:current_window_number +1
  endfor

  "Go to 'ending_window_number'
  execute l:args['ending_window_number'] . 'wincmd w'

  "Restore g:initial_netrw_liststyle, whether it had been changed or not.
  let g:netrw_liststyle = g:initial_netrw_liststyle

  "NOTE-DOC: This fails in Vim 7.2 -- the first Function_ref assignment
  "succeeds, but all subsequent assignments fail, producing a tab
  "in which all windows were defined via the first assignment to
  "Function_ref. Vim Patch 7.2 402 seems to respond to this issue,
  "and the issue is NOT apparent in Vim 7.3.
  "    Patch 7.2.402
  "    Problem:    This gives a #705 error: let X = function('haslocaldir')
  "                let X = function('getcwd')
  "    Solution:   Don't give E705 when the name is found in the hashtab. (Sergey
  "                Khorev)
  "    Files:      src/eval.c
  "17 Mar 2010
  "http://www.mail-archive.com/vim_dev@googlegroups.com/msg08663.html"
  "
"     let g:file_element_path_this_buffer = expand("%:p")
"     if (g:file_element_path_this_buffer =~ 'NetrwTreeListing\c')
"     \ || (isdirectory(g:file_element_path_this_buffer) == 1)
"     \ || (&filetype == 'netrw')
endfunction
" --------------------------------------------------------------- 
function! Close_windows(          args_hash)
" --------------------------------------------------------------- 
   "NOTE-DOC: to assure that window number integrity
   "is maintained when closing  multiple windows, 
   "the number sequence should be from high to low.
   for       l:window_number in a:args_hash['window_numbers'] 
     execute l:window_number . 'wincmd w'
     close
   "for       l:window_number in reverse(sort(a:args_hash['window_numbers']))
   "FAIL!! -- NOTE-DOC: Vim sort() is alphabetic, not numeric !!!
   "NOTE-DO: Make a call to perl to get a sort.  Until then, caller
   "must spec window nums in high to low order.
  endfor
endfunction
" --------------------------------------------------------------- 
function! Is_positive_int(args_hash)
" --------------------------------------------------------------- 
  let l:args = extend({
\   'value'    : 'UNDEFINED',
\   'var_name' : 'An unspecified var name',
\   },
\   deepcopy(a:args_hash,1)
\ )
  if (  l:args['value'] =~ '\D')
    call Report_error({ 'message' :
    \ "ERROR -- " . l:args['var_name'] . " IS NOT A POSITIVE INT:  "
    \})
    return 0
  endif
    return 1
endfunction

" ===============================================================
" --- SYMMETRIC TABS
" ===============================================================

" --------------------------------------------------------------- 
function! Screen_globals()
" --------------------------------------------------------------- 
  "Remove '+' signs at begin of dim vars
  if (  g:tabwins_max_v_size =~ '^+')
    let g:tabwins_max_v_size = substitute(g:tabwins_max_v_size, '+', '', 'g')
  endif
  if (  g:tabwins_max_h_size =~ '^+')
    let g:tabwins_max_h_size = substitute(g:tabwins_max_h_size, '+', '', 'g')
  endif
  "Yes, this would remove any '+' that are oddly inside the strings, if there were also '+' at the begin

  if !Is_positive_int({'value' : g:tabwins_max_h_size, 'var_name' : 'g:tabwins_max_h_size' })
    return 0
  endif
  if !Is_positive_int({'value' : g:tabwins_max_v_size, 'var_name' : 'g:tabwins_max_v_size' })
    return 0
  endif

  return 1
endfunction
" --------------------------------------------------------------- 
function! Build_cmds_for_symmetrical_tabs(args_hash)
" --------------------------------------------------------------- 
  let l:args = extend({
\   'primary_dim' : 'V',
\   },
\   deepcopy(a:args_hash,1)
\ )

  if !Screen_globals()
    return 0
  endif

  "--- SCREEN l:args['primary_dim'] & SET LOCALS

  if    (l:args['primary_dim'] == 'V')
    let  l:primary_dim_max   = g:tabwins_max_v_size
    let  l:secondary_dim_max = g:tabwins_max_h_size

  elseif(l:args['primary_dim'] == 'H')
    let  l:primary_dim_max   = g:tabwins_max_h_size
    let  l:secondary_dim_max = g:tabwins_max_v_size

  else
    return 0
    call Report_error({ 'message' :
    \ "ERROR: Build_cmds_for_symmetrical_tabs() Unrecognized 'primary_dim' = " .
    \ l:args['primary_dim']
    \})
  endif

  "--- BUILD CMDS !

  for l:count1 in range(1,l:primary_dim_max)
    for l:count2 in range(1, l:secondary_dim_max)
      let l:cmd_name
      \ = l:args['primary_dim'] .         l:count1 . 'x'  . l:count2
      "e.g 'V2x3'

      let l:cmd_rhs = "call Create_tab ('" .
      \   l:args['primary_dim'] . "', " . l:count1 . ", " . l:count2 . ")"

      "e.g            "call Create_tab ('V', 2, 3)"

      let     l:execute_arg = 'command! ' . l:cmd_name  . ' '  . l:cmd_rhs
      execute l:execute_arg

      " Build Cmd Abbrevs for tabs whose 2nd dim. is 1 -- e.g. abbrev 'V3' for 'V3x1'
      if (l:execute_arg =~ 'x1 ') && (l:count1 <= 10)
        " Do this only thru 10, as 11 and later will trample the cmd names
        " for Asymmetric tabs -- e.g. Asymmetric V13 for 2 vertical cols, the first w/ 1
        " window and the 2nd with 3 Horizontal windows, would be trampled here
        " w/o the bound of 10.  And really, how many times will there be windows
        " w/ >10 cols or rows ?  (not many times?)
        let     l:execute_arg_abbrev_cmd_name = substitute(l:execute_arg, 'x1', '', "")
        execute l:execute_arg_abbrev_cmd_name
      endif
    endfor
  endfor
endfunction
"echo l:execute_arg
"echo l:execute_arg_abbrev_cmd_name
" --------------------------------------------------------------- 
command! BuildCmdsForSymmetricalTabsV
\ :call  Build_cmds_for_symmetrical_tabs({'primary_dim' : 'V'})

command! BuildCmdsForSymmetricalTabsH
\ :call  Build_cmds_for_symmetrical_tabs({'primary_dim' : 'H'})

" Test case for failure
command! BuildCmdsForSymmetricalTabsERROR
\ :call  Build_cmds_for_symmetrical_tabs({'primary_dim' : 'X'})
" --------------------------------------------------------------- 


" --------------------------------------------------------------- 
" Build commands for Symmetric tabs on plugin load
" --------------------------------------------------------------- 
BuildCmdsForSymmetricalTabsV
BuildCmdsForSymmetricalTabsH
" --------------------------------------------------------------- 


" ===============================================================
" --- ASYMMETRIC TABS
" ===============================================================

"NOTE-DOC-VIM: The approach of creating a grid of windows and 
"then filling them w/ buffers via :edit seems to be more PER-
"FORMATIVE than starting w/ a tab and doing repeated pairs of 
"(v)split then :edit, likely because the 2nd approach has to 
"constantly rebalance windows filled w/ buffers?

"For asymmetric windows, the approach here is to first build a
"tab of symmetric windows, and then delete the unneeded windows,
"resulting in the intended asymmetric windows.

"NOTE-DOC-VIM-WINDOW-MGT: Since Vim numbers windows down then to the 
"right, the highest number is always bottom right.  Each window closure
"forces a renumbering of windows that have a higher number than the 
"window that has just closed.  So, window close orders go
"from higher window number to lower window number, so that closing a
"window does not change the order of remaining windows. Which means
"that the 2nd and later closes in each func below can rely on the
"initial window nums that resulted from calls to Create_tab().

"NOTE-DOC: Since windows in these tabs are asymmetrical, a naming scheme 
"that includes strings like "2x3" does not work, because that scheme 
"represents symmetrical grids.  So, use vN+ namming format -- e.g. v123
"to identify 3 vertical cols that going Left=>Right have 1, 2, & then 3
"windows in successive columns.

" NOTE-DOC-IMPORTANT: New asymmetric commands must call
" Close_windows() with window_numbers in descending 
" order !!! See comments in that func.
"
" --------------------------------------------------------------- 
" Vertical Asymmetric
" --------------------------------------------------------------- 

" NOTE-DOC: Creation of commands for asymmetric tabs is not as readily 
" automated as command creation for symmetric tabs. SO, the 
" following inventory of asymmetric command builders can be 
" supplemented by the users as-needed.
"

function! Create_tab_v31()
  call    Create_tab ('V', 2, 3)
  call    Close_windows ({
  \ 'window_numbers' : [6,5]
  \})
endfunction
command! V31 :call Create_tab_v31()

function! Create_tab_v32()
  call    Create_tab ('V', 2, 3)
  call    Close_windows ({
  \ 'window_numbers' : [6]
  \})
endfunction
command! V32 :call Create_tab_v32()

function! Create_tab_v41()
  call    Create_tab ('V', 2, 4)
  call    Close_windows ({
  \ 'window_numbers' : [8,7,6]
  \})
endfunction
command! V41 :call Create_tab_v41()


function! Create_tab_v42()
  call    Create_tab ('V', 2, 4)
  call    Close_windows ({
  \ 'window_numbers' : [8,7]
  \})
endfunction
command! V42 :call Create_tab_v42()

function! Create_tab_v123()
  call    Create_tab ('V', 3, 3)
  call    Close_windows ({
  \ 'window_numbers' : [5,3,2]
  \})
endfunction
command! V123 :call Create_tab_v132()


function! Create_tab_v113()
  call    Create_tab ('V', 3, 3)
  call    Close_windows ({
  \ 'window_numbers' : [6,5,3,2]
  \})
endfunction
command! V113 :call Create_tab_v113()

function! Create_tab_v142()
  call    Create_tab ('V', 3, 4)
  call    Close_windows ({
  \ 'window_numbers' : [12,11,4,3,2]
  \})
endfunction
command! V142 :call Create_tab_v142()

function! Create_tab_v143()
  call    Create_tab ('V', 3, 4)
  call    Close_windows ({
  \ 'window_numbers' : [12,4,3,2]
  \})
endfunction
command! V143 :call Create_tab_v143()

function! Create_tab_v144()
  call    Create_tab ('V', 3, 4)
  call    Close_windows ({
  \ 'window_numbers' : [3,2,1]
  \})
endfunction
command! V144 :call Create_tab_v144()

function! Create_tab_v23()
  call    Create_tab ('V', 2, 3)
  call    Close_windows ({
  \ 'window_numbers' : [3]
  \})
endfunction
command! V23 :call Create_tab_v23()

function! Create_tab_v234()
  call    Create_tab ('V', 3, 4)
  call    Close_windows ({
  \ 'window_numbers' : [8, 4,3]
  \})
endfunction
command! V234 :call Create_tab_v234()


command! V23 :call Create_tab_v23()
function! Create_tab_v211()
  call    Create_tab ('V', 3, 2)

  "Close the bottom windows of cols 2 & 3.
  call    Close_windows ({
  \ 'window_numbers' : [6,4]
  \})
endfunction
command! V211 :call Create_tab_v211()

function! Create_tab_v212()
  call    Create_tab ('V', 3, 2)
  call    Close_windows ({
  \ 'window_numbers' : [4]
  \})
endfunction
command! V212 :call Create_tab_v212()

function! Create_tab_v213()
  call    Create_tab ('V', 3, 3)
  call    Close_windows ({
  \ 'window_numbers' : [6,5,3]
  \})
endfunction
command! V213 :call Create_tab_v213()

function! Create_tab_v214()
  call    Create_tab ('V', 3, 4)
  call    Close_windows ({
  \ 'window_numbers' : [8,7,6,4,3]
  \})
endfunction
command! V214 :call Create_tab_v214()

function! Create_tab_v223()
  call    Create_tab ('V', 3, 3)
  call    Close_windows ({
  \ 'window_numbers' : [6,3]
  \})
endfunction
command! V223 :call Create_tab_v223()

function! Create_tab_v224()
  call    Create_tab ('V', 3, 4)
  call    Close_windows ({
  \ 'window_numbers' : [8,7,4,3]
  \})
endfunction
command! V224 :call Create_tab_v224()

function! Create_tab_v232()
  call    Create_tab ('V', 3, 3)

  "Close the botto windows of cols 1 & 3.
  call    Close_windows ({
  \ 'window_numbers' : [9,3]
  \})
endfunction
command! V232 :call Create_tab_v232()

function! Create_tab_v233()
  call    Create_tab ('V', 3, 3)
  call    Close_windows ({
  \ 'window_numbers' : [3]
  \})
endfunction
command! V233 :call Create_tab_v233()

function! Create_tab_v242()
  call    Create_tab ('V', 3, 4)
  call    Close_windows ({
  \ 'window_numbers' : [12,11,4,3]
  \})
endfunction
command! V242 :call Create_tab_v242()

function! Create_tab_v322()
  call    Create_tab ('V', 3, 3)
  call    Close_windows ({
  \ 'window_numbers' : [9,6]
  \})
  "Close the bottom windows of cols 2 & 3.
endfunction
command! V322 :call Create_tab_v322()

function! Create_tab_v21()
  call    Create_tab ('V', 2, 2)
  call    Close_windows ({
  \ 'window_numbers' : [4]
  \})
endfunction
command! V21 :call Create_tab_v21()

function! Create_tab_v112()
  call    Create_tab ('V', 3, 2)
  call    Close_windows ({
  \ 'window_numbers' : [4,2]
  \})
endfunction
command! V112 :call Create_tab_v112()

function! Create_tab_v122()
  call    Create_tab ('V', 3, 2)
  call    Close_windows ({
  \ 'window_numbers' : [2]
  \})
endfunction
command! V122 :call Create_tab_v122()


function! Create_tab_v13()
  call    Create_tab ('V', 2, 3)
  call    Close_windows ({
  \ 'window_numbers' : [3,2]
  \})
endfunction
command! V13 :call Create_tab_v13()

function! Create_tab_v132()
  call    Create_tab ('V', 3, 3)
  call    Close_windows ({
  \ 'window_numbers' : [9,3,2]
  \})
endfunction
command! V132 :call Create_tab_v132()

function! Create_tab_v1321()
  call    Create_tab ('V', 4, 3)
  call    Close_windows ({
  \ 'window_numbers' : [12,11,9,3,2]
  \})
endfunction
command! V1321 :call Create_tab_v1321()

function! Create_tab_v134()
  call    Create_tab ('V', 3, 4)
  call    Close_windows ({
  \ 'window_numbers' : [8,4,3,2]
  \})
endfunction
command! V134 :call Create_tab_v134()

function! Create_tab_v14()
  call    Create_tab ('V', 2, 4)
  call    Close_windows ({
  \ 'window_numbers' : [4,3,2]
  \})
endfunction
command! V14 :call Create_tab_v14()

function! Create_tab_v1511()
  call    Create_tab ('V', 4, 5)
  call    Close_windows ({
  \ 'window_numbers' : [20,19,18,17, 15,14,13,12,  5,4,3,2 ]
  \})
endfunction
command! V1511 :call Create_tab_v1511()

command! V14 :call Create_tab_v14()
function! Create_tab_v121()
  call    Create_tab ('V', 3, 2)
  call    Close_windows ({
  \ 'window_numbers' : [6,2]
  \})
endfunction
command! V121 :call Create_tab_v121()

function! Create_tab_v113()
  call    Create_tab ('V', 3, 3)
  call    Close_windows ({
  \ 'window_numbers' : [6,5,3,2]
  \})
endfunction
command! V113 :call Create_tab_v113()

function! Create_tab_v1112()
  call    Create_tab ('V', 4, 2)
  call    Close_windows ({
  \ 'window_numbers' : [6,4,2]
  \})
endfunction
command! V1112 :call Create_tab_v1112()

function! Create_tab_v1122()
  call    Create_tab ('V', 4, 2)
  call    Close_windows ({
  \ 'window_numbers' : [4,2]
  \})
endfunction
command! V1122 :call Create_tab_v1122()

function! Create_tab_v1123()
  call    Create_tab ('V', 4, 3)
  call    Close_windows ({
  \ 'window_numbers' : [9,  6,5,  3,2]
  \})
endfunction
command! V1123 :call Create_tab_v1123()

function! Create_tab_v311()
  call    Create_tab ('V', 3, 3)
  call    Close_windows ({
  \ 'window_numbers' : [9,8,6,5]
  \})
endfunction
command! V311 :call Create_tab_v311()


function! Create_tab_v313()
  call    Create_tab ('V', 3, 3)
  call    Close_windows ({
  \ 'window_numbers' : [6,5]
  \})
endfunction
command! V313 :call Create_tab_v313()

function! Create_tab_v323()
  call    Create_tab ('V', 3, 3)
  call    Close_windows ({
  \ 'window_numbers' : [5]
  \})
endfunction
command! V323 :call Create_tab_v323()

function! Create_tab_v331()
  call    Create_tab ('V', 3, 3)
  call    Close_windows ({
  \ 'window_numbers' : [9,8]
  \})
endfunction
command! V331 :call Create_tab_v331()

function! Create_tab_v3111()
  call    Create_tab ('V', 4, 3)
  call    Close_windows ({
  \ 'window_numbers' : [12,11, 9,8, 6,5]
  \})
endfunction
command! V3111 :call Create_tab_v3111()

function! Create_tab_v332()
  call    Create_tab ('V', 3, 3)
  call    Close_windows ({
  \ 'window_numbers' : [9]
  \})
endfunction
command! V332 :call Create_tab_v332()

function! Create_tab_v413()
  call    Create_tab ('V', 3, 4)
  call    Close_windows ({
  \ 'window_numbers' : [12,8,7,6]
  \})
endfunction
command! V413 :call Create_tab_v413()

function! Create_tab_v433()
  call    Create_tab ('V', 3, 4)
  call    Close_windows ({
  \ 'window_numbers' : [12,8]
  \})
endfunction
command! V433 :call Create_tab_v433()

function! Create_tab_v443()
  call    Create_tab ('V', 3, 4)
  call    Close_windows ({
  \ 'window_numbers' : [12]
  \})
endfunction
command! V443 :call Create_tab_v443()


function! Create_tab_v511()
  call    Create_tab ('V', 3, 5)
  call    Close_windows ({
  \ 'window_numbers' : [15,14,13,12,10,9,8,7]
  \})
endfunction
command! V511 :call Create_tab_v511()


function! Create_tab_v624()
  call    Create_tab ('V', 3, 6)
  call    Close_windows ({
  \ 'window_numbers' : [18,17,12,11,10,9]
  \})
endfunction
command! V624 :call Create_tab_v624()

function! Create_tab_v12()
  call    Create_tab ('V', 2, 2)
  call    Close_windows ({
  \ 'window_numbers' : [2]
  \})
endfunction
command! V12 :call Create_tab_v12()


function! Create_tab_v1121()
  call    Create_tab ('V', 4, 2)
  call    Close_windows ({
  \ 'window_numbers' : [8,4,2]
  \})
endfunction
command! V1121 :call Create_tab_v1121()

function! Create_tab_v1122()
  call    Create_tab ('V', 4, 2)
  call    Close_windows ({
  \ 'window_numbers' : [4,2]
  \})
endfunction
command! V1122 :call Create_tab_v1122()

function! Create_tab_v2112()
  call    Create_tab ('V', 4, 2)
  call    Close_windows ({
  \ 'window_numbers' : [6, 4]
  \})
endfunction
command! V2112 :call Create_tab_v2112()

function! Create_tab_v2113()
  call    Create_tab ('V', 4, 3)
  call    Close_windows ({
  \ 'window_numbers' : [12,9,8,6,5,3]
  \})
endfunction
command! V2113 :call Create_tab_v2113()

function! Create_tab_v2114()
  call    Create_tab ('V', 4, 4)
  call    Close_windows ({
  \ 'window_numbers' : [12,11,10,8,7,6,4,3]
  \})
endfunction
command! V2114 :call Create_tab_v2114()

function! Create_tab_v76()
  call    Create_tab ('V', 2, 7)
  call    Close_windows ({
  \ 'window_numbers' : [14]
  \})
endfunction
command! V76 :call Create_tab_v76()

function! Create_tab_v2111()
  call    Create_tab ('V', 4, 2)
  call    Close_windows ({
  \ 'window_numbers' : [8,6,4]
  \})
endfunction
command! V2111 :call Create_tab_v2111()

function! Create_tab_v2211()
  call    Create_tab ('V', 4, 2)
  call    Close_windows ({
  \ 'window_numbers' : [8,6]
  \})
endfunction
command! V2211 :call Create_tab_v2211()

function! Create_tab_v2212()
  call    Create_tab ('V', 4, 2)
  call    Close_windows ({
  \ 'window_numbers' : [6]
  \})
endfunction
command! V2212 :call Create_tab_v2212()

function! Create_tab_v2121()
  call    Create_tab ('V', 4, 2)
  call    Close_windows ({
  \ 'window_numbers' : [8,4]
  \})
endfunction
command! V2121 :call Create_tab_v2121()

function! Create_tab_v2123()
  call    Create_tab ('V', 4, 3)
  call    Close_windows ({
  \ 'window_numbers' : [ 9,6,5,3 ]
  \})
endfunction
command! V2123 :call Create_tab_v2123()

function! Create_tab_v11131()
  call    Create_tab ('V', 5, 1)

  4wincmd 
  vsplit
  vsplit
endfunction

" --------------------------------------------------------------- 
" Horizontal Asymmetric
" --------------------------------------------------------------- 
"  old-style window removal -- horizontal asyms are not used by
"  the plugin author...

function! Create_tab_h122()
  call    Create_tab ('H', 3, 2)

  "Horizontal Row #1
  2wincmd w
  close
endfunction
command! H122 :call Create_tab_h122()


function! Create_tab_h113()
  call    Create_tab ('H', 3, 3)

  "Horizontal Row #2
  6wincmd w
  close

  5wincmd w
  close

  "Horizontal Row #1
  3wincmd w
  close

  2wincmd w
  close
endfunction
command! H113 :call Create_tab_h113()


" ===============================================================
" DEMOS
" ===============================================================

" ---------------------------------------------------------------
function! Open_tab_unix_filesystem_1()
" ---------------------------------------------------------------
  :V234

  "Fill_tab() fills windows in the order of elements
  "in 'window_fill_specs' You want to spec something for each
  "of the windows created by :H2 above.
  "You can spec commands, filepaths, or dirpaths.

  call Fill_tab({
  \ 'ending_window_number'      : 3,
  \ 'window_fill_specs' : [
  \   '/',
  \   '/dev',
  \
  \   '/bin',
  \   '/usr/bin',
  \   '/opt/local/bin',
  \
  \   '/opt/X11',
  \   '/opt/X11/bin',
  \   '/opt/X11/lib',
  \   '/opt/X11/share',
  \ ]
  \})
"                                    !perl -e '$h=$ENV{HOME}; $parent=$h; $parent =~ s|/\w+$||; print $parent;'
" let g:home_parent_dirpath = system("perl -e '$h=$ENV{HOME}; $parent=$h; $parent =~ s|/\w+$||; print $parent;'")
endfunction
command! Otuf1 :call Open_tab_unix_filesystem_1()
" ---------------------------------------------------------------
function! Open_tab_home_dir()
" ---------------------------------------------------------------
  "1ST, Create the windowed-tab
  :V232
  "VERTICAL ASYMMETRIC TAB.  3 cols, from left to right with
  "2, 3, and then 2 windows successively.

  let l:home_parent_dirpath = substitute(finddir($HOME), '\/\w\+$', '', 'g')

  "2ND, Fill buffers in the new tab
  call Fill_tab({
  \ 'line_number_at_window_top' : 1,
  \ 'window_fill_specs' : [
  \   $HOME,
  \   'Explore' . l:home_parent_dirpath,
  \
  \   'edit! ~/.bashrc',
  \   '~/.gitignore',
  \   'enew!',
  \
  \   '~/.vimrc',
  \   '~/.vim',
  \ ]
  \})
  "Fill_tab() fills windows in the order of elements
  "in 'window_fill_specs' You want to spec something for each
  "of the windows created by :V1321 above,
  "either commands, filepaths, or dirpaths.
  "Specs can include shell or vim vars, and if files or dirs
  "the spec can include a vim command or use the default :edit or
  ":Explore call in Fill_tab()

  "3d, optional, apply Vim resize and/or other commands to the windows/buffers.
  2wincmd w
  resize 30

  1wincmd w
  "And end back in window 1
endfunction
command! Othd :call Open_tab_home_dir()
" ---------------------------------------------------------------
function!             Open_tab_vim_help_quickref_and_index()
" ---------------------------------------------------------------
  :V2

  let l:vim_doc_dirpath = $VIMRUNTIME . '/doc'
  call Fill_tab({
  \ 'window_fill_specs' : [
  \   l:vim_doc_dirpath . '/quickref.txt',
  \   l:vim_doc_dirpath . '/index.txt',
  \ ]
  \})
endfunction
command! Otvhqi :call Open_tab_vim_help_quickref_and_index()
" ---------------------------------------------------------------
function!             Open_tab_vim_help_tocs_args_and_opts()
" ---------------------------------------------------------------
  :V4
  let l:vim_doc_dirpath = $VIMRUNTIME . '/doc'
  call Fill_tab({
  \ 'window_fill_specs' : [
  \   l:vim_doc_dirpath . '/usr_toc.txt',
  \   l:vim_doc_dirpath . '/help.txt',
  \   l:vim_doc_dirpath . '/starting.txt',
  \   l:vim_doc_dirpath . '/options.txt',
  \ ]
  \})
endfunction
command! Otvhtao :call Open_tab_vim_help_tocs_args_and_opts()
" ---------------------------------------------------------------
function!           Open_vim_help_tabs()
" ---------------------------------------------------------------
  call Open_tab_vim_help_quickref_and_index()
  call Open_tab_vim_help_tocs_args_and_opts()
endfunction
command! Otvh :call Open_vim_help_tabs()
" ---------------------------------------------------------------
function!             Open_tab_vim_dirs()
" ---------------------------------------------------------------
  :V323
  let l:vim_doc_dirpath = $VIMRUNTIME . '/doc'
  call Fill_tab({
  \ 'ending_window_number' : 2,
  \ 'window_fill_specs' : [
  \   $VIM,
  \   $VIMRUNTIME,
  \   $VIMRUNTIME . '/doc',
  \
  \   $VIMRUNTIME . '/autoload',
  \   $VIMRUNTIME . '/autoload/README.txt',
  \
  \   $VIMRUNTIME . '/tools',
  \   $VIMRUNTIME . '/plugin',
  \   $VIMRUNTIME . '/macros',
  \ ]
  \})
endfunction
command! Otvd :call Open_tab_vim_dirs()
" ---------------------------------------------------------------
function!             Open_tab_perl5_lib()
" ---------------------------------------------------------------
"  NOTE-DOC: Current shell MUST have set $PERL5LIB.
  :V1511
  call Fill_tab({
  \ 'window_fill_specs' : [
  \   $PERL5LIB,
  \
  \   $PERL5LIB . '/Moose',
  \   $PERL5LIB . '/Moo',
  \   $PERL5LIB . '/Net',
  \   $PERL5LIB . '/IO',
  \   $PERL5LIB . '/Statistics',
  \
  \   $PERL5LIB . '/Data/Dumper.pm',
  \
  \   $PERL5LIB . '/Getopt/Long.pm',
  \ ]
  \})
  1wincmd w
  vertical resize 30

  2wincmd w
  vertical resize 80

  1wincmd w
  "intended vertical dims require 1-2 order
  "above, but want active window at end to 
  "be 1
endfunction
command! Otp5l :call Open_tab_perl5_lib()
" ---------------------------------------------------------------
function! Tabwins_menu_build()
" ---------------------------------------------------------------
  execute g:tabwins_menu_number . 'amenu Tabwins.EXAMPLE\ TABS <Nop>'
  amenu Tabwins.-Sep100-                     <Nop>

  "--- Sym V
  amenu Tabwins.Vertical\ Symmetric.V2x2    :silent! V2x2<CR>
  amenu Tabwins.Vertical\ Symmetric.V2x6    :silent! V2x6<CR>
  amenu Tabwins.Vertical\ Symmetric.V4x3    :silent! V4x3<CR>
  amenu Tabwins.Vertical\ Symmetric.V4x7    :silent! V4x7<CR>
  amenu Tabwins.Vertical\ Symmetric.V8x4    :silent! V8x4<CR>
  amenu Tabwins.Vertical\ Symmetric.V8x14   :silent! V8x14<CR>
  amenu Tabwins.Vertical\ Symmetric.V11x2   :silent! V11x2<CR>
  amenu Tabwins.Vertical\ Symmetric.V14x7   :silent! V14x7<CR>

  "--- Sym H
  amenu Tabwins.Horizontal\ Symmetric.H2x2  :silent! H2x2<CR>
  amenu Tabwins.Horizontal\ Symmetric.H2x6  :silent! H2x6<CR>
  amenu Tabwins.Horizontal\ Symmetric.H4x3  :silent! H4x3<CR>
  amenu Tabwins.Horizontal\ Symmetric.H4x7  :silent! H4x7<CR>
  amenu Tabwins.Horizontal\ Symmetric.H8x4  :silent! H8x4<CR>
  amenu Tabwins.Horizontal\ Symmetric.H8x14 :silent! H8x14<CR>
  amenu Tabwins.Horizontal\ Symmetric.H11x2 :silent! H11x2<CR>
  amenu Tabwins.Horizontal\ Symmetric.H14x7 :silent! H14x7<CR>
  amenu Tabwins.-Sep130-                   <Nop>

  "--- Asym V
  amenu Tabwins.Vertical\ Asymmetric.V12   :silent! V12<CR>
  amenu Tabwins.Vertical\ Asymmetric.V13   :silent! V13<CR>
  amenu Tabwins.Vertical\ Asymmetric.V214  :silent! V214<CR>
  amenu Tabwins.Vertical\ Asymmetric.V2212 :silent! V2212<CR>
  amenu Tabwins.Vertical\ Asymmetric.V23   :silent! V23<CR>
  amenu Tabwins.Vertical\ Asymmetric.V3111 :silent! V3111<CR>
  amenu Tabwins.Vertical\ Asymmetric.V332  :silent! V332<CR>
  amenu Tabwins.Vertical\ Asymmetric.V413  :silent! V413<CR>
  amenu Tabwins.Vertical\ Asymmetric.V443  :silent! V443<CR>

  "--- Asym H
  amenu Tabwins.Horizontal\ Asymmetric.H113 :silent! H113<CR>
  amenu Tabwins.Horizontal\ Asymmetric.H122 :silent! H122<CR>
  amenu Tabwins.-Sep150-                   <Nop>

  "--- Populated
  amenu Tabwins.Populated\ Tabs.1\ \ \ \ :V234\ with\ unix_filesystem_1                                     :silent! call Open_tab_unix_filesystem_1()<CR>
  amenu Tabwins.Populated\ Tabs.2\ \ \ \ :V1511\ with\ perl5_lib\ (Assumes\ $PERL5LIB\ defined)             :silent! call Open_tab_perl5_lib()<CR>
  amenu Tabwins.Populated\ Tabs.-Sep100-                                               <Nop>

  amenu Tabwins.Populated\ Tabs.3\ \ \ \ :V2\ with\ vim_help_quickref_and_index                             :silent! call Open_tab_vim_help_quickref_and_index()<CR>
  amenu Tabwins.Populated\ Tabs.4\ \ \ \ :V4\ with\ vim_help_tocs_args_and_opts                             :silent! call Open_tab_vim_help_tocs_args_and_opts()<CR>
  amenu Tabwins.Populated\ Tabs.5\ \ \ \ BOTH\ vim\ help\ tabs                                              :silent! call Open_vim_help_tabs()<CR>
  amenu Tabwins.Populated\ Tabs.-Sep200-                                               <Nop>

  amenu Tabwins.Populated\ Tabs.6\ \ \ \ :V323\ with\ vim_dirs\ \ (Assumes\ $VIM\ &&\ $VIMRUNTIME\ defined) :silent! call Open_tab_vim_dirs()<CR>
  amenu Tabwins.Populated\ Tabs.-Sep300-                                               <Nop>

  amenu Tabwins.Populated\ Tabs.7\ \ \ \ :V232\ with\ home_dir\ (Assumes\ several\ ~/\ dot\ files)         :silent! call Open_tab_home_dir()<CR>
endfunction
" ---------------------------------------------------------------
if g:load_tabwins_menu_is_wanted =~ '^Y\c'
  call Tabwins_menu_build()
endif
