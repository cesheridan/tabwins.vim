# Introduction

tabwins.vim creates and enables definition of Vim commands that 
BUILD TABS with: 

  1) SYMMETRIC  window structures of EMPTY BUFFERS  

     e.g. :V4x2 for 4 columns, each with 2 windows


  2) ASYMMETRIC window structures of EMPTY BUFFERS 

     e.g. :V2113 for 4 columns, of 2, 1, 1, & 3 windows respectively


  3) EITHER of the above structures, with BUFFERS POPULATED 
     by files, dirs, or results of running :execute on 
     user-specified strings. 

     e.g. :Vim_help_tab1 for an asymmetric V1312 tab of Vim help entries


Loading tabwins.vim creates vim commands that have name formats
as described in |TabwinsUsage|.

Default settings load Vim menu Tabwins, for access to selected 
                      ~~~~~~~~~~~~~~~~~
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

See doc/tabwins.txt for more information, or view this file via
Vim :help.

An html version of the .txt file is at
http://htmlpreview.github.io/?https://github.com/cesheridan/tabwins/blob/master/tabwins.txt.html   


