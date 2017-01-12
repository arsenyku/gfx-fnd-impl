#!/bin/bash

if [ "$1" = "OLD" ]; then

../bin/gfx-fnd-00 5 ../../gfx-fnd-tests/00/01_feep_bitmap_5x/in.pnm ~/Desktop/out-00-01.pnm
../bin/gfx-fnd-00 6 ../../gfx-fnd-tests/00/02_feep_graymap_6x/in.pnm ~/Desktop/out-00-02.pnm
../bin/gfx-fnd-00 6 ../../gfx-fnd-tests/00/03_feep_color_7x/in.pnm ~/Desktop/out-00-03.pnm

exit 
fi

if [ "$1" = "" ]; then

../bin/gfx-fnd-00 4 3x3.bw.pnm ~/Desktop/out.3x3.bw.pnm
../bin/gfx-fnd-00 4 F.gray.pnm ~/Desktop/out.F.gray.pnm

exit
fi

cd ../../gfx-fnd-tests
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-00 00

exit 

./run_tests ../gfx-fnd-impl/bin/gfx-fnd-00 00 01
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-00 00 02
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-00 00 03
 
