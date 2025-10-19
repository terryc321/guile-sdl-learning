
CC=clang
CFLAGS_SDL=`pkg-config --cflags sdl2`
CFLAGS_GUILE=`pkg-config --cflags guile-3.0`

all:	pixelformat.so

pixelformat.so:	test.c
	rm -f pixelformat.so
	${CC} -fPIC -shared -o pixelformat.so ${CFLAGS_SDL} ${CFLAGS_GUILE} test.c


