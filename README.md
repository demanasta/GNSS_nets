# Plot GNSS Networks in Greece
This repository includes bash scripts that use [Generic Tool Maps (Wessel et al., 2013)](http://gmt.soest.hawaii.edu/projects/gmt) to plot all continuous and campaign GNSS networks processed at DSO automated platform and campaign networks. Also a new script added to plot metadata from a MySQL, processed and unprocessed stations from a network, rms and baselined formed for the data processing.

#configuration files
1. dbparameters
copy dbparameters.default file to dbparameters and edit the variables to connect your database
```
#!bin/bash
#configure this file for the main database parameters
dbhost="database_hostname"
dbuser="username"
dbpasswd="password"
dbase="database_name"
db_table="database table"
db_code="column name with stations codes"
db_lat="column name include latitude"
db_lon="column name include longitude"
```
2. gmtparam :  config all gmt parameters, input and output file, paths, styles etc
3. regparam : NOT USED

If you don't use database you must set input files as bellow (only for scripts cGNSSnets.sh campaign_nets.sh)

name:network.sites

CODE longitute latitude

# 1. Plot Continuous GNSS Networks (cGNSSnets.sh)
plot all available continuous GNSS stations in Greece

use -h (help) to see all available switces
```
/******************************************************************************/
	Program Name : cGNSSnets.sh
	Version : v-1.0
	Purpose : Plot cGNSS network stations
	Usage   : cGNSSnets.sh -r region |  | -o [output] | -jpg 
Switches:
	-r [:= region] region to plot [saegean, sant, extsant]
		default : greece region
		sant : santorini
		extsant : extented santorini
		saegean : South aegean region 
		grCyprus: greece + cyprus
		corinth: corinth rift
	-mt [:= map title] title map default none use quotes
	-fgnss : use file for gps inform (*network*.sites)
	-dbgnss: use database for gps information

/*** NETWORKS  PLOTS **********************************************************/
	-ggr [:= gps greece] Plot GPS Stations
	-ggrcom [:= gps COMET] Plot GPS Stations
	-ggrnoa [:= gps NOANET] Plot GPS Stations
	-ggrcrl [:= gps CRL] Plot GPS Stations
	-ggreth [:=jHellas -ethz]

	-gsa [:= gps santorini]
	-gur [:= gps uranus]
	-gme [:= gps mterica]
	-ghp [:= gps hepos]

/*** OTHER OPRTIONS ************************************************************/
	-topo [:=topography] use dem for background
	-o [:= output] name of output files
	-l [:=labels] plot labels
	-leg [:=legend] insert legends
	-jpg : convert eps file to jpg
	-h [:= help] help menu

	Exit Status:    1 -> help message or error
	Exit Status:    0 -> sucesseful exit

	run:
/******************************************************************************/
```
## Example:
```
$ ./cGNSSnets.sh -fgnss  -jpg -topo -leg -logo -o test -ggrcom -ggrnoa -ggrcrl -gsa -gur -mt "Example 1" 

```

![Example1](https://raw.githubusercontent.com/demanasta/GNSS_nets/master/Example1.jpg)


# 2. Plot Campaign GPS Networks(campaign_nets.sh)
plot all available campaign GPS stations in Greece

use -h (help) to see all available switces
```
/******************************************************************************/
	Program Name : campaign_nets.sh
	Version : v-0.1
	Purpose : Plot cGNSS network stations
	Usage   :campaign_nets.sh -r region |  | -o [output] | -jpg 
Switches:
	-r [:= region] region to plot [saegean, sant, extsant]
		default : greece region
		sant : santorini
		extsant : extented santorini
		saegean : South aegean region
		grCyprus: greece + cyprus
		corinth: corinth rift
	-mt [:= map title] title map default none use quotes
	-fgnss : use file for gps inform (*network*.sites)
	-dbgnss: use database for gps information

/*** CAMPAIGN NETWORKS  PLOTS **********************************************************/
	-cAegean [:= campaign Aegean]
	-cCentrGR [:= campaign central greece]
	-cCorinth [:= campaign corinth]
	-cEvia [:= campaign Evia]
	-cGrevena [:= campaign Grevena]
	-cHELLNET [:= campaign HEELNET]
	-cIonian [:= campaign Ionian]
	-cRoads [:= campaign Roads]
	-cSING [:= campaign SING] Plot GPS Stations
        
/*** OTHER OPRTIONS ************************************************************/
	-topo [:=topography] use dem for background
	-o [:= output] name of output files
	-l [:=labels] plot labels
	-leg [:=legend] insert legends
	-jpg : convert eps file to jpg
	-h [:= help] help menu

	Exit Status:    1 -> help message or error
	Exit Status:    0 -> sucesseful exit

	run:
/******************************************************************************/
```
## Example:
```
$ ./campaign_nets.sh -topo -jpg -leg -logo -fgnss -cAegean -cCorinth -cHELLNET -cSING -mt "Example 2"

```

![Example2](https://raw.githubusercontent.com/demanasta/GNSS_nets/master/Example2.jpg)

# 3. Plot Processed GPS Networks (cGNSSproc.sh)
```
/******************************************************************************/
	Program Name : cGNSSproc.sh
	Version : v-1.0
	Purpose : Plot cGNSS network stations from procsta database
	Usage   : cGNSSnets.sh -r region |  | -o [output] | -jpg 
Switches:
	-r [:= region] region to plot [saegean, sant, extsant]
		default : greece region
		sant : santorini
		extsant : extented santorini
		saegean : South aegean region 
		grCyprus: greece + cyprus
		corinth: corinth rift
		europe: europe region
	-mt [:= map title] title map default none use quotes

/*** NETWORKS  PLOTS **********************************************************/
	-n (network) %select processed network from bellow
	   greece
	   uranus
	   santorini
	   ....etc

/*** SOLUTION PLOTS **********************************************************/
	-s (sol file)
	   -pall : plot all station network
	   -ppro : plot processing stations
	   -pell : plot ellipsis
	   -pbl  : plot baselines
	   
/*** OTHER OPRTIONS ************************************************************/
	-topo [:=topography] use dem for background
	-o [:= output] name of output files
	-l [:=labels] plot labels
	-leg [:=legend] insert legends
	-logo [:=logo] plot logo
	-jpg : convert eps file to jpg
	-h [:= help] help menu

	Exit Status:    1 -> help message or error
	Exit Status:    0 -> sucesseful exit

	run:
/******************************************************************************/
```
For plotting solution metadata should be created a solution file following the structure bellow:
```
# this is comments!
# FOR PROCESSED STATIONS:
##  CODE dx       dy      dz       rms_x  rms_y   rms_z    ell_a    ell_b     Az   typ  Longtitude Latitude   Height
##* **** ******* ******* ********  ****** ******* ******* ******** ******** ****** *** ********** ********** ******
01 ANKR  0.0148  0.00523 -0.00036 -0.0101 -0.0034 0.01154 0.000570 0.000620 085.80 EST 39.8873712 32.7584698 976.02
# FOR BASELINES (use BL for fisst 2 chars)
##  lat 1         lon 1         lat2         lon2     amb  typ
## *********** ************ ************ ************ **** ***
BL 40.56681913 23.003721009 41.140212284 24.916801994 66.0 W/N
```
take a look also at example file greece-15002-fin.proc


## Example:
Plot processed and unrocessed stations for network greece.
```
$ ./cGNSSproc.sh  -n greece  -jpg -s greece-15002-fin.proc -pall -ppro -leg -topo -mt "Example 3" -logo -o Example3

```
![Example3](https://raw.githubusercontent.com/demanasta/GNSS_nets/master/Example3.jpg)

## Example:
Plot Helmert rms and baselines for network greece
```
./cGNSSproc.sh -r europe -n greece -jpg -s greece-15002-fin.proc -pell -pbl -mt "Example 4" -leg -logo -o Example4
```
![Example4](https://raw.githubusercontent.com/demanasta/GNSS_nets/master/Example4.jpg)


# Updates
========
- 29-1-2015: added cGNSSpros.sh script
- 21-1-2015: online version is available

# References
=========

Wessel, P., W. H. F. Smith, R. Scharroo, J. F. Luis, and F. Wobbe, Generic Mapping Tools: Improved version released, EOS Trans. AGU, 94, 409-410, 2013.

# Contact
=========
Demitris Anastasiou, danast@mail.ntua.gr

Xanthos Papanikolaou, xanthos@mail.ntua.gr
