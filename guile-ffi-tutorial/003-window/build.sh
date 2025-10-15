#!/bin/bash

rm -f main

#
#g++ -o sdl.o `pkg-config --cflags sdl2` `pkg-config --cflags guile-3.0` `pkg-config --cflags cairo` -I/usr/include/libpng16 -I/usr/include/freetype2 -I/usr/include/pixman-1 -fpermissive -fPIC  sdl.c
#
#ld -o main `pkg-config --libs sdl2` `pkg-config --libs cairo` `pkg-config --libs guile-3.0`  sdl.o

#gcc -o main `pkg-config --cflags --libs sdl2` `pkg-config --cflags --libs cairo` `pkg-config --cflags --libs guile-3.0` sdl.c

#gcc -o main -I/usr/include/SDL2 -D_REENTRANT -I/usr/include/cairo -I/usr/include/libpng16 -I/usr/include/freetype2 -I/usr/include/pixman-1 -I/usr/include/guile/3.0 -lguile-3.0 -lgc -lpthread -ldl -lSDL2 -lcairo  sdl.c

clang -o main -I/usr/include/SDL2 -D_REENTRANT -I/usr/include/cairo -I/usr/include/libpng16 -I/usr/include/freetype2 -I/usr/include/pixman-1 -I/usr/include/guile/3.0 -lguile-3.0 -lgc -lpthread -ldl -lSDL2 -lcairo  sdl.c

#gcc -o main -D_REENTRANT -I/usr/include/guile/3.0 -lguile-3.0 -lgc -lpthread -ldl sdl.c








