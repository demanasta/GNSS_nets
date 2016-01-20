# Plot GNSS Networks in Greece
plot all continuous an campaign GNSS networks processing at DSO automated platform and campaign networks.

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

If you don't use database you must set input files as bellow

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
# 1. Plot Campaign GPS Networks (campaign_nets.sh)
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

