#include "Prototipos_Alumno.h"

__global__ void kernel_Filtro1(double *IMG1, double *IMG2, const unsigned int DimX, const unsigned int DimY, double *GAUSS){
	int half = 2;

    //extern __shared__ double *IMG2[DimX*DimY];

    int i = blockIdx.y * blockDim.y + threadIdx.y + half;
    int j = blockIdx.x * blockDim.x + threadIdx.x + half;

    //if( i < DimY && j<DimX)
    //    IMG2[i*DimX+j] = IMG1[i*DimX+j];

    //__syncthreads();

	int f, iDx;
	double sum;

	// Filtro por columnas
    if(i < DimY-half*2){
        iDx = i*DimX;
	    //for (i = half; i<DimY-half; i++){
	    	//iDx = i*DimX;

            if(j < DimX-half*2){
	    	    //for (j = half; j<DimX-half; j++){
	    	    	sum = 0.0;
                    
	    	    	for(f = 0; f<5; f++)
	    	    		sum += IMG1[iDx+(f-half)*DimX + j]*GAUSS[f];
                    
	    	    	IMG2[iDx+j] = sum;
	    	    //}
	    //}

                    __syncthreads();

	    // Filtro por filas
	    //for (i = half; i<DimY-half; i++){
	    	//iDx = i*DimX;

	    	    //for (j = half; j<DimX-half; j++){
	    	    	sum = 0.0;
                
	    	    	for(f = 0; f<5; f++)
	    	    		sum += IMG2[iDx + j + (f-half)]*GAUSS[f];
                
	    	    	IMG1[iDx+j] = sum;
	    	    //}
            }
	    //}
    }
}