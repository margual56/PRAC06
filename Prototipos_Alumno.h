
__global__ void kernel_Filtro1_vertical(double *IMG1, double *IMG2, const unsigned int DimX, const unsigned int DimY, double *GAUSS);
__global__ void kernel_Filtro1_horizontal(double *IMG1, double *IMG2, const unsigned int DimX, const unsigned int DimY, double *GAUSS);

// __global__ void kernel_Filtro2(double *IMG, const unsigned int DimX, const unsigned int DimY, double *value);
__global__ void kernel_Filtro3(double *IMG, const unsigned int DimX, const unsigned int DimY, const double value);
__global__ void kernel_Filtro4(double *IMG1, double *IMG2, const unsigned int DimX, const unsigned int DimY, const double value);