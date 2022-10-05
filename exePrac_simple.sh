#!/bin/sh

#source /opt/intel/oneapi/setvars.sh > /dev/null

make
#make

size=10
thr_block=32 # Threads per block

img="../Imagenes/bilde.bmp"
./EXE/Filtro $img "output.bmp" $size ${thr_block} || exit 1
./EXE/profesores $img "outputP.bmp" $size 2
./EXE/Error "output.bmp" "outputP.bmp"

#rm -rf output.bmp  #outputP.bmp
