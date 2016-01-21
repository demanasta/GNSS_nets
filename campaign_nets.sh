#!/bin/bash
#plot network forseismo platform
# //////////////////////////////////////////////////////////////////////////////
# HELP FUNCTION
function help {	echo "
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
	-logo [:=logo] plot logos
	-jpg : convert eps file to jpg
	-h [:= help] help menu

	Exit Status:    1 -> help message or error
	Exit Status:    0 -> sucesseful exit

	run:
/******************************************************************************/"
	exit 1
}

# //////////////////////////////////////////////////////////////////////////////
# GMT parameters
gmt gmtset MAP_FRAME_TYPE fancy
gmt gmtset PS_PAGE_ORIENTATION portrait
gmt gmtset FONT_ANNOT_PRIMARY 10 FONT_LABEL 10 MAP_FRAME_WIDTH 0.12c FONT_TITLE 18p
# gmtset PS_MEDIA 29cx21c

# //////////////////////////////////////////////////////////////////////////////
# Pre-defined parameters for bash script
REGION="greece"
TOPOGRAPHY=0
LABELS=0
LOGO=0
OUTJPG=0
LEGEND=0

CNET_AEGEAN=0
CNET_CENTRCR=0
CNET_CORINTH=0
CNET_EVIA=0
CNET_GREVENA=0
CNET_HELLNET=0
CNET_IONIAN=0
CNET_ROADS=0
CNET_SING=0


FGNSS=0
DBGNSS=0

if [ ! -f "gmtparam" ]
then
	echo "gmtparam file does not exist"
	exit 1
else
	source gmtparam
fi

# //////////////////////////////////////////////////////////////////////////////
# Set PATHS parameters
# pth2dems=${HOME}/Map_project/dems

# # //////////////////////////////////////////////////////////////////////////////
# # Set FILE parameters
# greece_sta=greece.sites
# sant_sta=santorini.sites
# uranus_sta=uranus.sites
# metrica_sta=metrica.sites
# gps_sta=${pth2nets}/net-gps.est
# gps_fsta=${pth2nets}/net-gps.fut
# seism_sta=${pth2nets}/net-seism.est
# seism_fsta=${pth2nets}/net-seism.fut
# accel_sta=${pth2nets}/net-accel.est
# accel_fsta=${pth2nets}/net-accel.fut
# tg_sta=${pth2nets}/net-tg.est
# tg_fsta=${pth2nets}/net-tg.fut

# # //////////////////////////////////////////////////////////////////////////////
# # Set Network Style Ploting
# gr_style="-St0.28c -W0.01c/0 -Gred"
# sa_style="-St0.25c -W0.01c/0 -Ggreen"
# ur_style="-St0.24c -W0.01c/0 -Gblue"
# me_style="-St0.20c -W0.01c/0 -Gblack"


# # //////////////////////////////////////////////////////////////////////////////
# # Pre-defined parameters for GMT
# outfile=test.eps
# out_jpg=test.jpg
# inputTopoL=${pth2dems}/ETOPO1_Bed_g_gmt4.grd
# inputTopoB=${pth2dems}/ETOPO1_Bed_g_gmt4.grd
# #inputTopoL=$HOME/Map_project/dems/ETOPO1_Bed_g_gmt4.grd
# #inputTopoB=$HOME/Map_project/dems/ETOPO1_Bed_g_gmt4.grd
# # frame=2
# # scale=-Lf20/34.5/36:24/100+l+jr
# # range=-R19/29/34/42
# # proj=-Jm24/37/1:6000000
# landcpt=land_man.cpt
# bathcpt=bath_man.cpt
# maptitle=""
# pth2logos=$HOME/Map_project/logos



# //////////////////////////////////////////////////////////////////////////////
# GET COMMAND LINE ARGUMENTS
if [ "$#" == "0" ]
then
	help
fi

while [ $# -gt 0 ]
do
	case "$1" in
		-r)
			REGION=$2
			shift
			shift
			;;
		-mt)
			maptitle=$2
			shift
			shift
			;;
		-fgnss)
			FGNSS=1
			shift
			;;
		-dbgnss)
			echo "DBASE not supported yet for campaign sites"
			DBGNSS=0
			exit 1
			shift
			;;
		-cAegean)
			CNET_AEGEAN=1
			shift
			;;
		-cCentrGR)
			CNET_CENTRCR=1
			shift
			;;
		-cCorinth)
			CNET_CORINTH=1
			shift
			;;
		-cEvia)
			CNET_EVIA=1
			shift
			;;
		-cGrevena)
			CNET_GREVENA=1
			shift
			;;
		-cHELLNET)
			CNET_HELLNET=1
			shift
			;;
		-cIonian)
			CNET_IONIAN=1
			shift
			;;
		-cRoads)
			CNET_ROADS=1
			shift
			;;
		-cSING)
			CNET_SING=1
			shift
			;;
		-topo)
#                       switch topo not used in server!
			TOPOGRAPHY=1
			shift
			;;
		-o)
			outfile=${2}.eps
			out_jpg=${2}.jpg
			shift
			shift
			;;
		-l)
			LABELS=1
			shift
			;;
		-leg)
			LEGEND=1
			shift
			;;
		-logo)
			LOGO=1
			shift
			;;
		-jpg)
			OUTJPG=1
			shift
			;;
		-h)
			help
			;;
	esac
done


###check dems
if [ "$TOPOGRAPHY" -eq 1 ]
then
	if [ ! -f $inputTopoB ]
	then
		echo "grd file for topography toes not exist, var turn to coastline"
		TOPOGRAPHY=0
	fi
fi

###check LOGO file
if [ ! -f "$pth2logos" ]
then
	echo "Logo file does not exist"
	LOGO=0
fi

# ///////////////// set region //////////////////////////////////
if [ "$REGION" == "sant" ]
then
gmt	gmtset PS_MEDIA 22cx21c
	frame=0.05
        scale=-Lf25.51/36.315/36:24/4+l+jr
        range=-R25.27/25.55/36.3/36.5
        proj=-Jm25.4/36.4/1:150000
        logo_pos=BL/0.2c/0.2c/"DSO[at]NTUA"
        logo_pos2="-C15.2c/13.6c"
        legendc="-Jx1i -R0/8/0/8 -Dx0c/0.3c/3.6c/4.7c/BL"
elif [ "$REGION" == "extsant" ]
then
gmt	gmtset PS_MEDIA 25cx21c
        frame=0.25
        scale=-Lf25.95/36.315/36:24/10+l+jr
        range=-R25.2/26.1/36.2/36.9
        proj=-Jm25.4/36.4/1:500000
        logo_pos=BL/0.2c/0.2c/"DSO[at]NTUA"
        logo_pos2="-C14.8c/0.1c"
        legendc="-Jx1i -R0/8/0/8 -Dx11c/3.3c/3.6c/4.7c/BL"
        
elif [ "$REGION" == "saegean" ] #-------------------saegean 
then
gmt	gmtset PS_MEDIA 29cx21c
        frame=2
        scale=-Lf22/34.3/36:24/100+l+jr
        range=-R21/30.5/34/38.7
        proj=-Jm24/36/1:3450000
	logo_pos=BL/19c/0.2c/"DSO[at]NTUA"
        logo_pos2="-C23.3c/13.8c"
	legendc="-Jx1i -R0/8/0/8 -Dx20c/0.3c/3.6c/4.7c/BL"
elif [ "$REGION" == "grCyprus" ] #-------------------greece - cyprus extended
then  
gmt	gmtset PS_MEDIA 29cx21c
        frame=2
        scale=-Lf20/34.5/36:24/100+l+jr
        range=-R19/35/34/42
        proj=-Jm24/37/1:6000000
        logo_pos=BL/18c/0.2c/"DSO[at]NTUA"
        logo_pos2="-C22c/13.7c"
        legendc="-Jx1i -R0/8/0/8 -Dx.4c/0.2c/3.6c/4.7c/BL"      
elif [ "$REGION" ==  "corinth" ] #-----------------corinth rift 
then
gmt	gmtset PS_MEDIA 21cx15c
	frame=.5x
	scale=-Lf21.2/37.9/36:24/20+l+jr
	range=-R21/23/37.8/38.68
	proj=-Jm24/37/1:1100000
	logo_pos=BL/19c/0.2c/"DSO[at]NTUA"
	logo_pos2="-C14.8c/0.1c"
	legendc="-Jx1i -R0/8/0/8 -Dx0.3c/0.6c/3.6c/4.3c/BL"	
else
gmt	gmtset PS_MEDIA 21cx21c
        frame=2
        scale=-Lf20/34.5/36:24/100+l+jr
        range=-R19/30/34/42
        proj=-Jm24/37/1:6000000
        logo_pos=BL/10.4c/0.2c/"DSO[at]NTUA"
        logo_pos2="-C14.8c/0.9c"
        legendc="-Jx1i -R0/8/0/8 -Dx0.3c/0.2c/3.6c/4.3c/BL"     

fi

# ####################### TOPOGRAPHY ###########################
if [ "$TOPOGRAPHY" -eq 0 ]
then
	################## Plot coastlines only ######################
gmt	psbasemap $range $proj $scale -B$frame:."$maptitle": -P -K > $outfile
gmt	pscoast -R -J -O -K -W0.25 -G195 -Df -Na -U$logo_pos >> $outfile
# 	psbasemap -R -J -O -K --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p >> $outfile
fi
if [ "$TOPOGRAPHY" -eq 1 ]
then
	# ####################### TOPOGRAPHY ###########################
	# bathymetry
gmt	makecpt -Cgebco.cpt -T-5000/100/150 -Z > $bathcpt
gmt	grdimage $inputTopoB $range $proj -C$bathcpt -K > $outfile
gmt	pscoast $proj -P $range -Df -Gc -K -O >> $outfile
	# land
gmt	makecpt -Cgray.cpt -T-5000/1800/50 -Z > $landcpt
gmt	grdimage $inputTopoL $range $proj -C$landcpt  -K -O >> $outfile
gmt	pscoast -R -J -O -K -Q >> $outfile
	#------- coastline -------------------------------------------
gmt	psbasemap -R -J -O -K --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p >> $outfile
gmt	pscoast -Jm -R -B$frame:."$maptitle": -Df -W.2,black -K  -O -U$logo_pos >> $outfile
fi

# start create legend file .legend
echo "G 0.2c" > .legend
echo "H 9 Times-Roman $maptitle" >> .legend
echo "D 0.3c 1p" >> .legend
echo "N 1" >> .legend

# ///////////////// PLOT AEGEAN NETWORKS //////////////////////////////////
if [ "$CNET_AEGEAN" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='GREECE';" \
		| grep -v + \
		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-gre
		gmt psxy tmp-gre -Jm -O -R $gr_style -K >> $outfile
		if [ "$LABELS" -eq 1 ]
		then		
			gmt pstext tmp-gre -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			
		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $aegean_sta ]
		then
			echo "input file $aegean_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $aegean_sta | gmt psxy -Jm -O -R $aegean_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"RB",$1}' $aegean_sta | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
	# 	        echo "G 0.25c" >> .legend
	# 		echo "S 0.4c t 0.22c red 0.22p 0.6c GREECE" >> .legend
		fi
	fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c t 0.20c red 0.22p 0.6c Aegean" >> .legend
	
	
fi

# ///////////////// PLOT CENTRAL CREECE NETWORKS //////////////////////////////////
if [ "$CNET_CENTRCR" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='GREECE';" \
		| grep -v + \
		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-gre
		gmt psxy tmp-gre -Jm -O -R $gr_style -K >> $outfile
		if [ "$LABELS" -eq 1 ]
		then		
			gmt pstext tmp-gre -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			
		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $centrgr_sta ]
		then
			echo "input file $centrgr_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $centrgr_sta | gmt psxy -Jm -O -R $centrgr_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"RB",$1}' $centrgr_sta | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
	# 	        echo "G 0.25c" >> .legend
	# 		echo "S 0.4c t 0.22c red 0.22p 0.6c GREECE" >> .legend
		fi
	fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c c 0.14c red 0.22p 0.6c Central Greece" >> .legend
fi

# ///////////////// PLOT CORINTH NETWORKS //////////////////////////////////
if [ "$CNET_CORINTH" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='GREECE';" \
		| grep -v + \
		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-gre
		gmt psxy tmp-gre -Jm -O -R $gr_style -K >> $outfile
		if [ "$LABELS" -eq 1 ]
		then		
			gmt pstext tmp-gre -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			
		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $corinth_sta ]
		then
			echo "input file $corinth_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $corinth_sta | gmt psxy -Jm -O -R $corinth_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"RB",$1}' $corinth_sta | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
	# 	        echo "G 0.25c" >> .legend
	# 		echo "S 0.4c t 0.22c red 0.22p 0.6c GREECE" >> .legend
		fi
	fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c c 0.10c green 0.22p 0.6c Corith Gulf" >> .legend
	
	
fi

# ///////////////// PLOT EVIA NETWORKS //////////////////////////////////
if [ "$CNET_EVIA" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='GREECE';" \
		| grep -v + \
		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-gre
		gmt psxy tmp-gre -Jm -O -R $gr_style -K >> $outfile
		if [ "$LABELS" -eq 1 ]
		then		
			gmt pstext tmp-gre -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			
		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $evia_sta ]
		then
			echo "input file $evia_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $evia_sta | gmt psxy -Jm -O -R $evia_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"RB",$1}' $evia_sta | gmt  pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
	# 	        echo "G 0.25c" >> .legend
	# 		echo "S 0.4c t 0.22c red 0.22p 0.6c GREECE" >> .legend
		fi
	fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c c 0.08c 204/51/255 0.22p 0.6c Evia" >> .legend
	
	
fi

# ///////////////// PLOT GREVENA NETWORKS //////////////////////////////////
if [ "$CNET_GREVENA" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='GREECE';" \
		| grep -v + \
		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-gre
		gmt psxy tmp-gre -Jm -O -R $gr_style -K >> $outfile
		if [ "$LABELS" -eq 1 ]
		then		
			gmt pstext tmp-gre -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			
		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $grevena_sta ]
		then
			echo "input file $grevena_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $grevena_sta | gmt psxy -Jm -O -R $grevena_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"RB",$1}' $grevena_sta | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
	# 	        echo "G 0.25c" >> .legend
	# 		echo "S 0.4c t 0.22c red 0.22p 0.6c GREECE" >> .legend
		fi
	fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c c 0.10c brown 0.22p 0.6c Grevena" >> .legend
	
	
fi

# ///////////////// PLOT HELLNET NETWORKS //////////////////////////////////
if [ "$CNET_HELLNET" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='GREECE';" \
		| grep -v + \
		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-gre
		gmt psxy tmp-gre -Jm -O -R $gr_style -K >> $outfile
		if [ "$LABELS" -eq 1 ]
		then		
			gmt pstext tmp-gre -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			
		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $hellnet_sta ]
		then
			echo "input file $hellnet_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $hellnet_sta | gmt psxy -Jm -O -R $hellnet_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"RB",$1}' $hellnet_sta | gmt  pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
	# 	        echo "G 0.25c" >> .legend
	# 		echo "S 0.4c t 0.22c red 0.22p 0.6c GREECE" >> .legend
		fi
	fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c c 0.12c 255/153/51 0.22p 0.6c HELLNET" >> .legend
	
	
fi

# ///////////////// PLOT IONIO NETWORKS //////////////////////////////////
if [ "$CNET_IONIAN" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='GREECE';" \
		| grep -v + \
		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-gre
		gmt psxy tmp-gre -Jm -O -R $gr_style -K >> $outfile
		if [ "$LABELS" -eq 1 ]
		then		
			gmt pstext tmp-gre -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			
		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $ionian_sta ]
		then
			echo "input file $ionian_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $ionian_sta | gmt psxy -Jm -O -R $ionian_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"RB",$1}' $ionian_sta | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
	# 	        echo "G 0.25c" >> .legend
	# 		echo "S 0.4c t 0.22c red 0.22p 0.6c GREECE" >> .legend
		fi
	fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c t 0.19c 0/153/0 0.22p 0.6c Ionian" >> .legend
	
	
fi

# ///////////////// PLOT ROADS NETWORKS //////////////////////////////////
if [ "$CNET_ROADS" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='GREECE';" \
		| grep -v + \
		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-gre
		gmt psxy tmp-gre -Jm -O -R $gr_style -K >> $outfile
		if [ "$LABELS" -eq 1 ]
		then		
			gmt pstext tmp-gre -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			
		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $roads_sta ]
		then
			echo "input file $roads_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $roads_sta | gmt psxy -Jm -O -R $roads_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"RB",$1}' $roads_sta | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
	# 	        echo "G 0.25c" >> .legend
	# 		echo "S 0.4c t 0.22c red 0.22p 0.6c GREECE" >> .legend
		fi
	fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c c 0.12c black 0.22p 0.6c ROADS" >> .legend
	
	
fi

# ///////////////// PLOT SING NETWORKS //////////////////////////////////
if [ "$CNET_SING" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='GREECE';" \
		| grep -v + \
		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-gre
		gmt psxy tmp-gre -Jm -O -R $gr_style -K >> $outfile
		if [ "$LABELS" -eq 1 ]
		then		
			gmt pstext tmp-gre -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			
		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $sing_sta ]
		then
			echo "input file $sing_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $sing_sta | gmt psxy -Jm -O -R $sing_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"RB",$1}' $sing_sta | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
	# 	        echo "G 0.25c" >> .legend
	# 		echo "S 0.4c t 0.22c red 0.22p 0.6c GREECE" >> .legend
		fi
	fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c t 0.18c blue 0.22p 0.6c SING" >> .legend
	
	
fi

echo "G 0.2c" >> .legend
echo "D 0.3c 1p" >> .legend

# ///////////////// PLOT LEGEND //////////////////////////////////
if [ "$LEGEND" -eq 1 ]
then
        gmt pslegend .legend ${legendc} -C0.1c/0.1c -L1.1 -O -K >> $outfile
fi

#/////////////////PLOT LOGO DSO
if [ "$LOGO" -eq 1 ]
then
gmt	psimage $pth2logos -O $logo_pos2 -W1.1c -F0.4  -K >>$outfile
fi

#//////// close eps file
echo "9999 9999" | gmt psxy -J -R  -O >> $outfile

#################--- Convert to jpg format ----##########################################
if [ "$OUTJPG" -eq 1 ]
then
	gs -sDEVICE=jpeg -dJPEGQ=100 -dNOPAUSE -dBATCH -dSAFER -r300 -sOutputFile=$out_jpg $outfile
fi

#rm tmp-*
rm .legend
rm *cpt

echo $?
