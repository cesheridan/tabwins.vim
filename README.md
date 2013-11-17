# Introduction

See the screen shots at
  https://github.com/cesheridan/graphics/tree/master/tabwins

1 command for immediate access to Vim customized window structures 
and content ~during~ Vim sessions.


The developer 
- Avoids hit-or-miss, time-consuming, manual, repetitious 
    runs of :split/:vsplit, and thought-sinks about how 
    to produce an intended window structure
- Avoids having to reload backed-up Vim sessions that 
    have the required window structures, thus losing the 
    current configuration
- Avoids loss of focus from these discontinuities


Easy access to the power of the Vim GUI.


COMMAND FORMS 

     :Tabwins {window_dimensions}; {fill_content,...};  {tab_options, ...}
     :{symmetric_command}          {fill_content,...};  {tab_options, ...}

     => semicolons separate arg groups, commas separate inside groups.

EXAMPLES 

     " For a new tab of 4 columns of 1, 2, 1, & 1 windows successively
     " left to right, with buffers empty --
     :Tabwins 1211 

     :Tabwins 1211;  $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin' 
     " Populate the buffers
     " => 'fill_content' specs of files are automatically opened via :edit,
     "    while specs of dirs are opened via :Explore
     " (Specify an '' empty string for windows intended to be empty.)

     :Tabwins 11111; $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin' 
     " Same buffer content, in different window structure, of 5 cols, 
     " one window in each.

     :V5x1           $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin' 
     " Structure & content as above -- since the structure is 
     " SYMMETRIC, i.e. lengths of secondary axis dimensions are all 
     " equal, this alternative is available to reduce keystrokes.

     :V5             $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin' 
     " Same result again: since the secondary axis has only 1 
     " window for its dimensions, V5 is available as an even
     " shorter alias.

      :Tabwins 1112;  $HOME, '~/.bashrc', '~/.vimrc', '/', 'Explore /usr/bin | resize 20' 
     " Same content, different structure, which includes :resize of the last window,
     " via Vim '|' cmd concat.  If a file or dir is followed with concated commands,
     " the caller needs to explicitly add the command that opens the file or dir, 
     " i.e. 'Explore' in this example.

EXAMPLES: Dimensions >9 

Dimensions >9 are unparsable when {window_dimensions} is an integer.  To enable dimensions >9, use list syntax:

     :Tabwins [ 8, 15, 23, 38] 
     " For a 4-column tab with 8, 15, 23, & 38 windows successively.
     " {fill_content} can be added as with all tabwins.vim commands.

     :Tabwins [ 18, 23 ] 

     :Tabwins [ 14, 14 ] 
     " Alternately, :V2x14

     :Tabwins [ 35, 30, 40, 40 ] 
     " For large monitors ...


EXAMPLES: {tab_options}  ** AVAILABLE IN A LATER RELEASE ** 

     [ these are available to callers of function Fill_tab(),
     but not yet to the Vim command line ]

     :Tabwins 1211;  $HOME, '~/.bashrc', '~/.vimrc', '/', '/usr/bin'; 'ending_window_number' : 2

     These have tab-scope.  For window-scoped options, concatenate 
     code to {fill_specs}, as shown above.

     Also see tabwins.txt section TabwinsAddingNewBuilders.

COMMANDS :Tabwins, :TabwinsVertical, & :TabwinsHorizontal 

:Tabwins is an alias for :TabwinsVertical, which gives priority to the vertical axis.

:TabwinsHorizontal gives priority to the horizontal axis.

See tabwins.txt section TabwinsVandH re vertical/horizontal & primary/secondary axes.




COMMAND TYPES :VJxK, :VJ, :HJxK, & :HJ 

Loading tabwins.vim creates Vim commands that have name formats
as described in section |TabwinsUsage| of tabwins.txt.

See above examples.


MENU 'Tabwins' 

  Default settings load Vim menu Tabwins, for access to selected 
  tab-builder commands.  Those and additional tab builders are 
  available via Vim commands defined in tabwins.vim. The menu has 
  only a small portion of the tab builders defined in tabwins.vim,
  and the developer is encouraged to add tab builder commands as needed.



# Deployment

This plugin is structured for deployment in a pathogen-managed
bundle directory.

If pathogen is not installed, copy the the files in the tabwins
subdirs to the same subdirs in ~/.vim.

# Documentation

See doc/tabwins.txt for more information, or view that file via
Vim :help.

An html version of the .txt file is at
http://htmlpreview.github.io/?https://github.com/cesheridan/tabwins/blob/master/tabwins.txt.html   
