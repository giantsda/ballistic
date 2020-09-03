ballistics.o: ballistics.cpp
	g++ ballistics.cpp  -c -g -Wall

main.o: main.cpp
	g++ main.cpp -c -g -Wall

.PHONY: all

all: ballistics.o main.o
	g++ -g  ballistics.o main.o  -Wall -I. 

.PHONY: run

run:  
	make all
	./a.out
	 
.PHONY: clean

clean :
	rm *.o a.out Data.txt



 