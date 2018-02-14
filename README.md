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

### FORMS 
````vim
    :{Tabwins cmd}   {window_dimensions}; {fill_spec,...};  {tab_option, ...} 
    :{symmetric cmd}                      {fill_spec,...};  {tab_option, ...} 
   
    Where
       :{Tabwins cmd} is any of :Tabwins, :TabwinsVertical, :TabwinsHorizontal 
       Aliases                  :Tw,      :V,             & :H 
       About aliases, see tabwins.txt section "Configuration"
   
       :{symmetric cmd} is any of the form :{V|H}IxJ or :{V|H}I  
   
       'fill_spec'  
       is a file, dir, shell/vim var, or string evaluable
       by :execute -- see EXAMPLES
   
       'tab_option' 
       has Vim key:value pair syntax -- see EXAMPLES
   
    Semicolons separate arg groups, commas separate inside groups.
   
    {window_dimensions} is the only mandatory arg, for :{Tabwins cmd}  ````
SECTION "Usage" HAS MORE DETAIL. 

### EXAMPLES

#### Empty Windows 
````vim
    :Tabwins 1211 
    :T       1211 
    " For a new tab of 4 columns of 1, 2, 1, & 1 windows successively
    " left to right.
   
    :TabwinsHorizontal 4221 
    :H                 4221 
    " For a new tab of 4 rows, with 4,2,2, & 1 windows successively 
    " top to bottom
    "  ````

#### Populated Windows 
````vim
    :Tabwins            1211; $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin' 
    :T                  {                   as above                        } 
    " 'fill_content' specs of files are automatically opened via :edit,
    " while specs of dirs are opened via :Explore
    " (Specify the '' empty string for windows intended to be empty.)
   
    :Tabwins           11111; $HOME, '/.bashrc', '~/.vimrc', '/', '/usr/bin' 
    :T                 {                    as above                        } 
    " Same buffer content, in different window structure, of 5 cols, 
    " one window in each.
   
    :TabwinsHorizontal 11111; $HOME, '/.bashrc', '/.vimrc', '/', '/usr/bin' 
    :H                 {                    as above                        } 
    " Flip axis priority of above to the horizontal
   
    :Tabwins             312; '/.bashrc', '/.vimrc', '/.git', $HOME, '/', '/usr/bin' 
    :T                   {                  as above                                  } 
    ````

#### Symmetric Window Structures 
![alt text][gif2]
[gif2]: ./doc/gif/tabwins.2dimension.HV.gif?raw=true  "gif2"
    In a symmetric window, all secondary axis dimensions are the same.
````vim
    :V5x8 
    :H5x8 
    :V6 
    :H6 
    :V8x14 
    :H8x14 
    " Empty windows
   
    :V5x1 
   
    :V5x1 $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin' 
    " Structure & content same as :Tabwins 11111 above
   
    :V5   $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin' 
    " Same result again: since the secondary axis has only 1 
    " window for its dimensions, V5 is available as an even
    " shorter alias.
    "

````
#### Dimensions >9
````vim
    :Tabwins [ 5, 8, 13, 21 ] 
    :T       [ 5, 8, 13, 21 ] 
    " For a 4-column tab with 5, 8, 13, 21 windows successively left to right.
   
    :Tabwins [ 14, 14 ] 
    :T       [ 14, 14 ] 
    " Or,      :V2x14
   
    :Tabwins [ 40, 30, 40, 30 ] 
    :T       [ 40, 30, 40, 30 ] 
    " For large monitors ...
    "
````


#### fill_specs with Multiple Commands
````vim
    :Tabwins 1112;  $HOME, '~/.bashrc', '~/.vimrc', '/', 'Explore /usr/bin | resize 20' 
    :T       {                           as above                                     } 
    " Does a :resize of the last window, via Vim '|' command concat.  If a file 
    " or dir is followed with concated commands, the caller needs to explicitly 
    " add the command that opens the file or dir, i.e. 'Explore' in this example.
    "
````

#### Tab Options
````vim
    :Tabwins 1211;  $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin'; 'ending_window_number' : 2 
    :Tabwins 1211;  $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin'; 'netrw_liststyle'      : 3 
    :T              {                    as above                                             } 
   
    :Tabwins 1211;  $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin'; 'netrw_liststyle'      : 3, 'ending_window_number' : 2 
    :T              {                    as above                                                                         }  " Multiple tab_options in same command.  
    "
````

#### TABWINS MENU

    Default settings load Vim menu Tabwins, for access to selected tab-builder commands.  
    
    Those and additional tab builders are available via Vim commands defined in tabwins.vim. 
    The menu has only a small portion of the tab builders defined in tabwins.vim.



#### DEPLOYMENT
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


# Section 2: Usage                                     

* See FORMS    in Introduction
* See EXAMPLES in Introduction


#### THREE TABWINS COMMANDS
    These commands all take the same arguments.

````vim
    :Tabwins 
    " Same as :TabwinsVertical
    " Default alias :T 
   
    :TabwinsVertical  
    " Priority to the vertical axis.
    " Default alias :V 
   
    :TabwinsHorizontal  
    " Priority to the horizontal axis.
    " Default alias :H 
    "
````

*  See "Vertical & Horizontal" about primary/secondary axes and vertical/horizontal priority.

* See "Configuration" re aliases.

  These commands accept arbitrary dimension specification, unconstrained by configuration vars, other than windows-per-tabsize limits of the Vim instance.


#### SYMMETRIC WINDOW STRUCTURES 

In these, the lengths of the secondary axis dimensions are all equal.

Symmetric commands are available to reduce keystrokes.

'H' indicates horizontal priority, 'V' vertical priority.

Loading tabwins.vim creates :{V|H}IxJ commands where the set of IxJ is the permutations of:
````vim
      g:tabwins_max_v_size  
      g:tabwins_max_h_size  
````
   
    The same global vars determine the set of :{V|H}J commands 
    also produced on tabwins.vim load, where N is from 1 to the 
    value of the relevant g:tabwins_max_{h|v}_size var above.


#### DIMENSIONS GREATER THAN 9 

Dimensions >9 are unparsable when {window_dimensions} is an integer.  

To enable dimensions >9, use list syntax as shown in EXAMPLES of "Introduction"

List syntax applies to any tab that one or more dimension >9.  All the dimensions of such a tab are specified in one list.



#### FILL SPECS WITH MULTIPLE COMMANDS 

Multiple Vim commands can be specified in a fill_spec by prepending commands with the Vim '|' concatenation operator.

See EXAMPLES in "Introduction"


#### TAB OPTIONS 

Available tab_options are below, with global default vars on the right.  

See tabwins.txt section "Configuration" re the globals.

These options apply to the entire tab and can be combined when separated by commas. 
      
````vim
       'explore_cmd_name'          : g:tabwins_explore_cmd_name_default,
       'netrw_liststyle'           : g:tabwins_netrw_liststyle_default,
       'line_number_at_window_top' : g:tabwins_netrw_line_number_default,
   
      " => Use a fill_spec for window-specific override of the 
          above options 
   
       'first_window_number'       : g:tabwins_first_window_number_default,
      " => window population starts with this number, so you wouldn't
          have to have to have a fill_spec for lower-numbered windows.
   
       'ending_window_number'      : g:tabwins_ending_window_number_default,
      " => the active window number after tabwins.vim builds a tab
       "
   
    See EXAMPLES in "Introduction"
````


## VERTICAL & HORIZONTAL
    
Windows are built one axis at a time. The first axis built
is the **primary axis**, and the other axis is the **secondary axis.**
If the tab starts by building the vertical axis, then the
vertical axis is the primary axis, and the horizontal axis
is the secondary axis. And vice-versa.

What's the difference between Horizontal & Vertical Tabs ? 

  Structurally, V2x3 is the same as H3x2.  The only difference
  is how Vim numbers the tabs, based on the axis that is the 
  primary axis.  
  
  IF the primary axis is vertical, then numbering starts in 
  col 1 and goes down the windows in col 1, then to the top 
  of col 2, then down col 2, and so on.  
  
  IF the primary axis is horizontal, numbering starts in 
  row 1 and goes left to right, then to row 2, left to right, 
  and so on.

  Most of the asymmetric tab builders defined in the plugin 
  use a vertical primary axis.  Developers can define any 
  mix of primary axis in their own tab builders -- See
  "Adding New Builders"


## TABWINS MENU  

In the 'Tabwins' menu built on plugin load, the extent that 
populated tabs fill their buffers is dependent on the shell 
vars available to the Vim session, and files/dirs present in 
the local environment.

The menu items reference some of these shell vars.  

The developer is encouraged to customize this menu for local usage.

Update or replace
  function Tabwins_menu_build() 
in tabwins.vim to do so.


## CONFIGURATION  
````vim
    The below globals are defined in tabwins.vim and are overridable.
   
    To change Vertical/Horizontal max dimensions:
      let g:tabwins_max_v_size                   = {N}
      let g:tabwins_max_h_size                   = {N}  
    Default: 15 for each
   
    To limit tabwins.vim load to once per Vim session:
      let g:tabwins_multiple_loads_are_permitted = 'N' 
    Default: 'Y'
   
    To prevent 'Tabwins' menu addition when tabwins loads:
      let g:load_tabwins_menu_is_wanted          = 'N' 
    Default: 'Y'
   
    To change the 'Tabwins' menu number:
    ````
MISSING 
MISSING 

## ADDING NEW BUILDERS

#### Adding Symmetric tab commands 

    Bump either/both values of:
````vim
      g:tabwins_max_v_size 
      g:tabwins_max_h_size 
    above the values assigned in tabwins.vim. 
    
    Loading tabwins.vim will build commands for all the HxV and 
    VxH permutations.
   
    Of course, the set of symmetric tab builder commands can be 
    reduced by lowering the values of the same globals.
    ````


#### More Generally 
  
  Adapt the below example to create your own commands that build tabs
  that have the window structures and content that you want.

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
          " here to facilitate interactive experimentation.
          "
    ````


*  See the other demo commands at end of the tabwins.vim.

*  See HELP in TabwinsUsage

## License 
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


## Bugs
Send bug reports and proposed fixes to opensource at att.net


## Distributions

github repository for this plugin: https://github.com/cesheridan/tabwins 

vim.org URL of this plugin: http://www.vim.org/scripts/script.php?script_id=4767

The distribution at vim.org is taken from the github repository.
