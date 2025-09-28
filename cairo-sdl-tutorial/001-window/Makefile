

#	g++ main.c -ggdb3 -Wall -Werror $(pkg-config --cflags sdl2) $(pkg-config --cflags cairo) $(pkg-config --libs sdl2) $(pkg-config --libs cairo) -lc -lm -o main



# This is the target that compiles our executable
# if i use gcc to compile files , program aborts SDL_Init with segfault
# if i use g++ , program runs fine ...
all : $(OBJS)
	g++ main.c -ggdb3 -Wall -I/usr/include/SDL2 -D_REENTRANT -I/usr/include/cairo -I/usr/include/libpng16 -I/usr/include/freetype2 -I/usr/include/pixman-1 -lSDL2 -lcairo -o main



