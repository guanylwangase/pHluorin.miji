# pHluorin.miji
These scripts are made for quantification of pHluorin exocytosis movies.
Note that these scripts are provided on an as is basis with no garantees or support. This is a work in progress, major changes and bugs are expected.
Note that these scripts are intended for academic use only. You can redistribute it and/or modify it under the terms of the GNU General Public License as published bythe Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This project is no longer under active development. pHluorin.ijm is a enhenced version of this project wrote with ImageJ Macro and don't need Matlab anymore.  

https://github.com/guanylwangase/pHluorin.ijm

Setup:
1. MIJ plugin for ImageJ or FIJI is required.

http://imagej.nih.gov/ij/ 

http://bigwww.epfl.ch/sage/soft/mij/ 

http://fiji.sc/

2. You need to mannually setup the directory for temporaty files and for result output.

-line 12 dir in 02-Macro/Spotfinder.ijm and line 13 diroutput in 02-Macro/CoordinateFinder.ijm 

-[temppath] and [resultpath] in 01-Setup/Initialiser.m 

[temppath] should be identical with dir and [resultpath] should be identical with diroutput 

3. These scripts may not work correctly on ImageJ2-based version of FIJI later than "Fiji Life-Line version, 2013 July 15". These scripts were only tested on Matlab 2010 and 2012.

