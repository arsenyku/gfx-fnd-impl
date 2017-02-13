#!/bin/bash

cd $HOME/dev/training/gfx/gfx-fnd-tests

solutionHome="$HOME/dev/training/gfx/gfx-fnd-impl"
solutionBin=$solutionHome/bin


if [ "$1" = "00" ]; then

solution=$solutionBin/gfx-fnd-00
eval $solution 4 3x3.bw.pnm ~/Desktop/out.3x3.bw.pnm
eval $solution 4 F.gray.pnm ~/Desktop/out.F.gray.pnm

exit
fi


if [ "$1" = "01" ]; then

solution=$solutionBin/gfx-fnd-01
eval $solution
eval $solution 8x7 1,2 3,4
eval $solution 10x20 0,0 9,19
eval $solution 100x100 33,34 75,95 ~/Desktop/bordercase.pnm
pnmtopng ~/Desktop/bordercase.pnm > ~/Desktop/bordercase.png


exit
fi

if [ "$1" = "02" ]; then

solution=$solutionBin/gfx-fnd-02
eval $solution
eval $solution testwalls.json

exit
fi

if [ "$1" = "03" ]; then

solution=$solutionBin/gfx-fnd-03
eval $solution
eval $solution ~/Desktop/gfx/7walls.json ~/Desktop/gfx/7walls.pnm
pnmtopng ~/Desktop/gfx/7walls.pnm > ~/Desktop/gfx/7walls.png

exit
fi

if [ "$1" = "10" ]; then

solution=$solutionBin/gfx-fnd-10
#./run_tests $solution 10 00

eval $solution ~/Desktop/gfx/tri01.json ~/Desktop/gfx/tri01.pnm
pnmtopng ~/Desktop/gfx/tri01.pnm > ~/Desktop/gfx/tri01.png

eval $solution ~/Desktop/gfx/tri02.json ~/Desktop/gfx/tri02.pnm
pnmtopng ~/Desktop/gfx/tri02.pnm > ~/Desktop/gfx/tri02.png

eval $solution 10/01_simple_draw/in.json ~/Desktop/gfx/10-01-out.pnm
pnmtopng ~/Desktop/gfx/10-01-out.pnm > ~/Desktop/gfx/10-01-out.png

eval $solution ~/Desktop/gfx/triVertEdge-1.json ~/Desktop/gfx/triVertOut-1.pnm
pnmtopng ~/Desktop/gfx/triVertOut-1.pnm > ~/Desktop/gfx/triVertOut-1.png

#eval $solution 10/02_spiral/in.json ~/Desktop/gfx/10-02-out.pnm
#pnmtopng ~/Desktop/gfx/10-02-out.pnm > ~/Desktop/gfx/10-02-out.png

exit
fi

if [ "$1" = "11" ]; then

solution=$solutionBin/gfx-fnd-11
#eval $solution 

#eval $solution ../gfx-fnd-impl/tests/tri3D-1.json > ~/Desktop/gfx/tri3D-1.out.pnm
#pnmtopng ~/Desktop/gfx/tri3D-1.out.pnm > ~/Desktop/gfx/tri3D-1.out.png

#eval $solution $solutionHome/tests/4tri-flat.json ~/Desktop/gfx/4tri-flat.out.pnm
#pnmtopng ~/Desktop/gfx/4tri-flat.out.pnm > ~/Desktop/gfx/4tri-flat.out.png

#eval $solution $solutionHome/tests/4tri.json ~/Desktop/gfx/4tri.out.pnm
#pnmtopng ~/Desktop/gfx/4tri.out.pnm > ~/Desktop/gfx/4tri.out.png

#eval $solution 11/00_four_triangles/in.json ~/Desktop/gfx/4tri.pnm
#pnmtopng ~/Desktop/gfx/4tri.pnm > ~/Desktop/gfx/4tri.png

#eval $solution $solutionHome/tests/square.json ~/Desktop/gfx/square.pnm
#pnmtopng ~/Desktop/gfx/square.pnm > ~/Desktop/gfx/square.png

#eval $solution $solutionHome/tests/edgeClipping.json ~/Desktop/gfx/edgeClipping.pnm
#pnmtopng ~/Desktop/gfx/edgeClipping.pnm > ~/Desktop/gfx/edgeClipping.png

#eval $solution $solutionHome/tests/smallZOrder.json ~/Desktop/gfx/smallZOrder.pnm
#pnmtopng ~/Desktop/gfx/smallZOrder.pnm > ~/Desktop/gfx/smallZOrder.png

#eval $solution $solutionHome/tests/basicTri.json ~/Desktop/gfx/basicTri.pnm
#pnmtopng ~/Desktop/gfx/basicTri.pnm > ~/Desktop/gfx/basicTri.png

#echo "Basic" | perl -ne 'print "[".localtime()."] $_"'

#eval $solution $solutionHome/tests/basicZOrder.json ~/Desktop/gfx/basicZOrder.pnm
#pnmtopng ~/Desktop/gfx/basicZOrder.pnm > ~/Desktop/gfx/basicZOrder.png

echo "Stack" | perl -ne 'print "[".localtime()."] $_"'

eval $solution $solutionHome/tests/triangleStack.json ~/Desktop/gfx/triangleStack.pnm
pnmtopng ~/Desktop/gfx/triangleStack.pnm > ~/Desktop/gfx/triangleStack.png

echo "End" | perl -ne 'print "[".localtime()."] $_"'

exit
fi

if [ "$1" = "time11" ]; then

solution=$solutionBin/gfx-fnd-11
cd $solutionHome/tests

for benchfile in `ls bench*`
do
    echo "$benchfile" | perl -ne 'print "[".localtime()."] $_"'
    eval $solution $benchfile ~/Desktop/gfx/$benchfile.pnm
    echo "end" | perl -ne 'print "[".localtime()."] $_"'
done

exit 
fi



./run_tests ../gfx-fnd-impl/bin/gfx-fnd-00 00
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-01 01
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-02 02
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-03 03
./run_tests ../gfx-fnd-impl/bin/gfx-fnd-10 10

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
