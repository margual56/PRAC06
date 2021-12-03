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

   cudaEventRecord(start, 0);
     /* aqui lo que determine cada cual */
     
     /* aqui empieza el suavizado */
     for (i=1; i<=Repet; i++)
     {
        /* llamada al (los) kernel para suavizar */
     }

     /* ahora el calculo del promedio */

     /* ahora la llamada al kernel para binarizar */

     /* ahora la llamada al kernel para perfilar */

     CHECKLASTERR();
         
     /* lo que proceda para que el resultado este en el puntero Image */
     
   cudaEventRecord(stop, 0);
   cudaEventSynchronize(stop);
   cudaEventElapsedTime(&time, start, stop);
   printf("\nTiempo %2.7E segundos\n", time/1000.0);

   if (!ImageSave(Salida, DimX, DimY, Image, Head, HeadSize)) { printf("Error: writing image\n"); return -1; }

   CUDAERR(cudaEventDestroy(start));
   CUDAERR(cudaEventDestroy(stop));

   /* Liberaciones de memoria que hagan falta */

   free(Head);
   free(Image);

   return 0;
}
