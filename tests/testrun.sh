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

if [ "$1" = "03" ]; then

../bin/gfx-fnd-03
../bin/gfx-fnd-03 ~/Desktop/gfx/7walls.json ~/Desktop/gfx/7walls.pnm
pnmtopng ~/Desktop/gfx/7walls.pnm > ~/Desktop/gfx/7walls.png


exit
fi

cd ../../gfx-fnd-tests
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-00 00
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-01 01
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-02 02
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-03 03

exit 

./run_tests ../gfx-fnd-impl/bin/gfx-fnd-00 00 01
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-00 00 02
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-00 00 03
 

exit
# Old tests I don't want to run right now

../bin/gfx-fnd-00 5 ../../gfx-fnd-tests/00/01_feep_bitmap_5x/in.pnm ~/Desktop/out-00-01.pnm
../bin/gfx-fnd-00 6 ../../gfx-fnd-tests/00/02_feep_graymap_6x/in.pnm ~/Desktop/out-00-02.pnm
../bin/gfx-fnd-00 6 ../../gfx-fnd-tests/00/03_feep_color_7x/in.pnm ~/Desktop/out-00-03.pnm


../bin/gfx-fnd-02 ../../gfx-fnd-tests/02/02_origin_simple_walls/in.json
#../bin/gfx-fnd-03 startImage.json ~/Desktop/skyAndGround.pnm
#../bin/gfx-fnd-03 exImage.json ~/Desktop/exImage.pnm
#../bin/gfx-fnd-03 ~/Desktop/onewall.in.json ~/Desktop/onewall.pnm
#../bin/pnmtopng ~/Desktop/onewall.pnm > ~/Desktop/onewall.png
#../bin/pnmtopng ~/Desktop/skyAndGround.pnm > ~/Desktop/skyAndGround.png
#../bin/gfx-fnd-03 ../../gfx-fnd-tests/03/01_empty_scene/in.json ~/Desktop/03-01.json
