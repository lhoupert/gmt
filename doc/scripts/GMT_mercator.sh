#!/bin/sh
#	$Id: GMT_mercator.sh,v 1.4 2004-07-13 18:47:09 pwessel Exp $
#

gmtset PLOT_DEGREE_FORMAT ddd:mm:ss BASEMAP_TYPE fancy
pscoast -R0/360/-70/70 -Jm1.2e-2i -Ba60f30/a30f15 -Dc -A5000 -Gblack -P > GMT_mercator.ps
