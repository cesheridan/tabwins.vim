# *tabwins.vim*
*1 command for custom window structures that persist*   /   Charles E. Sheridan

[8x14]: ./doc/images/V8x14.jpg?raw=true  "8x14"
![alt text][8x14]

_"I'm very impressed with it. **It gets my highest accolade: the coveted 'Why The 
Hell Isn't This Functionality Built-In To Vim' award**_"  -  Damian Conway 

![alt text][gif1]
[gif1]: ./doc/gif/tabwins.1dimension.HV.2-8.gif?raw=true  "gif1"

---
__**The Developer:**__
  * Avoids hit-or-miss, time-consuming, manual, repetitious runs of :split/:vsplit
    
  * Avoids detours thinking about how to produce an intended window structure

  * Avoids losing current configurations due to mid-session reloads of backed-up Vim sessions that have preferred window structures

  * Avoids loss of focus from these discontinuities
---

![alt text][pop1]
[pop1]: ./doc/images/populated_tab_1.v234.jpg?raw=true  "pop1"


# FORMS 
````vim
    :{tabwins_cmd}   {window_dimensions}; {fill_spec,...};  {tab_option, ...} 
    :{symmetric_cmd}                      {fill_spec,...};  {tab_option, ...} 
   
    WHERE
      '{tabwins_cmd}' is any of :Tabwins, :TabwinsVertical, :TabwinsHorizontal 
       Alias:                              :V,             & :H 

      '{window_dimensions}' is the only mandatory arg, for :{Tabwins cmd}  
      'see the Asymmetric & Dimensions >9 subsections in USAGE re the 
      'two syntax conventions for 'window_dimensions'
   
      ':{symmetric cmd}' is any of the form :{V|H}IxJ or :{V|H}I  
   
      'fill_spec'  is a file, dir, shell/vim var, or string evaluable by :execute 
   
      'tab_option' has Vim key:value pair syntax 
  ```` 
**Semicolons** separate arg groups, **commas** separate inside groups.
   


#### 3 TABWINS COMMANDS

These commands take the same arguments and accept arbitrary dimension specification, unconstrained by configuration vars, other than any windows-per-tab limits in Vim.


````vim
    :Tabwins 
    " Same as :TabwinsVertical
    " Default alias :T 
   
    :TabwinsVertical  
    " Priority to the vertical axis.
    " Default alias :V 
   
    :TabwinsHorizontal  
    " Priority to the horizontal axis.
    " Default alias :H " ````

# USAGE

### Tabwins Menu
    
This menu shows how tabwins.vim _**shields developers from the nuisances**_ listed above, by _making complex window structures persistent, quick-building, and easily-invokable from the Vim GUI._

Most of the  tab builders referenced here are defined in tabwins.vim, and several of these are available from the 'Tabwins' menu.

The developer is encouraged to customize this menu for local usage.  Update or replace function **Tabwins_menu_build()** to do so.  

Global **g:load_tabwins_menu_is_wanted** is defaulted to **'Y'** and can be set to 'N' to turn off this menu.

The extent that populated tabs invoked from this menu load their buffers is dependent on shell vars available to the Vim session, and files/dirs present in the local environment -- again, this is intended as a starting point for the developer to 'fill-in' with content from the local environment(s).


### Symmetric Window Structures 
![alt text][gif2]
[gif2]: ./doc/gif/tabwins.2dimension.HV.gif?raw=true  "gif2"

Sourcing _tabwins.vim_ creates **symmetric tab-builder commands** of the form :{V|H}IxJ, where the IxJ permutation set defines on:
````vim
      g:tabwins_max_v_size  
      g:tabwins_max_h_size  
````
In a symmetric structure, all secondary axis dimensions are the same.  This permits shorter Ex line command names.

The simplest symmetric structures have _only 1 dimension with length >1_, as shown in the 2nd graphic on this page. 


_Structures with 2 dimensions with length >1_ are shown immediately above.

**'H'** indicates horizontal priority, **'V'** vertical priority -- _SEE: 'VERTICAL & HORIZONTAL'_

````vim
    :V5x8 
    :H5x8 
    :V8x14 
    :H8x14 
   
    :V6x1
    :V6 
    :H6 ````


### Asymmetric Window Structures 

![alt text][gif3]
[gif3]: ./doc/gif/tabwins.2dimension.asym.HV.gif?raw=true "gif3"

In an asymmetric window, secondary axis dimensions vary, and _axis-specification syntax is different_ than for symmetric windows.
````vim
    :Tabwins 1211 
    :T       1211 
    " For a new tab of 4 columns of 1, 2, 1, & 1 windows successively
    " left to right.
   
    :TabwinsHorizontal 4221 
    :H                 4221 
    " For a new tab of 4 rows, with 4,2,2, & 1 windows successively 
    " top to bottom "````



### Dimensions >9

![alt text][gt9]
[gt9]: ./doc/gif/tabwins.2dimension.HV.GT9.gif?raw=true  "gt9"

For tabs with one or both dimensions >9, use list syntax as below.

````vim
    :Tabwins [ 5, 8, 13, 21 ] 
    :T       [ 5, 8, 13, 21 ] 
    " For a 4-column tab with 5, 8, 13, 21 windows successively left to right.
   
    :Tabwins [ 14, 14 ] 
    :T       [ 14, 14 ] 
    " Or,      :V2x14
   
    :Tabwins [ 40, 30, 40, 30 ] 
    :T       [ 40, 30, 40, 30 ] 
    " For really big monitors ...  " ````

### FILL SPECS 

![alt text][fill_specs]
[fill_specs]: ./doc/gif/tabwins.2dimension.HV.GT9.gif?raw=true  "fill_specs"

'fill_specs' enable the developer to specify that _tabwins.vim_ **fill buffers with files and directories**, and along with those, or instead of those, the **outputs of commands** specified in a fill_spec, including **command sequences** where '|' bars separate the commands.

````vim
:Tabwins           11111; $HOME, '/.bashrc', '~/.vimrc', '/', '/usr/bin' 
:T                 {                  same args                        } 

:V5x1 $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin' 
" Structure & content same as :Tabwins 11111 above

:V5   $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin' 
" Same result again: since the secondary axis has only 1 
" window for its dimensions, V5 is available as an even
" shorter alias.

:Tabwins            1211; $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin' 
:T                  {                  same args                        } 
" 'fill_content' specs of files are automatically opened via :edit,
" while specs of dirs are opened via :Explore
" (Specify the '' empty string for windows intended to be empty.)


:TabwinsHorizontal 11111; $HOME, '/.bashrc', '/.vimrc', '/', '/usr/bin' 
:H                        {                  same args                } 
" FLIP axis priority of above to the horizontal

:Tabwins             312; '/.bashrc', '/.vimrc', '/.git', $HOME, '/', '/usr/bin' 
:T                        {                  same args                         } 

:Tabwins 1112;  $HOME, '~/.bashrc', '~/.vimrc', '/', 'Explore /usr/bin | resize 20' 
:T       {                           same args                                    } 
" Does a :resize of the last window, via Vim '|' command concat.  If a file 
" or dir is followed with concated commands, the caller needs to explicitly 
" add the command that opens the file or dir, e.g. 'Explore' here." ````


### TAB OPTIONS 

Available tab_options are below, with global default vars on the right.  

These options apply to the entire tab and can be combined when separated by commas. 
      
````vim
       'explore_cmd_name'          : g:tabwins_explore_cmd_name_default,
       'netrw_liststyle'           : g:tabwins_netrw_liststyle_default,
       'line_number_at_window_top' : g:tabwins_netrw_line_number_default,
   
      " => Use a fill_spec for window-specific override of the 
      "   above options  
   
       'first_window_number'       : g:tabwins_first_window_number_default,
      " => window population starts with this number, so you wouldn't
      "   have to have to have a fill_spec for lower-numbered windows.
   
       'ending_window_number'      : g:tabwins_ending_window_number_default,
      " => the active window number after tabwins.vim builds a tab"````
   
Examples
````vim
    :Tabwins 1211; $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin'; 'ending_window_number' : 2 
    :Tabwins 1211; $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin'; 'netrw_liststyle'      : 3 
    :T             {                    as above                                             } 
   
    :Tabwins 1211; $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin'; 'netrw_liststyle'      : 3, 
     \                                                              'ending_window_number' : 2 
    :T             {                           same args                                      } 
    " Multiple tab_options in same command.  " ````

# CONFIGURATION  
Overridable globals in _tabwins.vim_:

````vim
To change Vertical/Horizontal max dimensions:
  let g:tabwins_max_v_size                   = {N}
  let g:tabwins_max_h_size                   = {N}  
Default: '15' for each

To limit tabwins.vim load to once per Vim session:
  let g:tabwins_multiple_loads_are_permitted = 'N' 
Default: 'Y'

To prevent 'Tabwins' menu addition when tabwins loads:
  let g:load_tabwins_menu_is_wanted          = 'N' 
Default: 'Y'

To change the 'Tabwins' menu number:
  let g:tabwins_menu_number                  = {menu_number} 
Default: '9998'

To turn off creation of :{tabwins_cmd} aliases
  let  g:tabwins_create_aliases_is_wanted    = 'N' 
Default: 'Y'
=> Creation of an alias command will NOT occur when an existing command has the same name.

:{tabwins_cmd} Alias Defaults:
  let g:tabwins_alias            = 'T' 
  let g:tabwinsvertical_alias    = 'V' 
  let g:tabwinshorizontal_alias  = 'H' 
  let g:tabwinsfindtabwins_alias = 'TF' 

To change the default beginning window number for filling fill_specs
  let g:tabwins_first_window_number_default  = {N} 
Default: '1'
Calls to Fill_tab() can override this on a per-tab basis.

To change the default window number active on :{tabwins_cmd} completion
  let g:tabwins_ending_window_number_default = {N} 
Default: '1' 
Calls to Fill_tab() can override this on a per-tab basis.

To change the default directory Explore command:
  let g:explore_cmd_name                     = {explore_command_name} 
Default: 'Explore'

To change the default top-line of netrw windows:
  let g:tabwins_netrw_line_number_default    = {N} 
Default: 'g:tabwins_netrw_line_number_dirpath', which defaults to 3
Calls to Fill_tab() can override this on a per-tab basis.

To change the default netrw liststyle:
  let g:tabwins_netrw_liststyle_default      = {N} 
Default: '1'
Calls to Fill_tab() can override this on a per-tab basis.
if netrw var g:netrw_liststyle is not defined, it gets this value.
````

## VERTICAL & HORIZONTAL

Windows are built one axis at a time. The first axis built is the **primary axis**, and the other axis is the **secondary axis.**

If a tab starts by building the vertical axis, then the vertical axis is the primary axis, and the horizontal axis is the secondary axis. And vice-versa.

_**What's the difference between Horizontal & Vertical Tabs ?**_

  Structurally, V2x3 is the same as H3x2.  The only difference is how Vim numbers the tabs, based on the axis that is the primary axis.  
  
**IF the primary axis is vertical**, then numbering starts in col 1 and goes down the windows in col 1, then to the top of col 2, then down col 2, and so on.  
  
**IF the primary axis is horizontal**, numbering starts in row 1 and goes left to right, then to row 2, left to right, and so on.

Most of the asymmetric tab builders defined in the plugin use a vertical primary axis.  Developers can define any mix of primary axis in their own tab builders.

## ADDING NEW BUILDERS

#### Auto-generated builders of symmetric tabs

Sourcing of _tabwins.vim_ creates tab builder commands on the HxV and VxH permutations of:
````vim
      g:tabwins_max_v_size  
      g:tabwins_max_h_size ````

_**Increase**_ either/both of these, for additional commands that build tabs with more windows.

Of course, this command set can be _**reduced by**_ lowering the values of the same globals.  

#### As you like it
  
Adapt the below example to create your own commands that build tabs with the window structures and content that you want.  
````vim
        let                g:home_parent_dirpath = substitute(finddir($HOME), '\/\w\+$', '', 'g')
        command! TabwinsHomeDir :Tabwins 232; 
          \   $HOME, 
          \   'Explore ' . g:home_parent_dirpath . ' | resize 30',
          \
          \   'edit! /.bashrc',
          \   '/.gitignore',
          \   'enew!',
          \
          \   '/.vimrc',
          \   '/.vim'
          \;
          \ 'line_number_at_window_top' : 1 

          " windows are filled with the order of elements
          " in 'fill_specs' You want to spec something for each
          " of the windows created by :Tabwins 232,
          " either commands, filepaths, or dirpaths. Spec an empty
          " string to bypass the fill of a window buffer.
          " Specs can include shell or vim vars, and if files or dirs
          " the spec can include a vim command or use the default :edit or
          " :Explore call in Fill_tab()

          " NOTE-the .vim file implementation defines 'home_parent_dirpath' as
          " as a vimscript var, i.e. 's:home_parent_dirpath' -- it's changed
          " here to facilitate interactive experimentation." ````

# LICENSE 
    Copyright (c) 2013, Charles E. Sheridan
   
    This program is free software; you can redistribute it
    and/or modify it under the terms of the GNU General Public
    License as published by the Free Software Foundation,
    version 3.0 of the License.
   
    This program is distributed in the hope that it will be
    useful, but WITHOUT ANY WARRANTY; without even the implied
    warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
    PURPOSE.
   
    See the GNU General Public License version 3.0 for more details.


# DEPLOYMENT
tabwins.vim tabwins/ dir is structured for deployment in a 
pathogen-managed bundle directory, e.g. ~/.vim/bundle/

If pathogen is not installed, copy the the files in the tabwins 
subdirs to the same subdirs in ~/.vim.
   
````vim
    Enable :h tabwins in a pathogen environment with
      :Helptags

    and in a non-pathogen environment with
      :helptags
    "
````

# DISTRIBUTIONS

github repository for this plugin: https://github.com/cesheridan/tabwins 

vim.org URL of this plugin: http://www.vim.org/scripts/script.php?script_id=4767

The distribution at vim.org is taken from the github repository.
