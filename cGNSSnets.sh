#!/bin/bash
#plot network forseismo platform
# //////////////////////////////////////////////////////////////////////////////
# HELP FUNCTION
function help {	echo "
/******************************************************************************/
	Program Name : cGNSSnets.sh
	Version : v-1.1
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
	-logo [:=logo] plot logo
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

GNET_GREECE=0
GNET_SANT=0
GNET_URANUS=0
GNET_METRICA=0
GNET_HEPOS=0
GNET_GRCOM=0
GNET_GRNOA=0
GNET_GRCRL=0
GNET_GRETH=0

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
			DBGNSS=1
			shift
			;;
		-ggr)
			GNET_GREECE=1
			shift
			;;
		-ggrcom)
			GNET_GRCOM=1
			shift
			;;
		-ggrnoa)
			GNET_GRNOA=1
			shift
			;;
		-ggrcrl)
			GNET_GRCRL=1
			shift
			;;
		-ggreth)
			GNET_GRETH=1
			shift
			;;
		-gsa)
			GNET_SANT=1
			shift
			;;
		-gur)
			GNET_URANUS=1
			shift
			;;
		-gme)
			GNET_METRICA=1
			shift
			;;
		-ghp)
			GNET_HEPOS=1
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

if [ "$DBGNSS" -eq 1 ]
then
	if [ ! -f "dbparameters" ]
	then
		echo "database parameters does not exist"
		echo "copy daparameters.default file to dbparameters and configure db parameters"
		exit 1
	else
		source dbparameters
	fi
fi

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
        legendc="-Jx1i -R0/8/0/8 -Dx0c/3c/3.6c/4.7c/BL"
elif [ "$REGION" == "extsant" ]
then
gmt	gmtset PS_MEDIA 25cx21c
        frame=0.25
        scale=-Lf25.92/36.24/36:24/10+l+jr
        range=-R25.2/26.1/36.2/36.9
        proj=-Jm25.4/36.4/1:500000
        logo_pos=BL/0.2c/0.2c/"DSO[at]NTUA"
        logo_pos2="-C14.8c/0.1c"
        legendc="-Jx1i -R0/8/0/8 -Dx11.7c/6.3c/3.6c/4.7c/BL"
        
elif [ "$REGION" == "saegean" ] #-------------------saegean 
then
gmt	gmtset PS_MEDIA 29cx21c
        frame=2
        scale=-Lf22/34.3/36:24/100+l+jr
        range=-R21/30.5/34/38.7
        proj=-Jm24/36/1:3450000
	logo_pos=BL/19c/0.2c/"DSO[at]NTUA"
        logo_pos2="-C23.3c/13.8c"
	legendc="-Jx1i -R0/8/0/8 -Dx20.5c/2.3c/3.6c/4.7c/BL"
elif [ "$REGION" == "grCyprus" ] #-------------------greece - cyprus extended
then  
gmt	gmtset PS_MEDIA 29cx21c
        frame=2
        scale=-Lf20/34.5/36:24/100+l+jr
        range=-R19/35/34/42
        proj=-Jm24/37/1:6000000
        logo_pos=BL/18c/0.2c/"DSO[at]NTUA"
        logo_pos2="-C22c/13.7c"
        legendc="-Jx1i -R0/8/0/8 -Dx20c/7.2c/3.6c/4.7c/BL"      
elif [ "$REGION" ==  "corinth" ] #-----------------corinth rift 
then
gmt	gmtset PS_MEDIA 24.5cx15c
	frame=.5x
	scale=-Lf21.2/37.9/36:24/20+l+jr
	range=-R21/23/37.8/38.68
	proj=-Jm24/37/1:1100000
	logo_pos=BL/4c/-1.2c/"DSO[at]NTUA"
	logo_pos2="-C14.8c/0.1c"
	legendc="-Jx1i -R0/8/0/8 -Dx17.7c/1.6c/3.6c/4.3c/BL"	
else
gmt	gmtset PS_MEDIA 21cx21c
        frame=2
        scale=-Lf20/34.5/36:24/100+l+jr
        range=-R19/30/34/42
        proj=-Jm24/37/1:6000000
        logo_pos=BL/10.4c/0.2c/"DSO[at]NTUA"
        logo_pos2="-C14.8c/0.9c"
        legendc="-Jx1i -R0/8/0/8 -Dx12.7c/10.8c/3.6c/4.3c/BL"     

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
gmt	makecpt -Cgebco -T-5000/100/150 -Z > $bathcpt
gmt	grdimage $inputTopoB $range $proj -C$bathcpt -K > $outfile
gmt	pscoast $proj -P $range -Df -Gc -K -O >> $outfile
	# land
gmt	makecpt -Cgray -T-5000/1800/50 -Z > $landcpt
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

# ///////////////// PLOT GREECE NETWORKS //////////////////////////////////
if [ "$GNET_GREECE" -eq 1 ]
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
		if [ ! -f $greece_sta ]
		then
			echo "input file $greece_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $greece_sta | gmt psxy -Jm -O -R $gr_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"RB",$1}' $greece_sta | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
	# 	        echo "G 0.25c" >> .legend
	# 		echo "S 0.4c t 0.22c red 0.22p 0.6c GREECE" >> .legend
		fi
	fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c t 0.37c red 0.22p 0.6c GREECE" >> .legend
	
	
fi

# ///////////////// PLOT GREECE NETWORKS -COMET SUBNETWORK //////////////////////////////////
if [ "$GNET_GRCOM" -eq 1 ]
then
        if [ "$DBGNSS" -eq 1 ]
        then
                mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
                "SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='GREECE' AND agency='NTUA-COMET';" \
                | grep -v + \
                | awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-grecom
                gmt psxy tmp-grecom -Jm -O -R $grcom_style -K >> $outfile
                if [ "$LABELS" -eq 1 ]
                then            
                        gmt pstext tmp-grecom -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile

                fi
        fi
        if [ "$FGNSS" -eq 1 ]
        then
                if [ ! -f $grecom_sta ]
                then
                        echo "input file $grecom_sta does not exist. look at network directory"
                        exit 1
                else
                        awk '{print $2,$3}' $grecom_sta | gmt psxy -Jm -O -R $grcom_style -K >> $outfile
                        if [ "$LABELS" -eq 1 ]
                        then
                              awk '{print $2,$3,9,0,1,"RB",$1}' $grecom_sta | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
                        fi
        #               echo "G 0.25c" >> .legend
        #               echo "S 0.4c t 0.22c red 0.22p 0.6c COMET-NTUA" >> .legend
                fi
        fi

        echo "G 0.25c" >> .legend
        echo "S 0.4c t 0.37c red 0.22p 0.6c COMET-NTUA" >> .legend
fi


# ///////////////// PLOT GREECE NETWORKS -NOANET SUBNETWORK //////////////////////////////////
if [ "$GNET_GRNOA" -eq 1 ]
then
        if [ "$DBGNSS" -eq 1 ]
        then
                mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
                "SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='GREECE' AND agency='NOA';" \
                | grep -v + \
                | awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-grenoa
                gmt psxy tmp-grenoa -Jm -O -R $grnoa_style -K >> $outfile
                if [ "$LABELS" -eq 1 ]
                then            
                        gmt pstext tmp-grenoa -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile

                fi
        fi
        if [ "$FGNSS" -eq 1 ]
        then
                if [ ! -f $grenoa_sta ]
                then
                        echo "input file $grenoa_sta does not exist. look at network directory"
                        exit 1
                else
                        awk '{print $2,$3}' $grenoa_sta | gmt psxy -Jm -O -R $grnoa_style -K >> $outfile
                        if [ "$LABELS" -eq 1 ]
                        then
                              awk '{print $2,$3,9,0,1,"RB",$1}' $grenoa_sta | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
                        fi
        #               echo "G 0.25c" >> .legend
        #               echo "S 0.4c t 0.22c red 0.22p 0.6c GREECE" >> .legend
                fi
        fi

        echo "G 0.25c" >> .legend
        echo "S 0.4c t 0.37c 153/76/0 0.22p 0.6c NOANET" >> .legend
fi

# ///////////////// PLOT GREECE NETWORKS -CRL SUBNETWORK //////////////////////////////////
if [ "$GNET_GRCRL" -eq 1 ]
then
        if [ "$DBGNSS" -eq 1 ]
        then
                mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
                "SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='GREECE' AND agency='CRL';" \
                | grep -v + \
                | awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-grecrl
                gmt psxy tmp-grecrl -Jm -O -R $grcrl_style -K >> $outfile
                if [ "$LABELS" -eq 1 ]
                then            
                        gmt pstext tmp-grecrl -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile

                fi
        fi
        if [ "$FGNSS" -eq 1 ]
        then
                if [ ! -f $grecrl_sta ]
                then
                        echo "input file $grecrl_sta does not exist. look at network directory"
                        exit 1
                else
                        awk '{print $2,$3}' $grecrl_sta | gmt psxy -Jm -O -R $grcrl_style -K >> $outfile
                        if [ "$LABELS" -eq 1 ]
                        then
                              awk '{print $2,$3,9,0,1,"RB",$1}' $grecrl_sta | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
                        fi
        #               echo "G 0.25c" >> .legend
        #               echo "S 0.4c t 0.22c red 0.22p 0.6c GREECE" >> .legend
                fi
        fi

        echo "G 0.25c" >> .legend
        echo "S 0.4c t 0.37c blue 0.22p 0.6c CRL" >> .legend
fi

# ///////////////// PLOT ETH HELLAS NET NETWORK //////////////////////////////////
if [ "$GNET_GRETH" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
	echo "Warning: HELLASNET cannot ploted via db until now! use -fgnss switch"
# 		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
# 		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='URANUS';" \
# 		| grep -v + \
# 		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-uranus
# 		psxy tmp-uranus -Jm -O -R $ur_style -K >> $outfile
# 		if [ "$LABELS" -eq 1 ]
# 		then		
# 			pstext tmp-uranus -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
# 			
# 		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $greeth_sta ]
		then
			echo "input file $greeth_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $greeth_sta | gmt psxy -Jm -O -R $greth_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"LB",$1}' $greeth_sta | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
		fi
        fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c t 0.37c yellow 0.22p 0.6c HELLAS-ETHZ" >> .legend
fi


# ///////////////// PLOT SANTORINI NETWORK //////////////////////////////////
if [ "$GNET_SANT" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='SANTORINI';" \
		| grep -v + \
		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-sant
		gmt psxy tmp-sant -Jm -O -R $sa_style -K >> $outfile
		if [ "$LABELS" -eq 1 ]
		then		
			gmt pstext tmp-sant -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			
		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $sant_sta ]
		then
			echo "input file $sant_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $sant_sta | gmt psxy -Jm -O -R $sa_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"LB",$1}' $sant_sta | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
		fi
        fi
        echo "G 0.25c" >> .legend
        echo "S 0.4c t 0.22c green 0.22p 0.6c SANTORINI" >> .legend
fi

# ///////////////// PLOT URANUS NETWORK //////////////////////////////////
if [ "$GNET_URANUS" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='URANUS';" \
		| grep -v + \
		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-uranus
		gmt psxy tmp-uranus -Jm -O -R $ur_style -K >> $outfile
		if [ "$LABELS" -eq 1 ]
		then		
			gmt pstext tmp-uranus -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			
		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $uranus_sta ]
		then
			echo "input file $uranus_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $uranus_sta | gmt psxy -Jm -O -R $ur_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"LB",$1}' $uranus_sta | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
		fi
        fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c t 0.22c blue 0.22p 0.6c URANUS" >> .legend
fi

# ///////////////// PLOT metrica NETWORK //////////////////////////////////
if [ "$GNET_METRICA" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='metrica';" \
		| grep -v + \
		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-metrica
		gmt psxy tmp-metrica -Jm -O -R $me_style -K >> $outfile
		if [ "$LABELS" -eq 1 ]
		then		
			gmt pstext tmp-metrica -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			
		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $metrica_sta ]
		then
			echo "input file $metrica_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $metrica_sta | gmt psxy -Jm -O -R $me_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"LB",$1}' $metrica_sta | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
	      fi
       fi
	echo "G 0.25c" >> .legend
	echo "S 0.3c t 0.22c black 0.22p 0.6c OTHERS" >> .legend
fi

# ///////////////// PLOT HEPOS NETWORK //////////////////////////////////
if [ "$GNET_HEPOS" -eq 1 ]
then
	if [ "$DBGNSS" -eq 1 ]
	then
	echo "Warning: HEPOS net cannot ploted via db until now! use -fgnss switch"
# 		mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
# 		"SELECT $db_code, $db_lat, $db_lon FROM $db_table where network='URANUS';" \
# 		| grep -v + \
# 		| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-uranus
# 		psxy tmp-uranus -Jm -O -R $ur_style -K >> $outfile
# 		if [ "$LABELS" -eq 1 ]
# 		then		
# 			pstext tmp-uranus -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
# 			
# 		fi
	fi
	if [ "$FGNSS" -eq 1 ]
	then
		if [ ! -f $hepos_sta ]
		then
			echo "input file $hepos_sta does not exist. look at network directory"
			exit 1
		else
			awk '{print $2,$3}' $hepos_sta | gmt psxy -Jm -O -R $hp_style -K >> $outfile
			if [ "$LABELS" -eq 1 ]
			then
			      awk '{print $2,$3,9,0,1,"LB",$1}' $hepos_sta | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
			fi
		fi
        fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c c 0.25c red 0.22p 0.6c HEPOS" >> .legend
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
