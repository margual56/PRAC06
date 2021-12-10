#!/bin/sh

source /opt/intel/oneapi/setvars.sh > /dev/null
make
#make

size=10
thr_block=32 # Threads per block

img="/opt/PracticasPCP2122/Imagenes/bilde.bmp"
./EXE/Filtro $img "output.bmp" 10 ${thr_block[$i]} || exit 1
./EXE/profesores $img "outputP.bmp" 10 x
./EXE/Error "output.bmp" "outputP.bmp"

#rm -rf output.bmp  #outputP.bmp
