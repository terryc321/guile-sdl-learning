
CC=clang
CFLAGS_SDL=`pkg-config --cflags sdl2`
CFLAGS_GUILE=`pkg-config --cflags guile-3.0`


all:	libpixelformat.so

libpixelformat.so:	test.c
	rm -f libpixelformat.so
	${CC} -fPIC -shared -o libpixelformat.so ${CFLAGS_SDL} ${CFLAGS_GUILE} test.c


