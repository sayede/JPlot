# JPlot

JPlot is a Perl/JavaScript library that produce interactive charts for WIEN2K code. It produces the same kind of plots (Density of States, Bandstructure and Optical properties) as the native WIEN2K interface but with no 3th program (i.e. gnuplot).

### Installation 
 
 * Download the latest release (see above, zip or tar.gz)
 * Extract JPlot out the compressed files( zip or tar.gz) : `unzip master.zip` or`tar -xzvf master.tar.gz`
 * Enter in JPlot directory : `cd JPlot/`
 * Execute the bash script `./INSTALL` in the JPlot folder following all prompts until completion

This will add two buttons to the w2web interface, one in the bandstructure task add1 and an other in the DOS task.

### Usage 

The [wiki](https://github.com/sayede/JPlot/wiki) has a set of example plots made with JSplot.

### Contributing 

Bug reports and fixes, suggestions, and so on should be submitted via GitHub as [Issues](https://github.com/sayede/JPlot/issues) or [Pull Requests](https://github.com/sayede/JPlot/pulls).

### Dependence
	
JPlot use : 
* JQuery
* Bootstrap
* Bootbox 
* jQuery UI
* Highcharts

Those libraries are already contained in the zip or tar.gz archive. It is not necessary to install them.
