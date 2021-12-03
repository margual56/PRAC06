#include "Prototipos_Alumno.h"

__global__ void kernel_Filtro1(double *IMG1, double *IMG2, const unsigned int DimX, const unsigned int DimY, const int times, double GAUSS){
	int half = 2;

    int i = blockIdx.x * blockDim.x + threadIdx.x + half;
    int j = blockIdx.y * blockDim.y + threadIdx.y + half;
	int f;
	double sum;

	// Filtro por columnas
    if(i<(DimY-half)*DimX){
	    //for (i = half; i<DimY-half; i++){
	    	//iDx = i*DimX;

            if(j < DimX-half){
	    	    //for (j = half; j<DimX-half; j++){
	    	    	sum = 0.0;
                    
	    	    	for(f = 0; f<5; f++)
	    	    		sum += IMG1[i+(f-half)*DimX + j]*GAUSS[f];
                    
	    	    	IMG2[i+j] = sum;
	    	    //}
	    //}

	    // Filtro por filas
	    //for (i = half; i<DimY-half; i++){
	    	//iDx = i*DimX;

	    	    //for (j = half; j<DimX-half; j++){
	    	    	sum = 0.0;
                
	    	    	for(f = 0; f<5; f++)
	    	    		sum += IMG2[i + j + (f-half)]*GAUSS[f];
                
	    	    	IMG1[i+j] = sum;
	    	    //}
            }
	    //}
    }
}