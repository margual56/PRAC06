#include "Prototipos.h"
#include "Prototipos_Alumno.h"

int main(int argc, char* argv[]) 
{
   unsigned char  *Head=NULL;
   char           *Entrada=NULL, *Salida=NULL;
   unsigned int   DimX, DimY, HeadSize, ThBlk;
   double         *Image=NULL;
   int            ndev, Repet, i;
   float          time;
   cudaEvent_t    start, stop;
   
   if (argc != 5) {
      printf("Usage: %s <Image input file> <Image output file> <times> <hilos por bloque>\n", argv[0]);
      return -1;
   }

   Entrada = strdup(argv[1]);
   Salida  = strdup(argv[2]);
   Repet   = atoi(argv[3]);
   ThBlk   = atoi(argv[4]);

   CUDAERR(cudaGetDeviceCount(&ndev));
   CUDAERR(cudaEventCreate(&start));
   CUDAERR(cudaEventCreate(&stop));

   if (!ImageDims(Entrada, &DimX, &DimY, &HeadSize)) { printf("Error: File Image not BMP\n"); return -1; }

   CHECKNULL(Head =(unsigned char *)calloc(HeadSize, sizeof(unsigned char)));
   CHECKNULL(Image=(double *)calloc(DimX*DimY, sizeof(double)));

   if (!ImageLoad(Entrada, DimX, DimY, Image, Head, HeadSize)) { printf("Error: reading image\n"); return -1; }

   /* El alumnado prepara aqui los datos */

   // Copiar los valores de GAUSS a la GPU
   double Host_GAUSS[5] = {1.0/16.0, 4.0/16.0, 6.0/16.0, 4.0/16.0, 1.0/16.0};
   double *Device_GAUSS;
   cudaMalloc((void **) &Device_GAUSS, 5*sizeof(double));

   // Alocar memoria para las imágenes
   double *Device_Image, *backup, *copy;
   CUDAERR(cudaMalloc((void **) &Device_Image, DimX*DimY*sizeof(double)));
   CUDAERR(cudaMalloc((void **) &backup, DimX*DimY*sizeof(double)));
   CUDAERR(cudaMalloc((void **) &copy, DimX*DimY*sizeof(double)));

   // Ceil the result [ (n + (p-1))/p ]
   dim3 blks2D (
      (DimX + (ThBlk-1)) / ThBlk,
      (DimY + (ThBlk-1)) / ThBlk
   );

   dim3 blks1D (
      (DimX * DimY + (ThBlk-1)) / ThBlk
   );

   printf("Dado que hay %d threads por bloque, se ha calculado que para esta imagen hacen falta bloques de %dx%d\n",
   ThBlk, blks2D.x, blks2D.y);

   dim3 thrs2D (
      ThBlk,
      ThBlk
   );

   dim3 thrs1D (
      ThBlk
   );

   // Copiar las imágenes a la GPU

   cudaEventRecord(start, 0);
     
     // Copiar datos
     CUDAERR(cudaMemcpy(Device_GAUSS, Host_GAUSS, 5*sizeof(double), cudaMemcpyHostToDevice)); 
     CUDAERR(cudaMemcpy(Device_Image, Image, DimX*DimY*sizeof(double), cudaMemcpyHostToDevice));
     CUDAERR(cudaMemcpy(backup, Device_Image, DimX*DimY*sizeof(double), cudaMemcpyDeviceToDevice));
     CUDAERR(cudaMemcpy(copy, Device_Image, DimX*DimY*sizeof(double), cudaMemcpyDeviceToDevice));
     
     printf("Aplicando filtro gaussiano %d veces\n", Repet);
     /* aqui empieza el suavizado */
     for (i=1; i<=Repet; i++)
     {
        /* llamada al (los) kernel para suavizar */
        kernel_Filtro1_vertical<<<blks2D, thrs2D>>>(Device_Image, copy, DimX, DimY, Device_GAUSS);
	     CHECKLASTERR();

	     kernel_Filtro1_horizontal<<<blks2D, thrs2D>>>(Device_Image, copy, DimX, DimY, Device_GAUSS);
	     CHECKLASTERR();
     }

     /* ahora el calculo del promedio */
     // TODO: Custom reduction kernel
     // kernel_Filtro2<<<blks1D, thrs1D>>>(double *IMG, const unsigned int DimX, const unsigned int DimY, const double value);

     double avg = 0;
     cublasHandle_t handle;
     CUBLASERR(cublasCreate(&handle));
     CUBLASERR(cublasDasum(handle, DimX*DimY, Device_Image, 1, &avg));
     CUBLASERR(cublasDestroy(handle));
     avg /= DimX*DimY;

     printf("El valor medio de la imagen es %.4f\n", avg);

     /* ahora la llamada al kernel para binarizar */
     kernel_Filtro3<<<blks2D, thrs2D>>>(Device_Image, DimX, DimY, avg);
     CHECKLASTERR();

     /* ahora la llamada al kernel para perfilar */
     kernel_Filtro4<<<blks2D, thrs2D>>>(Device_Image, backup, DimX, DimY, avg);

     CHECKLASTERR();
         
     /* lo que proceda para que el resultado este en el puntero Image */

     CUDAERR(cudaMemcpy(Image, Device_Image, DimX*DimY*sizeof(double), cudaMemcpyDeviceToHost)); 
     
   cudaEventRecord(stop, 0);
   cudaEventSynchronize(stop);
   cudaEventElapsedTime(&time, start, stop);
   printf("\nTiempo %2.7E segundos\n", time/1000.0);
     CHECKLASTERR();

   if (!ImageSave(Salida, DimX, DimY, Image, Head, HeadSize)) { printf("Error: writing image\n"); return -1; }

   CUDAERR(cudaEventDestroy(start));
   CUDAERR(cudaEventDestroy(stop));

   /* Liberaciones de memoria que hagan falta */

   free(Head);
   free(Image);
   cudaFree(Device_GAUSS);
   cudaFree(Device_Image);
   cudaFree(copy);
   cudaFree(backup);

   return 0;
}
