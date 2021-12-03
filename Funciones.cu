#include "Prototipos.h"

int ImageDims(char *FileName, unsigned int *DimX, unsigned int *DimY, unsigned int *HeadSize)
{
  FILE           *fp;
  char           type[2];
  unsigned int   nVals[4];
  unsigned short TMP;
  size_t         leidos;
  
  fp = fopen(FileName, "rb");
  assert(fp);

  leidos=fread(type, 2, 1, fp);
  if ((type[0] != 'B') || (type[1] != 'M')) {
     printf("It is not a bmp image\n");
     return 0;
  }

  leidos=fread(nVals, 1, 4, fp);
  leidos=fread(nVals, 1, 4, fp);
  leidos=fread(HeadSize, 1, 4, fp);

  leidos=fread(nVals, 1, 4, fp);
  if (nVals[0] != 40){
     printf("BitmapInfoHeader size is %d != 40 Bytes\n", nVals[0]);
     return 0;
  }

  leidos=fread(DimX, 1, 4, fp);
  leidos=fread(DimY, 1, 4, fp);
  leidos=fread(&TMP, 1, 2, fp);

  leidos=fread(&TMP, 1, 2, fp);
  if ((TMP != 8) && (TMP != 16) && (TMP != 24) && (TMP != 32)) {
     printf("The image is not a BMP with 256, 16bit, 24bit o 32bit colors\n");
     return 0;
  }                     

  TMP=TMP/8;
  if (TMP != 1) { printf("We do not work if Bytes per Pixel != 1\n"); return 0; }                     

  leidos=fread(nVals, 1, 4, fp);
  if (nVals[0] != 0) { printf("We do not work with compressed bmps\n"); return 0; }                     

  leidos=fread(nVals, 1, 4, fp);
  leidos=fread(nVals, 4, 4, fp);

  leidos++; // para que no de warnings el compilador //
  fclose(fp);
  return 1;
}


int ImageLoad(char *FileName, const unsigned int DimX, const unsigned int DimY, double *Image,
              unsigned char *Head, const unsigned int HeadSize)
{
  FILE *fp;
  unsigned char *buffer=NULL;
  unsigned int i, j, tmp;
  size_t leidos;

  fp = fopen(FileName, "rb");
  assert(fp);

  buffer=(unsigned char *)calloc(DimX, sizeof(unsigned char));
  
  leidos=fread(Head, HeadSize, 1, fp);

  for (i=0; i<DimY; i++)
  {
     leidos=fread(buffer, DimX, 1, fp);
     tmp=i*DimX;
     for (j=0; j<DimX; j++)
        Image[tmp+j]=(double)buffer[j];
  }

  leidos++; // para que no de warnings el compilador //
  free(buffer);
  fclose(fp);
  return 1;
}


int ImageSave(char *FileName, const unsigned int DimX, const unsigned int DimY, const double *Image,
              const unsigned char *Head, const unsigned int HeadSize)
{
  FILE *fp;
  unsigned char *buffer=NULL;
  unsigned int i, j, tmp;
  size_t escritos;

  fp = fopen(FileName, "wb");
  assert(fp);

  buffer=(unsigned char *)calloc(DimX, sizeof(unsigned char));
  
  escritos=fwrite(Head, HeadSize, 1, fp);

  for (i=0; i<DimY; i++)
  {
     tmp=i*DimX;
     for (j=0; j<DimX; j++)
     {
        buffer[j]=(unsigned char)Image[tmp+j];

        if (buffer[j] < 1)   buffer[j]=0;
        if (buffer[j] > 255) buffer[j]=255;
     }
     escritos=fwrite(buffer, DimX, 1, fp);
  }

  escritos++; // para que no de warnings el compilador //
  free(buffer);
  fclose(fp);
  return 1;
}
