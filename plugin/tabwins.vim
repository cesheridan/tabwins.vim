" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" ||                                                              ||
" ||             _        _                _                      ||
" ||            | |      | |              (_)                     ||
" ||            | |_ __ _| |__   __      ___ _ __  ___            ||
" ||            | __/ _` | '_ \  \ \ /\ / / | '_ \/ __|           ||
" ||            | || (_| | |_) |  \ V  V /| | | | \__ \           ||
" ||             \__\__,_|_.__/    \_/\_/ |_|_| |_|___/           ||
" ||                                                              ||
" ||                                                              ||
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
"                  http://htmlpreview.github.io/?http<SID>//github.com/cesheridan/tabwins/blob/master/tabwins.txt.html
"###############################################################################

let g:tabwins_version = 3.1.0

" Load overhead should be small, so default is to permit reload
if !exists("g:tabwins_multiple_loads_are_permitted")
  let       g:tabwins_multiple_loads_are_permitted = 'Y'
endif

if         (g:tabwins_multiple_loads_are_permitted == 'N') && exists("g:tabwins_is_loaded") 
  finish
endif
let         g:tabwins_is_loaded = 'Y'

" --------------------------------------------------------------- 
"  GLOBALS
" --------------------------------------------------------------- 

" --- Dimensions

if !exists("g:tabwins_max_v_size")
  let       g:tabwins_max_v_size = 15
endif
if !exists("g:tabwins_max_h_size")
  let       g:tabwins_max_h_size = 15
endif
" these maxes are only for building symmetric tab cmds, these
" are not relevant for asym tabs, for which cmds are not 
" auto-generated.

" --- 'Tabwins' menu

if !exists("g:load_tabwins_menu_is_wanted")
  let       g:load_tabwins_menu_is_wanted = 'Y'
endif

if !exists("g:tabwins_menu_number")
  let       g:tabwins_menu_number = 9998
endif

" --- :Tabwins* aliases

if !exists("g:tabwins_create_aliases_is_wanted")
  let       g:tabwins_create_aliases_is_wanted  = 'Y'
endif

if !exists("g:tabwins_alias")
  let       g:tabwins_alias                     = 'T'
endif
if !exists("g:tabwinsvertical_alias")
  let       g:tabwinsvertical_alias             = 'V'
endif
if !exists("g:tabwinshorizontal_alias")
  let       g:tabwinshorizontal_alias           = 'H'
endif
if !exists("g:tabwinsfindtabwins_alias")
  let       g:tabwinsfindtabwins_alias          = 'TF'
endif

" --- Tab options

" windows

if !exists("g:tabwins_first_window_number_default")
  let       g:tabwins_first_window_number_default  = 1
endif

if !exists("g:tabwins_ending_window_number_default")
let         g:tabwins_ending_window_number_default = 1
endif

" netrw

if !exists("g:tabwins_explore_cmd_name_default")
let         g:tabwins_explore_cmd_name_default      = 'Explore'
endif

if !exists("g:tabwins_netrw_liststyle_default")
let         g:tabwins_netrw_liststyle_default      = 1
endif

let         g:tabwins_netrw_line_number_dirpath    = 3
" so that top line of netrw window is the path, replacing 2 lines
" of netwr banner overhead above with file listings.

if !exists("g:tabwins_netrw_line_number_default")
  let       g:tabwins_netrw_line_number_default    = g:tabwins_netrw_line_number_dirpath
endif

" g:netrw_liststyle is declared in the netrw plugin
if !exists("g:netrw_liststyle")
  let       g:netrw_liststyle = g:tabwins_netrw_liststyle_default
endif
" --------------------------------------------------------------- 
function! s:report_error(args_hash)
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
function! Explore_netrw_directory_buffer(args_hash)
" --------------------------------------------------------------- 
" Format a buffer after it's been loaded from an :Explore cmd.
  let l:args = extend({
\   'line_number_at_netrw_window_top' : g:tabwins_netrw_line_number_default,
\   },
\   deepcopy(a:args_hash,1)
\ )
  "Adjust the line number shown at window top.
  execute   l:args['line_number_at_netrw_window_top']
  normal zt

  setlocal number
  "Seems to get overridden every time that `i` runs.
endfunction
" --------------------------------------------------------------- 
function! Explore_file_system_element(args_hash)
" --------------------------------------------------------------- 
  " NOTE-DOC: Handles both files and dirs.
  let l:args = extend({
\   'explore_cmd_name'                : g:tabwins_explore_cmd_name_default,
\   'netrw_liststyle'                 : g:tabwins_netrw_liststyle_default,
\   'file_system_element_names'       : '',
\   'line_number_at_netrw_window_top' : g:tabwins_netrw_line_number_default,
\   },
\   deepcopy(a:args_hash,1)
\ )
  " NOTE-VIM-DOC-expand()-eval: Use this to assure that file_system_element_names
  " is a string.  Otherwise, the caller could pass in a shell var identifier,
  " such as $a_dirpath, and !isdirectory() below would 
  " evaluate the arg as a literal, i.e. as '$a_dirpath', and thus 
  " call edit even if the eval of the var is a dir.
  " expand() is a Vim version of eval()
  let       l:args['file_system_element_names'] 
  \= expand(l:args['file_system_element_names'])

  if !isdirectory (l:args['file_system_element_names'])
    "Explore does not handle files, so send files to :edit.
    execute 'silent! edit ' . l:args['file_system_element_names']
    redraw 
    "so user needn't press key to move to normal mode in the buffer

    redrawstatus
    "get rid of the blue message about hitting a key FAIL!!!

    "silent! & the redraws together free the user from having to hit a 
    "key in order to load & see the new buffer content

    " leave line #1 at top of window
    :normal gg 
   ":1 why does this sometimes fail, while `:normal gg` does not  ?
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

  let w:netrw_liststyle = l:args['netrw_liststyle']
  " NOTE-DOC-VIM-WindowVar_vs_GlobalVar: MUST refer to the
  " w-scoped 'w:netrw_liststyle' in order to actually make
  " the window show the intended liststyle.  Merely setting
  " g:netrw_liststyle will NOT determine how the Explore 
  " cmd draws the netrw window instance !!

  execute ':silent! ' . l:args['explore_cmd_name'] . ' ' . l:args['file_system_element_names']

  redraw
  redrawstatus 
  " same two successive cmds as above -- see comments there.

  call Explore_netrw_directory_buffer({
  \ 'line_number_at_netrw_window_top' : l:args['line_number_at_netrw_window_top']})
endfunction
" --------------------------------------------------------------- 
function! s:close_windows(          args_hash)
" --------------------------------------------------------------- 
   " NOTE-UNNEEDED: this func needed pre v.1.8.0, kept
   " as a util"
   " NOTE-DOC: to assure that window number integrity
   " is maintained when closing  multiple windows, 
   " the number sequence should be from high to low.
   for       l:window_number in a:args_hash['window_numbers'] 
     execute l:window_number . 'wincmd w'
     close
   " for       l:window_number in reverse(sort(a:args_hash['window_numbers']))
   " FAIL!! -- NOTE-DOC: Vim sort() is alphabetic, not numeric !!!
   " NOTE-DO: Make a call to perl to get a sort.  Until then, caller
   " must spec window nums in high to low order.
  endfor
endfunction
" --------------------------------------------------------------- 
function! s:is_int(args_hash)
" --------------------------------------------------------------- 
  let l:args = extend({
\   'value'                     : 'UNDEFINED',
\   'var_name'                  : 'An unspecified var name',
\   'report_if_false_is_wanted' : 'N',
\   },
\   deepcopy(a:args_hash,1)
\ )
  if type(l:args['value']) != type(5)
 "if (  l:args['value'] =~ '\D')
   "if match(l:args['report_if_false_is_wanted'], '/^Y/\c')
    if l:args['report_if_false_is_wanted'] == 'Y'
      call <SID>report_error({ 'message' :
      \ "ERROR -- " . l:args['var_name'] . " IS NOT AN INTEGER:  " .
      \ l:args['value']
      \})
    endif
    return 0
  endif
    return 1
endfunction
" --------------------------------------------------------------- 
function! s:screen_globals()
" --------------------------------------------------------------- 
  " Remove '+' signs at begin of dim vars
  if (  g:tabwins_max_v_size =~ '^+')
    let g:tabwins_max_v_size = substitute(g:tabwins_max_v_size, '+', '', 'g')
  endif
  if (  g:tabwins_max_h_size =~ '^+')
    let g:tabwins_max_h_size = substitute(g:tabwins_max_h_size, '+', '', 'g')
  endif
  " Yes, this would remove any '+' that are oddly inside the strings, if there were also '+' at the begin

  if !<SID>is_int({'value' : g:tabwins_max_h_size, 'var_name' : 'g:tabwins_max_h_size' })
    return 0
  endif
  if !<SID>is_int({'value' : g:tabwins_max_v_size, 'var_name' : 'g:tabwins_max_v_size' })
    return 0
  endif

  return 1
endfunction
" --------------------------------------------------------------- 
function! s:build_cmds_for_symmetric_tabs(args_hash)
" --------------------------------------------------------------- 
  let l:args = extend({
\   'primary_dim' : 'V',
\   },
\   deepcopy(a:args_hash,1)
\ )

  if !<SID>screen_globals()
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
    call <SID>report_error({ 'message' :
    \ "ERROR: tabwins.vim <SID>build_cmds_for_symmetric_tabs() Unrecognized 'primary_dim' = " .
    \ l:args['primary_dim']
    \})
    return 0
  endif

  "--- BUILD CMDS !

  for l:count1 in range(1,l:primary_dim_max)
    for l:count2 in range(1, l:secondary_dim_max)
      let l:cmd_name
      \ = l:args['primary_dim'] .           l:count1 . 'x'    .  l:count2
      "e.g 'V2x1'

      let l:cmd_rhs =
      \  ":call <SID>create_tab_cli({ 'args_string' : '[ \""                .
      \   l:args['primary_dim'] . "\", "   . l:count1 . ", "   .  l:count2 . " ]; " .
      \  "\'\. <q-args> ". " })"
      " eg :call <SID>create_tab_cli({ 'args_string' : '[ "V", 2, 1 ]; '. <q-args>  })

      " Here, dynamic build of a command with syntax that makes part of the
      " command itself dynamically evaled when the built command runs.
      " Need <q-args> evaluable during exec of the built cmd, so need to separate
      " <q-args> from the static part of the string in front of it
         "  "\'\. <q-args> ". ' })'
         " the two \ being the escapes needed to get '. in the result, ie
         " to get the ' to terminate what is evaled completely on this bind
         " here, to the left, and then the . to join with <q-args> to be 
         " evaled when this built command runs.

      " ------------------------------------------------------------------
      let     l:execute_arg = 'command! -complete=file -nargs=* ' . l:cmd_name  . ' ' .  l:cmd_rhs
      execute l:execute_arg
      " ------------------------------------------------------------------
      " eg command! -complete=file -nargs=* V2x1 :call <SID>create_tab_cli({ 'args_string' : '[ "V", 2, 1 ]; '. <q-args>  })

      " Build Cmd Abbrevs for tabs whose 2nd dim. is 1 -- e.g. abbrev 'V3' for 'V3x1'
      if (l:execute_arg =~ 'x1 ') && (l:count1 <= 10)
        " Do this only thru 10, as 11 and later will trample the cmd names
        " for Asymmetric tabs -- e.g. Asymmetric V13 for 2 vertical cols, the first w/ 1
        " window and the 2nd with 3 Horizontal windows, would be trampled here
        " w/o the bound of 10.  And really, how many times will there be windows
        " w/ >10 cols or rows ?
        let     l:execute_arg_abbrev_cmd_name = substitute(l:execute_arg, 'x1', '', "")
        execute l:execute_arg_abbrev_cmd_name

        " NOTE-DOC: Since windows in these tabs can be asymmetric, a naming scheme 
        " with strings like "2x3" does not work, because that scheme 
        " does not distinguish the V & H axes.  So, use V{I...} namming format 
        " -- e.g. V123 for 3 vertical cols that going Left=>Right have 1, 2, 
        " & then 3 windows in successive columns.
      endif
    endfor
  endfor
endfunction
" --------------------------------------------------------------- 
function! s:create_windowed_tab_symmetric(primary_axis, primary_size, secondary_size)
" --------------------------------------------------------------- 
  if (a:primary_axis !~? '^[VH]\c')
    let l:message =
    \ 'ERROR: Invalid primary_axi<SID> ' . a:primary_axis . '.'
    \ 'Valid values begin with "H" or "V"'
    call <SID>report_error({ 'message' : l:message })
    return 0
  endif

  tab new

  "`tab new` above creates the first window for primary_size & secondary_size,
  "so the l:counts are now both 1.
  let l:count1 = 1
  let l:count2 = 1

  while (count1 <= a:primary_size) 
    " <= rather than '<' so that if primary_size==1, the below
    " logic does not prevent creation of windows in the
    " secondary axis -- this applies when the caller 
    " specifies secondary_size > primary_size when primary_size==1
    " -- e.g. 1 vertical window, partitioned into 3
    " horizontal windows, w/ args being ('vertical', 1, 3)

    " The primary axis creates windows via
    " `botright`, while the secondary window creation 
    " does not -- that's what enforces the primary.

    " NOTE-DOC: approach of [v]split and :enew to 
    " assure that each window in the grid has a unique 
    " buffer.  If there was not :enew and instead code
    " like 'botright vsplit new', all the windows 
    " would have the same buffer with same name of 'new'
    " A change in one window would be seen in all windows.
    " Closing one window would close the buffer in all windows.
    " Thus :enew ...
    if (count1!=1) "`tab new` above created the first window
      if (a:primary_axis =~? '^V\c')
        botright vsplit
        enew
      else
        botright split 
        enew
      endif
    endif

    let l:count1 = l:count1 + 1

    " Now if the secondary axis has more than 1 window
    " inside each of the primary windows, create
    " the secondary windows, i.e. secondary windows
    " inside the primary window just created.
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
function! s:create_windowed_tab(args_hash)
" --------------------------------------------------------------- 
  let l:args = extend({
\   'primary_dim' : 'V',
\   'dims'        :  [],
\   },
\   deepcopy(a:args_hash,1)
\ )
"echo '<SID>create_windowed_tab' echo l:args

  " --- SCREEN ARGS

  " screen l:args['dims']  -- can be an integer or a list

  let l:sym_type_is_known_symmetric = 'N'
  "For now, this is known only when 'dims' is an explicit
  "symmetric command -- this could also be derived for 
  "symmetric IJK... 'dims'

  let   g:secondary_dim_lengths = []

  if <SID>is_int({'value' :                  l:args['dims'], 'var_name' : 'dims' })
    let g:secondary_dim_lengths = split(l:args['dims'],'\zs')
    " e.g. 'dims' = 5924 becomes array ['5', '9', '2', '4']
    " Convert 'dims' from an integer to a list.
    " IF it's an integer, each digit is treated as the dimension of
    " the secondary axis.  SO, an integer 'dims' can spec a secondary_dim
    " not larger than 9.

  elseif type(   l:args['dims']) == type([])

    if (l:args['dims'][0] == 'V') || (l:args['dims'][0] == 'H')
      " 'dims' is spec for a symmetric structure, e.g. 'V5x2'
      let l:args['primary_dim'] = l:args['dims'][0] "e.g. 'V'
      let l:primary_dim_size    = l:args['dims'][1] "e.g. 5
      let l:secondary_dim_max   = l:args['dims'][2] "e.g. 2
      " get rid of the hard-coding ...

      let l:sym_type_is_known_symmetric = 'Y'
    else
      " 'dims' is (should be!) a list of secondary_dim sizes
      let g:secondary_dim_lengths = l:args['dims'] 
      " To spec a secondary_dim larger than 9, the caller needs to submit
      " 'dims' as a list -- e.g. [19, 20, 4, 15] at the vim command line.
    endif

  else
    return 0
  endif

  " screen l:args['primary_dim']

  if (l:args['primary_dim'] != 'V') && (l:args['primary_dim'] != 'H')
    call <SID>report_error({ 'message' :
    \ "ERROR: tabwins.vim <SID>create_windowed_tab() Unrecognized 'primary_dim' = " .
    \ l:args['primary_dim']
    \})
    return 0
  endif

  "If above assigned to g:secondary_dim_lengths, use it
  if len(g:secondary_dim_lengths) > 0
    let l:primary_dim_size  = len(g:secondary_dim_lengths)
    let l:secondary_dim_max = max(g:secondary_dim_lengths)
  endif

  " --- DO IT!

  " ------------------------------------------------------------------
  " 1st, Build a symmetric window structure
  call <SID>create_windowed_tab_symmetric(l:args['primary_dim'], l:primary_dim_size, l:secondary_dim_max)
  " Chisel away at this in step 2 if the structure is to be asymmetric.
  " ------------------------------------------------------------------
  if(l:sym_type_is_known_symmetric == 'Y')
    return 1
  endif

  " 2nd, Remaining code goes thru each secondary axis and closes surplus windows.
  " (if caller speced symmetric windows, none will close)
  " In this interface, symmetric window specs looks like: 5555 & [11, 11, 11 ]

   " NOTE-DOC-VIM-WINDOW-MGT: Since Vim numbers windows down then to the 
   " right, the highest number is always bottom right.  Each window closure
   " forces a renumbering of windows that have a higher number than the 
   " window that has just closed.  So, window close orders go
   " from higher window number to lower window number, so that closing a
   " window does not change the order of remaining windows.
   " The the two range() loops go from high to low.
  for l:primary_idx in range(l:primary_dim_size-1, 0, -1)

    let   l:surplus_win_count_this_secondary  =  l:secondary_dim_max - g:secondary_dim_lengths[l:primary_idx]

    if    l:surplus_win_count_this_secondary  >  0
      let l:reference_win_num                 =  l:secondary_dim_max * l:primary_idx

      " In the symmetric windows created by <SID>create_windowed_tab_symmetric(), the
      " win num of the first window in THIS secondary axis is 1 more than the num 
      " the end of the structurally previous secondary_dim -- E.G. if 
      " <SID>create_windowed_tab_symmetric() built a 6x8 w/ Vertical primary_axis, and 
      " now l:primary_idx is 3 (col 4) then the reference window num is to the 
      " window at the end of col 3, which would be 24, as each of the first three 
      " cols has 8 windows.  And the current secondary axis begins w/ window
      " 24+1 => 25 at top of col 4
      for l:win_num_increment in range(l:surplus_win_count_this_secondary, 1, -1)
        " ------------------------------------------------------------------
        let     l:win_num_to_close =   l:reference_win_num + l:win_num_increment 
        execute l:win_num_to_close . 'wincmd w'
        " ------------------------------------------------------------------
        " wincmd uses window nums that start at 1, not 0 !
        close!
      endfor
    endif
  endfor

  "END at window #1
  1wincmd w
  return 1
endfunction
" --------------------------------------------------------------- 
function! Fill_tab(args_hash)
" --------------------------------------------------------------- 
  let l:args = extend({
\   'fill_specs'                      : [],
\
\   'explore_cmd_name'                : g:tabwins_explore_cmd_name_default,
\   'netrw_liststyle'                 : g:tabwins_netrw_liststyle_default,
\   'line_number_at_netrw_window_top' : g:tabwins_netrw_line_number_default,
\
\   'first_window_number'             : g:tabwins_first_window_number_default,
\   'ending_window_number'            : g:tabwins_ending_window_number_default,
\   },
\   deepcopy(a:args_hash,1)
\ )
"echo 'Fill_tab'  echo l:args  return

  let g:initial_netrw_liststyle =  g:netrw_liststyle
  let g:netrw_liststyle         =  l:args['netrw_liststyle']
  " g:netrw_liststyle should be defined in the netrw plugin but 
  " defined in tabwin.vim if not.

  " NOTE-DOC: this does not check whether there are enough windows for all 
  " the buffers -- if that happens, likely that multiple bufs will be opened 
  " successively into the last window of the current tab.

  let l:current_window_number =  l:args['first_window_number']
  for l:window_fill_spec in (l:args['fill_specs'])

    " Go to the window
    execute l:current_window_number . 'wincmd w'
    if filereadable(l:window_fill_spec) || isdirectory(l:window_fill_spec)
      " NOTE-DOC: the three config in l:args below are bypassed
      " if when the 'else' below runs -- so that's how the caller
      " overrides these configs on a per-window basis.
      call Explore_file_system_element({
      \  'file_system_element_names'       : l:window_fill_spec,
      \  'explore_cmd_name'                : l:args['explore_cmd_name'],
      \  'netrw_liststyle'                 : l:args['netrw_liststyle'],
      \  'line_number_at_netrw_window_top' : l:args['line_number_at_netrw_window_top']
      \})
    else
      silent! execute l:window_fill_spec
    endif

    let l:current_window_number = l:current_window_number +1
  endfor

  " Go to 'ending_window_number'
  execute l:args['ending_window_number'] . 'wincmd w'

  " Restore g:initial_netrw_liststyle, whether it had been changed or not.
  let g:netrw_liststyle = g:initial_netrw_liststyle

endfunction
" --------------------------------------------------------------- 
function! s:create_tab(args_hash)
" --------------------------------------------------------------- 
  let l:args = extend({
\   'primary_dim'   : 'V',
\   'dims'          : [],
\   'fill_specs'    : {},
\   'tab_options'   : {},
\   },
\   deepcopy(a:args_hash,1)
\ )
"echo '<SID>create_tab' echo l:args

  call <SID>create_windowed_tab({
\   'primary_dim'   : l:args['primary_dim'],
\   'dims'          : l:args['dims'],
\ })
  call Fill_tab(extend(
\   {'fill_specs' : l:args['fill_specs']},
\   l:args['tab_options']
\ ))
endfunction
" --------------------------------------------------------------- 
function! s:create_tab_cli(args_hash)
" --------------------------------------------------------------- 
  let l:args = extend({
\   'primary_dim'    : 'V',
\   'args_string'    : '',
\   'separator_char' : ';'
\   },
\   deepcopy(a:args_hash,1)
\ )
  let l:dims_idx         = 0
  let l:fill_specs_idx   = 1
  let l:tab_options_idx  = 2

  " Convert 'args_string' to an array
  let l:tab_specs        = split(l:args['args_string'], l:args['separator_char'])
  " Vim facilities for parsing user-defined command args are rudimentary,
  " so use 'separator_char' to simplify local parsing.

  let l:tab_specs_count  = len(l:tab_specs)

  if  l:tab_specs_count  <  1
    " Nothing speced, so nothing to do ...
    return
  endif

  " 'dims' could be an int or a list -- parsing of that occurs in a called function
  execute 'let l:dims = ' . l:tab_specs[l:dims_idx]
  " NOTE-DOC: MUST define l:dims via above approach w/ :execute.  Due to the 
  " way that the received a:args_hash is built and has to be processed w/
  " split() above, l:args['dims_idx'] will have single quotes around it, 
  " e.g. '[ ... ]' -- ie it's a string, not an array. If the data type of 
  " 'dims' really is an array, later processing will incorrectly interpret
  " it as a string; if string, it will be interpreted as a double-quoted
  " string (?)

  if    l:tab_specs_count >=                       l:fill_specs_idx + 1
    execute 'let l:fill_specs = [ ' . l:tab_specs[ l:fill_specs_idx ] . ' ]'
    " NOTE-DOC: MUST define via above approach w/ :execute.  See notes above re
    " same for l:dims.  DO NOT assign like "let l:fill_specs = ..."
  else
    let l:fill_specs  = []
    " let l:dims = [] " NOTE-DOC-VIM-POST-BIND-TYPE-CHECKING: let l:x = []
    " causes Vim to define x as an ARRAY type which CANNOT be 
    " later bound to a string or anything else that's not an array.  WELL...
    " => This is why the init [] bind is in the 'else' rather than an init
    " that precedes the 'if'
  endif


  let   l:tab_options      = {}
  if    l:tab_specs_count >=                       l:tab_options_idx +1
    execute 'let l:tab_options = { ' . l:tab_specs[l:tab_options_idx] . ' }'
    " NOTE-DOC: MUST define via above approach w/ :execute.  See notes above re
    " same for l:dims
  endif

  call <SID>create_tab({
\   'primary_dim' : l:args['primary_dim'],
\   'dims'        : l:dims,
\   'fill_specs'  : l:fill_specs,
\   'tab_options' : l:tab_options,
\})
" echo  l:args['primary_dim'] " echo  l:dims " echo  l:fill_specs " echo  l:fill_specs " echo  type(l:tab_options)
endfunction
" ===============================================================
" COMMANDS
" ===============================================================
command! BuildCmdsForSymmetricTabsV
\ :call  <SID>build_cmds_for_symmetric_tabs({'primary_dim' : 'V'})

command! BuildCmdsForSymmetricTabsH
\ :call  <SID>build_cmds_for_symmetric_tabs({'primary_dim' : 'H'})

" Test case for failure
command! BuildCmdsForSymmetricTabsERROR
\ :call  <SID>build_cmds_for_symmetric_tabs({'primary_dim' : 'X'})
" --------------------------------------------------------------- 
command! -complete=file -nargs=+ TabwinsHorizontal call <SID>create_tab_cli({
\ 'primary_dim' : 'H',
\ 'args_string' : <q-args>
\})
" --------------------------------------------------------------- 
command! -complete=file -nargs=+ TabwinsVertical   call <SID>create_tab_cli({
\ 'primary_dim' : 'V',
\ 'args_string' : <q-args>
\})
" --------------------------------------------------------------- 
command! -complete=file -nargs=+ Tabwins           call <SID>create_tab_cli({
\ 'primary_dim' : 'V',
\ 'args_string' : <q-args>
\})

" ===============================================================
" --- ASYMMETRIC TABS
" ===============================================================
"
" NOTE: tabwins.vim v1.8.0 obviates the need to create a function
" for each asymmetric tab.  So tabwins v2.0.0 removes the asymmetric 
" tab builder functions, commented out below as examples of an 
" earlier, less dynamic design.

      " NOTE-DOC-IMPORTANT: New asymmetric commands must call
      " <SID>close_windows() with window_numbers in descending 
      " order !!!

      " function! s:create_windowed_tab_symmetric_v2123()
      "   call    s:create_windowed_tab_symmetric ('V', 4, 3)
      "   call    s:close_windows ({
      "   \ 'window_numbers' : [ 9,6,5,3 ]
      "   \})
      " endfunction
      " command! V2123 :call <SID>create_windowed_tab_symmetric_v2123()
      " 
      " function! s:create_windowed_tab_symmetric_v11131()
      "   call    s:create_windowed_tab_symmetric ('V', 5, 1)
      " 
      "   4wincmd 
      "   vsplit
      "   vsplit
      " endfunction

" ===============================================================
" DEMOS
" ===============================================================

" ---------------------------------------------------------------
function! s:open_tab_unix_filesystem_1_IMPL_FUNCTION()
" ---------------------------------------------------------------
"  NOTE-DOC: This func kept as an example of implementation
"  prior to tabwins v3.1.0, when the tabins.vim CLI cmds could
"  not support all the args.

  :Tabwins 234
  " Fill_tab() fills windows in the order of elements
  " in 'fill_specs' You want to spec something for each
  " of the windows created by :H2 above.
  " You can spec commands, filepaths, or dirpaths.
  call Fill_tab({
  \ 'ending_window_number'      : 3,
  \ 'fill_specs' : [
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
endfunction
" ---------------------------------------------------------------
command! TabwinsUnixFilesystem1 :Tabwins 234;
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
  \   '/opt/X11/share'
  \;
  \ 'ending_window_number'      : 3
" ---------------------------------------------------------------
let                s:home_parent_dirpath = substitute(finddir($HOME), '\/\w\+$', '', 'g')
command! TabwinsHomeDir :Tabwins 232;
  \   $HOME,
  \   'Explore ' . s:home_parent_dirpath . ' | resize 30',
  \
  \   'edit! ~/.bashrc',
  \   '~/.gitignore',
  \   'enew!',
  \
  \   '~/.vimrc',
  \   '~/.vim'
  \;
  \ 'line_number_at_netrw_window_top' : 1
  " windows are filled with the order of elements
  " in the list above. Spec something for each
  " of the windows created by :Tabwins 232,
  " either commands, filepaths, dirpaths, or commands.
  " Specs can include shell or vim vars, and if files or dirs
  " the spec can include a vim command or use the default :edit or
  " :Explore call in Fill_tab()
" ---------------------------------------------------------------
command! TabwinsVimHelpQuickrefAndIndex :Tabwins 11;
  \   $VIMRUNTIME . "/doc/quickref.txt",
  \   $VIMRUNTIME . "/doc/index.txt"
" ---------------------------------------------------------------
command! TabwinsVimHelpTOCsArgsAndOpts :Tabwins 1111;
  \   $VIMRUNTIME . '/doc/usr_toc.txt',
  \   $VIMRUNTIME . '/doc/help.txt',
  \   $VIMRUNTIME . '/doc/starting.txt',
  \   $VIMRUNTIME . '/doc/options.txt'
" ---------------------------------------------------------------
" NOTE-DO: FIX THE 'Trailing Args' ERROR HERE !!!
" command! -nargs=*   TabwinsVimHelpTabs
" \  :TabwinsVimHelpQuickrefAndIndex <Bar>
" \  :TabwinsVimHelpTOCsArgsAndOpts
command! -nargs=* TabwinsVimHelpTabs :TabwinsVimHelpQuickrefAndIndex <Bar> TabwinsVimHelpTOCsArgsAndOpts
" ---------------------------------------------------------------
function!                         <SID>open_vim_help_tabs()
" ---------------------------------------------------------------
  :TabwinsVimHelpQuickrefAndIndex
  :TabwinsVimHelpTOCsArgsAndOpts
endfunction
command! TabwinsVimHelpTabs :call <SID>open_vim_help_tabs()
" ---------------------------------------------------------------
command! TabwinsVimDirs :Tabwins 323;
  \   $VIM,
  \   $VIMRUNTIME,
  \   $VIMRUNTIME . '/doc',
  \
  \   $VIMRUNTIME . '/autoload',
  \   $VIMRUNTIME . '/autoload/README.txt',
  \
  \   $VIMRUNTIME . '/tools',
  \   $VIMRUNTIME . '/plugin',
  \   $VIMRUNTIME . '/macros'
  \;
  \' ending_window_number' : 2
" ---------------------------------------------------------------
command! TabwinsOpenTabPerl5lib :Tabwins 1511;
  \   'Explore ' . $PERL5LIB .       ' | vertical resize 30',
  \   'Explore ' . $PERL5LIB . '/Moose | vertical resize 80',
  \   $PERL5LIB . '/Moo',
  \   $PERL5LIB . '/Net',
  \   $PERL5LIB . '/IO',
  \   $PERL5LIB . '/Statistics',
  \
  \   $PERL5LIB . '/Data/Dumper.pm',
  \
  \   $PERL5LIB . '/Getopt/Long.pm'
  \;
" NOTE-DOC: Current shell MUST have set $PERL5LIB.
" ---------------------------------------------------------------
function! s:menu_build()
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
  amenu Tabwins.-Sep130-                    <Nop>

  "--- Asym V
  amenu Tabwins.:TabwinsVertical\ Asymmetric.12    :silent! TabwinsVertical 12<CR>
  amenu Tabwins.:TabwinsVertical\ Asymmetric.13    :silent! TabwinsVertical 13<CR>
  amenu Tabwins.:TabwinsVertical\ Asymmetric.214   :silent! TabwinsVertical 214<CR>
  amenu Tabwins.:TabwinsVertical\ Asymmetric.2212  :silent! TabwinsVertical 2212<CR>
  amenu Tabwins.:TabwinsVertical\ Asymmetric.23    :silent! TabwinsVertical 23<CR>
  amenu Tabwins.:TabwinsVertical\ Asymmetric.3111  :silent! TabwinsVertical 3111<CR>
  amenu Tabwins.:TabwinsVertical\ Asymmetric.332   :silent! TabwinsVertical 332<CR>
  amenu Tabwins.:TabwinsVertical\ Asymmetric.413   :silent! TabwinsVertical 413<CR>
  amenu Tabwins.:TabwinsVertical\ Asymmetric.443   :silent! TabwinsVertical 443<CR>

  "--- Asym H
  amenu Tabwins.:TabwinsHorizontal\ Asymmetric.113 :silent! TabwinsHorizontal 113<CR>
  amenu Tabwins.:TabwinsHorizontal\ Asymmetric.122 :silent! TabwinsHorizontal 122<CR>
  amenu Tabwins.-Sep150-                   <Nop>

  "--- Populated
  amenu Tabwins.Populated\ Tabs.1\ \ \ \ :Tabwins\ 234\ with\ unix_filesystem_1                                     :silent! TabwinsUnixFilesystem1<CR>
  amenu Tabwins.Populated\ Tabs.2\ \ \ \ :Tabwins\ 1511\ with\ perl5_lib\ (Assumes\ $PERL5LIB\ defined)             :silent! TabwinsOpenTabPerl5lib<CR>
  amenu Tabwins.Populated\ Tabs.-Sep100-                                               <Nop>

  amenu Tabwins.Populated\ Tabs.3\ \ \ \ :Tabwins\ 2\ with\ vim_help_quickref_and_index                             :silent! TabwinsVimHelpQuickrefAndIndex<CR>
  amenu Tabwins.Populated\ Tabs.4\ \ \ \ :Tabwins\ 4\ with\ vim_help_tocs_args_and_opts                             :silent! TabwinsVimHelpTOCsArgsAndOpts<CR>
  amenu Tabwins.Populated\ Tabs.5\ \ \ \ BOTH\ vim\ help\ tabs                                                      :silent! TabwinsVimHelpTabs<CR>
  amenu Tabwins.Populated\ Tabs.-Sep200-                                               <Nop>

  amenu Tabwins.Populated\ Tabs.6\ \ \ \ :Tabwins\ 323\ with\ vim_dirs\ \ (Assumes\ $VIM\ &&\ $VIMRUNTIME\ defined) :silent! TabwinsVimDirs<CR>
  amenu Tabwins.Populated\ Tabs.-Sep300-                                               <Nop>

  amenu Tabwins.Populated\ Tabs.7\ \ \ \ :Tabwins\ 232\ with\ home_dir\ (Assumes\ several\ ~/\ dot\ files)          :silent! TabwinsHomeDir<CR>

  amenu Tabwins.Populated\ Tabs.8\ \ \ \ :V2\ :find\ tabwins\.vim/\.txt\ (Assumes\ a\ parent\ dir\ is\ in\ Vim\ &&runtimepath) :silent! TabwinsFindTabwins<CR>
endfunction

" --------------------------------------------------------------- 
" Build commands for Symmetric tabs on plugin load
" --------------------------------------------------------------- 
BuildCmdsForSymmetricTabsV
BuildCmdsForSymmetricTabsH

" ---------------------------------------------------------------
if g:load_tabwins_menu_is_wanted =~ '^Y\c'
  call <SID>menu_build()
endif
" ---------------------------------------------------------------

command! TabwinsFindTabwins :V2 'find tabwins.vim','find tabwins.txt | set filetype=help'
" works if these files are in &runtimepath -- including ~/.vim 
" should work unless tabwins.vim/txt is deployed elsewhere.

if g:tabwins_create_aliases_is_wanted == 'Y'
  " NOTE-DOC: 'command,' NOT 'command!' so that these do NOT override command name space
  silent! execute 'command -nargs=+ ' . g:tabwins_alias            . ' :Tabwins(<args>)'
  silent! execute 'command -nargs=+ ' . g:tabwinsvertical_alias    . ' :TabwinsVertical(<args>)'
  silent! execute 'command -nargs=+ ' . g:tabwinshorizontal_alias  . ' :TabwinsHorizontal(<args>)'
  silent! execute 'command '          . g:tabwinsfindtabwins_alias . ' :TabwinsFindTabwins'
endif



" __END__

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
" NOTES-ABOUT-EARLIER-VERSION-OF-Fill_tab()
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

" The earlier version was iterating on fill specs differently than now and
" ran into a Vim bug as described below.  This info moved out of Fill_tab()
" but kept here for the record (!)

  " In the current tab, cycles thru windows from 'first_window_number',
  " filling them successively with the output of Function_ref().
  " NOTE-DOC: default to starting at window #1.
 
  " NOTE-DOC: below hash for Vim v7.2 -- see NOTE-DOC further down 
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

  " NOTE-DOC: This fails in Vim 7.2 -- the first Function_ref assignment
  " succeeds, but all subsequent assignments fail, producing a tab
  " in which all windows were defined via the first assignment to
  " Function_ref. Vim Patch 7.2 402 seems to respond to this issue,
  " and the issue is NOT apparent in Vim 7.3.
  "    Patch 7.2.402
  "    Problem:    This gives a #705 error: let X = function('haslocaldir')
  "                let X = function('getcwd')
  "    Solution:   Don't give E705 when the name is found in the hashtab. (Sergey
  "                Khorev)
  "    File<SID>      src/eval.c
  " 17 Mar 2010
  " http://www.mail-archive.com/vim_dev@googlegroups.com/msg08663.html"
  "
"     let g:file_element_path_this_buffer = expand("%:p")
"     if (g:file_element_path_this_buffer =~ 'NetrwTreeListing\c')
"     \ || (isdirectory(g:file_element_path_this_buffer) == 1)
"     \ || (&filetype == 'netrw')
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



" let          g:s = '[1,2,3]'
" let          g:a = []
" execute 'let g:a = ' . g:s
" echo         g:a
" echo type(g:a)
" echo type([])
"
" let          g:a = []
" execute 'let g:a = [ 7,8,9 ]'
"
" let          g:s = 'string'
" execute 'let g:s = [ 7,8,9 ]'
