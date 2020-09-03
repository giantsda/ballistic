gaussj.o: gaussj.c  
	g++ gaussj.c  -c -g -Wall

chen_util.o: chen_util.c
	g++ chen_util.c -c -g -Wall

ADM_chen_C.o: ADM_chen_C.c
	g++  ADM_chen_C.c -c -g -Wall

nrutil.o: nrutil.c
	g++  nrutil.c -c -g -Wall

driveADM.o: driveADM.c   nrutil.o
	g++  driveADM.c nrutil.o -c -g -Wall


.PHONY: all

all:ballistics.cpp main.cpp gaussj.o ADM_chen_C.o nrutil.o chen_util.o nrutil.o
	g++ -g ballistics.cpp main.cpp nrutil.o gaussj.o ADM_chen_C.o chen_util.o  -Wall -I.

.PHONY: run

run:  
	make all
	./a.out
	 
.PHONY: clean

clean :
	rm *.o a.out



 