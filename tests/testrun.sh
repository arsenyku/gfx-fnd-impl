#!/bin/bash

cd $HOME/dev/training/gfx/gfx-fnd-impl/tests

if [ "$1" = "00" ]; then

../bin/gfx-fnd-00 4 3x3.bw.pnm ~/Desktop/out.3x3.bw.pnm
../bin/gfx-fnd-00 4 F.gray.pnm ~/Desktop/out.F.gray.pnm

exit
fi


if [ "$1" = "01" ]; then

../bin/gfx-fnd-01
../bin/gfx-fnd-01 8x7 1,2 3,4
../bin/gfx-fnd-01 10x20 0,0 9,19

exit
fi

if [ "$1" = "02" ]; then

../bin/gfx-fnd-02
../bin/gfx-fnd-02 testwalls.json

exit
fi

cd ../../gfx-fnd-tests
#./run_tests ../gfx-fnd-impl/bin/gfx-fnd-00 00
#./run_tests ../gfx-fnd-impl/bin/gfx-fnd-01 01
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-01 01 00
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-01 01

exit 

./run_tests ../gfx-fnd-impl/bin/gfx-fnd-00 00 01
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-00 00 02
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-00 00 03
 

exit
# Old tests I don't want to run right now

../bin/gfx-fnd-00 5 ../../gfx-fnd-tests/00/01_feep_bitmap_5x/in.pnm ~/Desktop/out-00-01.pnm
../bin/gfx-fnd-00 6 ../../gfx-fnd-tests/00/02_feep_graymap_6x/in.pnm ~/Desktop/out-00-02.pnm
../bin/gfx-fnd-00 6 ../../gfx-fnd-tests/00/03_feep_color_7x/in.pnm ~/Desktop/out-00-03.pnm


