#!/bin/bash
#plot network forseismo platform
# //////////////////////////////////////////////////////////////////////////////
# HELP FUNCTION
function help {	echo "
/******************************************************************************/
	Program Name : cGNSSproc.sh
	Version : v-1.1
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
	   metrica
	   epnlac 
	   epnbench 	:Network for EPN-Repro2 Benchmark test.
	   epndens1 	:Network for Densification Benchmark test.
	   lefk15 	:Stations of all available network for Lefkada Eart.

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
plotnet="greece"

PLOTSOL=0
PALL=0
PPRO=0
PELL=0
PBL=0


DBGNSS=1

if [ ! -f "gmtparam" ]
then
	echo "gmtparam file does not exist"
	exit 1
else
	source gmtparam
fi




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
		-dbgnss)
			DBGNSS=1
			shift
			;;
		-topo)
#                       switch topo not used in server!
			TOPOGRAPHY=1
			shift
			;;
		-n)
			plotnet=$2
			shift
			shift
			;;
		-s)
			solfile=$2
			PLOTSOL=1
			shift
			shift
			;;
		-pall)
			PALL=1
			shift
			;;
		-ppro)
			PPRO=1
			shift
			;;
		-pell)
			PELL=1
			shift
			;;
		-pbl)
			PBL=1
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

#check solutions types
if [ "$PLOTSOL" -eq 1 ]
then
	if [ ! -f $solfile ]
	then
		echo "solution file $solfile does not exist, CHECK"
		exit 1
	fi
fi


# ///////////////// set region //////////////////////////////////
if [ "$REGION" == "sant" ]
then
gmt	gmtset PS_MEDIA 22cx21c
	frame=0.05
        scale=-Lf25.51/36.315/36:24/4+l+jr
        range=-R25.27/25.55/36.3/36.5
        projt=-Jm
        projp=25.4/36.4/1:150000
        logo_pos=BL/0.2c/0.2c/"DSO[at]NTUA"
        logo_pos2="-C15.2c/13.6c"
        legendc="-Jx1i -R0/8/0/8 -Dx0c/3c/3.6c/4.7c/BL"
elif [ "$REGION" == "extsant" ]
then
gmt	gmtset PS_MEDIA 25cx21c
        frame=0.25
        scale=-Lf25.92/36.24/36:24/10+l+jr
        range=-R25.2/26.1/36.2/36.9
        projt=-Jm
        projp=25.4/36.4/1:500000
        logo_pos=BL/0.2c/0.2c/"DSO[at]NTUA"
        logo_pos2="-C14.8c/0.1c"
        legendc="-Jx1i -R0/8/0/8 -Dx11.7c/6.3c/3.6c/4.7c/BL"
        
elif [ "$REGION" == "saegean" ] #-------------------saegean 
then
gmt	gmtset PS_MEDIA 29cx21c
        frame=2
        scale=-Lf22/34.3/36:24/100+l+jr
        range=-R21/30.5/34/38.7
        projt=-Jm
        projp=24/36/1:3450000
	logo_pos=BL/19c/0.2c/"DSO[at]NTUA"
        logo_pos2="-C23.3c/13.8c"
	legendc="-Jx1i -R0/8/0/8 -Dx20.5c/2.3c/3.6c/4.7c/BL"
elif [ "$REGION" == "grCyprus" ] #-------------------greece - cyprus extended
then  
gmt	gmtset PS_MEDIA 29cx21c
        frame=2
        scale=-Lf20/34.5/36:24/100+l+jr
        range=-R19/35/34/42
        projt=-Jm
        projp=24/37/1:6000000
        logo_pos=BL/18c/0.2c/"DSO[at]NTUA"
        logo_pos2="-C22c/13.7c"
        legendc="-Jx1i -R0/8/0/8 -Dx20c/7.2c/3.6c/4.7c/BL"      
elif [ "$REGION" ==  "corinth" ] #-----------------corinth rift 
then
gmt	gmtset PS_MEDIA 24.5cx15c
	frame=.5x
	scale=-Lf21.2/37.9/36:24/20+l+jr
	range=-R21/23/37.8/38.68
	projt=-Jm
	projp=24/37/1:1100000
	logo_pos=BL/4c/-1.2c/"DSO[at]NTUA"
	logo_pos2="-C14.8c/0.1c"
	legendc="-Jx1i -R0/8/0/8 -Dx17.7c/1.6c/3.6c/4.3c/BL"	
elif [ "$REGION" == "europe" ]
then
gmt	gmtset PS_MEDIA Custom_29cx20c
        frame=10
        scale=-Lf-4/26/50:20/500+l+jr
        range=-R-30/63/30/72
	projt=-Jl
 	projp=17.5/45/40/50/1:36000000
        logo_pos=BL/19.3c/-0.9c/"DSO[at]NTUA"
        logo_pos2="-C24c/-0.3c"
	legendc="-Jx1i -R0/8/0/8 -Dx-1.2c/-1.7c/4.3c/3.7c/BL"
else
gmt	gmtset PS_MEDIA 21cx21c
        frame=2
        scale=-Lf20/34.5/36:24/100+l+jr
        range=-R19/30/34/42
        projt=-Jm
        projp=24/37/1:6000000
        logo_pos=BL/10.4c/0.2c/"DSO[at]NTUA"
        logo_pos2="-C14.8c/0.9c"
        legendc="-Jx1i -R0/8/0/8 -Dx12.7c/10.8c/3.6c/4.3c/BL"     

fi

# ####################### TOPOGRAPHY ###########################
if [ "$TOPOGRAPHY" -eq 0 ]
then
	################## Plot coastlines only ######################
	if [ "$REGION" == "europe" ]
	then
	gmt	psbasemap $range ${projt}${projp} $scale -B$frame:."$maptitle": -P -K> $outfile
	gmt	pscoast -R -J -O -K -W0.25 -G240 -S204/229/255 -Df -Na  -U$logo_pos >> $outfile
	# gmt	pscoast -R -J -O -K -W0.25 -G205 -Df -Na -U$logo_pos >> $outfile
	else
	gmt	psbasemap $range ${projt}${projp} $scale -B$frame:."$maptitle": -P -K> $outfile
	gmt	pscoast -R -J -O -K -W0.25 -G205 -Df -Na -U$logo_pos >> $outfile
	fi
fi
if [ "$TOPOGRAPHY" -eq 1 ]
then
	# ####################### TOPOGRAPHY ###########################
	# bathymetry
if [ "$REGION" == "europe" ]
then
gmt	makecpt -Cgebco -T-7000/0/150 -Z > $bathcpt
gmt	makecpt -Cgray -T-5000/2300/50 -Z > $landcpt
else
gmt	makecpt -Cgebco -T-5000/100/150 -Z > $bathcpt
gmt	makecpt -Cgray -T-5000/1800/50 -Z > $landcpt
fi
# gmt	makecpt -Cgebco.cpt -T-5000/100/150 -Z > $bathcpt
gmt	grdimage $inputTopoB $range ${projt}${projp} -C$bathcpt -K > $outfile
gmt	pscoast ${projt}${projp} -P $range -Df -Gc -K -O >> $outfile
	# land
# gmt	makecpt -Cgray.cpt -T-5000/1800/50 -Z > $landcpt
gmt	grdimage $inputTopoL $range ${projt}${projp} -C$landcpt  -K -O >> $outfile
gmt	pscoast -R -J -O -K -Q >> $outfile
	#------- coastline -------------------------------------------
gmt	psbasemap -R -J -O -K --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p >> $outfile
gmt	pscoast ${projt} -R -B$frame:."$maptitle": -Df -W.2,black -K  -O -U$logo_pos >> $outfile
fi

# start create legend file .legend
echo "G 0.2c" > .legend
echo "H 9 Times-Roman $maptitle" >> .legend
echo "D 0.3c 1p" >> .legend
echo "N 1" >> .legend

# ///////////////// PLOT ALL STATION NETWORKS //////////////////////////////////
if [ "$PALL" -eq 1 ]
then
	mysql -h $dbhost -u $dbuser -p$dbpasswd -D $dbase -e \
	"SELECT $db_code, $db_lat, $db_lon FROM $db_table JOIN sta2nets ON sta2nets.station_id=station.station_id JOIN network ON network.network_id=sta2nets.network_id WHERE network.network_name='$plotnet';" \
	| grep -v + \
	| awk 'NR>1 {print $3,$2,9,0,1,"RB",$1}' > tmp-gre
	gmt psxy tmp-gre ${projt} -O -R $gr_style -K >> $outfile
	if [ "$LABELS" -eq 1 ]
	then		
		gmt pstext tmp-gre ${projt} -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
		
	fi
	echo "G 0.25c" >> .legend
	echo "S 0.4c t 0.37c red 0.22p 0.6c All stations" >> .legend
fi
# 	if [ "$FGNSS" -eq 1 ]
# 	then
# 		if [ ! -f $greece_sta ]
# 		then
# 			echo "input file $greece_sta does not exist. look at network directory"
# 			exit 1
# 		else
# 			awk '{print $2,$3}' $greece_sta | gmt psxy ${projt} -O -R $gr_style -K >> $outfile
# 			if [ "$LABELS" -eq 1 ]
# 			then
# 			      awk '{print $2,$3,9,0,1,"RB",$1}' $greece_sta | gmt pstext ${projt} -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
# 			fi
# 	# 	        echo "G 0.25c" >> .legend
# 	# 		echo "S 0.4c t 0.22c red 0.22p 0.6c GREECE" >> .legend
# 		fi
# 	fi
# 	echo "G 0.25c" >> .legend
# 	echo "S 0.4c t 0.37c red 0.22p 0.6c GREECE" >> .legend
# 	
# 	
# fi


# ///////////////// PLOT PROCESSED STATIONS NETWORKS //////////////////////////////////
if [ "$PPRO" -eq 1 ] 
then
	grep -v "#" $solfile | grep -v BL | awk '{print $14,$13}' | gmt psxy ${projt} -O -R -St0.37c -W0.01c/0 -Ggreen -K >> $outfile
# 	if [ "$LABELS" -eq 1 ] &&   [ "$STAALL" -eq 0 ]
# 	then
# 		grep -v "#" $input_proc | grep -v BL | awk '{print $14,$13,5,0,1,"LB",$2}' | pstext ${projt} -R -Dj0.1c/0.1c -G0/0/0 -O -V -K>> $out_eps
# 	fi
	#write legend file
	echo "G 0.25c" >> .legend
	echo "S 0.4c t 0.37c green 0.22p 0.6c Proccessed Stations" >> .legend
fi


# ///////////////// PLOT ERROR ELLIPSIS //////////////////////////////////
# plot  Helmert Transformation Ellipses
if [ "$PELL" -eq 1 ]
then
#	grep -v "#" $input_proc | grep -v BL | awk '{print $14,$13,90-$11,$9*400,$10*400}' | psxy ${projt} -O -R -Se  -G255/130/71 -W0.01c/0  -K >> $out_eps
#        grep -v "#" $input_proc | grep -v BL | awk '{print $14,$13}' | psxy ${projt} -O -R -Sc0.05c  -G0 -W0.01c/0  -K >> $out_eps
	grep -v "#" $solfile | grep -v BL | grep HLM | awk '{print $14,$13,90-$11,$9*400,$10*400}' | gmt psxy ${projt} -O -R -Se  -G30/144/255	 -W0.01c/0  -K >> $outfile
	grep -v "#" $solfile | grep -v BL | grep EST | awk '{print $14,$13,90-$11,$9*400,$10*400}' | gmt psxy ${projt} -O -R -Se  -G255/130/71 -W0.01c/0  -K >> $outfile
        grep -v "#" $solfile | grep -v BL | awk '{print $14,$13}' | gmt psxy ${projt} -O -R -Sc0.05c  -G0 -W0.01c/0  -K >> $outfile

	#write legend file
        echo "G 0.25c" >> .legend
        echo "S 0.4c c 0.4c 30/144/255 0.1p 0.8c Aligned Stations r=0.1mm" >> .legend
        echo "G 0.25c" >> .legend
        echo "G 0.25c" >> .legend
        echo "S 0.4c c 0.4c 255/130/71 0.1p 0.8c Estimated Stations r=0.1mm" >> .legend
        echo "G 0.25c" >> .legend

fi



# ///////////////// PLOT RESOLVED BASELINES //////////////////////////////////

## -- PLOT CREATED BASELINES -- ##
if [ "$PBL" -eq 1 ]
then
        #plot basselines
#        rm .tmp2.bl 2>/dev/null
        grep BL $solfile > .tmp1.bl
while [ -s .tmp1.bl ]; do
        head -n 1 .tmp1.bl | awk '{print ">",$6}'>> .tmp2.bl
        head -n 1 .tmp1.bl | awk '{print $3,$2}'>> .tmp2.bl
        head -n 1 .tmp1.bl | awk '{print $5,$4}'>> .tmp2.bl
        sed -i '1d' .tmp1.bl
done

        gmt psxy  .tmp2.bl -Sqn1xkikin3:+Lh+u%+s4 -R -J -m -W0.5p,green -O -K >> $outfile
	#write legend file
	echo "S 0.4c - 0.55c green 0.6p,green 0.8c Baselines" >> .legend
rm .tmp1.bl 
rm .tmp2.bl
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
