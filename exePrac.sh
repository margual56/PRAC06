#!/bin/sh

[ -f Filtro ] || make
#make

#sizes=(1 10 101 500 1001)
sizes=(10)
#block_sizes=(1 1 1 1 1)
block_sizes=(1)

for img in /opt/PracticasPCP2122/Imagenes/* 
do
	printf "\n\n$img\nveces;secuencial;openmp\n"
	
	for size in ${sizes[@]};
	do
		#echo "./PRAC04 $img "output.bmp" $size"

		export OMP_NUM_THREADS=1
		sec=$(./Filtro $img "output.bmp" $size)

		unset OMP_NUM_THREADS
		par=$(./Filtro $img "output.bmp" $size)

		printf "$size;${sec};${par}\n"
		#./profesores $img_name "outputP.bmp" $2 $3
		#./Error "output.bmp" "outputP.bmp"

		i=$(( $i + 1 ))
	done
done

rm -rf "output.bmp" #"outputP.bmp"