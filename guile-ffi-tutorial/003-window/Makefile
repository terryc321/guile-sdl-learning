

#CC=gcc
CC=clang

#all: test2

#test2: test2.c
#	${CC} -o test2 `pkg-config --cflags sdl2` `pkg-config --cflags guile-3.0` `pkg-config --libs sdl2` `pkg-config# --libs guile-3.0` test2.c


all: 	main lib

main:	sdl.c

	${CC} -o main `pkg-config --cflags sdl2` `pkg-config --cflags guile-3.0` `pkg-config --libs sdl2` `pkg-config --libs guile-3.0` sdl.c


lib:	sdl-lib.c

	${CC} -shared -fPIC -o libguile-sdl.so `pkg-config --cflags sdl2` `pkg-config --cflags guile-3.0` sdl-lib.c


clean:
	rm -f main
	rm -f lib

