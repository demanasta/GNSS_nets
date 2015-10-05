#!/bin/bash
#plot processed stations for each network
# //////////////////////////////////////////////////////////////////////////////
# HELP FUNCTION
function help {
	echo "/******************************************************************************/"
	echo " Program Name : plot_proc.sh"
	echo " Version : v-1.0"
	echo " Purpose : Plot network stations"
	echo " Usage   : plot_proc.sh -y [year] | -d [doy] | -n [network] | -t [TYPE] | -o [output] | -jpg "
	echo " Switches: "
        echo "           -y [:=year] year of processed day"
	echo "           -d [:=doy] day of year of processed day"
	echo "           -n [:= network] network to plot [ greece | uranus | santorini | metrica ]"
	echo "           -t [:=type]  type of solution (final,urapid; default final)"
	echo "           -o [:= output] name of output files"
	echo "           -l [:=labels] plot labels"
	echo "           -jpg : convert eps file to jpg"
	echo "           -h [:= help] help menu"
	echo " Exit Status:   -2 -> help message or error"
	echo " Exit Status: >= 0 -> sucesseful exit"
	echo ""
	echo "/******************************************************************************/"
	exit -2
}


# //////////////////////////////////////////////////////////////////////////////
# GMT parameters
gmtset MAP_FRAME_TYPE fancy
gmtset PS_PAGE_ORIENTATION portrait
gmtset FONT_ANNOT_PRIMARY 10 FONT_LABEL 10 MAP_FRAME_WIDTH 0.12c FONT_TITLE 18p
# gmtset PS_MEDIA 29cx21c

# //////////////////////////////////////////////////////////////////////////////
# Pre-defined parameters for bash script
TOPOGRAPHY=0
LABELS=0
OUTJPG=0
TYPE="fin"

# //////////////////////////////////////////////////////////////////////////////
# Pre-defined parameters for GMT
outfile=plot_nets.eps
out_jpg=plot_nets.jpg
inputTopoL=$HOME/Map_project/maps_gmt/greeceSRTM.grd
inputTopoB=$HOME/Map_project/maps_gmt/greeceSRTM.grd
# frame=2
# scale=-Lf20/34.5/36:24/100+l+jr
# range=-R19/29/34/42
# proj=-Jm24/37/1:6000000
landcpt=land_man.cpt
bathcpt=bath_man.cpt


# //////////////////////////////////////////////////////////////////////////////
# GET COMMAND LINE ARGUMENTS
if [ "$#" == "0" ]
then
	help
fi

while [ $# -gt 0 ]
do
	case "$1" in
		-y)
			year=$2
			shift
			shift
			;;
		-d)
			doy=$2
			shift
			shift
			;;
		-n)
			network=$2
			shift
			shift
			;;
		-t)
			case "$2" in
				final)
					TYPE="fin"
					shift
					shift
					;;
				urapid)
					TYPE="ur"
					shift
					shift
					;;
			esac
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
		-jpg)
			OUTJPG=1
			shift
			;;
		-h)
			help
			;;
	esac
done

# ///////////////// set input fiiles ////////////////////////////
#input_all=${network}.sites
#input_proc=${network}-${year:2:2}${doy}-${TYPE}.proc

# /////////////// check input file exist ////////////////////////
#if [ !-d $input_proc ]
#then
#	echo "input file $input_proc does not exist"
#	exit -2
#fi

# ///////////////// set output fiiles ////////////////////////////
outfile=cgps-nets.eps
out_jpg=cgps-nets.jpg

# ///////////////// set region //////////////////////////////////
if [ "$network" == "santorini" ]
then
	frame=0.05
	scale=-Lf25.51/36.315/36:24/4+l+jr
	range=-R25.27/25.55/36.3/36.5
	proj=-Jm25.4/36.4/1:150000
else
	frame=2
	scale=-Lf20/34.5/36:24/100+l+jr
	range=-R19/29/34/42
	proj=-Jm24/37/1:6000000
fi

# ####################### TOPOGRAPHY ###########################
if [ "$TOPOGRAPHY" -eq 0 ]
then
	################## Plot coastlines only ######################
	pscoast $range $proj -B$frame:."networks": -Df -W0.5/0/0/0 -G195  -U"DSO-HGL/NTUA" -K > $outfile
	psbasemap -R -J -O -K --ANNOT_FONT_SIZE_PRIMARY=10p $scale --LABEL_FONT_SIZE=10p >> $outfile
fi
if [ "$TOPOGRAPHY" -eq 1 ]
then
	# ####################### TOPOGRAPHY ###########################
	# bathymetry
	makecpt -CGMT_gebco.cpt -T-7000/0/150 -Z > $bathcpt
	grdimage $inputTopoB $range $proj -C$bathcpt -K > $outfile
	pscoast $proj -P $range -Df -Gc -K -O >> $outfile
	# land
	makecpt -CGMT_gray.cpt -T-3000/1800/50 -Z > $landcpt
	grdimage $inputTopoL $range $proj -C$landcpt  -K -O >> $outfile
	pscoast -R -J -O -K -Q >> $outfile
	#------- coastline -------------------------------------------
	psbasemap -R -J -O -K --ANNOT_FONT_SIZE_PRIMARY=8p $scale --LABEL_FONT_SIZE=8p >> $outfile
	pscoast -Jm -R -B$frame:."networks": -Df -W0.5/0/0/0 -K -O -U"DSO-HGL/NTUA" >> $outfile
fi

# plot all network stations in red stars

awk '{print $2,$3}' uranus.sites | psxy -Jm -O -R -Sa0.22c -W0.01c/0 -Gblue -K >> $outfile
awk '{print $2,$3}' greece.sites | psxy -Jm -O -R -Sa0.22c -W0.01c/0 -Gred -K >> $outfile
awk '{print $2,$3}' santorini.sites | psxy -Jm -O -R -Sa0.22c -W0.01c/0 -Ggreen -K >> $outfile

#if [ "$LABELS" -eq 1 ]
#then
#	awk '{print $2,$3,7,0,1,"LB",$1}' greece.sites | pstext -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V -K>> $outfile
#fi

# plot proccessed network stations in green stars
#awk 'NR>=8&&NR<=90' $input_proc |awk '{print $10,$11}' | psxy -Jm -O -R -Sa0.22c -W0.01c/0 -Ggreen -K >> $outfile

#if [ "$network" == "santorini" ]
#then
#echo  "25.485 36.34 8 0 1 LM processed stations" | psxy -Jm -O -R -Sa0.22c -W0.01c/0 -Ggreen -K >> $outfile
#echo  "25.49 36.34 8 0 1 LM processed stations" | pstext -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V -K>> $outfile
#echo  "25.485 36.33 8 0 1 LM unprocessed stations" | psxy -Jm -O -R -Sa0.22c -W0.01c/0 -Gred -K >> $outfile
#echo  "25.49 36.33 8 0 1 LM unprocessed stations" | pstext -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V -K>> $outfile
#else
#echo  "19.4 34.9 8 0 1 LM processed stations" | psxy -Jm -O -R -Sa0.22c -W0.01c/0 -Ggreen -K >> $outfile
#echo  "19.6 34.9 8 0 1 LM processed stations" | pstext -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V -K>> $outfile
#echo  "19.4 34.7 8 0 1 LM unprocessed stations" | psxy -Jm -O -R -Sa0.22c -W0.01c/0 -Gred -K >> $outfile
#echo  "19.6 34.7 8 0 1 LM unprocessed stations" | pstext -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V -K>> $outfile
#
#fi

#################--- Convert to jpg format ----##########################################
if [ "$OUTJPG" -eq 1 ]
then
	gs -sDEVICE=jpeg -dJPEGQ=100 -dNOPAUSE -dBATCH -dSAFER -r300 -sOutputFile=$out_jpg $outfile
fi
