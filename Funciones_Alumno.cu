#include "Prototipos_Alumno.h"

__global__ void kernel_Filtro1_vertical(double *IMG1, double *IMG2, const unsigned int DimX, const unsigned int DimY, double *GAUSS){
	int half = 2;

    //extern __shared__ double *IMG2[];

    int j = blockIdx.x * blockDim.x + threadIdx.x + half;
    int i = blockIdx.y * blockDim.y + threadIdx.y + half;

    //if( i < DimY && j<DimX)
    //    IMG2[i*DimX+j] = IMG1[i*DimX+j];

    //__syncthreads();

	// Filtro por columnas
    if(i < DimY-half && j < DimX-half) {
		IMG2[i*DimX+j] = 
			IMG1[(i-2)*DimX + j] * 1.0/16.0 + 
			IMG1[(i-1)*DimX + j] * 4.0/16.0 + 
			IMG1[(i+0)*DimX + j] * 6.0/16.0 + 
			IMG1[(i+1)*DimX + j] * 4.0/16.0 + 
			IMG1[(i+2)*DimX + j] * 1.0/16.0; 
    }
}

__global__ void kernel_Filtro1_horizontal(double *IMG1, double *IMG2, const unsigned int DimX, const unsigned int DimY, double *GAUintSS){
	int half = 2;

    //extern __shared__ double *IMG2[];

    int j = blockIdx.x * blockDim.x + threadIdx.x + half;
    int i = blockIdx.y * blockDim.y + threadIdx.y + half;

    //if( i < DimY && j<DimX)
    //    IMG2[i*DimX+j] = IMG1[i*DimX+j];

    //__syncthreads();

	int iDx;

	// Filtro por columnas
    if(i < DimY-half && j < DimX-half) {
        iDx = i*DimX;
		
		IMG1[iDx+j] = 
			IMG2[iDx + (j-2)] * 1.0/16.0 + 
			IMG2[iDx + (j-1)] * 4.0/16.0 + 
			IMG2[iDx + (j+0)] * 6.0/16.0 + 
			IMG2[iDx + (j+1)] * 4.0/16.0 + 
			IMG2[iDx + (j+2)] * 1.0/16.0;

	}
}
