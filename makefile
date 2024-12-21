all: main

main: ./objetos
	@ as ./fonte/ES.s -o ./objetos/ES.o
	@ as ./fonte/main.s -o ./objetos/main.o
	@ ld ./objetos/ES.o ./objetos/main.o -o main

./objetos:
	@ mkdir objetos

clean:
	@ rm -r objetos
	@ rm main