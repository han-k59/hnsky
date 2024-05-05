How to compile HNSKY:

1) Install Lazurus  (this will also install Free Pascal Compiler)


2a) Start Lazarus GUI.  Load hnsky.lpi (or hnsky_linux.lpi or hnsky_macos.lpi). Menu Run, Run or Compile

2b) Command line:

  Windows: 
     lazbuild -B hnsky.lpi

  Linux:  
    lazbuild -B hnsky_linux.lpi

  Mac:  
    lazbuild -B hnsky_macos.lpi

To include package Synape, just load ./synapse/laz_synapse.lpk package in the editor of Lazarus.  Then load hnsky.lpi (or hnsky_linux.lpi or hnsky_macos.lpi) and compile.

