#include "Prototipos_Alumno.h"

__global__ void kernel_Filtro1_vertical(double *IMG1, double *IMG2, const unsigned int DimX, const unsigned int DimY, double *GAUSS)
{
	int half = 2;
    int t = blockIdx.x * blockDim.x + threadIdx.x;
	int j = t/DimX + half;
   int i = t % DimX + half;

       // int Dim_2 = blockDim.x*blockDim.y;
       //    if(i < Dim_2 && j < Dim_2) {
       //        IMG1_2[i*Dim_2+j] = IMG1[i*DimX+j];
       //      __syncthreads();
       // }

   if(i < DimY-half && j < DimX-half)
       {
               // Filtro por columnas
               IMG2[i*DimX+j] =
                       IMG1[(i-2)*DimX + j] * GAUSS[0] +
                       IMG1[(i-1)*DimX + j] * GAUSS[1] +
                       IMG1[(i+0)*DimX + j] * GAUSS[2] +
                       IMG1[(i+1)*DimX + j] * GAUSS[3] +
                       IMG1[(i+2)*DimX + j] * GAUSS[4];
   }
}

__global__ void kernel_Filtro1_horizontal(double *IMG1, double *IMG2, const unsigned int DimX, const unsigned int DimY, double *GAUSS)
{
	int half = 2;

    //extern __shared__ double *IMG2[];

    int j = blockIdx.x * blockDim.x + threadIdx.x + half;
    int i = blockIdx.y * blockDim.y + threadIdx.y + half;

    //if( i < DimY && j<DimX)
    //    IMG2[i*DimX+j] = IMG1[i*DimX+j];

    //__syncthreads();

	int iDx;

	// Filtro por columnas
    if(i < DimY-half && j < DimX-half)
	{
        iDx = i*DimX;
		
		IMG1[iDx+j] = 
			IMG2[iDx + (j-2)] * GAUSS[0] + 
			IMG2[iDx + (j-1)] * GAUSS[1] + 
			IMG2[iDx + (j+0)] * GAUSS[2] + 
			IMG2[iDx + (j+1)] * GAUSS[3] + 
			IMG2[iDx + (j+2)] * GAUSS[4];

	}
}

// double Filtro2(double *IMG, const unsigned int DimX, const unsigned int DimY, double *value)
// {
//     int j = blockIdx.x * blockDim.x + threadIdx.x + half;
//     int i = blockIdx.y * blockDim.y + threadIdx.y + half;
// 
// 	double result=0;
// 	int half = 2;
// 	unsigned int size = (DimX-half*2)*(DimY-half*2);
// 	
// 	if(i<DimY-half && j<DimX-half)
// 			result += IMG[i*DimX+j]/size;
// 	
// 	value = result;
// }

__global__ void kernel_Filtro3(double *IMG, const unsigned int DimX, const unsigned int DimY, const double value)
{
    int j = blockIdx.x * blockDim.x + threadIdx.x;
    int i = blockIdx.y * blockDim.y + threadIdx.y;

	if(i<DimY && j<DimX) {
		if(IMG[i*DimX+j]<=value) 
			IMG[i*DimX+j] = 255;

		else
			IMG[i*DimX+j] = 0;
	}
}


__global__ void kernel_Filtro4(double *IMG1, double *IMG2, const unsigned int DimX, const unsigned int DimY, const double value)
{
    int j = blockIdx.x * blockDim.x + threadIdx.x;
    int i = blockIdx.y * blockDim.y + threadIdx.y;
	
	double v256 = (value/256.0);

	__syncthreads();

	if(i<DimY && j<DimX)
		IMG1[i*DimX+j] = IMG1[i*DimX+j]*v256 + IMG2[i*DimX+j]*(1-v256);
}
