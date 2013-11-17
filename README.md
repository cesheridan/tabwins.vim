# Introduction

See the screen shots at
  https://github.com/cesheridan/graphics/tree/master/tabwins


tabwins.vim creates and enables definition of Vim commands that 
BUILD TABS with: 

  1) SYMMETRIC  window structures of EMPTY BUFFERS  
  
     e.g. for 4 columns, each with 2 windows --
       :TabwinsVertical 2222  OR
       :Tabwins         2222  OR
       :V4x2

     e.g. for 2 columns, each with 12 windows --
        :TabwinsVertical [ 12, 12 ]  OR
        :Tabwins         [ 12, 12 ]  OR
        :V2x12

       => Use a list arg for :Tabwins* dimensions >9, as above. 


  2) ASYMMETRIC window structures of EMPTY BUFFERS 

     e.g. for 4 columns, of 2, 1, 1, & 3 windows successively --
       :TabwinsVertical 2113 
       :Tabwins         2113 

     e.g. for 4 columns, of 18, 5, 26, & 3 windows successively --
       :TabwinsVertical  [ 18, 5, 26, 3 ]
       :Tabwins          [ 18, 5, 26, 3 ]

       => Use a list arg for :Tabwins* dimensions >9, as above. 


  3) EITHER of the above structures, with BUFFERS POPULATED 
     by files, dirs, or results of running :execute on 
     user-specified strings. 

     e.g. :Open_tab_unix_filesystem_1 for an asymmetric V234 tab populated with typical unix dirs.


See section 'Vertical & Horizontal' in doc/tabwins.txt for definitions of 
Vertical and Horizontal tabs, and of Primary and Secondary axes.

Default settings load Vim menu Tabwins, for access to selected 
tab-builder commands.  Those and additional tab builders are 
available via Vim commands defined in tabwins.vim. The menu has 
only a small portion of the tab builders defined in tabwins.vim,
and the developer is encouraged to add tab builder commands as needed.

By enabling customized tab creation ~during~ Vim sessions, 
tabwins.vim gives each developer immediate access to the Vim 
window structures and content that the developer uses the most.

The developer 
  - avoids having to reload backed up Vim sessions,  
  - avoids losing the current configuration, and 
  - avoids loss of focus caused by these discontinuities.

Easy access to the power of the Vim GUI. 



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
