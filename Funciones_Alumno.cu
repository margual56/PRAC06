#include "Prototipos_Alumno.h"

__global__ void kernel_Filtro1_vertical(double *IMG1, double *IMG2, const unsigned int DimX, const unsigned int DimY, double *GAUSS){
    //extern __shared__ double IMG1_2[];

	int half = 2;
    int j = blockIdx.x * blockDim.x + threadIdx.x + half;
    int i = blockIdx.y * blockDim.y + threadIdx.y + half;

	// int Dim_2 = blockDim.x*blockDim.y;
	//    if(i < Dim_2 && j < Dim_2) {
	//        IMG1_2[i*Dim_2+j] = IMG1[i*DimX+j];
	//  	__syncthreads();
	// }

    if(i < DimY-half && j < DimX-half) {
		// Filtro por columnas
		IMG2[i*DimX+j] = 
			IMG1[(i-2)*DimX + j] * GAUSS[0] + 
			IMG1[(i-1)*DimX + j] * GAUSS[1] + 
			IMG1[(i+0)*DimX + j] * GAUSS[2] + 
			IMG1[(i+1)*DimX + j] * GAUSS[3] + 
			IMG1[(i+2)*DimX + j] * GAUSS[4]; 
    }
}

__global__ void kernel_Filtro1_horizontal(double *IMG1, double *IMG2, const unsigned int DimX, const unsigned int DimY, double *GAUSS){
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
			IMG2[iDx + (j-2)] * GAUSS[0] + 
			IMG2[iDx + (j-1)] * GAUSS[1] + 
			IMG2[iDx + (j+0)] * GAUSS[2] + 
			IMG2[iDx + (j+1)] * GAUSS[3] + 
			IMG2[iDx + (j+2)] * GAUSS[4];

	}
}
