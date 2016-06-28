#!/bin/bash
#               GMT EXAMPLE 33
#               $Id$
#
# Purpose:      Illustrate grdtrack's new cross-track and stacking options
# GMT modules:  makecpt, gmtconvert, grdimage, grdgradient, grdtrack, pstext, psxy
# Unix progs:   cat, rm
#
ps=example_33.ps

# Extract a subset of ETOPO1m for the East Pacific Rise
# gmt grdcut etopo1m_grd.nc -R118W/107W/49S/42S -Gspac.nc
gmt makecpt -Crainbow -T-5000/-2000 > z.cpt
gmt grdgradient spac.nc -A15 -Ne0.75 -Gspac_int.nc
gmt grdimage spac.nc -Ispac_int.nc -Cz.cpt -JM6i -P -Baf -K -Xc --FORMAT_GEO_MAP=dddF > $ps
# Select two points along the ridge
cat << EOF > ridge.txt
-111.6	-43.0
-113.3	-47.5
EOF
# Plot ridge segment and end points
gmt psxy -Rspac.nc -J -O -K -W2p,blue ridge.txt >> $ps
gmt psxy -R -J -O -K -Sc0.1i -Gblue ridge.txt >> $ps
# Generate cross-profiles 400 km long, spaced 10 km, samped every 2km
# and stack these using the median, write stacked profile
gmt grdtrack ridge.txt -Gspac.nc -C400k/2k/10k+v -Sm+sstack.txt > table.txt
gmt psxy -R -J -O -K -W0.5p table.txt >> $ps
# Show upper/lower values encountered as an envelope
gmt gmtconvert stack.txt -o0,5 > env.txt
gmt gmtconvert stack.txt -o0,6 -I -T >> env.txt
gmt psxy -R-200/200/-3500/-2000 -Bxafg1000+l"Distance from ridge (km)" -Byaf+l"Depth (m)" -BWSne \
	-JX6i/3i -O -K -Glightgray env.txt -Y6.5i >> $ps
gmt psxy -R -J -O -K -W3p stack.txt >> $ps
echo "0 -2000 MEDIAN STACKED PROFILE" | gmt pstext -R -J -O -K -Gwhite -F+jTC+f14p -Dj0.1i >> $ps
gmt psxy -R -J -O -T >> $ps
# cleanup
rm -f z.cpt spac_int.nc ridge.txt table.txt env.txt stack.txt
