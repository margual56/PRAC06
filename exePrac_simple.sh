#!/bin/sh

source /opt/intel/oneapi/setvars.sh > /dev/null
[ -f ./EXE/Filtro ] || make
#make

#sizes=(1 10 101 500 1001)
size=1000
#block_sizes=(1 1 1 1 1)
thr_block=32 # Threads per block

img="/opt/PracticasPCP2122/Imagenes/bilde.bmp"
./EXE/Filtro $img "output.bmp" $size ${thr_block[$i]}
./EXE/profesores $img "outputP.bmp" $size x
./EXE/Error "output.bmp" "outputP.bmp"

rm -rf output.bmp outputP.bmp