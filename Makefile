COMPIL=nvcc
CFLAGS=-O3 -Xcompiler -O3,-Wall
LIBS=-lcublas -lcurand -lcudart

all : cleanall	Filtro
		@ echo "Compilado "

cleanall : clean
	@rm -f 	Filtro

clean :
	@rm -f *.o core *~

Filtro : Filtro.cu Funciones.cu
	$(COMPIL) -o EXE/Filtro Filtro.cu Funciones.cu Funciones_Alumno.cu $(CFLAGS) $(LIBS)

