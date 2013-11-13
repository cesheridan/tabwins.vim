# Introduction

See the screen captures at
  https://github.com/cesheridan/graphics/tree/master/tabwins


tabwins.vim creates and enables definition of Vim commands that 
BUILD TABS with: 

  1) SYMMETRIC  window structures of EMPTY BUFFERS  

     e.g. :V4x2 for 4 columns, each with 2 windows


  2) ASYMMETRIC window structures of EMPTY BUFFERS 

     e.g. :V2113 for 4 columns, of 2, 1, 1, & 3 windows respectively


  3) EITHER of the above structures, with BUFFERS POPULATED 
     by files, dirs, or results of running :execute on 
     user-specified strings. 

     e.g. :Open_tab_unix_filesystem_1 for an asymmetric V234 tab populated with typical unix dirs.


Loading tabwins.vim creates vim commands that have name formats
as described in the TabwinsUsage section of doc/tabwins.txt.

Default settings load Vim menu Tabwins, for access to selected 
tab-builder commands.  Those and additional tab builders are 
available via vim commands defined in tabwins.vim. The menu has 
only a small portion of the tab builders defined in tabwins.vim,
and the user is encouraged to add tab builder commands as needed.

By enabling customized tab creation ~during~ sessions, tabwins.vim
gives Vim users immediate access to the window structures and
content that they most commonly use.  The Vim user is saved from
having to reload backed up Vim sessions, and the consequent 
loss of current configuration, and the loss of user focus that 
follows.  

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

# Pending Release
The next release includes new commands to build arbitrarily-dimensioned symmetric AND asymmetric tabs. 
The code is working and release is pending deployment overhead. 

Example invocation1
    Build a tab of 4 vertical spaces, w/ 1, 3, 4, and 6 windows successively from left to right. 
    
    :Tabwins_vertical 1346               

Example invocation2
    Build a tab of 4 vertical spaces, w/ 18, 12, 1, and 4 windows successively from left to right.  
    
    :Tabwins_vertical [18, 12, 1, 4]   
    
    Parsing of the int in the previous example treats each digit as a separate dimension, so dimensions 
    cannot be larger than 9 for integer args.  The list arg in this example gets around that limit. 
