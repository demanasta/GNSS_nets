#!/bin/bash
echo ".....comet net...."
./cGNSSnetsgr.sh -mt "cGNSS Network COMET" -fgnss -topo -o comet -jpg -ggrcom
echo "......noanet ...."
./cGNSSnetsgr.sh -mt "cGNSS Network NOANET" -fgnss -topo -o noanet -jpg -ggrnoa
echo "........CRLab ........"
./cGNSSnetsgr.sh -mt "cGNSS Network CRLab" -fgnss -topo -o crlnet -jpg -ggrcrl -r corinth
echo ".......GREECE......."
./cGNSSnetsgr.sh -mt "cGNSS Network GREECE" -fgnss -topo -o greeceall -jpg -ggrnoa -ggrcom -ggrcrl -ghp -leg
echo ".......URANUS......."
./cGNSSnetsgr.sh -mt "cGNSS Network URANUS" -fgnss -topo -o uranus -jpg -gur -r grCyprus
