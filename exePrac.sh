#!/bin/sh

[ -f Filtro ] || make
#make

#sizes=(1 10 101 500 1001)
sizes=(10)
#block_sizes=(1 1 1 1 1)
thr_block=(1) # Threads per block

for img in /opt/PracticasPCP2122/Imagenes/* 
do
	printf "\n\n$img\nveces;secuencial;openmp\n"
	
	i=0
	for size in ${sizes[@]};
	do
		#echo "./PRAC04 $img "output.bmp" $size"

		cuda=$(./Filtro $img "output.bmp" $size ${thr_block[$i]})

		printf "$size;${sec};${par}\n"
		#./profesores $img_name "outputP.bmp" $2 $3
		#./Error "output.bmp" "outputP.bmp"

		i=$(( $i + 1 ))
	done
done

rm -rf "output.bmp" #"outputP.bmp"